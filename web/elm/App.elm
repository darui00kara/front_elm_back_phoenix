module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

type alias UserData =
  { name  : String
  , email : String
  , id    : Int
  }

type Msg =
  LoadUserData ( Result Http.Error UserData )

-- main

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : (UserData, Cmd Msg)
init =
  ( { name = "none", email = "none", id = 0 }
  , sendRequest
  )

update : Msg -> UserData -> ( UserData, Cmd Msg )
update msg user =
  case msg of
    LoadUserData ( Ok newUser ) ->
      ( newUser, Cmd.none )
    LoadUserData ( Err _ ) ->
      ( user, Cmd.none )

view : UserData -> Html Msg
view user =
  div []
    [ h2 [] [ text user.name ]
    , h2 [] [ text user.email ]
    ]

subscriptions : UserData -> Sub Msg
subscriptions user =
  Sub.none

-- decoder

idDecoder =
  ( Decode.field "id" Decode.int )

nameDecoder =
  ( Decode.field "name" Decode.string )

emailDecoder =
  ( Decode.field "email" Decode.string )

userDecoder =
  Decode.map3 UserData nameDecoder emailDecoder idDecoder

-- request 

getUserUrl : String
getUserUrl =
  "http://localhost:4000/api/users/1"

getUser : Http.Request UserData
getUser =
  Http.get getUserUrl userDecoder

sendRequest : Cmd Msg
sendRequest =
  Http.send LoadUserData getUser 

