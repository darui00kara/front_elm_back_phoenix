# FrontElmBackPhoenix

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## API

```cmd
$ curl -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:4000/api/users
```

## Advice

送るデータは Json.Encode でElmの値 ⇒ Json.Encode.Value に変換、
逆に受け取る JSON データは Json.Decode で Decoder を作って Elm の値に変換します。

```elm
post : String -> Body -> Decoder a -> Request a
jsonBody : Value -> Body
send : (Result Error a -> msg) -> Request a -> Cmd msg
```

## Memo

```elm
> import Json.Decode exposing (..)

> type alias UserData = {name : String, email : String, id : Int}
> idDecoder = (field "id" int)
<decoder> : Json.Decode.Decoder Int
> nameDecoder = (field "name" string)
<decoder> : Json.Decode.Decoder String
> emailDecoder = (field "email" string)
<decoder> : Json.Decode.Decoder String
> userDecoder = map3 UserData nameDecoder emailDecoder idDecoder
<decoder> : Json.Decode.Decoder Repl.UserData

> json = "{\"name\":\"hogehoge\", \"id\":1, \"email\":\"hoge@test.com\"}"
"{\"name\":\"hogehoge\", \"id\":1, \"email\":\"hoge@test.com\"}" : String
> result = decodeString userDecoder json
Ok { name = "hogehoge", email = "hoge@test.com", id = 1 }
    : Result.Result String Repl.UserData

> import Http exposing (..)
> getRequest = get "http://localhost:4000/api/users/1" userDecoder
Request { method = "GET", headers = [], url = "http://localhost:4000/api/users/1", body = EmptyBody, expect = { responseType = "text", responseToResult = <function> }, timeout = Nothing, withCredentials = False }
    : Http.Request Repl.UserData
> type Msg = LoadUserData (Result Http.Error UserData)
> send LoadUserData getRequest
{ type = "leaf", home = "Task", value = Perform <task> }
    : Platform.Cmd.Cmd Repl.Msg

## Phoenixのレスポンスに対応するには下記のようになる
## Appモジュールに関しては、elmソースを参照のこと
> import App
> import Json.Decode as Decode
> json = "{\"data\":{\"name\":\"hogehoge\",\"id\":1,\"email\":\"hoge@test.com\"}}"
"{\"data\":{\"name\":\"hogehoge\",\"id\":1,\"email\":\"hoge@test.com\"}}"
    : String
> Decode.decodeString App.userDataDecoder json
Ok { name = "hogehoge", email = "hoge@test.com", id = 1 }
    : Result.Result String App.User
```

sample
