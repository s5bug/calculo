type tile = #empty | #nuisance | #puyo u8

let deserialize_board(in_board: [][]u8): [][]tile =
  let f x : tile =
    match x & 0b11
      case 0 -> #empty
      case 1 -> #nuisance
      case _ -> #puyo (x >> 2)
  in map (map f) in_board

let main(in_board: [][]u8) =
  ((deserialize_board(in_board))[0])[0] == #puyo 0