import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../constants/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final double size;

  const PieceWidget({super.key, required this.piece, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_getPieceAsset(piece), width: size, height: size);
  }

  String _getPieceAsset(Piece piece) {
    if (piece.color == Color.white) {
      switch (piece.type) {
        case PieceType.pawn:
          return AppImages.whitePawn;
        case PieceType.knight:
          return AppImages.whiteKnight;
        case PieceType.bishop:
          return AppImages.whiteBishop;
        case PieceType.rook:
          return AppImages.whiteRook;
        case PieceType.queen:
          return AppImages.whiteQueen;
        case PieceType.king:
          return AppImages.whiteKing;
      }
    } else {
      switch (piece.type) {
        case PieceType.pawn:
          return AppImages.blackPawn;
        case PieceType.knight:
          return AppImages.blackKnight;
        case PieceType.bishop:
          return AppImages.blackBishop;
        case PieceType.rook:
          return AppImages.blackRook;
        case PieceType.queen:
          return AppImages.blackQueen;
        case PieceType.king:
          return AppImages.blackKing;
      }
    }
  }
}
