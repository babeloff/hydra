module Main where

import Hydra.Generation (writeModulesJson)
import Hydra.Sources.All (kernelModules)
import System.Exit (exitFailure)
import Control.Exception (catch, SomeException)


main :: IO ()
main = do
  putStrLn "=== Generate Hydra kernel JSON ==="
  putStrLn ""
  putStrLn $ "Generating " ++ show (length kernelModules) ++ " kernel modules to JSON..."
  putStrLn ""

  result <- catch (writeModulesJson True "src/gen-main/json" kernelModules kernelModules >> return True)
                  (\e -> do
                    putStrLn $ "Error: " ++ show (e :: SomeException)
                    return False)

  if result
    then do
      putStrLn ""
      putStrLn "=== Done! ==="
      putStrLn ""
      putStrLn "Generated files are in: src/gen-main/json/"
    else do
      putStrLn ""
      putStrLn "=== FAILED ==="
      exitFailure
