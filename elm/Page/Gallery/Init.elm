module Page.Gallery.Init exposing (..)

import App.Message exposing (Message)
import App.Model exposing (Model)
import Page.Gallery.Request as Request
import Page.Gallery.Message

initialCmd : Model -> Cmd Message
initialCmd model = Request.objectsOnPath model.global.jwtToken model.gallery (Request.wrapMsg Page.Gallery.Message.ObjectListArrived)