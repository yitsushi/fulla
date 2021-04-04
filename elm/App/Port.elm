port module App.Port exposing (..)

port saveToken : String -> Cmd msg

type alias KeyEvent = 
  { shiftKey : Bool
  , altKey : Bool
  , ctrlKey : Bool
  , key : String
  }

port onKeyEvent : (KeyEvent -> msg) -> Sub msg