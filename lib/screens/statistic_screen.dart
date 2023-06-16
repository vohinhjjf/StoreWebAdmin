import 'package:chips_choice/chips_choice.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../data/time_picker.dart';
import '../services/firebase_services.dart';

class StatisticScreen extends StatefulWidget {
  static const String id = 'statistic-screen';

  const StatisticScreen({super.key});
  @override
  State<StatisticScreen> createState() => _StatisticScreen();
}

class _StatisticScreen extends State<StatisticScreen> {
  final FirebaseServices _services = FirebaseServices();
  int tag = 0, year = 2023, month = DateTime.now().month;
  DateFormat dateFormat = DateFormat('MM/yyyy');
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  List<String> options = [
    'Theo năm',//0
    'Theo tháng',//1,
    'Theo ngày',//2
  ];

   List<FlSpot> spots = const [
    FlSpot(0, 0),
    FlSpot(180, 0),
    FlSpot(360, 0),
    FlSpot(540, 0),
  ];

  final leftTitle = {
    0: '0',
    50: '50',
    100: '100',
    150: '150',
    200: '200',
    250: '250',
    300: '300',
    350: '350',
    400: '400',
    450: '450',
    500: '500',
  };

  final leftTitle_Day = {
    0: '0',
    30: '30',
    60: '60',
    90: '90',
    120: '120',
    150: '150',
  };

  final bottomTitle_Day = {
    0: '1',5: '2',10: '3',15: '4',20: '5',25: '6',30: '7',35: '8',40: '9',45: '10',
    50: '11',55: '12',60: '13',65: '14',70: '15',75: '16',80: '17',85: '18',90: '19',
    95: '20', 100: '21',105: '22',110: '23',115: '24',120: '25',125: '26',130: '27',
    135: '28', 140: '29',145: '30',150: '31',
  };

  final bottomTitle_Month = {
    0: 'Jan',
    50: 'Feb',
    100: 'Mar',
    150: 'Apr',
    200: 'May',
    250: 'Jun',
    300: 'Jul',
    350: 'Aug',
    400: 'Sep',
    450: 'Oct',
    500: 'Nov',
    550: 'Dec',
  };

  final bottomTitle_Year = {
    0: '2020',
    180: '2021',
    360: '2022',
    540: '2023',
  };

  Future<void> queryRevenueByYear() async {
    double revenue_2020 = 0,revenue_2021 = 0,revenue_2022 = 0,revenue_2023 = 0;
    DateFormat inputFormat = DateFormat('hh:mm:ss dd/MM/yyyy');
    await _services.users.get().then((value) async {
      for(var data1 in value.docs){
        await _services.users.doc(data1.id).collection("purchase history").where("orderStatus", isEqualTo: "Đã nhận hàng")
            .get().then((value) {
          for(var data2 in value.docs){
            switch (inputFormat
                .parse(data2.data()["orderDate"])
                .year) {
              case 2020:
                {
                  revenue_2020 += data2.data()["total"] as int;
                };
                break;
              case 2021:
                {
                  revenue_2021 += data2.data()["total"] as int;
                };
                break;
              case 2022:
                {
                  revenue_2022 += data2.data()["total"] as int;
                };
                break;
              case 2023:
                {
                  revenue_2023 += data2.data()["total"] as int;
                };
                break;
            }
          }
        });
      }
    });
    setState(() {
      spots =  [
        FlSpot(0, revenue_2020/1000000),
        FlSpot(180, revenue_2021/1000000),
        FlSpot(360, revenue_2022/1000000),
        FlSpot(540, revenue_2023/1000000),
      ];
    });
  }

