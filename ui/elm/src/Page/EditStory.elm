module Page.EditStory exposing (Model, Msg(..), init, update, view)

import API
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import RemoteData exposing (RemoteData(..), WebData)
import Route
import Story as Story exposing (Story)



-- MODEL


type alias Model =
    RemoteData String { story : Story }


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

        Success { story } ->
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


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        GoHome ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Home )

        GoToDashboard ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Dashboard )

        HandleStoryResponse response ->
            case response of
                NotAsked ->
                    ( NotAsked, Cmd.none )

                Loading ->
                    ( Loading, Cmd.none )

                Failure _ ->
                    ( Failure "error loading story", Cmd.none )

                Success story ->
                    ( Success { story = story }, Cmd.none )
