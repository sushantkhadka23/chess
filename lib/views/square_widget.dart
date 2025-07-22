import 'package:flutter/material.dart';

import 'piece_widget.dart';
import '../models/position.dart';
import '../models/board_cell.dart';

class SquareWidget extends StatelessWidget {
  final BoardCell cell;
  final Position position;
  final bool isSelected;
  final bool isPossibleMove;
  final bool isLastMove;
  final VoidCallback onTap;

  const SquareWidget({
    super.key,
    required this.cell,
    required this.position,
    required this.onTap,
    this.isSelected = false,
    this.isPossibleMove = false,
    this.isLastMove = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: _getBackgroundColor(), border: _getBorder()),
        child: Stack(
          children: [
            // Piece
            if (cell.piece != null) Center(child: PieceWidget(piece: cell.piece!, size: 40)),

            // Possible move indicator
            if (isPossibleMove && cell.piece == null)
              Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                ),
              ),

            // Capture indicator
            if (isPossibleMove && cell.piece != null)
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 3)),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return Colors.yellow.withOpacity(0.7);
    }
    if (isLastMove) {
      return Colors.blue.withOpacity(0.3);
    }
    return cell.squareColor;
  }

  Border? _getBorder() {
    if (isSelected) {
      return Border.all(color: Colors.yellow, width: 3);
    }
    return null;
  }
}
