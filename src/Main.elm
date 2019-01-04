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


type Model
    = NotFound Nav.Key NotFound.Model
    | Home Nav.Key Bool Home.Model
    | Story Nav.Key Bool Story.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRouteTo (Route.fromUrl url) (NotFound navKey {})



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
    case model of
        NotFound _ notFoundModel ->
            viewPage (NotFound.view notFoundModel) GotNotFoundMsg

        Home _ loaded homeModel ->
            if loaded then
                viewPage (Home.view homeModel) GotHomeMsg

            else
                viewLoading

        Story _ loaded storyModel ->
            if loaded then
                viewPage (Story.view storyModel) GotStoryMsg

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
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( RequestedUrl urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl (getNavKey model) (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotNotFoundMsg subMsg, NotFound navKey notFoundModel ) ->
            NotFound.update navKey subMsg notFoundModel
                |> updateWith (NotFound navKey) GotNotFoundMsg model

        ( GotHomeMsg subMsg, Home navKey loaded homeModel ) ->
            Home.update navKey subMsg homeModel
                |> updateWith (Home navKey loaded) GotHomeMsg model

        ( GotStoryMsg subMsg, Story navKey loaded storyModel ) ->
            Story.update navKey subMsg storyModel
                |> updateWith (Story navKey loaded) GotStoryMsg model

        ( GotSubscription json, _ ) ->
            case Json.Decode.decodeValue Port.decode json of
                Ok portMsg ->
                    case portMsg of
                        Port.ImagesLoaded ->
                            ( setLoadedOnModel True model, Cmd.none )
                        
                        Port.VoiceLoaded ->
                            let
                                _ = Debug.log "voice loaded" 0
                            in
                            ( model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


setLoadedOnModel : Bool -> Model -> Model
setLoadedOnModel loaded model =
    case model of
        NotFound _ _ ->
            model

        Home navKey _ homeModel ->
            Home navKey loaded homeModel

        Story navKey _ storyModel ->
            Story navKey loaded storyModel


getNavKey : Model -> Nav.Key
getNavKey model =
    case model of
        NotFound navKey _ ->
            navKey

        Home navKey _ _ ->
            navKey

        Story navKey _ _ ->
            navKey


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        navKey =
            getNavKey model
    in
    case maybeRoute of
        Nothing ->
            let
                ( notFoundModel, cmds ) =
                    NotFound.init
            in
            ( NotFound navKey notFoundModel, Cmd.map (always Ignored) cmds )

        Just Route.Home ->
            Home.init
                |> updateWith (Home navKey False) GotHomeMsg model

        Just (Route.Story story) ->
            Story.init story
                |> updateWith (Story navKey False) GotStoryMsg model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
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
