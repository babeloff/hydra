#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import System.Environment
import System.Exit
import System.IO

-- This is a simple runner script for the GraphSON generation functions
-- Since we're having dependency issues with GHCi, this provides an alternative

main :: IO ()
main = do
    args <- getArgs
    case args of
        ["example"] -> do
            putStrLn "Running generateExampleGraphSON..."
            putStrLn "This would generate GraphSON for the sales example data."
            putStrLn ""
            putStrLn "To run this properly, you need to:"
            putStrLn "1. Build the hydra-ext project with Stack"
            putStrLn "2. Load the Demo module in GHCi"
            putStrLn "3. Call generateExampleGraphSON"
            putStrLn ""
            putStrLn "From GHCi:"
            putStrLn "  :l Hydra.Ext.Demos.GenPG.Demo"
            putStrLn "  generateExampleGraphSON"
        ["copilot"] -> do
            putStrLn "Running generateCopilotGraphSON..."
            putStrLn "This would generate GraphSON for the copilot/health data."
            putStrLn ""
            putStrLn "To run this properly, you need to:"
            putStrLn "1. Build the hydra-ext project with Stack"
            putStrLn "2. Load the Demo module in GHCi"
            putStrLn "3. Call generateCopilotGraphSON"
            putStrLn ""
            putStrLn "From GHCi:"
            putStrLn "  :l Hydra.Ext.Demos.GenPG.Demo"
            putStrLn "  generateCopilotGraphSON"
        [] -> do
            putStrLn "Usage: runhaskell run-graphson.hs [example|copilot]"
            putStrLn ""
            putStrLn "Available functions:"
            putStrLn "  example  - Generate GraphSON for sales example data"
            putStrLn "  copilot  - Generate GraphSON for copilot/health data"
            putStrLn ""
            putStrLn "Both functions are defined in:"
            putStrLn "  hydra-ext/src/main/haskell/Hydra/Ext/Demos/GenPG/Demo.hs"
            putStrLn ""
            putStrLn "Input data locations:"
            putStrLn "  Sales:  hydra-ext/data/genpg/sources/sales/"
            putStrLn "  Health: hydra-ext/data/genpg/sources/health/"
            putStrLn ""
            putStrLn "Output locations:"
            putStrLn "  Sales:  hydra-ext/data/genpg/sales.json"
            putStrLn "  Health: hydra-ext/data/genpg/copilot.json"
        _ -> do
            putStrLn "Error: Unknown argument"
            putStrLn "Usage: runhaskell run-graphson.hs [example|copilot]"
            exitWith (ExitFailure 1)
