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
import Json.Encode
import List.Extra
import Markdown
import Port
import RemoteData exposing (RemoteData(..), WebData)
import Story exposing (Story, Narrative)
import Story.Components exposing (..)
import Url



{-
   Things needed for the story
   Engine
   Rules


-}


type alias Model =
    { story : WebData Story
    }



-- { engineModel : Engine.Model
-- , story : Story
-- , storyLine : List Narrative
-- , narrativeContent : Dict String String
-- }


init : Flags -> StoryInfo -> ( Model, Cmd Msg )
init _ story =
    ( { story = Loading }, API.getStoryById story.id HandleStoryResponse )



-- let
-- -- https://package.elm-lang.org/packages/ohanhi/remotedata-http/4.0.0/
-- manifest =
--     Story.getManifest story
-- rules =
--     Story.getRules story
-- engineModel =
--     Engine.init
--         { items = List.map Tuple.first manifest.items
--         , locations = List.map Tuple.first manifest.locations
--         , characters = List.map Tuple.first manifest.characters
--         }
--         (Dict.map getRuleData rules)
--         |> Engine.changeWorld (Story.getStartingState story)
-- loadImagesMsg =
--     Port.PreloadImages (Story.getImagesToPreload story)
-- in
-- ( { engineModel = engineModel
--   , story = story
--   , storyLine = [ Story.getStartingNarrative story ]
--   , narrativeContent = Dict.map getNarrative rules
--   }
-- , Port.toJavaScript (Port.encode loadImagesMsg)
-- )
-- View
-- type alias DisplayState =
--     { title : String
--     , currentLocation : Entity
--     , itemsInCurrentLocation : List Entity
--     , charactersInCurrentLocation : List Entity
--     , connectingLocations : List Entity
--     , ending : Maybe String
--     , storyLine : List Narrative
--     }


view : Model -> { title : String, content : Html Msg }
view model =
    case model.story of
        Loading ->
            { title = "Story Page"
            , content = text "Loading..."
            }

        Success story ->
            { title = "Story Page"
            , content = text <| Debug.toString story
            }

        Failure error ->
            { title = "Story Page"
            , content = text <| Debug.toString error
            }

        NotAsked ->
            { title = "Story Page"
            , content = text "Not loaded"
            }