  Future<void> queryRevenueByMonth() async {
    double revenue_1 = 0,revenue_2 = 0,revenue_3 = 0,revenue_4 = 0,revenue_5 = 0
    ,revenue_6 = 0,revenue_7 = 0,revenue_8 = 0,revenue_9 = 0,revenue_10 = 0
    ,revenue_11 = 0,revenue_12 = 0;
    DateFormat inputFormat = DateFormat('hh:mm:ss dd/MM/yyyy');
    await _services.users.get().then((value) async {
      for(var data1 in value.docs){
        await _services.users.doc(data1.id).collection("purchase history").where("orderStatus", isEqualTo: "Đã nhận hàng")
            .get().then((value) {
          for(var data2 in value.docs){
            if(inputFormat.parse(data2.data()["orderDate"]).year == year) {
              switch (inputFormat
                  .parse(data2.data()["orderDate"])
                  .month) {
                case 1:
                  {
                    revenue_1 += data2.data()["total"] as int;
                  };
                  break;
                case 2:
                  {
                    revenue_2 += data2.data()["total"] as int;
                  };
                  break;
                case 3:
                  {
                    revenue_3 += data2.data()["total"] as int;
                  };
                  break;
                case 4:
                  {
                    revenue_4 += data2.data()["total"] as int;
                  };
                  break;
                case 5:
                  {
                    revenue_5 += data2.data()["total"] as int;
                  };
                  break;
                case 6:
                  {
                    revenue_6 += data2.data()["total"] as int;
                  };
                  break;
                case 7:
                  {
                    revenue_7 += data2.data()["total"] as int;
                  };
                  break;
                case 8:
                  {
                    revenue_8 += data2.data()["total"] as int;
                  };
                  break;
                case 9:
                  {
                    revenue_9 += data2.data()["total"] as int;
                  };
                  break;
                case 10:
                  {
                    revenue_10 += data2.data()["total"] as int;
                  };
                  break;
                case 11:
                  {
                    revenue_11 += data2.data()["total"] as int;
                  };
                  break;
                default:
                  {
                    revenue_12 += data2.data()["total"] as int;
                  };
                  break;
              }
            }
          }
        });
      }
    });
    setState(() {
      spots =  [
        FlSpot(0, revenue_1/1000000),
        FlSpot(50, revenue_2/1000000),
        FlSpot(100, revenue_3/1000000),
        FlSpot(150, revenue_4/1000000),
        FlSpot(200, revenue_5/1000000),
        FlSpot(250, revenue_6/1000000),
        FlSpot(300, revenue_7/1000000),
        FlSpot(350, revenue_8/1000000),
        FlSpot(400, revenue_9/1000000),
        FlSpot(450, revenue_10/1000000),
        FlSpot(500, revenue_11/1000000),
        FlSpot(550, revenue_12/1000000),
      ];
    });
  }

