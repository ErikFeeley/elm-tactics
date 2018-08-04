module Data.User exposing (User, UserResponse, decodeUser, decodeUserResponse)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode


type alias UserResponse =
    { status : String
    , data : List User
    , timestamp : String
    , statusCode : Int
    }


decodeUserResponse : Decode.Decoder UserResponse
decodeUserResponse =
    decode UserResponse
        |> required "status" Decode.string
        |> required "data" (Decode.list decodeUser)
        |> required "timestamp" Decode.string
        |> required "statusCode" Decode.int


encodeUserResponse : UserResponse -> Json.Encode.Value
encodeUserResponse record =
    Json.Encode.object
        [ ( "status", Json.Encode.string <| record.status )
        , ( "data", Json.Encode.list <| List.map encodeUser <| record.data )
        , ( "timestamp", Json.Encode.string <| record.timestamp )
        , ( "statusCode", Json.Encode.int <| record.statusCode )
        ]


type alias User =
    { id : String
    , friends : List String
    , rating : Int
    , name : String
    }


decodeUser : Decode.Decoder User
decodeUser =
    decode User
        |> required "id" Decode.string
        |> required "friends" (Decode.list Decode.string)
        |> required "rating" Decode.int
        |> required "name" Decode.string


encodeUser : User -> Json.Encode.Value
encodeUser record =
    Json.Encode.object
        [ ( "id", Json.Encode.string <| record.id )
        , ( "friends", Json.Encode.list <| List.map Json.Encode.string <| record.friends )
        , ( "rating", Json.Encode.int <| record.rating )
        , ( "name", Json.Encode.string <| record.name )
        ]
