module Page.Dashboard exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import API
import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import RemoteData exposing (RemoteData(..), WebData)
import Route
import Story



-- MODEL


type alias Model =
    RemoteData String { stories : List Story.Info }


init : List Story.Info -> ( Model, Cmd Msg )
init stories =
    let
        _ =
            Debug.log "in init" stories
    in
    ( Loading, API.getStories HandleStoriesResponse )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    case model of
        Loading ->
            { title = "Story Page"
            , content = text "Loading..."
            }

        Success { stories } ->
            { title = "Dashboard | Stories By Iot"
            , content =
                div [ class "page page__dashboard clearfix" ]
                    [ div [ class "container" ]
                        [ div [ class "row" ]
                            [ div [ class "column" ] [ text "admin dashboard" ]
                            ]
                        ]
                    , div [ class "clearfix" ]
                        [ div [ class "story__icon story__icon--home" ]
                            [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
                            ]
                        ]
                    , div [ class "row" ] (List.map viewStory stories)
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


viewStory : Story.Info -> Html Msg
viewStory storyInfo =
    div [ class "one-half column story" ]
        [ img [ src storyInfo.coverImage, alt storyInfo.title, onClick <| GoToEdit storyInfo.id ] []
        ]



-- Update


type Msg
    = GoHome
    | GoToEdit String
    | HandleStoriesResponse (WebData (List Story.Info))


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        GoToEdit storyId ->
            ( model, Nav.pushUrl navKey <| Route.routeToString <| Route.EditStory storyId )

        GoHome ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Home )

        HandleStoriesResponse response ->
            case response of
                NotAsked ->
                    ( NotAsked, Cmd.none )

                Loading ->
                    ( Loading, Cmd.none )

                Failure _ ->
                    ( Failure "error loading stories", Cmd.none )

                Success stories ->
                    ( Success { stories = stories }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
