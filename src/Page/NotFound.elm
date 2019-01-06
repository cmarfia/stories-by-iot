module Page.NotFound exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot > Not Found"
    , content =
        div []
            [ button [ onClick GoHome ] [ text "Go Home" ]
            , h1 [] [ text "not found" ]
            ]
    }



-- Update


type Msg
    = GoHome


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        GoHome ->
            ( model, Nav.pushUrl navKey "/" )
