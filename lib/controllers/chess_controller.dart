import 'package:flutter/material.dart';

import '../models/move.dart';
import '../models/piece.dart';
import '../models/game_state.dart';
import '../models/position.dart';
import '../services/database_service.dart';
import 'package:chess/models/board_cell.dart';

class ChessController extends ChangeNotifier {
  GameState _gameState = GameState();
  final DatabaseService _databaseService = DatabaseService();
  Position? _selectedPosition;
  List<Position> _possibleMoves = [];

  GameState get gameState => _gameState;
  Position? get selectedPosition => _selectedPosition;
  List<Position> get possibleMoves => _possibleMoves;

  // Initialize game
  Future<void> initializeGame() async {
    final lastGame = await _databaseService.getLastGame();
    if (lastGame != null) {
      _gameState = lastGame;
    } else {
      _gameState = GameState();
      await saveGame();
    }
    notifyListeners();
  }

  // Save current game state
  Future<void> saveGame() async {
    await _databaseService.saveGame(_gameState);
  }

  // Start new game
  Future<void> newGame() async {
    _gameState = GameState();
    _selectedPosition = null;
    _possibleMoves = [];
    await saveGame();
    notifyListeners();
  }

  // Handle square selection
  void onSquareSelected(Position position) {
    final cell = _gameState.board[position.row][position.col];

    // If no piece is selected
    if (_selectedPosition == null) {
      if (cell.piece != null && cell.piece!.color == _gameState.currentPlayer) {
        _selectedPosition = position;
        _possibleMoves = getPossibleMoves(position);
        notifyListeners();
      }
      return;
    }

    // If same square selected, deselect
    if (_selectedPosition == position) {
      _selectedPosition = null;
      _possibleMoves = [];
      notifyListeners();
      return;
    }

    // If selecting another piece of same color
    if (cell.piece != null && cell.piece!.color == _gameState.currentPlayer) {
      _selectedPosition = position;
      _possibleMoves = getPossibleMoves(position);
      notifyListeners();
      return;
    }

    // Try to make a move
    if (_possibleMoves.contains(position)) {
      makeMove(_selectedPosition!, position);
    }

    _selectedPosition = null;
    _possibleMoves = [];
    notifyListeners();
  }

