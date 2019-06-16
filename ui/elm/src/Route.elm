module Route exposing (Route(..), fromUrl, toHref)

import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Story exposing (Story)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)



-- ROUTING


type Route
    = Home
    | Story Story


toHref : Route -> Attribute msg
toHref targetRoute =
    href (routeToString targetRoute)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- Internal Helpers


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Story Story.parser
        ]


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Story story ->
                    [ Story.getSlug story ]
    in
    "#/" ++ String.join "/" pieces
