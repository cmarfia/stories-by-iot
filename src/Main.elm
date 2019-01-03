port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Story as Story
import Port exposing (..)
import Route exposing (Route)
import Tuple
import Url exposing (Url)



-- MODEL


type Model
    = NotFound Nav.Key NotFound.Model
    | Home Nav.Key Home.Model
    | Story Nav.Key Story.Model


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
    in
    case model of
        NotFound _ notFoundModel ->
            viewPage (NotFound.view notFoundModel) (always Ignored)

        Home _ homeModel ->
            viewPage (Home.view homeModel) GotHomeMsg

        Story _ storyModel ->
            viewPage (Story.view storyModel) GotStoryMsg



-- UPDATE


type Msg
    = Ignored
    | Loaded Bool
    | RequestedUrl Browser.UrlRequest
    | ChangedUrl Url.Url
    | GotNotFoundMsg NotFound.Msg
    | GotHomeMsg Home.Msg
    | GotStoryMsg Story.Msg


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

        ( GotHomeMsg subMsg, Home navKey homeModel ) ->
            Home.update navKey subMsg homeModel
                |> updateWith (Home navKey) GotHomeMsg model

        ( GotStoryMsg subMsg, Story navKey storyModel ) ->
            Story.update navKey subMsg storyModel
                |> updateWith (Story navKey) GotStoryMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


getNavKey : Model -> Nav.Key
getNavKey model =
    case model of
        NotFound navKey _ ->
            navKey

        Home navKey _ ->
            navKey

        Story navKey _ ->
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
                |> updateWith (Home navKey) GotHomeMsg model

        Just (Route.Story story) ->
            Story.init story
                |> updateWith (Story navKey) GotStoryMsg model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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
