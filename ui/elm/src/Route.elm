module Route exposing (Route(..), fromUrl, toHref)

import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Flags exposing (Flags, StoryInfo)



-- ROUTING


type Route
    = Home
    | Story StoryInfo


toHref : Route -> Attribute msg
toHref targetRoute =
    href (routeToString targetRoute)


fromUrl : Flags -> Url -> Maybe Route
fromUrl flags url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse (parser flags)



-- Internal Helpers


parser : Flags -> Parser (Route -> a) a
parser flags =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Story <| storyParser flags
        ]


storyParser : Flags -> Parser (StoryInfo -> a) a
storyParser flags =
    let
        toParser story =
            Parser.map story (s story.slug)
    in
    oneOf (List.map toParser flags.library)

routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Story { slug } ->
                    [ slug ]
    in
    "#/" ++ String.join "/" pieces
