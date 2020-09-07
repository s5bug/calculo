type tile = #empty | #nuisance | #puyo u8

type game_state [n] [m] = {
  board: [n][m]tile
}

type node [n] [m] = {
  score: f64,
  target_state: game_state [n] [m]
}

let deserialize_board [n] [m] (in_board: [n][m]u8): [n][m]tile =
  let f (x : u8) : tile =
    match x & 0b11
      case 0 -> #empty
      case 1 -> #nuisance
      case _ -> #puyo (x >> 2)
  in map (map f) in_board

let heuristic [n] [m] (state: game_state [n] [m]): f64 =
  let {board} = state
  let score (x: tile) : f64 =
    match x
      case #empty -> 0.0
      case #nuisance -> -1.0
      case #puyo _ -> 1.0
  let cell_score = map (map score) board
  let total_score = reduce_comm (+) 0 (map (reduce_comm (+) 0) cell_score)
  in total_score

let search 'a (f: a -> f64) (x: a): f64 =
  f x

let main [n] [m] (in_board: [n][m]u8) =
  let deserialized = deserialize_board in_board
  let cur_state: game_state [n] [m] = {
    board = deserialized
  }
  in search heuristic cur_state
