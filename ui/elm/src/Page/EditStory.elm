module Page.EditStory exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Route
import Story



-- MODEL


type alias Model =
    {}


init : List Story.Info -> String -> ( Model, Cmd Msg )
init _ _ =
    ( {}, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Not Found | Stories By Iot"
    , content =
        div [ class "page page_dashboard clearfix" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "column" ] [ text "Admin Edit Story" ]
                    ]
                , div [ class "clearfix" ]
                    [ div [ class "story__icon story__icon--home" ]
                        [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
                        ]
                    ]
                ]
            ]
    }



-- Update


type Msg
    = GoHome


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        GoHome ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Home )
