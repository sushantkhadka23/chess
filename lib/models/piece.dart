enum Color { white, black }

enum PieceType { pawn, knight, bishop, rook, queen, king }

class Piece {
  final Color color;
  final PieceType type;
  bool hasMoved;

  Piece({required this.color, required this.type, this.hasMoved = false});

  Piece copyWith({Color? color, PieceType? type, bool? hasMoved}) {
    return Piece(color: color ?? this.color, type: type ?? this.type, hasMoved: hasMoved ?? this.hasMoved);
  }

  Map<String, dynamic> toMap() {
    return {'color': color.name, 'type': type.name, 'hasMoved': hasMoved ? 1 : 0};
  }

  factory Piece.fromMap(Map<String, dynamic> map) {
    return Piece(
      color: Color.values.firstWhere((e) => e.name == map['color']),
      type: PieceType.values.firstWhere((e) => e.name == map['type']),
      hasMoved: map['hasMoved'] == 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          type == other.type &&
          hasMoved == other.hasMoved;

  @override
  int get hashCode => color.hashCode ^ type.hashCode ^ hasMoved.hashCode;
}
