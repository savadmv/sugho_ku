// lib/main.dart

import 'package:flutter/material.dart';
import 'sudoku.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuHomePage(),
    );
  }
}

class SudokuHomePage extends StatefulWidget {
  const SudokuHomePage({super.key});

  @override
  _SudokuHomePageState createState() => _SudokuHomePageState();
}

class _SudokuHomePageState extends State<SudokuHomePage> {
  late Sudoku _sudoku;
  int _selectedSize = 9;

  @override
  void initState() {
    super.initState();
    _sudoku = Sudoku(size: _selectedSize);
  }

  void _newGame(int size) {
    setState(() {
      _selectedSize = size;
      _sudoku = Sudoku(size: size);
    });
  }

  void _handleInput(int row, int col) async {
    if (_sudoku.wrongEntries >= 5) {
      _showGameOverDialog();
      return;
    }

    int? num = await _showNumberPicker(context);
    if (num != null) {
      setState(() {
        bool isValid = _sudoku.validateUserInput(row, col, num);
        if (!isValid && _sudoku.wrongEntries >= 5) {
          _showGameOverDialog();
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('You have entered 5 wrong numbers.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _sudoku.resetWrongEntries();
                  _newGame(_selectedSize);
                });
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSizeButton(4),
                _buildSizeButton(9),
                // Add more sizes as needed
              ],
            ),
            Text('Wrong entries: ${_sudoku.wrongEntries}', style: const TextStyle(fontSize: 18, color: Colors.red)),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _selectedSize,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: _selectedSize * _selectedSize,
                itemBuilder: (context, index) {
                  int row = index ~/ _selectedSize;
                  int col = index % _selectedSize;
                  return GestureDetector(
                    onTap: () => _handleInput(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: _sudoku.board[row][col] == 0 ? Colors.white : Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          _sudoku.board[row][col] == 0 ? '' : _sudoku.board[row][col].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sudoku.solve();
                });
              },
              child: const Text('Solve'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(int size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => _newGame(size),
        child: Text('$size x $size'),
      ),
    );
  }

  Future<int?> _showNumberPicker(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      builder: (context) {
        return NumberPickerDialog(maxNum: _selectedSize);
      },
    );
  }
}

class NumberPickerDialog extends StatelessWidget {
  final int maxNum;

  const NumberPickerDialog({Key? key, required this.maxNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a number'),
      content: Container(
        width: double.minPositive,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: maxNum,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(index + 1);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
