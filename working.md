# Personal Note

Hey! This is a simple chess game app and its underlying algorithm explained in easy terms.  
It's built mostly in Flutter (code not included here) and focuses on the core chess moves and rules like piece movement, turns, check, checkmate, and draws.  

**Important:** Advanced chess features like castling, pawn promotion, and en passant are *not* included yet—just basics to keep it straightforward.  

Feel free to use this explanation as a starting point or reference for your own chess project!

---

# Chess App Working Process

This explains how the chess app works from start to finish, including board setup, user moves, and saving the game locally.

## 1. Launching the App

- The app loads its game logic, interface, and database.
- Checks if there's a saved game locally:
  - Loads it to continue or
  - Starts a new game.
- Shows the chessboard with pieces as simple letters (e.g., "P" for pawn).
- Displays whose turn it is (e.g., "White to move").

## 2. Board Arrangement

- Sets an 8x8 grid with alternating white and brown squares.
- Pieces placed in starting positions:
  - White at bottom (row 7 and 6).
  - Black at top (row 0 and 1).
- Empty rows in the middle (2–5).
- Pieces labeled by color and type.
- Board and status shown on screen.

## 3. Database Setup and Data Storage

- Uses local SQLite database to save game progress.
- Stores:
  - Board state (pieces, colors, moved or not).
  - Current player.
  - Move history.
  - Counters for draws.
  - Position repetition for draw checking.
  - Timestamps.
- Saves after each move and loads last game on start.

## 4. User Interaction and Gameplay

- Player taps a square to select a piece.
- If owned by current player:
  - Square highlights blue.
  - Possible moves highlight green.
- Player taps destination to move.
- App checks if move is valid:
  - Matches piece movement rules.
  - Does not leave player's king in check.
- If valid:
  - Moves piece.
  - Captures opponent piece if present.
  - Updates counters and move history.
  - Switches player turn.
  - Saves game state.
- If invalid:
  - Move rejected, player tries again.
- Screen updates with new status (e.g., "Black to move").

## 5. Game Status and Termination

- After each move, app checks for:
  - **Check:** King under threat.
  - **Checkmate:** No moves available, king threatened → opponent wins.
  - **Stalemate:** No moves available, king safe → draw.
  - **Draws:** 50 moves without pawn moves or captures, 3 repeated positions, or insufficient pieces.
- Status message updates accordingly.
- Player can start a new game anytime.

## 6. Starting a New Game

- Tap "New Game" button.
- Resets board and counters.
- Sets current player to white.
- Saves fresh game to database.
- Updates screen.

## 7. Visual and Interactive Features

- Board is simple text on colored squares.
- Selection and move options highlighted.
- Status message visible at all times.
- "New Game" button present.
- Instant screen updates on actions.

---

# Notes

- Board coordinates: Rows 0–7 (0 = black’s back rank, 7 = white’s). Columns 0–7.
- White moves “up” (decreasing row number).
- App supports basic chess rules only.
- Does NOT include castling, pawn promotion, or en passant.
- Uses SQLite for local game saves.
- UI is text-based now, can be enhanced with images.
- Future ideas:
  - Add pawn promotion.
  - Add castling and en passant.
  - Better visuals and move history display.

---

Thanks for checking this out! It’s made to be easy to understand and use in your own Flutter projects or as a learning reference.
