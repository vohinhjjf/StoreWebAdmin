import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time extends StatefulWidget {
  late DateTime dateTime;

  Time({super.key, required this.dateTime});
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> with SingleTickerProviderStateMixin {
  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );


  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.grey.shade400
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: const CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 3),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(4, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 9),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(10, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            color: Theme.of(context).cardColor,
            child: AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: const Duration(milliseconds: 300),
              child: Container(
                //height: _pickerOpen ? null : 0.0,
                //width: MediaQuery.of(context).size.width /3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear - 1;
                            });
                          },
                          icon: const Icon(Icons.navigate_before_rounded),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _pickerYear.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear + 1;
                            });
                          },
                          icon: const Icon(Icons.navigate_next_rounded),
                        ),
                      ],
                    ),
                    ...generateMonths(),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(DateFormat.yMMMM().format(_selectedMonth)),
          const SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
            onPressed: (){
              setState(() {
                widget.dateTime = _selectedMonth;
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Select date',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}