module Route exposing (Route(..), fromUrl, routeToString, toHref)

import Flags exposing (Flags, StoryInfo)
import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)



-- ROUTING


type Route
    = Home
    | Story StoryInfo
    | Dashboard
    | EditStory String


toHref : Route -> Attribute msg
toHref targetRoute =
    href (routeToString targetRoute)


fromUrl : Flags -> Url -> Maybe Route
fromUrl flags url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse (parser flags)


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


parser : Flags -> Parser (Route -> a) a
parser flags =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Dashboard (s "admin" </> s "dashboard")
        , Parser.map EditStory (s "admin" </> s "edit" </> string)
        , Parser.map Story <| storyParser flags
        ]


storyParser : Flags -> Parser (StoryInfo -> a) a
storyParser flags =
    let
        toParser story =
            Parser.map story (s story.slug)
    in
    oneOf (List.map toParser flags.library)
