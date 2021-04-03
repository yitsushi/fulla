module Page.SignIn.Message exposing (..)

import Http
import Page.SignIn.Token

type Message
  = NameInput String
  | TokenInput String
  | SubmitForm
  | LoginResponse (Result Http.Error Page.SignIn.Token.Token)