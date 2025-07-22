# Chess Algorithm

This document explains the basic algorithm for a simple two-player chess game. It covers the board setup, piece movements, move validation, game state tracking, and win/draw rules without advanced features like pawn promotion, castling, or en passant.

---

## 1. Board Setup

**Goal:** Set up an 8x8 chessboard with all pieces in the starting positions.

**Steps:**
- Create an 8x8 grid, alternating white and brown squares like a checkerboard.
- Place pieces for both players:
  - **White:** Back rank (row 7) with rook, knight, bishop, queen, king, bishop, knight, rook; pawns on row 6.
  - **Black:** Back rank (row 0) with the same order; pawns on row 1.
- Rows 2 to 5 are empty.
- Each piece stores its color (white or black) and type (pawn, knight, bishop, rook, queen, king).
- Track if a piece has moved (initially false).

---

## 2. Game State Initialization

**Goal:** Get the game ready to start.

**Steps:**
- Set current player to **white**.
- Initialize an empty move history list.
- Set a counter for moves without captures or pawn moves (important for draws) to zero.
- Track positions to detect threefold repetition draws.

---

## 3. Piece Movement Rules

**Goal:** Find all valid moves for a selected piece.

**Steps:**

- Identify piece on selected square and its color.
- If piece belongs to the current player, calculate moves based on piece type:

  - **Pawn:**
    - Move forward 1 square if empty.
    - Move forward 2 squares if on starting row and both squares are empty.
    - Capture diagonally 1 square forward if enemy piece present.
  
  - **Knight:**
    - Moves in an "L" shape: 2 squares in one direction, then 1 perpendicular.
    - Can jump over pieces.
    - Destination must be empty or have opponent’s piece.
  
  - **Bishop:**
    - Move any number of squares diagonally.
    - Stops before friendly piece or captures opponent piece.
  
  - **Rook:**
    - Move any number of squares horizontally or vertically.
    - Same stopping rules as bishop.
  
  - **Queen:**
    - Move any number of squares horizontally, vertically, or diagonally.
    - Same stopping rules as bishop.
  
  - **King:**
    - Move 1 square in any direction.
    - Destination empty or opponent’s piece.

- Return the list of possible squares for the move.

---

## 4. Move Validation

**Goal:** Make sure a move doesn’t leave the player's king in check.

**Steps:**
- Confirm the piece belongs to the current player and proposed move is in its possible moves.
- Simulate the move on a copy of the board:
  - Move the piece and remove any captured piece.
- Check if the current player’s king is attacked (in check) after the move.
- If yes, reject the move; if no, allow it.

---

## 5. Executing a Move

**Goal:** Update the board and game state after a legal move.

**Steps:**
- Move the piece to the destination and clear starting square.
- Remove any captured opponent’s piece.
- Mark the piece as moved.
- Update the move counter:
  - Reset to 0 if move was a capture or a pawn move.
  - Otherwise, increase by 1.
- Record the move in move history.
- Create a unique board representation and track it for repetition.
- Switch the current player (white ↔ black).

---

## 6. Game State Evaluation

**Goal:** Check if the game continues, is in check, or ended.

**Steps:**
- Check if current player’s king is in check.
- If in check:
  - If player has legal moves, state = **check**.
  - Otherwise, state = **checkmate** (opponent wins).
- If not in check:
  - If player has legal moves, state = **ongoing**.
  - Otherwise, state = **stalemate** (draw).
- Check draw conditions:
  - 50 moves without capture or pawn moves → draw.
  - Same board position repeated 3 times → draw.
  - Only kings or king + bishop/knight left → draw (insufficient material).

---

## 7. Game Loop

**Goal:** Keep the game running until it ends.

**Steps:**
- Show the current board and player turn.
- Get player input (start and end squares).
- Validate the move.
- If valid:
  - Execute the move.
  - Update and evaluate game state.
  - If checkmate → announce winner and end.
  - If stalemate/draw → announce draw and end.
  - If check → notify player.
- If invalid, ask for new move.

---

## 8. Persistence

**Goal:** Save and load game to continue later.

**Steps:**

- **To save:**
  - Store board pieces (positions, color, moved status).
  - Store current player, move history, counters, and board repetition counts.
  - Save timestamps.
  
- **To load:**
  - Retrieve latest saved state.
  - Restore board, current player, counters.
  - If no save found, start a new game.

---

## Notes

- Board coordinates: rows 0–7 (row 0 is black’s back rank, row 7 is white’s); columns 0–7.
- White moves “up” (decreasing row), Black moves “down” (increasing row).
- Does **not** cover advanced rules like pawn promotion, castling, or en passant.
- Possible future improvements:
  - Pawn promotion.
  - Castling.
  - En passant.
- Debugging can be easier by showing the board after each move.

---
