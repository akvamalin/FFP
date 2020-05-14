------------------------------------------------------------------
-- A2-1 boolean expressions as trees
------------------------------------------------------------------
data BoolExpr = Const Bool
                | Or BoolExpr BoolExpr
                | And BoolExpr BoolExpr
                | Not BoolExpr
                | Xor BoolExpr BoolExpr
                deriving(Show)

data BoolExprI = Con Bool
                | BoolExprI :+: BoolExprI
                | BoolExprI :*: BoolExprI
                | Nit BoolExprI
                | BoolExprI :^: BoolExprI

testExpr1, testExpr2 :: BoolExpr
testExpr1 = Or (Not (Const True)) (And (Const True) (Const False))
testExpr2 = Xor (And (Const True) (Not (Const True)))
                (Xor (Not (Const False)) (Const True))
testExpr3 = And
    (And
        (Xor (And (Const True) (Const False))
             (Not (And (Const False) (Const True)))
        )
        (Or (Const False) (Not (Const False)))
    )
    (Or (Const True) (Not (Const False)))

eval :: BoolExpr -> Bool
eval (Const a) = a
eval (Or  a b) = eval a || eval b
eval (And a b) = eval a && eval b
eval (Not a  ) = not (eval a)
eval (Xor a b) = eval (Or (And a (Not b)) (And (Not a) b))


testInExpr1 :: BoolExprI
testInExpr1 = Nit (Con True) :+: (Con True :*: Con False)

evalI :: BoolExprI -> Bool
evalI (Con a  ) = a
evalI (a :+: b) = evalI a || evalI b
evalI (a :*: b) = evalI a && evalI b
evalI (Nit a  ) = not (evalI a)

------------------------------------------------------------------
-- A2-2 boolean expressions as trees
------------------------------------------------------------------
data BoolExpr' = Const' Bool
               | And'   BoolExpr' BoolExpr'
               | Or'    BoolExpr' BoolExpr'
               | Not'   BoolExpr'
               | Xor'   BoolExpr' BoolExpr'
               | Var'   String
               deriving (Show)

testExpr1', testExpr2', testExpr3' :: BoolExpr'
testExpr1' = Or' (Not' (Const' True)) (And' (Const' True) (Const' False))
testExpr2' = Xor' (And' (Const' True) (Not' (Const' False)))
                  (Xor' (Not' (Var' "x")) (Const' True))
testExpr3' = And'
    (And'
        (Xor' (And' (Const' True) (Var' "z"))
              (Not' (And' (Const' False) (Const' True)))
        )
        (Or' (Not' (Const' True)) (Not' (Var' "x")))
    )
    (Or' (Const' True) (Not' (Var' "y")))


search :: (Eq a, Show a) => a -> [(a, b)] -> b
search a [] = error ("Exception: Ungebundene Variable: " ++ show a)
search a ((x, y) : t) | a == x    = y
                      | otherwise = search a t


eval' :: BoolExpr' -> [(String, Bool)] -> Bool
eval' (Const' a) _   = a
eval' (Var'   a) env = search a env
eval' (Or'  a b) env = eval' a env || eval' b env
eval' (And' a b) env = eval' a env && eval' b env
eval' (Not' a  ) env = not (eval' a env)
eval' (Xor' a b) env = eval' (Or' (And' a (Not' b)) (And' (Not' a) b)) env

------------------------------------------------------------------
-- A2-3 boolean expressions as trees
------------------------------------------------------------------
data BoolExpr_ = Const_ Bool
                | And_   BoolExpr_ BoolExpr_
                | Or_    BoolExpr_ BoolExpr_
                | Not_   BoolExpr_
                | Xor_   BoolExpr_ BoolExpr_
                | Var_   String
                | Let_   (String,BoolExpr_) BoolExpr_
                deriving (Show)

exp1, exp2, exp3 :: BoolExpr_
exp1 = Or_ (Not_ (Const_ True)) (And_ (Const_ True) (Const_ False))
exp2 = Xor_ (Or_ (Const_ False) (Let_ ("x", Const_ True) (Var_ "x")))
            (Xor_ (Not_ (Var_ "x")) (Const_ True))
exp3 = And_
    (And_
        (Xor_
            (And_ (Const_ True) (Var_ "z"))
            (Not_ (And_ (Const_ False) (Let_ ("v", Const_ True) (Var_ "v"))))
        )
        (Or_ (Not_ (Const_ True)) (Not_ (Var_ "x")))
    )
    (Or_ (Const_ True) (Not_ (Var_ "y")))

-- Under construction -- Is still to do -- didn't manage before deadline 
-- hope the idea is correct somehow
eval_ :: BoolExpr_ -> BoolExpr_
eval_ (Const_ a) = Const_ a
-- eval_ (Let_ (var, binded_expr) (Var_ subst)) | var == subst = binded_expr
--                                              | otherwise    = subst

-- eval_ (Let_ (var, binded_expr)) (And_ False exp2)
--     | exp1 == False
--     = False
--     | exp2 == False
--     = False
--     | otherwise
--     = eval_ (var, binded_expr) exp1 && eval_ (var, binded_expr) exp2

-- eval_ (Let_ (var, binded_expr)) (And_ exp1 exp2) =
--     eval_ (var, binded_expr) exp1 && eval_ (var, binded_expr) exp2
-- eval_ (Let_ (var, binded_expr)) (Or_ exp1 exp2)
--     | exp1 == True = True
--     | exp2 == True = True
--     | otherwise = eval_ (var, binded_expr) exp1 || eval_ (var, binded_expr) exp2

main = do
    -- 1 --------------------------
    print (eval testExpr1) -- False
    print (eval testExpr2) -- False
    print (eval testExpr3) -- True
    print (evalI testInExpr1) -- False
    -- 2 --------------------------
    print (eval' testExpr1' []) -- False
    -- print (eval' testExpr2' []) --  Exception: Ungebundene Variable: "x"
    print (eval' testExpr2' [("x", True)]) -- False
    print (eval' testExpr2' [("x", False)]) -- True
    print (eval' testExpr3' [("z", True), ("y", False)]) -- False
    -- print (eval' testExpr3' [("z", False), ("y", False)]) -- Exception: Ungebundene Variable: "x"
    print (eval' testExpr3' [("x", False), ("z", False), ("y", True)]) -- True
    -- 3 --------------------------
