# Chess App

This is a simple two-player chess game built with Flutter, following the Model-View-Controller (MVC) design. It uses letters to show pieces on the board (like "P" for a white pawn and "p" for a black pawn), making the interface clean and easy to understand. The game logic lives in the controller, and your progress is saved locally with a database, so you can pick up where you left off.

If you want a nicer look, you can add chess piece images (SVGs) from [Wikimedia Commons: SVG chess pieces](https://commons.wikimedia.org/wiki/Category:SVG_chess_pieces).

---

## Features

- Classic 8x8 chessboard with alternating white and brown squares.  
- Pieces shown as text by default, with optional SVG images.  
- Moves checked for legality to prevent invalid moves.  
- Tracks game status: check, checkmate, stalemate, and draws (fifty-move rule, threefold repetition, insufficient material).  
- Saves and restores game progress locally using a database.  
- "New Game" button to start fresh anytime.

---

## Packages Used

- **flutter_svg:** To display SVG images (optional).  
- **sqflite:** Handles local SQLite database for saving games.  
- **provider:** Manages app state and UI updates.  
- **path:** Helps manage database file paths.

---

## Documentation Links

- [`algo.md`](./algo.md): Simple explanation of the chess algorithm (board setup, moves, validation).  
- [`working.md`](./working.md): How the app works including board layout, database usage, and gameplay flow.

---

## Limitations

- No support yet for pawn promotion, castling, or en passant.  
- Default UI uses text pieces; SVG images require manual asset setup.  
- Basic interface without move history or enhanced visuals.

---


Feel free to download the SVG pieces from Wikimedia Commons and add them to your project to give your chess app a stylish graphical look!
