module Visualization exposing (Config, defaultConfig, view)

import Dict exposing (Dict)
import Engine
import Html exposing (Html)
import Html.Events exposing (onClick)
import Story as Story exposing (Story)
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias Config =
    { passage :
        { width : Int
        , height : Int
        , cornerRadius : Int
        }
    }


defaultConfig : Config
defaultConfig =
    { passage =
        { width = 200
        , height = 50
        , cornerRadius = 15
        }
    }


type alias Model =
    { storyProgression : Dict String (List String)
    , levelsByPassage : Dict String Int
    , passagesByLevel : Dict Int (List String)
    , story : Story
    , config : Config
    , numberOfLevels : Int
    , maxLevelSize : Int
    }


view : Config -> Story -> (String -> msg) -> Html msg
view config story selectPassage =
    let
        storyProgression =
            getStoryProgression story

        levelsByPassage =
            getVisualizationLevels storyProgression story.startingPassageId

        convertToLevels : ( String, Int ) -> Dict Int (List String) -> Dict Int (List String)
        convertToLevels ( id, level ) totalLevels =
            case Dict.get level totalLevels of
                Just passages ->
                    Dict.insert level (id :: passages) totalLevels

                Nothing ->
                    Dict.insert level [ id ] totalLevels

        passagesByLevel =
            levelsByPassage
                |> Dict.toList
                |> List.foldl convertToLevels Dict.empty

        model =
            { storyProgression = storyProgression
            , levelsByPassage = levelsByPassage
            , passagesByLevel = passagesByLevel
            , story = story
            , config = config
            , numberOfLevels = Dict.size passagesByLevel
            , maxLevelSize =
                Dict.toList passagesByLevel
                    |> List.map (Tuple.second >> List.length)
                    |> List.maximum
                    |> Maybe.withDefault 0
            }

        height_ =
            800
    in
    svg [ width "100%", height <| String.fromInt height_ ]
        (viewStyles :: viewPassages model selectPassage)


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


viewLines : Config -> Html msg
viewLines config =
    g []
        [ line [ class "node", stroke "black", strokeWidth "2", x1 "301", y1 "125", x2 "416", y2 "125" ] []
        ]


viewPassages : Model -> (String -> msg) -> List (Html msg)
viewPassages model selectPassage =
    let
        passagesToSVG : Int -> Int -> Int -> String -> Html msg
        passagesToSVG level levelSize index id =
            Dict.get id model.story.passages
                |> Maybe.map (viewPassage model selectPassage level levelSize index id)
                |> Maybe.withDefault (text "")

        levelsToSVG : ( Int, List String ) -> List (Html msg)
        levelsToSVG ( level, passages ) =
            passages
                |> List.reverse
                |> List.indexedMap (passagesToSVG level (List.length passages))
    in
    model.passagesByLevel
        |> Dict.toList
        |> List.concatMap levelsToSVG


