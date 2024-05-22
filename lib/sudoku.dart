// lib/sudoku.dart

import 'dart:math';

class Sudoku {
  List<List<int>> _board;
  int size;
  int subGridSize;
  int wrongEntries = 0;

  Sudoku({this.size = 9}) : _board = List.generate(size, (_) => List.filled(size, 0)), subGridSize = sqrt(size).toInt() {
    _board = List.generate(size, (_) => List.filled(size, 0));
    subGridSize = sqrt(size).toInt();
    _generatePuzzle();
  }

  List<List<int>> get board => _board;

  void _generatePuzzle() {
    if (size == 4) {
      _board = [
        [1, 0, 0, 2],
        [0, 2, 3, 0],
        [0, 3, 4, 0],
        [4, 0, 0, 1]
      ];
    } else if (size == 9) {
      _board = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9]
      ];
    }
  }

  bool isValid(int row, int col, int num) {
    for (int i = 0; i < size; i++) {
      if (_board[row][i] == num || _board[i][col] == num) {
        return false;
      }
    }

    int startRow = (row ~/ subGridSize) * subGridSize;
    int startCol = (col ~/ subGridSize) * subGridSize;

    for (int i = 0; i < subGridSize; i++) {
      for (int j = 0; j < subGridSize; j++) {
        if (_board[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool solve() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (_board[row][col] == 0) {
          for (int num = 1; num <= size; num++) {
            if (isValid(row, col, num)) {
              _board[row][col] = num;
              if (solve()) {
                return true;
              } else {
                _board[row][col] = 0;
              }
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool validateUserInput(int row, int col, int num) {
    if (isValid(row, col, num)) {
      _board[row][col] = num;
      return true;
    } else {
      wrongEntries++;
      return false;
    }
  }

  void resetWrongEntries() {
    wrongEntries = 0;
  }
}
