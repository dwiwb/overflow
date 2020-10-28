module Overflow.Pattern
( sendPattern
) where

import Overflow
import Data.Char   (chr)
import Text.Printf

-- |...
sendPattern :: Host -> Int -> Affix -> IO ()
sendPattern h l a = do 
        printf "    ───> Sending %d-byte cyclic pattern to target...\n" l
        sendPayload h payload >>= printResult
    where
        payload   = createPayload (cyclicPattern l) a

-- ...
cyclicPattern :: Int -> String
cyclicPattern i = take i $ generate
    where
        generate         = concat $ map squash $ iterate nextCycle (65, 97, 48)
        squash (x, y, z) = [chr x, chr y, chr z] 

-- ...
nextCycle :: (Int, Int, Int) -> (Int, Int, Int)
nextCycle (x, y, z) = next (x, y, z + 1)
    where
        next  (a, b, 58) = next (a, b + 1, 48)
        next (a, 123, c) = next (a + 1, 97, c)
        next  (91, _, _) = next (65, 97, 48)
        next   (a, b, c) = (a, b, c)

-- ...
printResult :: Bool -> IO ()
printResult x
    | x         = putStrLn "Done! Finished sending pattern to target."
    | otherwise = putStrLn "Error: An error occurred sending payload to target."
