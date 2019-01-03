module Page.Home exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)



-- Model


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Story Telling"
    , content = a [ href "#/how-jarald-and-tenzin-met" ] [ text "How Jarald And Tenzin Met" ]
    }



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )
