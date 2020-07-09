module Main where

import DnD
import System.Environment

dieRange :: Int -> Range
dieRange n = [1..n]

dieCDF :: Int -> CDF
dieCDF n x
    | x <= 0    = 0
    | x <= n    = (fromIntegral x) / (fromIntegral n)
    | otherwise = 1

die :: Int -> Die
die n = Die (dieCDF n) (dieRange n)

longName :: Roll -> String
longName A = "advantage"
longName D = "disadvantage"

prettyPrint :: String -> [Roll] -> String
prettyPrint die rs = (++ ".") $ foldl (\s r -> s ++ " with " ++ longName r) ("roll a " ++ die) rs

main :: IO ()
main = do
    args <- getArgs
    let n = read (args !! 0) :: Int
    let e = read (args !! 1) :: Double
    let a = read (args !! 2) :: Double
    let s = rollSequence (die n) e a
    putStr $ "For an expected value of "
    putStr $ show (rollsEV (die n) s) ++ ", "
    putStrLn $ prettyPrint ("d" ++ show n) s
