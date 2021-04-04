module App.Sub exposing (..)

import App.Message
import App.Model
import App.Port


subscriptions : App.Model.Model -> Sub App.Message.Message
subscriptions _ =
    App.Port.onKeyEvent App.Message.KeyEvent
