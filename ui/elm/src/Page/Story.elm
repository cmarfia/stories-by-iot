module Page.Story exposing (Model, Msg(..), init, update, view)

import API
import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Engine exposing (..)
import Flags exposing (Flags, StoryInfo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import Http
import Json.Encode
import List.Extra
import Markdown
import Port
import RemoteData exposing (RemoteData(..), WebData)
import Story as Story exposing (Story)
import Url


type alias Model =
    RemoteData String { story : Story, engine : Engine.Model, currentPassageId : String }



-- Init


init : Flags -> StoryInfo -> ( Model, Cmd Msg )
init _ story =
    ( Loading, API.getStoryById story.id HandleStoryResponse )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    case model of
        Loading ->
            { title = "Story Page"
            , content = text "Loading..."
            }

        Success { story, engine, currentPassageId } ->
            { title = story.title
            , content = viewLayout story engine currentPassageId
            }

        Failure error ->
            { title = "Story Page"
            , content = text error
            }

        NotAsked ->
            { title = "Story Page"
            , content = text "Not Asked"
            }


viewLayout : Story -> Engine.Model -> String -> Html Msg
viewLayout story engine currentPassageId =
    case Dict.get currentPassageId story.passages of
        Just currentPassage ->
            div [ class "page page__story clearfix" ]
                [ div [ class "container" ]
                    [ viewTitle story.title
                    , viewIcons currentPassage
                    , div [ class "row story__wrapper" ]
                        [ div [ class "story__header" ]
                            [ viewLocation <| Dict.get (Engine.getCurrentLocation engine) story.locations
                            , viewCharacters <| List.filterMap (\characterId -> Dict.get characterId story.characters) <| Engine.getCharactersInCurrentLocation engine
                            ]
                        , viewStoryLine currentPassage.narrative (Engine.getEnding engine)
                        ]
                    , div [ class "story__actions" ]
                        [ case Engine.getEnding engine of
                            Just ending ->
                                div [ class "row" ]
                                    [ div [ class "one-half column story__action" ]
                                        [ button [ onClick Restart ] [ text "Read Again" ]
                                        ]
                                    ]

                            Nothing ->
                                viewActions story engine currentPassageId
                        ]
                    ]
                ]

        Nothing ->
            div [ class "page page__story clearfix" ]
                [ div [ class "container" ] [ text "could not find current passage" ]
                ]


viewTitle : String -> Html Msg
viewTitle title =
    div [ class "row story__title" ]
        [ h2 [] [ text title ]
        ]


viewIcons : Story.Passage -> Html Msg
viewIcons passage =
    div [ class "clearfix" ]
        [ div [ class "story__icon story__icon--home" ]
            [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
            ]
        , if Maybe.withDefault "" passage.narrative.audio /= "" then
            div [ class "story__icon story__icon--speak" ]
                [ button [ onClick Speak ] [ i [ class "icon-volume-up" ] [] ]
                ]

          else
            text ""
        ]


viewLocation : Maybe Story.Location -> Html Msg
viewLocation maybeLocation =
    case maybeLocation of
        Just location ->
            div [ class "story__location" ]
                [ h3 [] [ text location.name ]
                , img [ src location.image, alt location.name ] []
                ]

        Nothing ->
            text ""


viewCharacters : List Story.Character -> Html Msg
viewCharacters list =
    case list of
        [] ->
            text ""

        characters ->
            let
                classByIndex : Int -> String
                classByIndex index =
                    if modBy 2 index == 0 then
                        "story__character--primary"

                    else
                        "story__character--secondary"

                toImage : Int -> Story.Character -> Html Msg
                toImage index character =
                    div []
                        [ img [ class <| classByIndex index, src character.image, alt character.name ] []
                        ]
            in
            div [ class "story__characters clearfix" ] <|
                List.indexedMap toImage characters


markdownOptions : Markdown.Options
markdownOptions =
    { githubFlavored = Just { tables = False, breaks = False }
    , defaultHighlighting = Nothing
    , sanitize = False
    , smartypants = True
    }


viewStoryLine : Story.Narrative -> Maybe String -> Html Msg
viewStoryLine narrative maybeEnding =
    div [ class "story__narrative" ]
        [ section [] [ Markdown.toHtmlWith markdownOptions [ class "markdown-body" ] narrative.text ]
        , case maybeEnding of
            Just ending ->
                section [ class "story__ending" ] [ text ending ]

            Nothing ->
                text ""
        ]


viewActions : Story -> Engine.Model -> String -> Html Msg
viewActions story engine currentPassageId =
    let
        viewAction : String -> String -> Html Msg
        viewAction id actionText =
            div [ class "one-half column story__action" ]
                [ button [ onClick <| Interact id ] [ text actionText ]
                ]

        wrapRows : List (Html Msg) -> Html Msg
        wrapRows =
            div [ class "row" ]

        characterActions =
            Engine.getCharactersInCurrentLocation engine
                |> List.filterMap (\id -> Dict.get id story.characters)
                |> List.filter (\{ id, interactable } -> id /= currentPassageId && interactable)
                |> List.map (\{ id, actionText, name } -> viewAction id (Maybe.withDefault name actionText))

        itemActions =
            Engine.getItemsInCurrentLocation engine
                |> List.append (Engine.getItemsInInventory engine)
                |> List.filterMap (\id -> Dict.get id story.items)
                |> List.map (\{ id, actionText } -> viewAction id actionText)

        locationActions =
            Dict.get (Engine.getCurrentLocation engine) story.locations
                |> Maybe.map (\location -> location.connectingLocations)
                |> Maybe.withDefault []
                |> List.filterMap (List.singleton >> Engine.chooseFrom engine)
                |> List.filterMap (\{ id } -> Dict.get id story.locations)
                |> List.map (\{ id, actionText, name } -> viewAction id (Maybe.withDefault name actionText))
    in
    div [ class "story__actions" ]
        (locationActions
            |> List.append itemActions
            |> List.append characterActions
            |> List.Extra.greedyGroupsOf 2
            |> List.map wrapRows
        )



-- UPDATE


type Msg
    = HandleStoryResponse (WebData Story)
    | GoHome
    | Speak
    | Restart
    | Interact String


update : Nav.Key -> Flags -> Msg -> Model -> ( Model, Cmd Msg )
update navKey flags msg model =
    case ( msg, model ) of
        ( HandleStoryResponse response, _ ) ->
            case response of
                NotAsked ->
                    ( NotAsked, Cmd.none )

                Loading ->
                    ( Loading, Cmd.none )

                Failure _ ->
                    ( Failure "error loading story", Cmd.none )

                Success story ->
                    case Story.toEngine story of
                        Ok engine ->
                            ( Success { story = story, engine = engine, currentPassageId = story.startingPassageId }
                            , Port.toJavaScript <| Port.encode <| Port.PreloadImages story.imagesToPreLoad
                            )

                        Err error ->
                            ( Failure error, Cmd.none )

        ( GoHome, _ ) ->
            ( model
            , Cmd.batch
                [ Nav.pushUrl navKey "/"
                , Port.toJavaScript <| Port.encode <| Port.Speak ""
                ]
            )

        ( Speak, Success { story } ) ->
            let
                audioLink =
                    Dict.get story.startingPassageId story.passages
                        |> Maybe.andThen (\passage -> passage.narrative.audio)
                        |> Maybe.withDefault ""
            in
            ( model
            , Port.toJavaScript <| Port.encode <| Port.Speak audioLink
            )

        ( Restart, Success { story } ) ->
            case Story.toEngine story of
                Ok engine ->
                    ( Success { story = story, engine = engine, currentPassageId = story.startingPassageId }
                    , Cmd.none
                    )

                Err error ->
                    ( Failure error, Cmd.none )

        ( Interact interactedWithId, Success { story, engine, currentPassageId } ) ->
            let
                ( newEngine, maybePassageId ) =
                    Engine.update interactedWithId engine
            in
            ( Success
                { story = story
                , engine = newEngine
                , currentPassageId = Maybe.withDefault currentPassageId maybePassageId
                }
            , Port.toJavaScript <| Port.encode <| Port.Speak ""
            )

        _ ->
            -- ignore all other possibilities
            ( model, Cmd.none )