  // Get possible moves for a piece
  List<Position> getPossibleMoves(Position position) {
    final piece = _gameState.board[position.row][position.col].piece;
    if (piece == null || piece.color != _gameState.currentPlayer) {
      return [];
    }

    List<Position> moves = [];

    switch (piece.type) {
      case PieceType.pawn:
        moves = _getPawnMoves(position);
        break;
      case PieceType.knight:
        moves = _getKnightMoves(position);
        break;
      case PieceType.bishop:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 1),
          const Position(row: 1, col: -1),
          const Position(row: -1, col: 1),
          const Position(row: -1, col: -1),
        ]);
        break;
      case PieceType.rook:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 0),
          const Position(row: -1, col: 0),
          const Position(row: 0, col: 1),
          const Position(row: 0, col: -1),
        ]);
        break;
      case PieceType.queen:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 0),
          const Position(row: -1, col: 0),
          const Position(row: 0, col: 1),
          const Position(row: 0, col: -1),
          const Position(row: 1, col: 1),
          const Position(row: 1, col: -1),
          const Position(row: -1, col: 1),
          const Position(row: -1, col: -1),
        ]);
        break;
      case PieceType.king:
        moves = _getKingMoves(position);
        break;
    }

    // Filter out moves that would put own king in check
    return moves.where((move) => isMoveLegal(position, move)).toList();
  }

  List<Position> _getPawnMoves(Position position) {
    final moves = <Position>[];
    final piece = _gameState.board[position.row][position.col].piece!;
    final direction = piece.color == Color.white ? -1 : 1;
    final startRow = piece.color == Color.white ? 6 : 1;

    // Move forward 1
    final oneForward = Position(row: position.row + direction, col: position.col);
    if (oneForward.isValid && _gameState.board[oneForward.row][oneForward.col].piece == null) {
      moves.add(oneForward);

      // Move forward 2 (from starting position)
      if (position.row == startRow) {
        final twoForward = Position(row: position.row + (2 * direction), col: position.col);
        if (twoForward.isValid && _gameState.board[twoForward.row][twoForward.col].piece == null) {
          moves.add(twoForward);
        }
      }
    }

    // Diagonal captures
    for (final dc in [-1, 1]) {
      final capturePos = Position(row: position.row + direction, col: position.col + dc);
      if (capturePos.isValid) {
        final target = _gameState.board[capturePos.row][capturePos.col].piece;
        if (target != null && target.color != piece.color) {
          moves.add(capturePos);
        }
      }
    }

    return moves;
  }

  List<Position> _getKnightMoves(Position position) {
    final moves = <Position>[];
    final piece = _gameState.board[position.row][position.col].piece!;

    final directions = [
      const Position(row: -2, col: -1),
      const Position(row: -2, col: 1),
      const Position(row: -1, col: -2),
      const Position(row: -1, col: 2),
      const Position(row: 1, col: -2),
      const Position(row: 1, col: 2),
      const Position(row: 2, col: -1),
      const Position(row: 2, col: 1),
    ];

    for (final direction in directions) {
      final newPos = position + direction;
      if (newPos.isValid) {
        final target = _gameState.board[newPos.row][newPos.col].piece;
        if (target == null || target.color != piece.color) {
          moves.add(newPos);
        }
      }
    }

    return moves;
  }

  List<Position> _getSlidingMoves(Position position, List<Position> directions) {
    final moves = <Position>[];
    final piece = _gameState.board[position.row][position.col].piece!;

    for (final direction in directions) {
      Position current = position;
      while (true) {
        current = current + direction;
        if (!current.isValid) break;

        final target = _gameState.board[current.row][current.col].piece;
        if (target == null) {
          moves.add(current);
        } else if (target.color != piece.color) {
          moves.add(current);
          break;
        } else {
          break;
        }
      }
    }

    return moves;
  }

  List<Position> _getKingMoves(Position position) {
    final moves = <Position>[];
    final piece = _gameState.board[position.row][position.col].piece!;

    final directions = [
      const Position(row: 1, col: 0),
      const Position(row: -1, col: 0),
      const Position(row: 0, col: 1),
      const Position(row: 0, col: -1),
      const Position(row: 1, col: 1),
      const Position(row: 1, col: -1),
      const Position(row: -1, col: 1),
      const Position(row: -1, col: -1),
    ];

    for (final direction in directions) {
      final newPos = position + direction;
      if (newPos.isValid) {
        final target = _gameState.board[newPos.row][newPos.col].piece;
        if (target == null || target.color != piece.color) {
          moves.add(newPos);
        }
      }
    }

    return moves;
  }

  // Check if move is legal (doesn't put own king in check)
  bool isMoveLegal(Position from, Position to) {
    final tempBoard = _gameState.deepCopyBoard();
    final piece = tempBoard[from.row][from.col].piece!;

    // Simulate the move
    tempBoard[to.row][to.col].piece = piece;
    tempBoard[from.row][from.col].piece = null;

    return !_isKingInCheck(_gameState.currentPlayer, tempBoard);
  }

  // Check if king is in check
  bool _isKingInCheck(Color player, List<List<BoardCell>> board) {
    final kingPos = _findKing(player, board);
    if (kingPos == null) return false;

    final opponent = player == Color.white ? Color.black : Color.white;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board[row][col].piece;
        if (piece != null && piece.color == opponent) {
          final position = Position(row: row, col: col);
          final moves = _getRawMoves(position, board);
          if (moves.contains(kingPos)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  Position? _findKing(Color player, List<List<BoardCell>> board) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board[row][col].piece;
        if (piece != null && piece.color == player && piece.type == PieceType.king) {
          return Position(row: row, col: col);
        }
      }
    }
    return null;
  }

  List<Position> _getRawMoves(Position position, List<List<BoardCell>> board) {
    final piece = board[position.row][position.col].piece;
    if (piece == null) return [];

    // Use current board state temporarily
    final originalBoard = _gameState.board;
    _gameState.board = board;

    List<Position> moves = [];
    switch (piece.type) {
      case PieceType.pawn:
        moves = _getPawnMoves(position);
        break;
      case PieceType.knight:
        moves = _getKnightMoves(position);
        break;
      case PieceType.bishop:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 1),
          const Position(row: 1, col: -1),
          const Position(row: -1, col: 1),
          const Position(row: -1, col: -1),
        ]);
        break;
      case PieceType.rook:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 0),
          const Position(row: -1, col: 0),
          const Position(row: 0, col: 1),
          const Position(row: 0, col: -1),
        ]);
        break;
      case PieceType.queen:
        moves = _getSlidingMoves(position, [
          const Position(row: 1, col: 0),
          const Position(row: -1, col: 0),
          const Position(row: 0, col: 1),
          const Position(row: 0, col: -1),
          const Position(row: 1, col: 1),
          const Position(row: 1, col: -1),
          const Position(row: -1, col: 1),
          const Position(row: -1, col: -1),
        ]);
        break;
      case PieceType.king:
        moves = _getKingMoves(position);
        break;
    }

    // Restore original board
    _gameState.board = originalBoard;
    return moves;
  }

  // Make a move
  Future<void> makeMove(Position from, Position to) async {
    if (!isMoveLegal(from, to)) return;

    final piece = _gameState.board[from.row][from.col].piece!;
    final capturedPiece = _gameState.board[to.row][to.col].piece;

    // Update half-move clock
    if (capturedPiece != null || piece.type == PieceType.pawn) {
      _gameState.halfMoveClock = 0;
    } else {
      _gameState.halfMoveClock++;
    }

    // Make the move
    _gameState.board[to.row][to.col].piece = piece.copyWith(hasMoved: true);
    _gameState.board[from.row][from.col].piece = null;

    // Add to move history
    _gameState.moveHistory.add(Move(from: from, to: to));

    // Update position count for threefold repetition
    final boardHash = _gameState.getBoardHash();
    _gameState.positionCount[boardHash] = (_gameState.positionCount[boardHash] ?? 0) + 1;

    // Switch players
    _gameState.currentPlayer = _gameState.currentPlayer == Color.white ? Color.black : Color.white;

    // Check game status
    _updateGameStatus();

    // Save game state
    await saveGame();
  }

  // Update game status (check, checkmate, stalemate, draw)
  void _updateGameStatus() {
    if (_isKingInCheck(_gameState.currentPlayer, _gameState.board)) {
      if (_hasLegalMoves(_gameState.currentPlayer)) {
        _gameState.status = GameStatus.check;
      } else {
        _gameState.status = GameStatus.checkmate;
      }
    } else {
      if (_hasLegalMoves(_gameState.currentPlayer)) {
        if (_isDraw()) {
          _gameState.status = GameStatus.draw;
        } else {
          _gameState.status = GameStatus.ongoing;
        }
      } else {
        _gameState.status = GameStatus.stalemate;
      }
    }
  }

  // Check if player has legal moves
  bool _hasLegalMoves(Color player) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = _gameState.board[row][col].piece;
        if (piece != null && piece.color == player) {
          final position = Position(row: row, col: col);
          final moves = getPossibleMoves(position);
          if (moves.isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Check for draw conditions
  bool _isDraw() {
    // Fifty-move rule
    if (_gameState.halfMoveClock >= 50) {
      return true;
    }

    // Threefold repetition
    final boardHash = _gameState.getBoardHash();
    if ((_gameState.positionCount[boardHash] ?? 0) >= 3) {
      return true;
    }

    final pieces = <Piece>[];
    for (final row in _gameState.board) {
      for (final cell in row) {
        if (cell.piece != null) {
          pieces.add(cell.piece!);
        }
      }
    }

    if (pieces.length <= 2) {
      return true;
    }

    if (pieces.length == 3) {
      final nonKingPieces = pieces.where((p) => p.type != PieceType.king).toList();
      if (nonKingPieces.length == 1) {
        final piece = nonKingPieces.first;
        if (piece.type == PieceType.knight || piece.type == PieceType.bishop) {
          return true; // King + knight/bishop vs. king
        }
      }
    }

    return false;
  }

  // Get game status message
  String getStatusMessage() {
    switch (_gameState.status) {
      case GameStatus.ongoing:
        return '${_gameState.currentPlayer == Color.white ? 'White' : 'Black'} to move';
      case GameStatus.check:
        return '${_gameState.currentPlayer == Color.white ? 'White' : 'Black'} is in check!';
      case GameStatus.checkmate:
        final winner = _gameState.currentPlayer == Color.white ? 'Black' : 'White';
        return 'Checkmate! $winner wins!';
      case GameStatus.stalemate:
        return 'Stalemate! It\'s a draw!';
      case GameStatus.draw:
        return 'Draw!';
    }
  }
}
