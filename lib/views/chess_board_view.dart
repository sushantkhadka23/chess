import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'square_widget.dart';
import '../models/position.dart';
import '../constants/app_constants.dart';
import 'package:chess/models/game_state.dart';
import '../controllers/chess_controller.dart';

class ChessBoardView extends StatelessWidget {
  const ChessBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Game'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: () => _showGameMenu(context), icon: const Icon(Icons.menu))],
      ),
      body: Consumer<ChessController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Game status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: _getStatusColor(controller),
                child: Text(
                  controller.getStatusMessage(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

              // Chess board
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.brown[800]!, width: 2)),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppConstants.boardSize,
                        ),
                        itemCount: 64,
                        itemBuilder: (context, index) {
                          final row = index ~/ AppConstants.boardSize;
                          final col = index % AppConstants.boardSize;
                          final position = Position(row: row, col: col);
                          final cell = controller.gameState.board[row][col];

                          final isSelected = controller.selectedPosition == position;
                          final isPossibleMove = controller.possibleMoves.contains(position);
                          final isLastMove = _isLastMoveSquare(controller, position);

                          return SquareWidget(
                            cell: cell,
                            position: position,
                            isSelected: isSelected,
                            isPossibleMove: isPossibleMove,
                            isLastMove: isLastMove,
                            onTap: () => controller.onSquareSelected(position),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Move history (last few moves)
              Container(height: 80, padding: const EdgeInsets.all(8), child: _buildMoveHistory(controller)),
            ],
          );
        },
      ),
    );
  }

  bool _isLastMoveSquare(ChessController controller, Position position) {
    if (controller.gameState.moveHistory.isEmpty) return false;

    final lastMove = controller.gameState.moveHistory.last;
    return lastMove.from == position || lastMove.to == position;
  }

  Color _getStatusColor(ChessController controller) {
    switch (controller.gameState.status) {
      case GameStatus.ongoing:
        return Colors.blue;
      case GameStatus.check:
        return Colors.orange;
      case GameStatus.checkmate:
        return Colors.red;
      case GameStatus.stalemate:
      case GameStatus.draw:
        return Colors.grey;
    }
  }

  Widget _buildMoveHistory(ChessController controller) {
    if (controller.gameState.moveHistory.isEmpty) {
      return const Center(
        child: Text('No moves yet', style: TextStyle(color: Colors.grey)),
      );
    }

    final recentMoves = controller.gameState.moveHistory
        .skip(controller.gameState.moveHistory.length > 10 ? controller.gameState.moveHistory.length - 10 : 0)
        .toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recentMoves.length,
      itemBuilder: (context, index) {
        final move = recentMoves[index];
        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
          child: Text(
            '${_positionToAlgebraic(move.from)} → ${_positionToAlgebraic(move.to)}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  String _positionToAlgebraic(Position position) {
    final files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    final rank = 8 - position.row;
    final file = files[position.col];
    return '$file$rank';
  }

  void _showGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Game'),
              onTap: () {
                Navigator.pop(context);
                _confirmNewGame(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save Game'),
              onTap: () {
                Navigator.pop(context);
                context.read<ChessController>().saveGame();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Game saved!')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Load Game'),
              onTap: () {
                Navigator.pop(context);
                _showLoadGameDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmNewGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Game'),
        content: const Text('Are you sure you want to start a new game? Current progress will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChessController>().newGame();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  void _showLoadGameDialog(BuildContext context) {
    // You can implement a game selection dialog here
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Load game feature - to be implemented')));
  }
}
