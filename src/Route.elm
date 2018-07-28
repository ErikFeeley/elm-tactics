module Route exposing (Route(..), route)

import UrlParser as Url exposing (Parser, oneOf, s)


type Route
    = Home
    | Battles


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Battles (s "battles")
        ]


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Battles ->
                    [ "battles" ]
    in
    "#/" ++ String.join "/" pieces
