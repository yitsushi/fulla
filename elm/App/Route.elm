module App.Route exposing (..)

import Global.Route as Global
import Page.SignIn.Route as SignIn

type Route
    = Global Global.Route
    | SignIn SignIn.Route