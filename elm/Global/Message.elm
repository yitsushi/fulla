module Global.Message exposing (..)

import Url
import Browser

type Message
  = NavigateTo String
  | UrlChanged Url.Url
  | UrlRequest Browser.UrlRequest