module Main where

import Text.Parsec
import Text.Parsec.Token as P
import Text.Parsec.Language (emptyDef)

lexer = P.makeTokenParser emptyDef
