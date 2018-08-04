module Page.User exposing (Model, init, view)

import Data.User as User exposing (UserResponse)
import Html exposing (..)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.User exposing (getUsers)
import Task exposing (Task)
import Views.Page as Page


-- MODEL


type alias Model =
    { users : UserResponse }


init : Task PageLoadError Model
init =
    let
        loadUserResults =
            getUsers
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.User "Users failed to load"
    in
    Task.map Model loadUserResults
        |> Task.mapError handleLoadError



-- VIEW


view : Model -> Html msg
view model =
    div [] [ text "user" ]



-- UPDATE
