module Request.User exposing (getUsers)

import Data.User as User exposing (UserResponse, decodeUserResponse)
import Http exposing (Request, get)
import Request.Helpers exposing (apiUrl)


getUsers : Request UserResponse
getUsers =
    get (apiUrl "/users") decodeUserResponse