-- viewLayout : Bool -> DisplayState -> Html Msg
-- viewLayout voiceLoaded displayState =
--     div [ class "page page__story clearfix" ]
--         [ div [ class "container" ]
--             [ viewTitle displayState.title
--             , viewIcons voiceLoaded
--             , div [ class "row story__wrapper" ]
--                 [ div [ class "story__header" ]
--                     [ viewLocation displayState.currentLocation
--                     , viewCharacters displayState.charactersInCurrentLocation
--                     ]
--                 , viewStoryLine displayState.storyLine
--                 ]
--             , div [ class "story__actions" ]
--                 [ viewActions displayState.ending displayState.storyLine displayState.charactersInCurrentLocation displayState.itemsInCurrentLocation displayState.connectingLocations
--                 ]
--             ]
--         ]
-- viewTitle : String -> Html Msg
-- viewTitle title =
--     div [ class "row story__title" ]
--         [ h2 [] [ text title ]
--         ]
-- viewIcons : Bool -> Html Msg
-- viewIcons voiceLoaded =
--     div [ class "clearfix" ]
--         [ div [ class "story__icon story__icon--home" ]
--             [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
--             ]
--         , if voiceLoaded then
--             div [ class "story__icon story__icon--speak" ]
--                 [ button [ onClick Speak ] [ i [ class "icon-volume-up" ] [] ]
--                 ]
--           else
--             text ""
--         ]
-- viewItem : Entity -> Html Msg
-- viewItem item =
--     button [ class "story__action", onClick <| Interact <| Tuple.first item ] [ text <| getActionTextOrName item ]
-- viewLocation : Entity -> Html Msg
-- viewLocation location =
--     let
--         locationName =
--             getName location
--     in
--     div [ class "story__location" ]
--         [ h3 [] [ text locationName ]
--         , img [ src <| Maybe.withDefault "" <| getImage location, alt locationName ] []
--         ]
-- viewCharacters : List Entity -> Html Msg
-- viewCharacters characters =
--     let
--         classByIndex : Int -> String
--         classByIndex index =
--             if modBy 2 index == 0 then
--                 "story__character--primary"
--             else
--                 "story__character--secondary"
--         toImage : Int -> Entity -> Html Msg
--         toImage index character =
--             div []
--                 [ img [ class <| classByIndex index, src <| Maybe.withDefault "" <| getImage character ] []
--                 ]
--     in
--     div [ class "story__characters clearfix" ] <|
--         List.indexedMap toImage characters
-- viewActions : Maybe String -> List Narrative -> List Entity -> List Entity -> List Entity -> Html Msg
-- viewActions endStory storyLine characters items locations =
--     div [] <|
--         if endStory /= Nothing then
--             [ div [ class "row" ]
--                 [ div [ class "one-half column story__action" ]
--                     [ button [ onClick Restart ] [ text "Read Again" ]
--                     ]
--                 ]
--             ]
--         else
--             let
--                 viewAction : Entity -> Html Msg
--                 viewAction action =
--                     div [ class "one-half column story__action" ]
--                         [ button [ onClick <| Interact <| Tuple.first action ] [ text <| getActionTextOrName action ]
--                         ]
--                 wrapRows : List (Html Msg) -> Html Msg
--                 wrapRows =
--                     div [ class "row" ]
--                 lastActionId =
--                     storyLine
--                         |> List.head
--                         |> Maybe.map .interactableId
--                         |> Maybe.withDefault ""
--                 characterActions =
--                     characters
--                         |> List.filter getInteractable
--                         |> List.filter (Tuple.first >> (/=) lastActionId)
--                         |> List.map viewAction
--                 itemActions =
--                     List.map viewAction items
--                 locationActions =
--                     List.map viewAction locations
--             in
--             locationActions
--                 |> List.append itemActions
--                 |> List.append characterActions
--                 |> List.Extra.greedyGroupsOf 2
--                 |> List.map wrapRows
-- viewStoryLine : List Narrative -> Html Msg
-- viewStoryLine storyLine =
--     div [ class "story__narrative" ]
--         [ case List.head storyLine of
--             Just { narrative } ->
--                 section [] [ Markdown.toHtmlWith markdownOptions [ class "markdown-body" ] narrative ]
--             Nothing ->
--                 text ""
--         ]
-- markdownOptions : Markdown.Options
-- markdownOptions =
--     { githubFlavored = Just { tables = False, breaks = False }
--     , defaultHighlighting = Nothing
--     , sanitize = False
--     , smartypants = True
--     }
-- getDisplayState : Model -> DisplayState
-- getDisplayState model =
--     let
--         manifest =
--             Story.getManifest model.story
--         currentLocation =
--             Engine.getCurrentLocation model.engineModel |> findEntity manifest
--     in
--     { title = Story.getTitle model.story
--     , currentLocation = currentLocation
--     , itemsInCurrentLocation = Engine.getItemsInCurrentLocation model.engineModel |> List.map (findEntity manifest)
--     , charactersInCurrentLocation = Engine.getCharactersInCurrentLocation model.engineModel |> List.map (findEntity manifest)
--     , connectingLocations = getConnectingLocations currentLocation |> List.map (findEntity manifest)
--     , ending = Engine.getEnding model.engineModel
--     , storyLine = model.storyLine
--     }
-- UPDATE


type Msg
    = HandleStoryResponse (WebData Story)



-- | Interact String
-- | Restart
-- | GoHome
-- | Speak


update : Nav.Key -> Flags -> Msg -> Model -> ( Model, Cmd Msg )
update navKey flags msg model =
    case msg of
        HandleStoryResponse data ->
            ( { story = data }, Cmd.none )



-- Interact interactableId ->
--     let
--         manifest =
--             Story.getManifest model.story
--         ( newEngineModel, maybeMatchedRuleId ) =
--             Engine.update interactableId model.engineModel
--         narrativeForThisInteraction =
--             { interactableId = interactableId
--             , audio = Nothing
--             , narrative =
--                 maybeMatchedRuleId
--                     |> Maybe.andThen (\id -> Dict.get id model.narrativeContent)
--                     |> Maybe.withDefault (List.head model.storyLine |> Maybe.map .narrative |> Maybe.withDefault "")
--             }
--         checkEnd =
--             case maybeMatchedRuleId of
--                 Just "TheEnd" ->
--                     Engine.changeWorld [ endStory "" ]
--                 _ ->
--                     identity
--     in
--     ( { model
--         | engineModel = newEngineModel |> checkEnd
--         , storyLine = narrativeForThisInteraction :: model.storyLine
--       }
--     , Port.Speak ""
--         |> Port.encode
--         |> Port.toJavaScript
--     )
-- Restart ->
--     init flags model.story
-- GoHome ->
--     ( model
--     , Cmd.batch
--         [ Nav.pushUrl navKey "/"
--         , Port.Speak ""
--             |> Port.encode
--             |> Port.toJavaScript
--         ]
--     )
-- Speak ->
--     let
--         narrative =
--             model.storyLine
--                 |> List.head
--                 |> Maybe.map .narrative
--                 |> Maybe.withDefault ""
--     in
--     ( model
--     , Port.Speak narrative
--         |> Port.encode
--         |> Port.toJavaScript
--     )
