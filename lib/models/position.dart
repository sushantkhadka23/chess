class Position {
  final int row;
  final int col;

  const Position({required this.row, required this.col});

  bool get isValid => row >= 0 && row < 8 && col >= 0 && col < 8;

  Position operator +(Position other) {
    return Position(row: row + other.row, col: col + other.col);
  }

  Map<String, dynamic> toMap() {
    return {'row': row, 'col': col};
  }

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(row: map['row'], col: map['col']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position(row: $row, col: $col)';
}
