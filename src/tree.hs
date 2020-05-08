-- data <Type constructor> <type variable> = <Data constructor> <type variable> 
import           Data.Char                      ( toLower
                                                , toUpper
                                                )
data BTree a = Leaf a | Node (BTree a) (BTree a) deriving(Eq, Show)

tree = Node
      (Node (Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4)))
            (Node (Leaf 5) (Leaf 6))
      )
      (Node (Leaf 7) (Node (Node (Leaf 8) (Leaf 9)) (Node (Leaf 10) (Leaf 11))))

-- Sum of Leafs
tSum :: Num a => BTree a -> a
tSum (Leaf a         ) = a
tSum (Node left right) = tSum left + tSum right

-- List of Leafs
tList :: BTree a -> [a]
tList (Leaf a         ) = [a]
tList (Node left right) = tList left ++ tList right

-- Map on tree
tMap :: (a -> a) -> BTree a -> BTree a
tMap f (Leaf l         ) = Leaf (f l)
tMap f (Node left right) = Node (tMap f left) (tMap f right)

tLeafs = tSum . tMap (const 1)

tElem :: Eq a => a -> BTree a -> Bool
tElem e (Leaf l) | e == l    = True
                 | otherwise = False
tElem e (Node left right) = tElem e left || tElem e right

tFold :: (a -> a -> a) -> BTree a -> a
tFold op (Leaf l         ) = l
tFold op (Node left right) = op (tFold op left) (tFold op right)

data MTree a = MLeaf a | MNode a (MTree a) (MTree a) deriving(Show)

mtree = MNode
      'A'
      (MNode 'B'
             (MNode 'D' (MLeaf 'H') (MLeaf 'I'))
             (MNode 'E' (MLeaf 'J') (MLeaf 'K'))
      )
      (MNode
            'C'
            (MNode 'F'
                   (MNode 'L' (MLeaf 'N') (MLeaf 'O'))
                   (MNode 'M' (MLeaf 'P') (MLeaf 'Q'))
            )
            (MLeaf 'G')
      )

preorder :: MTree a -> [a]
preorder (MLeaf l           ) = [l]
preorder (MNode a left right) = a : preorder left ++ preorder right

inorder :: MTree a -> [a]
inorder (MLeaf l           ) = [l]
inorder (MNode a left right) = inorder left ++ a : preorder right

postorder :: MTree a -> [a]
postorder (MLeaf l           ) = [l]
postorder (MNode a left right) = postorder left ++ postorder right ++ [a]


levelorder t = loForest [t]
   where
      loForest xs | null xs   = []
                  | otherwise = map root xs ++ loForest (concatMap subtrees xs)
      root (MLeaf a    ) = a
      root (MNode a _ _) = a
      subtrees (MLeaf _    ) = []
      subtrees (MNode _ l r) = [l, r]

data ETree a b = ELeaf a | ENode a (b, ETree a b) (b, ETree a b) deriving(Show)

etree = ENode 'a'
              (0, ENode 'b' (2, ELeaf 'd') (3, ELeaf 'e'))
              (1, ENode 'c' (4, ELeaf 'f') (5, ELeaf 'g'))

biMap :: (a -> a) -> (b -> Bool) -> ETree a b -> ETree a Bool
biMap f g (ELeaf l) = ELeaf (f l)
biMap f g (ENode a (left_edge, left) (right_edge, right)) =
      ENode (f a) (g left_edge, biMap f g left) (g right_edge, biMap f g right)

main = do
      print (tSum tree)
      print (tList tree)
      print (tSum (tMap (* 100) tree))
      print (tLeafs tree)
      print (tElem 4 tree)
      print (tFold (+) tree)
      print mtree
      print (preorder mtree)
      print (inorder mtree)
      print (postorder mtree)
      print (levelorder mtree)
      print etree
      print (biMap toUpper even etree)



-- TODO
-- 1. Guardians
-- Slide 119 error in level order function
-- levelorder t = loForest [t]
--    where
--       loForest xs | null xs   = []
--                   | otherwise = map root xs ++ loForest (concatMap subtrees xs)
--       root (MLeaf a    ) = a
--       root (MNode a _ _) = a
--       subtrees (MLeaf _    ) = []
--       subtrees (MNode _ l r) = [l, r]
