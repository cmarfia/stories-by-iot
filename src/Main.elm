port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Json.Encode
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Story as Story
import Port
import Route exposing (Route)
import Tuple
import Url exposing (Url)



-- MODEL


type Page
    = NotFound NotFound.Model
    | Home Home.Model
    | Story Story.Model


type alias Model =
    { navKey : Nav.Key
    , loaded : Bool
    , voiceLoaded : Bool
    , page : Page
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    { navKey = navKey, loaded = False, voiceLoaded = False, page = NotFound {} }
        |> changeRouteTo (Route.fromUrl url) 


-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage { title, content } toMsg =
            { title = title
            , body = [ Html.map toMsg content ]
            }

        viewLoading =
            { title = "Stories By Iot"
            , body =
                [ div [] [ text "Loading" ]
                ]
            }
    in
    case model.page of
        NotFound notFoundModel ->
            viewPage (NotFound.view notFoundModel) GotNotFoundMsg

        Home homeModel ->
            if model.loaded then
                viewPage (Home.view homeModel) GotHomeMsg

            else
                viewLoading

        Story storyModel ->
            if model.loaded then
                viewPage (Story.view model.voiceLoaded storyModel) GotStoryMsg

            else
                viewLoading



-- UPDATE


type Msg
    = Ignored
    | Loaded Bool
    | RequestedUrl Browser.UrlRequest
    | ChangedUrl Url.Url
    | GotNotFoundMsg NotFound.Msg
    | GotHomeMsg Home.Msg
    | GotStoryMsg Story.Msg
    | GotSubscription Json.Encode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( RequestedUrl urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotNotFoundMsg subMsg, NotFound notFoundModel ) ->
            NotFound.update model.navKey subMsg notFoundModel
                |> updatePageWith NotFound GotNotFoundMsg
                |> updateModelWith model

        ( GotHomeMsg subMsg, Home homeModel ) ->
            Home.update model.navKey subMsg homeModel
                |> updatePageWith Home GotHomeMsg
                |> updateModelWith model

        ( GotStoryMsg subMsg, Story storyModel ) ->
            Story.update model.navKey subMsg storyModel
                |> updatePageWith Story GotStoryMsg
                |> updateModelWith model

        ( GotSubscription json, _ ) ->
            case Json.Decode.decodeValue Port.decode json of
                Ok portMsg ->
                    case portMsg of
                        Port.ImagesLoaded ->
                            ( { model | loaded = True }, Cmd.none )

                        Port.VoiceLoaded ->
                            ( { model | voiceLoaded = True }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            NotFound.init
                |> updatePageWith NotFound GotNotFoundMsg
                |> updateModelWith { model | loaded = True }

        Just Route.Home ->
            Home.init
                |> updatePageWith Home GotHomeMsg
                |> updateModelWith model

        Just (Route.Story story) ->
            Story.init story
                |> updatePageWith Story GotStoryMsg
                |> updateModelWith model

updateModelWith : Model -> ( Page, Cmd Msg) -> ( Model, Cmd Msg)
updateModelWith model (page, cmds) =
    ( { model | page = page }, cmds)

updatePageWith : (subModel -> Page) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Page, Cmd Msg )
updatePageWith toPage toMsg ( subModel, subCmd ) =
    ( toPage subModel
    , Cmd.map toMsg subCmd
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Port.fromJavaScript GotSubscription


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = RequestedUrl
        }
