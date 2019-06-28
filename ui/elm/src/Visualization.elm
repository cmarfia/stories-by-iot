module Visualization exposing
    ( Config
    , Model
    , Msg
    , Node
    , defaultConfig
    , getSelectedNode
    , init
    , subscriptions
    , update
    , updateNodes
    , updateSelectedNode
    , view
    )

import Dict exposing (Dict)
import Draggable
import Engine
import Html exposing (Html)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import Math.Vector2 as Vector2 exposing (Vec2, getX, getY)
import Story as Story exposing (Story)
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)



-- Types


type alias Config =
    { width : Int
    , height : Int
    , borderRadius : Int
    , borderWidth : Int
    , padding : Int
    , maxTextSize : Int
    }


defaultConfig : Config
defaultConfig =
    { width = 200
    , height = 50
    , borderRadius = 16
    , borderWidth = 2
    , padding = 50
    , maxTextSize = 23
    }


type alias Node =
    { text : String
    , connections : List String
    }


type alias Coords a =
    { a
        | x : Float
        , y : Float
    }


type Model
    = Model
        { config : Config
        , nodes : Dict String (Coords Node)
        , startingNode : String
        , selectedNode : Maybe String
        , hoveringNode : Maybe String
        , height : Float
        , width : Float
        , drag : Draggable.State ()
        , position : Vec2
        }


dragConfig : Draggable.Config () Msg
dragConfig =
    Draggable.basicConfig (\( dx, dy ) -> DragBy <| Vector2.vec2 dx dy)



-- Init


init : Config -> Dict String Node -> String -> Model
init config nodes startingNode =
    let
        columns =
            relateColumnsToNodes nodes startingNode

        itemHeight_ =
            itemHeight config

        itemWidth_ =
            itemWidth config

        height =
            (itemHeight_ * maxRowSize columns) + itemHeight_

        nodes_ =
            addCoords config columns nodes startingNode

        width =
            (itemWidth_ * (toFloat <| List.length columns)) + itemWidth_

        x_ =
            negate (width / 4) + itemWidth_

        y_ =
            case Dict.get startingNode nodes_ of
                Just { y } ->
                    y - (itemHeight_ / 2)

                Nothing ->
                    height / 2
    in
    Model
        { config = config
        , nodes = nodes_
        , startingNode = startingNode
        , selectedNode = Nothing
        , hoveringNode = Nothing
        , height = height / 4
        , width = width / 2
        , drag = Draggable.init
        , position = Vector2.vec2 x_ y_
        }



-- View


view : Model -> Html Msg
view (Model model) =
    let
        svgNodes =
            model.nodes
                |> Dict.toList
                |> List.map (viewNode model.config model.nodes model.selectedNode model.hoveringNode)

        viewBox_ =
            [ getX model.position, getY model.position, model.width, model.height ]
                |> List.map String.fromFloat
                |> String.join " "
    in
    svg [ width "100%", height "500", viewBox viewBox_, Draggable.mouseTrigger () GotDragMsg ]
        (viewStyles :: viewLines model.config model.nodes model.selectedNode model.hoveringNode ++ svgNodes)


viewStyles : Html msg
viewStyles =
    Svg.style [] [ text ".passage > * {cursor: pointer;} .link {fill: none;}" ]


