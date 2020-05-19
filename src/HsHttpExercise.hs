{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Core.Program
  ( execute,
    write,
  )
import Core.Text.Rope
import Data.Text
import Network.HTTP.Req

promHost :: Text
promHost = "localhost"

serverUrl :: Url 'Http
serverUrl = http promHost /: "api" /: "v1" /: "query"

options :: Option 'Http
options = port 9090 <> "query" =: ("up" :: Text)

main :: IO ()
main = execute $ do
  response <-
    runReq
      defaultHttpConfig
      (req GET serverUrl NoReqBody bsResponse options)
  write . intoRope $ responseBody response
