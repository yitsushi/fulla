module Page.Gallery.Message exposing (..)

import Http
import Page.Gallery.Model

type Message
  = NoOp
  | ObjectListArrived (Result Http.Error (List Page.Gallery.Model.Object))
  | Enlarge String
  | Shrink