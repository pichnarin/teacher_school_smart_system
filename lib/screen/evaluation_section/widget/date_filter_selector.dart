import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'month_button.dart';

class DateFilterSelector extends StatelessWidget {
  final List<String> months;
  final List<int> years;
  final int selectedMonth;
  final int selectedYear;
  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;

  const DateFilterSelector({
    super.key,
    required this.months,
    required this.years,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final monthNum = index + 1;
                final isSelected = monthNum == selectedMonth;
                return MonthButton(
                  month: months[index],
                  isSelected: isSelected,
                  onPressed: () => onMonthChanged(monthNum),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: selectedYear,
          style: Theme.of(context).textTheme.titleMedium,
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          items:
          years
              .map(
                (y) =>
                DropdownMenuItem(value: y, child: Text(y.toString())),
          )
              .toList(),
          onChanged: (y) {
            if (y != null) {
              onYearChanged(y);
            }
          },
        ),
      ],
    );
  }
}