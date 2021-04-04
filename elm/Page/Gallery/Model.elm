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

initialModel : Maybe String -> Model
initialModel path =
  { objectList = Nothing
  , path = Maybe.withDefault "/" path
  , error = Nothing
  }