  Future<void> queryRevenueByDay() async {
    double revenue_1 = 0,revenue_2 = 0,revenue_3 = 0,revenue_4 = 0,revenue_5 = 0
    ,revenue_6 = 0,revenue_7 = 0,revenue_8 = 0,revenue_9 = 0,revenue_10 = 0
    ,revenue_11 = 0,revenue_12 = 0, revenue_13 = 0,revenue_14 = 0,revenue_15 = 0
    ,revenue_16 = 0,revenue_17 = 0,revenue_18 = 0,revenue_19 = 0,revenue_20 = 0
    ,revenue_21 = 0,revenue_22 = 0,revenue_23 = 0,revenue_24 = 0,revenue_25 = 0
    ,revenue_26 = 0,revenue_27 = 0,revenue_28 = 0,revenue_29 = 0,revenue_30 = 0
    ,revenue_31 = 0;
    DateFormat inputFormat = DateFormat('hh:mm:ss dd/MM/yyyy');
    await _services.users.get().then((value) async {
      for(var data1 in value.docs){
        await _services.users.doc(data1.id).collection("purchase history").where("orderStatus", isEqualTo: "Đã nhận hàng")
            .get().then((value) {
          for(var data2 in value.docs){
            if(inputFormat.parse(data2.data()["orderDate"]).year == year) {
              switch (inputFormat.parse(data2.data()["orderDate"]).month) {
                case 1: revenue_1 += data2.data()["total"] as int;break;
                case 2: revenue_2 += data2.data()["total"] as int;break;
                case 3: revenue_3 += data2.data()["total"] as int;break;
                case 4: revenue_4 += data2.data()["total"] as int;break;
                case 5: revenue_5 += data2.data()["total"] as int;break;
                case 6: revenue_6 += data2.data()["total"] as int;break;
                case 7: revenue_7 += data2.data()["total"] as int;break;
                case 8: revenue_8 += data2.data()["total"] as int;break;
                case 9: revenue_9 += data2.data()["total"] as int;break;
                case 10: revenue_10 += data2.data()["total"] as int;break;
                case 11: revenue_11 += data2.data()["total"] as int;break;
                case 12: revenue_12 += data2.data()["total"] as int;break;
                case 13: revenue_13 += data2.data()["total"] as int;break;
                case 14: revenue_14 += data2.data()["total"] as int;break;
                case 15: revenue_15 += data2.data()["total"] as int;break;
                case 16: revenue_16 += data2.data()["total"] as int;break;
                case 17: revenue_17 += data2.data()["total"] as int;break;
                case 18: revenue_18 += data2.data()["total"] as int;break;
                case 19: revenue_19 += data2.data()["total"] as int;break;
                case 20: revenue_20 += data2.data()["total"] as int;break;
                case 21: revenue_21 += data2.data()["total"] as int;break;
                case 22: revenue_22 += data2.data()["total"] as int;break;
                case 23: revenue_23 += data2.data()["total"] as int;break;
                case 24: revenue_24 += data2.data()["total"] as int;break;
                case 25: revenue_25 += data2.data()["total"] as int;break;
                case 26: revenue_26 += data2.data()["total"] as int;break;
                case 27: revenue_27 += data2.data()["total"] as int;break;
                case 28: revenue_28 += data2.data()["total"] as int;break;
                case 29: revenue_29 += data2.data()["total"] as int;break;
                case 30: revenue_30 += data2.data()["total"] as int;break;
                default: revenue_31 += data2.data()["total"] as int;break;
              }
            }
          }
        });
      }
    });
    setState(() {
      spots =  [
        FlSpot(0, revenue_1/1000000),
        FlSpot(5, revenue_2/1000000),
        FlSpot(10, revenue_3/1000000),
        FlSpot(15, revenue_4/1000000),
        FlSpot(20, revenue_5/1000000),
        FlSpot(25, revenue_6/1000000),
        FlSpot(30, revenue_7/1000000),
        FlSpot(35, revenue_8/1000000),
        FlSpot(40, revenue_9/1000000),
        FlSpot(45, revenue_10/1000000),
        FlSpot(50, revenue_11/1000000),
        FlSpot(55, revenue_12/1000000),
        FlSpot(60, revenue_13/1000000),
        FlSpot(65, revenue_14/1000000),
        FlSpot(70, revenue_15/1000000),
        FlSpot(75, revenue_16/1000000),
        FlSpot(80, revenue_17/1000000),
        FlSpot(85, revenue_18/1000000),
        FlSpot(90, revenue_19/1000000),
        FlSpot(95, revenue_20/1000000),
        FlSpot(100, revenue_21/1000000),
        FlSpot(105, revenue_22/1000000),
        FlSpot(110, revenue_23/1000000),
        FlSpot(115, revenue_24/1000000),
        FlSpot(120, revenue_25/1000000),
        FlSpot(125, revenue_26/1000000),
        FlSpot(130, revenue_27/1000000),
        FlSpot(135, revenue_28/1000000),
        FlSpot(140, revenue_29/1000000),
        FlSpot(145, revenue_30/1000000),
        FlSpot(150, revenue_31/1000000),
      ];
    });
  }


