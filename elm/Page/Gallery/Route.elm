module Page.Gallery.Route exposing (..)

import Url.Parser as Parser exposing ((</>), (<?>))
import Url.Parser.Query as Query

type Route
    = Root
    | Show (Maybe String)


route : Parser.Parser (Route -> a) a
route =
    Parser.s "gallery" </> Parser.oneOf
    [ Parser.map Show (Parser.s "show" <?> Query.string "path")
    , Parser.map Root Parser.top
    ]