viewPassage : Model -> (String -> msg) -> Int -> Int -> Int -> String -> Story.Passage -> Html msg
viewPassage model selectPassage level levelSize index id passage =
    let
        padding =
            50

        borderWidth =
            2

        itemHeight =
            (model.config.passage.height + borderWidth) + (padding * 2)

        maxHeight =
            itemHeight * model.maxLevelSize

        emptyCells =
            model.maxLevelSize - levelSize

        emptySpace =
            emptyCells * itemHeight

        paddingPerCell =
            toFloat emptySpace / toFloat levelSize

        heightPerItem =
            (paddingPerCell / 2) + toFloat itemHeight

        y_ =
            heightPerItem * toFloat (index + 1)

        x_ =
            toFloat (level * model.config.passage.width) + ((toFloat padding + (toFloat model.config.passage.width / 2)) * toFloat level) + toFloat padding

        -- + (8 + ((model.config.passage.width // 2) * level)) + 8
        -- model.config.passage.height + ((model.config.passage.height + 16) * index) + (model.config.passage.height // 2)
        hasFutureProgressions =
            Dict.get id model.storyProgression
                |> Maybe.withDefault []
                |> List.isEmpty
                |> not

        trianglePoints =
            String.join ", "
                [ (String.fromFloat <| x_ + toFloat model.config.passage.width) ++ " " ++ (String.fromFloat <| y_ + (toFloat model.config.passage.height / 3))
                , (String.fromFloat <| x_ + toFloat model.config.passage.width + (toFloat model.config.passage.height / 3)) ++ " " ++ (String.fromFloat <| y_ + (toFloat model.config.passage.height / 2))
                , (String.fromFloat <| x_ + toFloat model.config.passage.width) ++ " " ++ (String.fromFloat <| y_ + (toFloat model.config.passage.height / 3) * 2)
                ]
    in
    g [ onClick <| selectPassage "hello", class "passage" ]
        [ if hasFutureProgressions then
            polygon [ points trianglePoints, fill "black" ] []

          else
            text ""
        , rect
            [ x <| String.fromFloat x_
            , y <| String.fromFloat y_
            , width <| String.fromInt model.config.passage.width
            , height <| String.fromInt model.config.passage.height
            , rx <| String.fromInt model.config.passage.cornerRadius
            , fill "white"
            , stroke "black"
            , strokeWidth "2"
            ]
            []
        , text_
            [ x <| String.fromFloat <| x_ + (toFloat model.config.passage.width * 0.05)
            , y <| String.fromFloat <| y_ + (toFloat model.config.passage.height * 0.58)
            ]
            [ text <| truncateString 23 id ]
        ]


truncateString : Int -> String -> String
truncateString maxChars str =
    if String.length str >= maxChars then
        String.left maxChars str ++ " ..."

    else
        str



-- Story Progression Graph


getStoryProgression : Story -> Dict String (List String)
getStoryProgression story =
    let
        possibleEngineUpdate : Engine.Model -> String -> Maybe ( String, Engine.Model )
        possibleEngineUpdate engine interactionId =
            let
                ( newEngine, maybePassageId ) =
                    Engine.update interactionId engine
            in
            case maybePassageId of
                Just passageId ->
                    Just ( passageId, newEngine )

                Nothing ->
                    Nothing

        generate : ( String, Engine.Model ) -> Dict String (List String) -> Dict String (List String)
        generate ( currentPassageId, engine ) progressions =
            let
                futureProgressions =
                    getInteractions story engine
                        |> List.filterMap (possibleEngineUpdate engine)
            in
            futureProgressions
                |> List.foldl generate (Dict.insert currentPassageId (List.map Tuple.first futureProgressions) progressions)
    in
    case Story.toEngine story of
        Ok engine ->
            generate ( story.startingPassageId, engine ) Dict.empty

        Err _ ->
            Dict.empty


getInteractions : Story -> Engine.Model -> List String
getInteractions story engine =
    let
        characters =
            Engine.getCharactersInCurrentLocation engine
                |> List.filterMap (\id -> Dict.get id story.characters)
                |> List.filter (\{ interactable } -> interactable)
                |> List.map .id

        items =
            Engine.getItemsInCurrentLocation engine
                |> List.append (Engine.getItemsInInventory engine)
                |> List.filterMap (\id -> Dict.get id story.items)
                |> List.map .id

        locations =
            Dict.get (Engine.getCurrentLocation engine) story.locations
                |> Maybe.map .connectingLocations
                |> Maybe.withDefault []
                |> List.filterMap (List.singleton >> Engine.chooseFrom engine)
                |> List.filterMap (\{ id } -> Dict.get id story.locations)
                |> List.map .id
    in
    characters ++ items ++ locations


getVisualizationLevels : Dict String (List String) -> String -> Dict String Int
getVisualizationLevels storyProgression startingPassageId =
    let
        generate : Int -> String -> Dict String Int -> Dict String Int
        generate currentLevel passageId levels =
            case Dict.get passageId storyProgression of
                Just progressions ->
                    let
                        updatedLevel =
                            case Dict.get passageId levels of
                                Just level ->
                                    -- todo look up parent dependencies
                                    level

                                Nothing ->
                                    currentLevel
                    in
                    progressions
                        |> List.foldl (generate (currentLevel + 1)) (Dict.insert passageId updatedLevel levels)

                Nothing ->
                    levels
    in
    generate 0 startingPassageId Dict.empty