  @override
  Widget build(BuildContext context) {
    if(tag == 0){
      queryRevenueByYear();
    }else if(tag == 1){
      queryRevenueByMonth();
    }else {
      queryRevenueByDay();
    }
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thống kê doanh thu",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: ShapeDecoration(
                shadows: [
                  const BoxShadow(color: Colors.grey)
                ],
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) {
                    setState(() {
                      tag = val;
                    });
                  },
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              shadowColor: Colors.grey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  children: [
                    tag == 0
                    ?const Text(
                      "Hằng năm",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    )
                    :tag == 1
                    ?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Năm ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                            width: 120,
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton(
                                alignment: Alignment.center,
                                value: year,
                                items: const [ //add items in the dropdown
                                  DropdownMenuItem(
                                    value: 2023,
                                    child: Text("2023",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26,
                                      ),),
                                  ),
                                  DropdownMenuItem(
                                    value: 2022,
                                    child: Text("2022",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26,
                                      ),),
                                  ),
                                  DropdownMenuItem(
                                      value: 2021,
                                      child: Text("2021",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 26,
                                        ),)
                                  ),
                                ],
                                onChanged: (int? value) {
                                  setState(() {
                                    year = value!;
                                  });
                                },
                                isExpanded: true,
                              ),
                            )
                        ),
                      ],
                    )
                    :Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Tháng ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        MaterialButton(
                            onPressed: (){
                              _showTimeDialog(_pickerYear, _selectedMonth);
                            },
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                _selectedMonth.month.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AspectRatio(
                      aspectRatio: 16/6,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                          ),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 1,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if(tag == 0){
                                    return bottomTitle_Year[value.toInt()] != null
                                        ? SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10,
                                      child: Text(
                                          bottomTitle_Year[value.toInt()].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    )
                                        : const SizedBox();
                                  }
                                  else if(tag == 1){
                                    return bottomTitle_Month[value.toInt()] != null
                                        ? SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10,
                                      child: Text(
                                          bottomTitle_Month[value.toInt()].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    )
                                        : const SizedBox();
                                  }
                                  else {
                                    return bottomTitle_Day[value.toInt()] != null
                                        ? SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10,
                                      child: Text(
                                          bottomTitle_Day[value.toInt()].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    )
                                        : const SizedBox();
                                  }
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: Text("Triệu đồng"),
                              ),
                              axisNameSize: 30,
                              sideTitles: SideTitles(
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if(tag == 2){
                                    return leftTitle_Day[value.toInt()] != null
                                        ? Text(
                                        leftTitle_Day[value.toInt()].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey))
                                        : const SizedBox();
                                  }
                                  else {
                                    return leftTitle[value.toInt()] != null
                                        ? Text(
                                        leftTitle[value.toInt()].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey))
                                        : const SizedBox();
                                  }
                                },
                                showTitles: true,
                                interval: 10,
                                reservedSize: 40,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                                isCurved: true,
                                curveSmoothness: 0,
                                color: Theme.of(context).primaryColor,
                                barWidth: 2.5,
                                isStrokeCapRound: false,
                                belowBarData: BarAreaData(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).primaryColor.withOpacity(0.5),
                                      Colors.transparent
                                    ],
                                  ),
                                  show: true,
                                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                                ),
                                dotData: FlDotData(show: true),
                                spots: spots)
                          ],
                          minX: 0,
                          maxX: tag == 2? 150 : 570,
                          maxY: tag == 2? 150 : 500,
                          minY: 0,
                        ),
                        swapAnimationDuration: const Duration(milliseconds: 250),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;

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


  _showTimeDialog(int pickerYear, DateTime selectedMonth){
    showDialog(
        context: context,
        builder: (_) => Dialog(
          child: SizedBox(
            height: MediaQuery.of(context).size.height/2.5,
            width: MediaQuery.of(context).size.width /3,
            child: Scaffold(
              body: Column(
                children: [
                  Material(
                    color: Theme.of(context).cardColor,
                    child: AnimatedSize(
                      curve: Curves.easeInOut,
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
                                      pickerYear = pickerYear - 1;
                                      Navigator.pop(context);
                                      _showTimeDialog(pickerYear, selectedMonth);
                                    });
                                  },
                                  icon: const Icon(Icons.navigate_before_rounded),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      pickerYear.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pickerYear = pickerYear + 1;
                                      Navigator.pop(context);
                                      _showTimeDialog(pickerYear, selectedMonth);
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
                  Text(DateFormat.yMMMM().format(selectedMonth)),
                  const SizedBox(
                    height: 5.0,
                  ),
                  ElevatedButton(
                    onPressed: (){
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
            ),
          ),
        ));
  }
}