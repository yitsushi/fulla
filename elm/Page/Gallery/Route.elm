module Page.Gallery.Route exposing (..)

import Url.Parser as Parser exposing ((</>))


type Route
    = Root
    | Show String


route : Parser.Parser (Route -> a) a
route =
    Parser.s "gallery" </> Parser.oneOf
    [ Parser.map Show (Parser.top </> Parser.string)
    , Parser.map Root Parser.top
    ]
