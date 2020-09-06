type tile = #empty | #nuisance | #puyo u8

-- let search [t] [n] 'a 's 'm (transitions: s -> a -> [t](s, m)) (heuristic: s -> f32) (resolve_dispute: (f32, [](s, m)) -> (f32, [](s, m)) -> (f32, [](s, m))) (known: [n]a) (current: s) : (f32, [](s, m)) =
--   let my_score = heuristic current
--   in
--     if null known then
--       (my_score, [])
--     else
--       let from_here: [t](s, m) = transitions current (head known)
--       let sub_search (candidate: (s, m)): (f32, [](s, m)) =
--         let (next_state, move) = candidate
--         let (res, tail) = search transitions heuristic (tail known) next_state
--         in (res, concat [(next_state, move)] tail)
--       let children: [t](f32, [](s, m)) = map sub_search from_here
--       let by_first (first : (f32, [](s, m))) (second : (f32, [](s, m))) : (f32, [](s, m)) =
--         let (first_score, x) = first
--         let (second_score, y) = second
--         in if first_score > second_score then first else if second_score > first_score then second else resolve_dispute first second
--       in reduce_comm by_first (my_score, []) children

let deserialize_board (in_board: [][]u8): [][]tile =
  let f (x : u8) : tile =
    match x & 0b11
      case 0 -> #empty
      case 1 -> #nuisance
      case _ -> #puyo (x >> 2)
  in map (map f) in_board

let main (in_board: [][]u8) =
  ((deserialize_board(in_board))[0])[0] == #puyo 0