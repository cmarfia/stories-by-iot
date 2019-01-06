module Page.Story exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Engine exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import Json.Encode
import Markdown
import Port
import Story exposing (Story)
import Story.Components exposing (..)
import Url


type alias Model =
    { engineModel : Engine.Model
    , story : Story
    , storyLine : List Snippet
    , narrativeContent : Dict String String
    }


init : Story -> ( Model, Cmd Msg )
init story =
    let
        manifest =
            Story.getManifest story

        rules =
            Story.getRules story

        engineModel =
            Engine.init
                { items = List.map Tuple.first manifest.items
                , locations = List.map Tuple.first manifest.locations
                , characters = List.map Tuple.first manifest.characters
                }
                (Dict.map getRuleData rules)
                |> Engine.changeWorld (Story.getStartingState story)

        loadImagesMsg =
            Port.PreloadImages (Story.getImagesToPreload story)
    in
    ( { engineModel = engineModel
      , story = story
      , storyLine = [ Story.getStartingNarrative story ]
      , narrativeContent = Dict.map getNarrative rules
      }
    , Port.toJavaScript (Port.encode loadImagesMsg)
    )



-- View


type alias DisplayState =
    { title : String
    , currentLocation : Entity
    , itemsInCurrentLocation : List Entity
    , charactersInCurrentLocation : List Entity
    , connectingLocations : List Entity
    , ending : Maybe String
    , storyLine : List { interactableName : String, interactableCssSelector : String, narrative : String }
    }


view : Bool -> Model -> { title : String, content : Html Msg }
view voiceLoaded model =
    { title = Story.getTitle model.story
    , content = viewLayout voiceLoaded (getDisplayState model)
    }


viewLayout : Bool -> DisplayState -> Html Msg
viewLayout voiceLoaded displayState =
    div [ class "page page__story" ]
        [ div [ class "container" ]
            [ viewTitle displayState.title
            , viewIcons voiceLoaded
            , div
                [ class "row" ]
                [ viewCharacters displayState.charactersInCurrentLocation
                , div [ class "Layout__Main" ] <|
                    [ viewStoryLine displayState.storyLine displayState.ending
                    , div []
                        (if displayState.ending /= Nothing then
                            [ button [ class "StoryRestart", onClick Restart ] [ text "Restart" ] ]

                         else
                            List.map viewItem displayState.itemsInCurrentLocation
                        )
                    ]
                , viewConnectingLocations displayState.connectingLocations
                ]
            ]
        ]


viewTitle : String -> Html Msg
viewTitle title =
    div [ class "row story__title" ]
        [ h2 [] [ text title ]
        ]


viewIcons : Bool -> Html Msg
viewIcons voiceLoaded =
    div [ class "clearfix" ]
        [ div [ class "story__icon story__icon--home" ]
            [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
            ]
        , if voiceLoaded then
            div [ class "story__icon story__icon--speak" ]
                [ button [ onClick Speak ] [ i [ class "icon-volume-up" ] [] ]
                ]

          else
            text ""
        ]


viewItem : Entity -> Html Msg
viewItem item =
    button [ class "story__action", onClick <| Interact <| Tuple.first item ] [ text <| getActionTextOrName item ]


viewCharacters : List Entity -> Html Msg
viewCharacters characters =
    let
        toImage character =
            div []
                [ img [ src <| Maybe.withDefault "" <| getImage character ] []
                , if getInteractable character then
                    button [ onClick <| Interact <| Tuple.first character ] [ text <| (++) "Speak with " <| getName character ]

                  else
                    text ""
                ]
    in
    div [ class "Characters" ] <|
        List.map toImage characters


viewConnectingLocations : List Entity -> Html Msg
viewConnectingLocations locations =
    let
        viewLocation location =
            button [ onClick <| Interact <| Tuple.first location ] [ text <| (++) "Go To " <| getName location ]
    in
    div [ class "story__locations" ] <|
        List.map viewLocation locations


viewStoryLine : List Snippet -> Maybe String -> Html Msg
viewStoryLine storyLine ending =
    div [ class "StoryLine" ]
        [ case List.head storyLine of
            Just { narrative } ->
                section [] [ Markdown.toHtml [ class "Storyline__Item__Narrative markdown-body" ] narrative ]

            Nothing ->
                text ""
        , if ending /= Nothing then
            h5
                [ class "Storyline__Item__Ending" ]
                [ text <| Maybe.withDefault "The End" ending ]

          else
            text ""
        ]


getDisplayState : Model -> DisplayState
getDisplayState model =
    let
        manifest =
            Story.getManifest model.story

        currentLocation =
            Engine.getCurrentLocation model.engineModel |> findEntity manifest
    in
    { title = Story.getTitle model.story
    , currentLocation = currentLocation
    , itemsInCurrentLocation = Engine.getItemsInCurrentLocation model.engineModel |> List.map (findEntity manifest)
    , charactersInCurrentLocation = Engine.getCharactersInCurrentLocation model.engineModel |> List.map (findEntity manifest)
    , connectingLocations = getConnectingLocations currentLocation |> List.map (findEntity manifest)
    , ending = Engine.getEnding model.engineModel
    , storyLine = model.storyLine
    }



-- UPDATE


type Msg
    = Interact String
    | Restart
    | GoHome
    | Speak


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        Interact interactableId ->
            let
                manifest =
                    Story.getManifest model.story

                ( newEngineModel, maybeMatchedRuleId ) =
                    Engine.update interactableId model.engineModel

                narrativeForThisInteraction =
                    { interactableName = findEntity manifest interactableId |> getName
                    , interactableCssSelector = findEntity manifest interactableId |> getClassName
                    , narrative =
                        maybeMatchedRuleId
                            |> Maybe.andThen (\id -> Dict.get id model.narrativeContent)
                            |> Maybe.withDefault (List.head model.storyLine |> Maybe.map .narrative |> Maybe.withDefault "")
                    }

                checkEnd =
                    case maybeMatchedRuleId of
                        Just "TheEnd" ->
                            Engine.changeWorld [ endStory "" ]

                        _ ->
                            identity
            in
            ( { model
                | engineModel = newEngineModel |> checkEnd
                , storyLine = narrativeForThisInteraction :: model.storyLine
              }
            , Port.Speak ""
                |> Port.encode
                |> Port.toJavaScript
            )

        Restart ->
            init model.story

        GoHome ->
            ( model
            , Cmd.batch
                [ Nav.pushUrl navKey "/"
                , Port.Speak ""
                    |> Port.encode
                    |> Port.toJavaScript
                ]
            )

        Speak ->
            let
                narrative =
                    model.storyLine
                        |> List.head
                        |> Maybe.map .narrative
                        |> Maybe.withDefault ""
            in
            ( model
            , Port.Speak narrative
                |> Port.encode
                |> Port.toJavaScript
            )
