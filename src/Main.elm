port module Main exposing (Model, findEntity, init, loaded, main, speak, update, view)

import Browser
import Browser.Navigation
import ClientTypes exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import Engine exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode
import Manifest
import Narrative
import Rules
import Theme.Layout
import Tuple


port speak : Json.Encode.Value -> Cmd msg


port loaded : (Bool -> msg) -> Sub msg



{- This is the kernel of the whole app.  It glues everything together and handles some logic such as choosing the correct narrative to display.
   You shouldn't need to change anything in this file, unless you want some kind of different behavior.
-}


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine : List StorySnippet
    , narrativeContent : Dict String String
    }


init : ( Model, Cmd ClientTypes.Msg )
init =
    let
        engineModel =
            Engine.init
                { items = List.map Tuple.first Manifest.items
                , locations = List.map Tuple.first Manifest.locations
                , characters = List.map Tuple.first Manifest.characters
                }
                (Dict.map (\k v -> getRuleData ( k, v )) Rules.rules)
                |> Engine.changeWorld Rules.startingState
    in
    ( { engineModel = engineModel
      , loaded = False
      , storyLine = [ Narrative.startingNarrative ]
      , narrativeContent = Dict.map (\k v -> getNarrative ( k, v )) Rules.rules
      }
    , Cmd.none
    )


findEntity : String -> Entity
findEntity id =
    (Manifest.items ++ Manifest.locations ++ Manifest.characters)
        |> List.filter (Tuple.first >> (==) id)
        |> List.head
        |> Maybe.withDefault (entity id)


update : ClientTypes.Msg -> Model -> ( Model, Cmd ClientTypes.Msg )
update msg model =
    case msg of
        Interact interactableId ->
            let
                ( newEngineModel, maybeMatchedRuleId ) =
                    Engine.update interactableId model.engineModel

                narrativeForThisInteraction =
                    { interactableName = findEntity interactableId |> getName
                    , interactableCssSelector = findEntity interactableId |> getClassName
                    , narrative =
                        maybeMatchedRuleId
                            |> Maybe.andThen (\id -> Dict.get id model.narrativeContent)
                            |> Maybe.withDefault (List.head model.storyLine |> Maybe.map .narrative |> Maybe.withDefault "")
                    }

                checkEnd =
                    case maybeMatchedRuleId of
                        Just "Ending" ->
                            Engine.changeWorld [ endStory "The End" ]

                        _ ->
                            identity
            in
            ( { model
                | engineModel = newEngineModel |> checkEnd
                , storyLine = narrativeForThisInteraction :: model.storyLine
              }
            , speak (Json.Encode.string narrativeForThisInteraction.narrative)
            )

        Loaded ->
            ( { model | loaded = True }
            , speak (Json.Encode.string Narrative.startingNarrative.narrative)
            )

        Restart ->
            ( { model | loaded = False }, Browser.Navigation.reload )


view : Model -> Html ClientTypes.Msg
view model =
    let
        currentLocation =
            Engine.getCurrentLocation model.engineModel |> findEntity

        displayState =
            { currentLocation = currentLocation
            , itemsInCurrentLocation =
                Engine.getItemsInCurrentLocation model.engineModel
                    |> List.map findEntity
            , charactersInCurrentLocation =
                Engine.getCharactersInCurrentLocation model.engineModel
                    |> List.map findEntity
            , itemsInInventory =
                Engine.getItemsInInventory model.engineModel
                    |> List.map findEntity
            , ending =
                Engine.getEnding model.engineModel
            , storyLine =
                model.storyLine
            }
    in
    if not model.loaded then
        div [ class "Loading" ] [ text "Loading..." ]

    else
        Theme.Layout.view displayState


main : Program () Model ClientTypes.Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = \_ -> loaded <| always Loaded
        }
