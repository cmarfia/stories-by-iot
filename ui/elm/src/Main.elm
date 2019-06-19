port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Json.Encode
import Page exposing (Page)
import Page.Home
import Page.NotFound
import Page.Story
import Port
import Route exposing (Route)
import Tuple
import Url exposing (Url)



-- MODEL


type Model
    = InitializationError String
    | Loading Nav.Key Flags Page
    | Viewing Nav.Key Flags Page


init : Json.Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flagsValue url navKey =
    case Json.Decode.decodeValue Flags.decode flagsValue of
        Ok flags ->
            let
                ( page, cmds ) =
                    initPageFromRoute flags (Route.fromUrl flags url)
            in
            ( Loading navKey flags page, cmds )

        Err error ->
            ( InitializationError "An error occurred loading the page."
            , Cmd.none
            )



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
        InitializationError error ->
            { title = "Stories By Iot"
            , body =
                [ div [ class "page page__error" ]
                    [ div [ class "container" ]
                        [ p [ ] [ text error ]
                        ]
                    ]
                ]
            }

        Loading _ _ _ ->
            { title = "Stories By Iot"
            , body =
                [ div [ class "page page__loading" ]
                    [ div [ class "container" ]
                        [ div [ class "loading__icon columns" ]
                            [ img [ src "img/loading.gif" ] []
                            ]
                        ]
                    , div [ class "attribution" ]
                        [ a [ href "https://loading.io/" ] [ text "spinner by loading.io" ]
                        ]
                    ]
                ]
            }

        Viewing navKey flags page ->
            case page of
                Page.NotFound notFoundModel ->
                    viewPage (Page.NotFound.view notFoundModel) GotNotFoundMsg

                Page.Home homeModel ->
                    viewPage (Page.Home.view homeModel) GotHomeMsg

                Page.Story storyModel ->
                    viewPage (Page.Story.view storyModel) GotStoryMsg



-- UPDATE


type Msg
    = Loaded Bool
    | RequestedUrl Browser.UrlRequest
    | ChangedUrl Url.Url
    | GotNotFoundMsg Page.NotFound.Msg
    | GotHomeMsg Page.Home.Msg
    | GotStoryMsg Page.Story.Msg
    | GotSubscription Json.Encode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        InitializationError _ ->
            -- Disregard all messages when an initialization error happens
            ( model, Cmd.none )

        Loading navKey flags page ->
            case ( msg, page ) of
                ( RequestedUrl urlRequest, _ ) ->
                    case urlRequest of
                        Browser.Internal url ->
                            case url.fragment of
                                Nothing ->
                                    ( model, Cmd.none )

                                Just _ ->
                                    ( model, Nav.pushUrl navKey (Url.toString url) )

                        Browser.External href ->
                            ( model, Nav.load href )

                ( ChangedUrl url, _ ) ->
                    let
                        ( updatedPage, cmds ) =
                            initPageFromRoute flags (Route.fromUrl flags url)
                    in
                    ( Loading navKey flags updatedPage, cmds )

                ( GotSubscription json, _ ) ->
                    case Json.Decode.decodeValue Port.decode json of
                        Ok portMsg ->
                            case portMsg of
                                Port.ImagesLoaded ->
                                    ( Viewing navKey flags page, Cmd.none )

                        Err _ ->
                            ( model, Cmd.none )

                ( GotNotFoundMsg subMsg, Page.NotFound notFoundModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.NotFound.update navKey flags subMsg notFoundModel
                                |> updatePageWith Page.NotFound GotNotFoundMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                ( GotHomeMsg subMsg, Page.Home homeModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.Home.update navKey flags subMsg homeModel
                                |> updatePageWith Page.Home GotHomeMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                ( GotStoryMsg subMsg, Page.Story storyModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.Story.update navKey flags subMsg storyModel
                                |> updatePageWith Page.Story GotStoryMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                _ ->
                    -- Disregard messages when the page is currently loading.
                    ( model, Cmd.none )

        Viewing navKey flags page ->
            case ( msg, page ) of
                ( RequestedUrl urlRequest, _ ) ->
                    case urlRequest of
                        Browser.Internal url ->
                            case url.fragment of
                                Nothing ->
                                    ( model, Cmd.none )

                                Just _ ->
                                    ( model, Nav.pushUrl navKey (Url.toString url) )

                        Browser.External href ->
                            ( model, Nav.load href )

                ( ChangedUrl url, _ ) ->
                    let
                        ( updatedPage, cmds ) =
                            initPageFromRoute flags (Route.fromUrl flags url)
                    in
                    ( Loading navKey flags updatedPage, cmds )

                ( GotNotFoundMsg subMsg, Page.NotFound notFoundModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.NotFound.update navKey flags subMsg notFoundModel
                                |> updatePageWith Page.NotFound GotNotFoundMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                ( GotHomeMsg subMsg, Page.Home homeModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.Home.update navKey flags subMsg homeModel
                                |> updatePageWith Page.Home GotHomeMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                ( GotStoryMsg subMsg, Page.Story storyModel ) ->
                    let
                        ( updatedPage, cmds ) =
                            Page.Story.update navKey flags subMsg storyModel
                                |> updatePageWith Page.Story GotStoryMsg
                    in
                    ( Viewing navKey flags updatedPage, cmds )

                ( _, _ ) ->
                    -- Disregard messages that arrived for the wrong page.
                    ( model, Cmd.none )


initPageFromRoute : Flags -> Maybe Route -> ( Page, Cmd Msg )
initPageFromRoute flags maybeRoute =
    case maybeRoute of
        Nothing ->
            Page.NotFound.init flags
                |> updatePageWith Page.NotFound GotNotFoundMsg

        Just Route.Home ->
            Page.Home.init flags
                |> updatePageWith Page.Home GotHomeMsg

        Just (Route.Story story) ->
            Page.Story.init flags story
                |> updatePageWith Page.Story GotStoryMsg


updatePageWith : (subModel -> Page) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Page, Cmd Msg )
updatePageWith toPage toMsg ( subModel, subCmd ) =
    ( toPage subModel
    , Cmd.map toMsg subCmd
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Port.fromJavaScript GotSubscription


main : Program Json.Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = RequestedUrl
        }
