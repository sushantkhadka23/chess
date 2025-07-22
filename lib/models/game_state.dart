import 'dart:convert';

import 'move.dart';
import 'piece.dart';
import 'board_cell.dart';
import '../constants/app_constants.dart';

enum GameStatus { ongoing, check, checkmate, stalemate, draw }

class GameState {
  late List<List<BoardCell>> board;
  Color currentPlayer;
  List<Move> moveHistory;
  int halfMoveClock;
  Map<String, int> positionCount;
  GameStatus status;
  final DateTime createdAt;
  DateTime updatedAt;
  int? id;

  GameState({
    List<List<BoardCell>>? board,
    this.currentPlayer = Color.white,
    List<Move>? moveHistory,
    this.halfMoveClock = 0,
    Map<String, int>? positionCount,
    this.status = GameStatus.ongoing,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.id,
  }) : moveHistory = moveHistory ?? [],
       positionCount = positionCount ?? {},
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now() {
    this.board = board ?? _initializeBoard();
  }

  List<List<BoardCell>> _initializeBoard() {
    final newBoard = <List<BoardCell>>[];

    // Initialize empty board
    for (int row = 0; row < AppConstants.boardSize; row++) {
      final rowCells = <BoardCell>[];
      for (int col = 0; col < AppConstants.boardSize; col++) {
        final squareColor = BoardCell.getSquareColor(row, col);
        rowCells.add(BoardCell(squareColor: squareColor));
      }
      newBoard.add(rowCells);
    }

    // Place pieces
    _placePieces(newBoard);

    return newBoard;
  }

  void _placePieces(List<List<BoardCell>> board) {
    final backRow = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];

    for (int col = 0; col < AppConstants.boardSize; col++) {
      // Black pieces (top of board)
      board[0][col].piece = Piece(color: Color.black, type: backRow[col]);
      board[1][col].piece = Piece(color: Color.black, type: PieceType.pawn);

      // White pieces (bottom of board)
      board[7][col].piece = Piece(color: Color.white, type: backRow[col]);
      board[6][col].piece = Piece(color: Color.white, type: PieceType.pawn);
    }
  }

  GameState copyWith({
    List<List<BoardCell>>? board,
    Color? currentPlayer,
    List<Move>? moveHistory,
    int? halfMoveClock,
    Map<String, int>? positionCount,
    GameStatus? status,
    DateTime? updatedAt,
    int? id,
  }) {
    return GameState(
      board: board ?? deepCopyBoard(),
      currentPlayer: currentPlayer ?? this.currentPlayer,
      moveHistory: moveHistory ?? List.from(this.moveHistory),
      halfMoveClock: halfMoveClock ?? this.halfMoveClock,
      positionCount: positionCount ?? Map.from(this.positionCount),
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }

  List<List<BoardCell>> deepCopyBoard() {
    return board
        .map((row) => row.map((cell) => BoardCell(squareColor: cell.squareColor, piece: cell.piece?.copyWith())).toList())
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'board': jsonEncode(board.map((row) => row.map((cell) => cell.toMap()).toList()).toList()),
      'currentPlayer': currentPlayer.name,
      'moveHistory': jsonEncode(moveHistory.map((move) => move.toMap()).toList()),
      'halfMoveClock': halfMoveClock,
      'positionCount': jsonEncode(positionCount),
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    final boardData = jsonDecode(map['board']) as List;
    final board = <List<BoardCell>>[];

    for (int row = 0; row < boardData.length; row++) {
      final rowData = boardData[row] as List;
      final rowCells = <BoardCell>[];
      for (int col = 0; col < rowData.length; col++) {
        final squareColor = BoardCell.getSquareColor(row, col);
        rowCells.add(BoardCell.fromMap(rowData[col], squareColor));
      }
      board.add(rowCells);
    }

    final moveHistoryData = jsonDecode(map['moveHistory']) as List;
    final moveHistory = moveHistoryData.map((moveMap) => Move.fromMap(moveMap)).toList();

    final positionCountData = jsonDecode(map['positionCount']) as Map<String, dynamic>;
    final positionCount = positionCountData.cast<String, int>();

    return GameState(
      board: board,
      currentPlayer: Color.values.firstWhere((e) => e.name == map['currentPlayer']),
      moveHistory: moveHistory,
      halfMoveClock: map['halfMoveClock'],
      positionCount: positionCount,
      status: GameStatus.values.firstWhere((e) => e.name == map['status']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      id: map['id'],
    );
  }

  String getBoardHash() {
    final buffer = StringBuffer();
    for (final row in board) {
      for (final cell in row) {
        if (cell.piece == null) {
          buffer.write('.');
        } else {
          final piece = cell.piece!;
          final char = _pieceToChar(piece.type);
          buffer.write(piece.color == Color.white ? char : char.toLowerCase());
        }
      }
    }
    buffer.write(currentPlayer.name);
    return buffer.toString();
  }

  String _pieceToChar(PieceType type) {
    switch (type) {
      case PieceType.pawn:
        return 'P';
      case PieceType.knight:
        return 'N';
      case PieceType.bishop:
        return 'B';
      case PieceType.rook:
        return 'R';
      case PieceType.queen:
        return 'Q';
      case PieceType.king:
        return 'K';
    }
  }
}