viewLines : Config -> Dict String (Coords Node) -> Maybe String -> Maybe String -> List (Html Msg)
viewLines config nodes maybeSelectedNode maybeHoveringNode =
    let
        itemHeight_ =
            toFloat config.height + toFloat config.borderWidth / 2

        itemWidth_ =
            toFloat config.width + toFloat config.borderWidth / 2

        moveTo x y =
            "M" ++ String.fromFloat x ++ " " ++ String.fromFloat y

        lineTo x y =
            "L" ++ String.fromFloat x ++ " " ++ String.fromFloat y

        arcTo radius largeArc sweep x y =
            "A" ++ String.fromFloat radius ++ " " ++ String.fromFloat radius ++ " 0 " ++ String.fromFloat largeArc ++ " " ++ String.fromFloat sweep ++ " " ++ String.fromFloat x ++ " " ++ String.fromFloat y

        viewArc nodeId sourceX sourceY { x, y } =
            let
                targetX =
                    x

                targetY =
                    y

                midX =
                    (sourceX + itemWidth_) + (targetX - (sourceX + itemWidth_)) / 2

                commands =
                    if sourceX < targetX then
                        if sourceY < targetY then
                            [ moveTo (sourceX + itemWidth_) (sourceY + itemHeight_ / 2)
                            , lineTo (midX - toFloat config.borderRadius) (sourceY + itemHeight_ / 2)
                            , arcTo (toFloat config.borderRadius) 0 1 midX (sourceY + (itemHeight_ / 2) + toFloat config.borderRadius)
                            , lineTo midX (targetY + (itemHeight_ / 2) - toFloat config.borderRadius)
                            , arcTo (toFloat config.borderRadius) 0 0 (midX + toFloat config.borderRadius) (targetY + (itemHeight_ / 2))
                            , lineTo targetX (targetY + (itemHeight_ / 2))
                            ]

                        else if sourceY > targetY then
                            [ moveTo (sourceX + itemWidth_) (sourceY + itemHeight_ / 2)
                            , lineTo (midX - toFloat config.borderRadius) (sourceY + itemHeight_ / 2)
                            , arcTo (toFloat config.borderRadius) 0 0 midX (sourceY + (itemHeight_ / 2) - toFloat config.borderRadius)
                            , lineTo midX (targetY + (itemHeight_ / 2) + toFloat config.borderRadius)
                            , arcTo (toFloat config.borderRadius) 0 1 (midX + toFloat config.borderRadius) (targetY + (itemHeight_ / 2))
                            , lineTo targetX (targetY + (itemHeight_ / 2))
                            ]

                        else
                            [ moveTo (sourceX + itemWidth_) (sourceY + itemHeight_ / 2)
                            , lineTo targetX (targetY + itemHeight_ / 2)
                            ]

                    else if sourceX > targetX then
                        if sourceY < targetY then
                            Debug.todo "need to implement connections to nodes < x && > y"

                        else if sourceY > targetY then
                            Debug.todo "need to implement connections to nodes < x && < y"

                        else
                            Debug.todo "need to implement connections to nodes < x && ()==) y"

                    else
                        Debug.todo "need to implement connections to nodes in the same column"
            in
            ( isSelectedNode maybeSelectedNode nodeId
            , isHoveringNode maybeHoveringNode nodeId
            , Svg.path
                [ class "link"
                , d <| String.join " " commands
                , stroke <| strokeColor maybeSelectedNode maybeHoveringNode nodeId
                , strokeWidth <| String.fromInt config.borderWidth
                ]
                []
            )

        linkNode ( nodeId, { x, y, connections } ) =
            connections
                |> List.filterMap (\id -> Dict.get id nodes)
                |> List.map (viewArc nodeId x y)

        selectionComparison ( prevSelected, prevHovered, _ ) ( nextSelected, nextHovered, _ ) =
            if prevSelected && nextSelected then
                EQ
            else if prevSelected then 
                GT
            else if nextSelected then
                LT
            else if prevHovered && nextHovered then
                EQ
            else if prevHovered then 
                GT
            else
                LT

    in
    nodes
        |> Dict.toList
        |> List.concatMap linkNode
        |> List.sortWith selectionComparison
        |> List.map (\( _, _, svg_ ) -> svg_)


