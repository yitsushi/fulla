module Page.Gallery.Model exposing (..)

type alias Model =
    { objectList : Maybe (List Object)
    , path : String
    , error : Maybe String
    }

type alias Object =
  { key : String
  , type_ : String
  }

initialModel : Model
initialModel =
  { objectList = Nothing
  , path = ""
  , error = Nothing
  }