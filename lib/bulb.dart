import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Active with ChangeNotifier {}

class Setting with ChangeNotifier {
  Setting() {
    activeTable = List.generate(size, (_) => List.generate(size, (_) => false));
  }
  int size = 3;
  late List<List<bool>> activeTable;

  void setSize(int newSize) {
    size = newSize;
    activeTable = List.generate(size, (_) => List.generate(size, (_) => false));
    notifyListeners();
  }

  void allOn() {
    activeTable = activeTable.map((e) => e.map((e) => true).toList()).toList();
    notifyListeners();
  }

  void rand() {
    var rand = Random();
    activeTable =
        activeTable.map((e) => e.map((e) => rand.nextBool()).toList()).toList();
    notifyListeners();
  }
}

class BulbPage extends StatelessWidget {
  const BulbPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Setting>(
      create: (context) => Setting(),
      child: Consumer<Setting>(
        builder: (context, setting, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: SizeSetter(),
              ),
              Expanded(
                flex: 3,
                child: Board(
                  size: setting.size,
                  activeTable: setting.activeTable,
                ),
              ),
              Expanded(
                flex: 1,
                child: BoardSetter(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    required this.size,
    required this.activeTable,
    Key? key,
  }) : super(key: key);
  final int size;
  final List<List<bool>> activeTable;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  ChangeNotifierProvider<Active> _makeRow(int row) {
    return ChangeNotifierProvider<Active>(
      create: (context) => Active(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.size,
          (index) => Bulb(
            coordinate: Point(row, index),
            isActive: widget.activeTable[row][index],
            size: widget.size,
          ),
        ),
      ),
    );
  }

  void updateBulb(int row, int col) {
    setState(() {
      for (var i = -1; i <= 1; i++) {
        for (var j = -1; j <= 1; j++) {
          if (row + i >= 0 &&
              row + i < widget.size &&
              col + j >= 0 &&
              col + j < widget.size)
            widget.activeTable[row + i][col + j] =
                !widget.activeTable[row + i][col + j];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.size,
              (index) => Expanded(
                flex: 1,
                child: _makeRow(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bulb extends StatelessWidget {
  const Bulb({
    this.isActive = false,
    required this.coordinate,
    required this.size,
    Key? key,
  }) : super(key: key);
  final Point<int> coordinate;
  final int size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        color: isActive ? Colors.yellow[300] : Colors.grey[300],
        child: TextButton(
          onPressed: () {
            context
                .findAncestorStateOfType<_BoardState>()!
                .updateBulb(coordinate.x, coordinate.y);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(
              isActive ? 'ON' : 'OFF',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}

class BoardSetter extends StatelessWidget {
  const BoardSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SettingButton(
          str: "Turn All Bulbs On",
          onPressed: () {
            context.read<Setting>().allOn();
          },
        ),
        SettingButton(
          str: "Start Random",
          onPressed: () {
            context.read<Setting>().rand();
          },
        ),
      ],
    );
  }
}

class SizeSetter extends StatelessWidget {
  const SizeSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 32.0, 0, 0),
            child: Text(
              'Set board size:',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Expanded(flex: 1, child: SizeButton(size: 3)),
        Expanded(flex: 1, child: SizeButton(size: 4)),
        Expanded(flex: 1, child: SizeButton(size: 5)),
        Expanded(flex: 1, child: SizeButton(size: 6)),
        Expanded(flex: 1, child: SizeButton(size: 7)),
        Expanded(flex: 1, child: SizeButton(size: 8)),
        Expanded(flex: 1, child: SizeButton(size: 9)),
        Expanded(
            flex: 0,
            child: Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 32.0)))
      ],
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({this.onPressed, required this.str, Key? key})
      : super(key: key);
  final String str;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          str,
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}

class SizeButton extends StatelessWidget {
  const SizeButton({required this.size, Key? key}) : super(key: key);
  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: () {
          context.read<Setting>().setSize(size);
        },
        child: Text(
          '$size x $size',
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}
