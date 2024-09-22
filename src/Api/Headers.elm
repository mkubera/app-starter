module Api.Headers exposing (..)

import Http


auth : String -> Http.Header
auth token =
    Http.header "auth" ("bearer " ++ token)
