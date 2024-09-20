import Lib
import Web.Scotty (scotty, post)
import Data.Maybe (fromMaybe)
import Data.Text (Text)

data User = User { id :: Int, email :: String }
  deriving Show

dummyUser = User 0 ""
user1 = User 1 "user@starter.app"
secret_token = "secret_jwt_token"

extractJsonField jsonData fieldName =
  jsonData .: fieldName
    $> fromMaybe "" 

createUser :: Value -> User
createUser value = case value of
  Object jsonData -> 
    user1
    -- User (genNewId users) (extractJsonField jsonData "email") 
  _ -> 
    dummyUser

isAuthenticated :: Value -> Bool
isAuthenticated value = case value of
  Object jsonData ->
    let 
      email <- extractJsonField jsonData "email"
    in 
      email == email user1
  _ -> 
    False

postSignup :: ActionM ()
postSignup = do
    newUser <- (createUser <$> jsonData)
    status 201
    json $ object ["msg" .= "ok"]

postLogin :: ActionM ()
postLogin = do
    if isAuthenticated jsonData then do 
      status 200
      json $ object ["token" .= "secret_token", "user" .= user1]
    else do
      status 401
      json $ object ["token" .= "", "user" .= dummyUser]
      

main :: IO ()
main = scotty 3000 $ do
  post "/api/users/signup" $ postSignup
  post "/api/users/login" $ postLogin

-- import Web.Scotty (scotty, post)
-- import Data.List (find)
-- import Data.Maybe (fromMaybe)
-- import Data.Text (Text)
-- import Data.Text.Read (readInt)
-- -- ImmutableArray
-- import Data.Array.IO (IOArray, newArray, writeArray, getElems)

-- -- Define the User data type
-- data User = User { id :: Int, email :: String, password :: String }
--   deriving Show

-- newtype Users = Users (IOArray Int User)
--   deriving Show

-- dummyUser = User 0 "" ""

-- users :: IO Users
-- users = do
--   arr <- newArray (0, 100) dummyUser
--   return $ Users arr

-- extractJsonField jsonData fieldName =
--   jsonData .: fieldName
--     $> fromMaybe "" 

-- createUser :: Value -> User
-- createUser value = case value of
--   Object jsonData -> 
--     User (genNewId users) (extractJsonField jsonData "email") (extractJsonField jsonData "password")
--   _ -> 
--     dummyUser

-- genNewId :: Users -> Int
-- genNewId (Users arr) = succ $ maximum [i | (i, _) <- assocs arr]

-- appendUser :: User -> Users -> IO Users
-- appendUser newUser (Users arr) = do
--   writeArray arr (genNewId (Users arr)) newUser
--   return $ Users arr

-- main :: IO ()
-- main = scotty 3000 $ do
--   POST "/api/users/signup" $ do
--     let newUser = (createUser <$> jsonData)
--     appendUser newUser users
--     json newUser