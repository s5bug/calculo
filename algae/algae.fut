type tile = #empty | #nuisance | #puyo u32
type board = [13][6]tile

let deserialize_board(in_board: [][]u32) =
  let f x : tile =
    match x & 0b11
      case 0 -> #empty
      case 1 -> #nuisance
      case _ -> #puyo (x >> 2)
  in map (map f) in_board

let main(in_board: [][]u32) =
  ((deserialize_board(in_board))[0])[0] == #empty