viewNode : Config -> Dict String (Coords Node) -> Maybe String -> Maybe String -> ( String, Coords Node ) -> Html Msg
viewNode config nodes maybeSelectedNode maybeHoveringNode ( nodeId, node ) =
    let
        strokeColor_ =
            strokeColor maybeSelectedNode maybeHoveringNode nodeId

        hasFutureProgressions =
            Dict.get nodeId nodes
                |> Maybe.map .connections
                |> Maybe.withDefault []
                |> List.isEmpty
                |> not

        trianglePoints =
            String.join ", "
                [ (String.fromFloat <| node.x + toFloat config.width) ++ " " ++ (String.fromFloat <| node.y + (toFloat config.height / 3))
                , (String.fromFloat <| node.x + toFloat config.width + (toFloat config.height / 3)) ++ " " ++ (String.fromFloat <| node.y + (toFloat config.height / 2))
                , (String.fromFloat <| node.x + toFloat config.width) ++ " " ++ (String.fromFloat <| node.y + (toFloat config.height / 3) * 2)
                ]
    in
    g
        [ onClick <| SelectNode <| Just nodeId
        , class "passage"
        , onMouseEnter <| EnteringNode nodeId
        , onMouseLeave LeavingNode
        ]
        [ if hasFutureProgressions then
            polygon [ points trianglePoints, fill strokeColor_ ] []

          else
            text ""
        , rect
            [ x <| String.fromFloat node.x
            , y <| String.fromFloat node.y
            , width <| String.fromInt config.width
            , height <| String.fromInt config.height
            , rx <| String.fromInt config.borderRadius
            , fill "white"
            , stroke strokeColor_
            , strokeWidth <| String.fromInt <| config.borderWidth
            ]
            []
        , text_
            [ x <| String.fromFloat <| node.x + (toFloat config.width * 0.05)
            , y <| String.fromFloat <| node.y + (toFloat config.height * 0.58)
            ]
            [ text <| truncateString config.maxTextSize node.text ]
        ]


strokeColor : Maybe String -> Maybe String -> String -> String
strokeColor maybeSelectedNode maybeHoveringNode nodeId =
    if isSelectedNode maybeSelectedNode nodeId then
        "blue"

    else if isHoveringNode maybeHoveringNode nodeId then
        "orange"

    else
        "black"


isSelectedNode : Maybe String -> String -> Bool
isSelectedNode maybeSelectedNode nodeId =
    case maybeSelectedNode of
        Just selectedId ->
            selectedId == nodeId

        Nothing ->
            False


isHoveringNode : Maybe String -> String -> Bool
isHoveringNode maybeHoveringNode nodeId =
    case maybeHoveringNode of
        Just hoverId ->
            hoverId == nodeId

        Nothing ->
            False



-- Update


type Msg
    = SelectNode (Maybe String)
    | UpdateNodes (Dict String Node)
    | GotDragMsg (Draggable.Msg ())
    | DragBy Vec2
    | EnteringNode String
    | LeavingNode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        SelectNode maybeNodeId ->
            ( Model { model | selectedNode = maybeNodeId }, Cmd.none )

        UpdateNodes nodes ->
            Debug.todo "implement this"

        GotDragMsg dragMsg ->
            let
                ( updatedModel, cmds ) =
                    Draggable.update dragConfig dragMsg model
            in
            ( Model updatedModel, cmds )

        DragBy rawDelta ->
            ( Model { model | position = model.position |> Vector2.add (Vector2.scale -1 rawDelta) }, Cmd.none )

        EnteringNode nodeId ->
            ( Model { model | hoveringNode = Just nodeId }, Cmd.none )

        LeavingNode ->
            ( Model { model | hoveringNode = Nothing }, Cmd.none )



-- Public Helpers


getSelectedNode : Model -> Maybe String
getSelectedNode (Model model) =
    model.selectedNode


updateSelectedNode : String -> Msg
updateSelectedNode id =
    SelectNode <| Just id


updateNodes : Dict String Node -> Msg
updateNodes nodes =
    UpdateNodes nodes



-- Private Helpers


truncateString : Int -> String -> String
truncateString maxChars str =
    if String.length str >= maxChars then
        String.left maxChars str ++ " ..."

    else
        str


itemHeight : Config -> Float
itemHeight config =
    toFloat <| (config.height + config.borderWidth) + (config.padding * 2)


