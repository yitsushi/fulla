module Page.SignIn.Model exposing (..)

type alias Model =
    { token : String
    , name : String
    , error : Bool
    }


initialModel : Model
initialModel =
  { token = ""
  , name = ""
  , error = False
  }