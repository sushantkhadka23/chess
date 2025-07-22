import 'package:flutter/material.dart';

import 'package:chess/constants/app_constants.dart';
import 'package:chess/models/piece.dart' show Piece;

class BoardCell {
  final Color squareColor;
  Piece? piece;

  BoardCell({required this.squareColor, this.piece});

  static Color getSquareColor(int row, int col) {
    return (row + col) % 2 == 0 ? AppConstants.lightSquare : AppConstants.darkSquare;
  }

  Map<String, dynamic> toMap() {
    return {'piece': piece?.toMap()};
  }

  factory BoardCell.fromMap(Map<String, dynamic> map, Color squareColor) {
    return BoardCell(squareColor: squareColor, piece: map['piece'] != null ? Piece.fromMap(map['piece']) : null);
  }

  BoardCell copyWith({Piece? piece}) {
    return BoardCell(squareColor: squareColor, piece: piece);
  }
}
