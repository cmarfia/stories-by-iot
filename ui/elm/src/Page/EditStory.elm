module Page.EditStory exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import API
import Browser.Navigation as Nav
import Dict as Dict exposing (Dict)
import Engine exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import RemoteData exposing (RemoteData(..), WebData)
import Route
import Story as Story exposing (Story)
import Visualization



-- MODEL


type alias Model =
    RemoteData String { story : Story, visualizationModel : Visualization.Model }


init : List Story.Info -> String -> ( Model, Cmd Msg )
init _ storyId =
    ( Loading, API.getStoryById storyId HandleStoryResponse )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    case model of
        Loading ->
            { title = "Story Page"
            , content = text "Loading..."
            }

        Success { story, visualizationModel } ->
            { title = "Edit Story | Stories By Iot"
            , content =
                div [ class "page page__edit-story clearfix" ]
                    [ div [ class "container" ]
                        [ div [ class "row" ]
                            [ div [ class "column" ] [ text "Admin Edit Story" ]
                            ]
                        , div [ class "clearfix" ]
                            [ div [ class "story__icon story__icon--home" ]
                                [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
                                ]
                            ]
                        , div [ class "clearfix" ]
                            [ div [ class "story__icon story__icon--arrow-left" ]
                                [ button [ onClick GoToDashboard ] [ i [ class "icon-arrow-left" ] [] ]
                                ]
                            ]
                        , div [ class "row" ]
                            [ h1 [] [ text story.title ]
                            ]
                        ]
                    , div [ style "background" "white" ]
                        [ Html.map GotVisualizationMsg <| Visualization.view visualizationModel
                        ]
                    ]
            }

        Failure error ->
            { title = "Story Page"
            , content = text error
            }

        NotAsked ->
            { title = "Story Page"
            , content = text "Not Asked"
            }



-- Update


type Msg
    = GoHome
    | GoToDashboard
    | HandleStoryResponse (WebData Story)
    | GotVisualizationMsg Visualization.Msg


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case ( msg, model ) of
        ( GoHome, _ ) ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Home )

        ( GoToDashboard, _ ) ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Dashboard )

        ( HandleStoryResponse response, _ ) ->
            case response of
                NotAsked ->
                    ( NotAsked, Cmd.none )

                Loading ->
                    ( Loading, Cmd.none )

                Failure _ ->
                    ( Failure "error loading story", Cmd.none )

                Success story ->
                    ( Success
                        { story = story
                        , visualizationModel = Visualization.init Visualization.defaultConfig (toNodes story) story.startingPassageId
                        }
                    , Cmd.none
                    )

        ( GotVisualizationMsg subMsg, Success { story, visualizationModel } ) ->
            let
                ( updatedModel, cmds ) =
                    Visualization.update subMsg visualizationModel
            in
            ( Success { story = story, visualizationModel = updatedModel }
            , Cmd.map GotVisualizationMsg cmds
            )

        ( _, _ ) ->
            -- ignore other possibilities
            ( model, Cmd.none )



-- Helpers


toNodes : Story -> Dict String Visualization.Node
toNodes story =
    let
        toNode id connections =
            Dict.get id story.passages
                |> Maybe.map (\{ narrative } -> { text = narrative.text, connections = connections })
                |> Maybe.withDefault { text = id, connections = connections }

        possibleEngineUpdate engine interactionId =
            let
                ( newEngine, maybePassageId ) =
                    Engine.update interactionId engine
            in
            maybePassageId
                |> Maybe.map (Tuple.pair newEngine)

        generate ( engine, currentPassageId ) progressions =
            let
                futureProgressions =
                    getInteractions story engine
                        |> List.filterMap (possibleEngineUpdate engine)

                updatedProgressions : Dict String Visualization.Node
                updatedProgressions =
                    Dict.insert currentPassageId (toNode currentPassageId <| List.map Tuple.second futureProgressions) progressions
            in
            futureProgressions
                |> List.foldl generate updatedProgressions
    in
    case Story.toEngine story of
        Ok engine ->
            generate ( engine, story.startingPassageId ) <| Dict.map (\_ { id } -> { text = id, connections = [] }) story.passages

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



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Success { visualizationModel } ->
            Sub.map GotVisualizationMsg <| Visualization.subscriptions visualizationModel

        _ ->
            Sub.none
