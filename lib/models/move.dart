import 'position.dart';

class Move {
  final Position from;
  final Position to;
  final DateTime timestamp;

  Move({required this.from, required this.to, DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {'from': from.toMap(), 'to': to.toMap(), 'timestamp': timestamp.millisecondsSinceEpoch};
  }

  factory Move.fromMap(Map<String, dynamic> map) {
    return Move(
      from: Position.fromMap(map['from']),
      to: Position.fromMap(map['to']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Move && runtimeType == other.runtimeType && from == other.from && to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;

  @override
  String toString() => 'Move(from: $from, to: $to)';
}
