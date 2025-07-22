## Board Representation Logic

- board with table of rows and columns (8x8) 2 dimensions,black and white alternative
- every cell might be empty or hold a piece(color info,type)

## Player Turn Logic
- only current player can move their own piece
- after valid move,switch to other player

## Piece Movement Logic

### for any piece that want to "move":
- identify all directions it's allowed to move
## for each direction,"scan" one square at time:
- stop if you hit board's edge
- stop if you hit friendly piece (cannot move further that way)
- hit an enemy?,you may move/capture there but not further past
- mark every empty spot along the way as possible

## Move Legality Algorithm
### when a player tries a move:
- is the piece theirs and is their turn?
- does that move obey the rules for that piece?
- does that move leave their own king in check?(not allowed)
- if yes to all:allow once.Otherwise deny

## Captures Logic

- if you move lands on a cell held by an enemy piece : it is captured(remove from board)

##  Check and Checkmate Logic (Game End)

## after each move, check if either king is "under threat" (in check)
- if yes, does that player have any legal moves to escape? if not, checkmate—the opponent wins.
- if no possible moves but not in check, it’s stalemate (draw).

## Draw Logic
- draw occurs by stalemate, fifty-move rule, insufficient material, or threefold repetition.


## Special Rules Logic
### Castling: 
- More conditions (king/rook not moved before, squares empty, not moving through check, etc.)

### En passant (pawn):
- Check last move, see if pawn is eligible.

### Promotion:
- If pawn reaches other end, it “promotes” to another piece.



