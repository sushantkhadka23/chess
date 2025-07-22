import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/chess_board_view.dart';
import 'controllers/chess_controller.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChessController()..initializeGame(),
      child: MaterialApp(
        title: 'Chess Game',
        theme: ThemeData(primarySwatch: Colors.brown, visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const ChessBoardView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