itemWidth : Config -> Float
itemWidth config =
    (toFloat config.padding * 1.5) + (toFloat config.width * 2)


maxRowSize : List ( Int, List String ) -> Float
maxRowSize columns =
    List.map (Tuple.second >> List.length) columns
        |> List.maximum
        |> Maybe.withDefault 0
        |> toFloat


addCoords : Config -> List ( Int, List String ) -> Dict String Node -> String -> Dict String (Coords Node)
addCoords config columns nodes startingNode =
    let
        itemHeight_ =
            itemHeight config

        itemWidth_ =
            itemWidth config

        maxRowSize_ =
            maxRowSize columns

        mapRowIndex rowIndex nodeId =
            Dict.get nodeId nodes
                |> Maybe.map (\node -> { text = node.text, connections = node.connections, rowIndex = rowIndex, nodeId = nodeId })

        addCoords_ node_ ( columnIndex, rowSize, nodes_ ) =
            let
                emptySpaceInColumn =
                    (maxRowSize_ - rowSize) * itemHeight_

                verticalPadding =
                    ((emptySpaceInColumn / rowSize) / 2) + itemHeight_

                newNode =
                    { text = node_.text
                    , connections = node_.connections
                    , nodeId = node_.nodeId
                    , y = verticalPadding * toFloat (node_.rowIndex + 1)
                    , x = itemWidth_ * toFloat columnIndex
                    }
            in
            ( columnIndex, rowSize, newNode :: nodes_ )

        mapColumn ( columnIndex, connections ) =
            connections
                |> List.indexedMap mapRowIndex
                |> List.filterMap identity
                |> List.foldl addCoords_ ( columnIndex, toFloat <| List.length connections, [] )
                |> (\( _, _, nodes_ ) -> nodes_)

        toNodeWithCoords node =
            ( node.nodeId, { text = node.text, connections = node.connections, x = node.x, y = node.y } )
    in
    columns
        |> List.concatMap mapColumn
        |> List.map toNodeWithCoords
        |> Dict.fromList


relateColumnsToNodes : Dict String Node -> String -> List ( Int, List String )
relateColumnsToNodes nodes startingNode =
    let
        relateColumnsToNodes_ ( nodeId, columnIndex ) columns =
            case Dict.get columnIndex columns of
                Just nodeIds ->
                    Dict.insert columnIndex (nodeId :: nodeIds) columns

                Nothing ->
                    Dict.insert columnIndex [ nodeId ] columns
    in
    relateNodesToColumns nodes startingNode
        |> List.foldl relateColumnsToNodes_ Dict.empty
        |> Dict.toList
        |> List.map (\( columnIndex, connections ) -> ( columnIndex, List.reverse connections ))


relateNodesToColumns : Dict String Node -> String -> List ( String, Int )
relateNodesToColumns nodes initialNodeId =
    let
        relateNodesToColumns_ currentLevel nodeId levels =
            let
                findAllChildren id =
                    Dict.get id nodes
                        |> Maybe.map .connections
                        |> Maybe.withDefault []
                        |> List.concatMap findAllChildren

                isAncestor childNodeId =
                    findAllChildren childNodeId
                        |> List.member nodeId

                updatedLevels =
                    case Dict.get nodeId levels of
                        Just level ->
                            if currentLevel > level then
                                Dict.insert nodeId currentLevel levels

                            else
                                levels

                        Nothing ->
                            Dict.insert nodeId currentLevel levels
            in
            case Dict.get nodeId nodes of
                Just { connections } ->
                    connections
                        |> List.filter (isAncestor >> not)
                        |> List.foldl (relateNodesToColumns_ (currentLevel + 1)) updatedLevels

                Nothing ->
                    updatedLevels
    in
    relateNodesToColumns_ 0 initialNodeId Dict.empty
        |> Dict.toList



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions (Model { drag }) =
    Draggable.subscriptions GotDragMsg drag
