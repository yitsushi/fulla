module App.Message exposing (..)

import Global.Message
import Page.SignIn.Message
import Page.Gallery.Message
import App.Port


type Message
    = NoOp
    | Global Global.Message.Message
    | SignIn Page.SignIn.Message.Message
    | Gallery Page.Gallery.Message.Message
    | KeyEvent App.Port.KeyEvent