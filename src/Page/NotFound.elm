module Page.NotFound exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Not Found"
    , content = h1 [] [ text "not found" ]
    }



-- Update


type Msg
    = NoOp


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        _ ->
            ( model, Cmd.none )
