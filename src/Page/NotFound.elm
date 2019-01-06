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
        div [ class "page page_notFound" ]
            [ div [ class "Container" ]
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
                    [ i [ class "icon-frown-o" ] []
                    , p [] [ text "Ope!" ]
                    , p [] [ text "Looks like nothing is here..." ]
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
            ( model, Nav.pushUrl navKey "/" )
