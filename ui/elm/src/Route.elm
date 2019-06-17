module Route exposing (Route(..), fromUrl, toHref)

import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Story
import Story.Info exposing (Info)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Flags exposing (Flags)



-- ROUTING


type Route
    = Home
    | Story Info


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
        , Parser.map Story (Story.parser flags)
        ]


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
