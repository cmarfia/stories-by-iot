module Page.NotFound exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Flags exposing (Flags)



-- MODEL


type alias Model =
    {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    let
        loadImagesMsg =
            Port.PreloadImages [ "img/logo.png" ]
    in
    ( {}, Port.toJavaScript (Port.encode loadImagesMsg) )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot > Not Found"
    , content =
        div [ class "page page_notFound clearfix" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "one column" ] []
                    , div [ class "ten columns header clearfix" ]
                        [ img [ src "img/logo.png", alt "logo" ] []
                        , p [] [ text "Stories By Iot" ]
                        ]
                    , div [ class "one column stories" ] []
                    ]
                , div [ class "clearfix" ]
                    [ div [ class "story__icon story__icon--home" ]
                        [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
                        ]
                    ]
                , div [ class "row notFound__message" ]
                    [ img [ src "img/404.png", alt "Page Not Found" ] []
                    ]
                ]
            ]
    }



-- Update


type Msg
    = GoHome


update : Nav.Key -> Flags -> Msg -> Model -> ( Model, Cmd Msg )
update navKey _ msg model =
    case msg of
        GoHome ->
            ( model, Nav.pushUrl navKey "/" )
