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


view : Config -> Story.Story -> (String -> msg) -> Html msg
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
    in
    svg [ width "1300", height "500" ]
        ([ Svg.style [] [ text ".passage > * {cursor: pointer;} .link {fill: none;}" ]

         {- , viewLines config -}
         ]
            ++ viewPassages config story selectPassage storyProgression levelsByPassage passagesByLevel
        )



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


viewPassages : Config -> Story.Story -> (String -> msg) -> Dict String (List String) -> Dict String Int -> Dict Int (List String) -> List (Html msg)
viewPassages config story selectPassage storyProgression levelsByPassage passagesByLevel =
    let
        toSvg : Int -> Int -> String -> Int -> Html msg
        toSvg index level id levelSize =
            Dict.get id story.passages
                |> Maybe.map (\passage -> viewPassage config selectPassage { x = (level * config.passage.width) + (8 + ((config.passage.width // 2) * level)), y = config.passage.height + ((config.passage.height + 16) * index) + (config.passage.height // 2), text = id })
                |> Maybe.withDefault (text "")
    in
    passagesByLevel
        |> Dict.toList
        |> List.concatMap (\( level, passages ) -> List.indexedMap (\index id -> toSvg index level id (List.length passages)) <| List.reverse passages)


viewPassage : Config -> (String -> msg) -> { x : Int, y : Int, text : String } -> Html msg
viewPassage config selectPassage passage =
    let
        trianglePoints =
            String.join ", "
                [ (String.fromInt <| passage.x + config.passage.width) ++ " " ++ (String.fromInt <| passage.y + (config.passage.height // 3))
                , (String.fromInt <| passage.x + config.passage.width + (config.passage.height // 3)) ++ " " ++ (String.fromInt <| passage.y + (config.passage.height // 2))
                , (String.fromInt <| passage.x + config.passage.width) ++ " " ++ (String.fromInt <| passage.y + (config.passage.height // 3) * 2)
                ]
    in
    g [ onClick <| selectPassage "hello", class "passage" ]
        [ polygon
            [ points trianglePoints
            , fill "black"
            ]
            []
        , rect
            [ x <| String.fromInt passage.x
            , y <| String.fromInt passage.y
            , width <| String.fromInt config.passage.width
            , height <| String.fromInt config.passage.height
            , rx <| String.fromInt config.passage.cornerRadius
            , fill "white"
            , stroke "black"
            , strokeWidth "2"
            ]
            []
        , text_
            [ x <| String.fromInt <| passage.x + (round <| toFloat config.passage.width * 0.05)
            , y <| String.fromInt <| passage.y + (round <| toFloat config.passage.height * 0.58)
            ]
            [ text <| truncateString 22 passage.text ]
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
