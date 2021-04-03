module Page.SignIn.Route exposing (..)

import Url.Parser as Parser


type Route
    = Root


route : Parser.Parser (Route -> a) a
route =
    Parser.map Root (Parser.s "signin")
