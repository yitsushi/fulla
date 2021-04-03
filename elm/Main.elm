module Main exposing (..)

import App.Main
import App.Flags exposing (Flags)
import App.Model exposing (Model)
import App.Message exposing (Message)


main : Program Flags Model Message
main =
    App.Main.main