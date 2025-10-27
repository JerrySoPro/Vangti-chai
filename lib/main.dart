import 'package:flutter/material.dart';

void main() {
  runApp(VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        primaryColor: Color(0xFF00897B),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: VangtiChaiHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VangtiChaiHome extends StatefulWidget {
  @override
  _VangtiChaiHomeState createState() => _VangtiChaiHomeState();
}

class _VangtiChaiHomeState extends State<VangtiChaiHome> {
  String amount = '';

  int get amountInt => int.tryParse(amount) ?? 0;

  // Taka denominations
  final List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];

  // Calculate note counts
  Map<int, int> get noteCounts {
    int remain = amountInt;
    Map<int, int> counts = {};
    for (var note in notes) {
      counts[note] = remain ~/ note;
      remain %= note;
    }
    return counts;
  }

  void addDigit(String digit) {
    setState(() {
      if (amount.length < 10) {
        if (!(digit == '0' && amount == '')) {
          amount += digit;
        }
      }
    });
  }

  void clearAmount() {
    setState(() {
      amount = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VangtiChai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFF00897B),
        elevation: 0,
      ),
      body: isPortrait ? buildPortraitLayout() : buildLandscapeLayout(),
    );
  }

  Widget buildPortraitLayout() {
    return Column(
      children: [
        // Amount Display Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Center(
            child: Text(
              'Taka: ${amount.isEmpty ? '' : amount}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ),

        // Main content area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Denominations column
                Expanded(flex: 4, child: buildDenominationsColumn()),

                SizedBox(width: 16),

                // Right side - Keypad
                Expanded(flex: 4, child: buildKeypad()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLandscapeLayout() {
    return Column(
      children: [
        // Amount Display - More compact for landscape
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Center(
            child: Text(
              'Taka: ${amount.isEmpty ? '' : amount}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact denominations for landscape
                Expanded(flex: 5, child: buildCompactDenominations()),

                SizedBox(width: 10),

                // Keypad - More compact for landscape
                Expanded(flex: 3, child: buildKeypadLandscape()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDenominationsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var note in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '$note: ${noteCounts[note]}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget buildCompactDenominations() {
    var allCounts = noteCounts.entries.toList();

    // Split into two columns
    int halfLength = (allCounts.length / 2).ceil();
    var leftColumn = allCounts.take(halfLength).toList();
    var rightColumn = allCounts.skip(halfLength).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var entry in leftColumn)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 16),
        // Right column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var entry in rightColumn)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildKeypad() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          children: [
            Expanded(child: buildKeyButton('1', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('2', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('3', isPortrait: true)),
          ],
        ),
        SizedBox(height: 8),

        // Row 2: 4, 5, 6
        Row(
          children: [
            Expanded(child: buildKeyButton('4', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('5', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('6', isPortrait: true)),
          ],
        ),
        SizedBox(height: 8),

        // Row 3: 7, 8, 9
        Row(
          children: [
            Expanded(child: buildKeyButton('7', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('8', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(child: buildKeyButton('9', isPortrait: true)),
          ],
        ),
        SizedBox(height: 8),

        // Row 4: 0, CLEAR
        Row(
          children: [
            Expanded(child: buildKeyButton('0', isPortrait: true)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: buildClearButton(isPortrait: true)),
          ],
        ),
      ],
    );
  }

  Widget buildKeypadLandscape() {
    return Column(
      children: [
        // Row 1: 1, 2, 3, 4
        Expanded(
          child: Row(
            children: [
              Expanded(child: buildKeyButton('1', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('2', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('3', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('4', isPortrait: false)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 2: 5, 6, 7, 8
        Expanded(
          child: Row(
            children: [
              Expanded(child: buildKeyButton('5', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('6', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('7', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('8', isPortrait: false)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 3: 9, 0, CLEAR
        Expanded(
          child: Row(
            children: [
              Expanded(child: buildKeyButton('9', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(child: buildKeyButton('0', isPortrait: false)),
              SizedBox(width: 8),
              Expanded(flex: 2, child: buildClearButton(isPortrait: false)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildKeyButton(String label, {required bool isPortrait}) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ElevatedButton(
        onPressed: () => addDigit(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE0E0E0),
          foregroundColor: Colors.black87,
          elevation: 1,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isPortrait ? 24 : 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget buildClearButton({required bool isPortrait}) {
    return AspectRatio(
      aspectRatio: isPortrait ? 2 : 2,
      child: ElevatedButton(
        onPressed: clearAmount,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE0E0E0),
          foregroundColor: Colors.black87,
          elevation: 1,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          'CLEAR',
          style: TextStyle(
            fontSize: isPortrait ? 18 : 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
