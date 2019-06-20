module Route exposing (Route(..), fromUrl, routeToString, toHref)

import Flags exposing (Flags)
import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Story



-- ROUTING


type Route
    = Home
    | Story Story.Info
    | Dashboard
    | EditStory String


toHref : Route -> Attribute msg
toHref targetRoute =
    href (routeToString targetRoute)


fromUrl : List Story.Info -> Url -> Maybe Route
fromUrl stories url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse (parser stories)


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Story { slug } ->
                    [ slug ]

                Dashboard ->
                    [ "admin", "dashboard" ]

                EditStory storyId ->
                    [ "admin", "edit", storyId ]
    in
    "#/" ++ String.join "/" pieces



-- Internal Helpers


parser : List Story.Info -> Parser (Route -> a) a
parser stories =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Dashboard (s "admin" </> s "dashboard")
        , Parser.map EditStory (s "admin" </> s "edit" </> string)
        , Parser.map Story <| storyParser stories
        ]


storyParser : List Story.Info -> Parser (Story.Info -> a) a
storyParser stories =
    let
        toParser story =
            Parser.map story (s story.slug)
    in
    oneOf (List.map toParser stories)
