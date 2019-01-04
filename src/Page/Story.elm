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
    { currentLocation : Entity
    , itemsInCurrentLocation : List Entity
    , charactersInCurrentLocation : List Entity
    , itemsInInventory : List Entity
    , ending : Maybe String
    , storyLine : List { interactableName : String, interactableCssSelector : String, narrative : String }
    }


view : Model -> { title : String, content : Html Msg }
view model =
    { title = Story.getTitle model.story
    , content = viewLayout (getDisplayState model)
    }


viewLayout : DisplayState -> Html Msg
viewLayout displayState =
    div [ class <| "Location Location--" ++ getClassName displayState.currentLocation, style "background-image" ("url(" ++ (Maybe.withDefault "" <| getImage displayState.currentLocation) ++ ")") ]
        [ button [ onClick GoHome ] [ text "Go Home" ]
        , div
            [ class "Layout" ]
            [ viewCharacters displayState.charactersInCurrentLocation
            , div [ class "Layout__Main" ] <|
                [ viewStoryLine displayState.storyLine displayState.ending
                , if displayState.ending /= Nothing then
                    h5 [ class "StoryRestart", onClick Restart ] [ text "Restart" ]

                  else
                    h5 [ class "StoryContinue", onClick (Interact "next") ] [ text "Continue" ]
                ]
            ]
        ]


viewCharacters : List Entity -> Html Msg
viewCharacters characters =
    let
        toImage character =
            div []
                [ img [ src <| Maybe.withDefault "" <| getImage character ] []
                ]
    in
    div [ class "Characters" ] <|
        List.map toImage characters


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
    in
    { currentLocation = Engine.getCurrentLocation model.engineModel |> findEntity manifest
    , itemsInCurrentLocation = Engine.getItemsInCurrentLocation model.engineModel |> List.map (findEntity manifest)
    , charactersInCurrentLocation = Engine.getCharactersInCurrentLocation model.engineModel |> List.map (findEntity manifest)
    , itemsInInventory = Engine.getItemsInInventory model.engineModel |> List.map (findEntity manifest)
    , ending = Engine.getEnding model.engineModel
    , storyLine = model.storyLine
    }



-- UPDATE


type Msg
    = Interact String
    | Restart
    | GoHome


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
            , Cmd.none
            )

        Restart ->
            init model.story

        GoHome ->
            ( model, Nav.pushUrl navKey "/" )



{-

-}
