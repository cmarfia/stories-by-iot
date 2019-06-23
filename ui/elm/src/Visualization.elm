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
import Html.Events exposing (onClick)
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
    , borderRadius = 15
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
                |> List.map (viewNode model.config model.nodes)

        viewBox_ =
            [ getX model.position, getY model.position, model.width, model.height ]
                |> List.map String.fromFloat
                |> String.join " "
    in
    svg [ width "100%", height "350", viewBox viewBox_, Draggable.mouseTrigger () GotDragMsg ]
        (viewStyles :: svgNodes)


viewStyles : Html msg
viewStyles =
    Svg.style [] [ text ".passage > * {cursor: pointer;} .link {fill: none;}" ]



-- [ Svg.style [] [ text " text { font-family: sans-serif; font-size: 10px; } .node { stroke-linecap: round; } .link { fill: none; } " ]
-- , Svg.path [ class "link", d " M8 46 L62 46 A16 16 90 0 1 78 62 L78 78 A16 16 90 0 0 94 94 L92 94", stroke "#1b9e77", strokeWidth "2" ] []
-- , line [ class "node", stroke "black", strokeWidth "8", x1 "8", y1 "46", x2 "8", y2 "46" ] []
-- , text_ [ x "12", y "42" ] [ text "Chaos" ]
-- , line [ class "node", stroke "black", strokeWidth "8", x1 "92", y1 "94", x2 "92", y2 "94" ] []
-- , text_ [ x "96", y "90" ] [ text "Gaea" ]
-- ]


viewLines : Config -> Html Msg
viewLines config =
    g []
        [ line [ class "node", stroke "black", strokeWidth "2", x1 "301", y1 "125", x2 "416", y2 "125" ] []
        ]


viewNode : Config -> Dict String (Coords Node) -> ( String, Coords Node ) -> Html Msg
viewNode config nodes ( nodeId, node ) =
    let
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
    g [ onClick <| SelectNode <| Just nodeId, class "passage" ]
        [ if hasFutureProgressions then
            polygon [ points trianglePoints, fill "black" ] []

          else
            text ""
        , rect
            [ x <| String.fromFloat node.x
            , y <| String.fromFloat node.y
            , width <| String.fromInt config.width
            , height <| String.fromInt config.height
            , rx <| String.fromInt config.borderRadius
            , fill "white"
            , stroke "black"
            , strokeWidth <| String.fromInt <| config.borderWidth
            ]
            []
        , text_
            [ x <| String.fromFloat <| node.x + (toFloat config.width * 0.05)
            , y <| String.fromFloat <| node.y + (toFloat config.height * 0.58)
            ]
            [ text <| truncateString config.maxTextSize node.text ]
        ]



-- Update


type Msg
    = SelectNode (Maybe String)
    | UpdateNodes (Dict String Node)
    | GotDragMsg (Draggable.Msg ())
    | DragBy Vec2


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



-- Public Helpers


getSelectedNode : Model -> Maybe String
getSelectedNode model =
    Nothing


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
