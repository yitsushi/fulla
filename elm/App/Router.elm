module App.Router exposing
    ( onUrlChange
    , onUrlRequest
    , parsedUrl
    , routeParser
    )

import Browser exposing (UrlRequest)
-- import Page.AoC.Route
-- import Page.SignIn.Route
import Url exposing (Url)
import Url.Parser as Parser
import App.Route as Route
import App.Message as Message
import Page.SignIn.Route as PageSignIn
import Global.Route as GlobalRoute
import Global.Message

routeParser : Parser.Parser (Route.Route -> a) a
routeParser =
    Parser.oneOf <|
        [ transformSignIn PageSignIn.route
        , transformGlobal GlobalRoute.route
        ]

parsedUrl : Url -> Route.Route
parsedUrl url =
    Maybe.withDefault (Route.Global GlobalRoute.NotFound) (Parser.parse routeParser url)


onUrlRequest : UrlRequest -> Message.Message
onUrlRequest request =
    Message.Global <| Global.Message.UrlRequest request


onUrlChange : Url -> Message.Message
onUrlChange url =
    Message.Global <| Global.Message.UrlChanged url

transformGlobal : Parser.Parser (GlobalRoute.Route -> Route.Route) b -> Parser.Parser (b -> c) c
transformGlobal r = Parser.map Route.Global r

transformSignIn : Parser.Parser (PageSignIn.Route -> Route.Route) b -> Parser.Parser (b -> c) c
transformSignIn r = Parser.map Route.SignIn r
