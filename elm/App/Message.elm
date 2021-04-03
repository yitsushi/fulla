module App.Message exposing (..)

import Global.Message
import Page.SignIn.Message
import Page.Gallery.Message


type Message
    = NoOp
    | Global Global.Message.Message
    | SignIn Page.SignIn.Message.Message
    | Gallery Page.Gallery.Message.Message

-- type Msg
--     = NoOp
--     | NavigareTo String
--     | UrlChanged Url.Url
--     | UrlRequest Browser.UrlRequest
--     | AccessTokenLanded (Result Http.Error Lib.OAuth.AccessToken)
--     | AdventOfCodeInputLanded (Result Http.Error String)