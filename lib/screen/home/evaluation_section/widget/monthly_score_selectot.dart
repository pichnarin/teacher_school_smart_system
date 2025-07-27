import 'package:flutter/material.dart';

class MonthlySelector extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<Map<String, String>> onMonthSelected;

  const MonthlySelector({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final monthNum = index + 1;
          final isSelected = monthNum == selectedMonth;
          return GestureDetector(
            onTap: () {
              onMonthSelected({
                'exam_month': monthNum.toString().padLeft(2, '0'),
                'exam_year': selectedYear.toString(),
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                months[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MonthlySelectorWithToday extends StatefulWidget {
  final ValueChanged<Map<String, String>> onMonthSelected;

  const MonthlySelectorWithToday({
    super.key,
    required this.onMonthSelected,
  });

  @override
  State<MonthlySelectorWithToday> createState() => _MonthlySelectorWithTodayState();
}

class _MonthlySelectorWithTodayState extends State<MonthlySelectorWithToday> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  void selectToday() {
    setState(() {
      selectedMonth = DateTime.now().month;
      selectedYear = DateTime.now().year;
    });
    widget.onMonthSelected({
      'exam_month': selectedMonth.toString().padLeft(2, '0'),
      'exam_year': selectedYear.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: selectToday,
          child: const Text('Select Today'),
        ),
        MonthlySelector(
          selectedMonth: selectedMonth,
          selectedYear: selectedYear,
          onMonthSelected: (selected) {
            setState(() {
              selectedMonth = int.parse(selected['exam_month']!);
              selectedYear = int.parse(selected['exam_year']!);
            });
            widget.onMonthSelected(selected);
          },
        ),
      ],
    );
  }
}

// Use this in your main:
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Monthly Selector')),
      body: Center(
        child: MonthlySelectorWithToday(
          onMonthSelected: (selected) {
            print('Selected Month: ${selected['exam_month']}, Year: ${selected['exam_year']}');
          },
        ),
      ),
    ),
  ));
}