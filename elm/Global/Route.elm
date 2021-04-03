module Global.Route exposing (..)

import Url.Parser as Parser


type Route
    = NotFound
    | Root
    | SomethingWentWrong ( Int, String )


route : Parser.Parser (Route -> a) a
route =
    Parser.map Root Parser.top