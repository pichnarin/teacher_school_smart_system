import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum KhmerMonth {
  Jan('មករា'),
  Feb('កម្ភៈ'),
  Mar('មិនា'),
  Apr('មេសា'),
  May('ឧសភា'),
  Jun('មិថុនា'),
  Jul('កក្កដា'),
  Aug('សីហា'),
  Sep('កញ្ញា'),
  Oct('តុលា'),
  Nov('វិច្ឆិកា'),
  Dec('ធ្នូ');

  final String khmer;
  const KhmerMonth(this.khmer);

  static String fromShortName(String shortName) {
    switch (shortName.toLowerCase()) {
      case 'jan':
        return KhmerMonth.Jan.khmer;
      case 'feb':
        return KhmerMonth.Feb.khmer;
      case 'mar':
        return KhmerMonth.Mar.khmer;
      case 'apr':
        return KhmerMonth.Apr.khmer;
      case 'may':
        return KhmerMonth.May.khmer;
      case 'jun':
        return KhmerMonth.Jun.khmer;
      case 'jul':
        return KhmerMonth.Jul.khmer;
      case 'aug':
        return KhmerMonth.Aug.khmer;
      case 'sep':
        return KhmerMonth.Sep.khmer;
      case 'oct':
        return KhmerMonth.Oct.khmer;
      case 'nov':
        return KhmerMonth.Nov.khmer;
      case 'dec':
        return KhmerMonth.Dec.khmer;
      default:
        return shortName; // fallback: original
    }
  }
}

enum KhmerWeekday {
  Mon('ច័ន្ទ'),
  Tue('អង្គារ'),
  Wed('ពុធ'),
  Thu('ព្រហស្បតិ៍'),
  Fri('សុក្រ'),
  Sat('សៅរ៍'),
  Sun('អាទិត្យ');

  final String khmer;
  const KhmerWeekday(this.khmer);

  static String fromShortName(String shortName) {
    switch (shortName.toLowerCase()) {
      case 'mon':
        return KhmerWeekday.Mon.khmer;
      case 'tue':
        return KhmerWeekday.Tue.khmer;
      case 'wed':
        return KhmerWeekday.Wed.khmer;
      case 'thu':
        return KhmerWeekday.Thu.khmer;
      case 'fri':
        return KhmerWeekday.Fri.khmer;
      case 'sat':
        return KhmerWeekday.Sat.khmer;
      case 'sun':
        return KhmerWeekday.Sun.khmer;
      default:
        return shortName; // fallback: original
    }
  }
}




class DatePickerController {
  GestureDatePickerState? _state;

  void setDate(DateTime date) {
    _state?.selectDate(date);
  }

  void jumpToToday() {
    _state?.jumpToToday();
  }

  String? formatDate([String pattern = 'yyyy-MM-dd']) {
    final date = _state?.selectedDate;
    return date != null ? DateFormat(pattern).format(date) : null;
  }

  DateTime? get selectedDate => _state?.selectedDate;
}

class GestureDatePicker extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  final DatePickerController? controller;
  final Color? selectedDateColor;
  final Color? todayHighlightColor;
  final double itemWidth;
  final double height;
  final DateTime? initialDate;

  const GestureDatePicker({
    super.key,
    this.onDateSelected,
    this.controller,
    this.selectedDateColor,
    this.todayHighlightColor,
    this.itemWidth = 85.0,
    this.height = 120.0,
    this.initialDate,
  });

  @override
  GestureDatePickerState createState() => GestureDatePickerState();
}

class GestureDatePickerState extends State<GestureDatePicker> {
  late ScrollController _scrollController;
  final int totalItems = 100000;
  late int centerIndex;
  late int selectedIndex;
  late DateTime selectedDate;
  final DateTime startDate = DateTime(2000, 1, 1);
  late double _viewportWidth;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!._state = this;
    }

    final today = DateTime.now();
    final initialDate = widget.initialDate ?? today;

    final daysFromStart = initialDate.difference(startDate).inDays;
    centerIndex = daysFromStart;
    selectedIndex = centerIndex;
    selectedDate = initialDate;

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewportWidth = MediaQuery.of(context).size.width;
        _scrollToIndex(selectedIndex, animate: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.controller != null) {
      widget.controller!._state = null;
    }
    super.dispose();
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final offset =
        widget.itemWidth * index -
        (_viewportWidth / 2) +
        (widget.itemWidth / 2);

    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  DateTime getDateFromIndex(int index) {
    return startDate.add(Duration(days: index));
  }

  void selectDate(DateTime date) {
    final index = date.difference(startDate).inDays;
    _selectIndex(index);
  }

  void jumpToToday() {
    selectDate(DateTime.now());
  }

  void _selectIndex(int index) {
    if (index < 0 || index >= totalItems) return;

    setState(() {
      selectedIndex = index;
      selectedDate = getDateFromIndex(index);
    });

    if (widget.onDateSelected != null) {
      widget.onDateSelected!(selectedDate);
    }

    _scrollToIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayIndex = today.difference(startDate).inDays;
    _viewportWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ជ្រើសរើសកាលបរិច្ឆេទ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${KhmerMonth.fromShortName(DateFormat('MMM').format(selectedDate))} ${DateFormat('yyyy').format(selectedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                ),
              ],
            ),

            const SizedBox(height: 16),

            // Enhanced date picker
            Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: totalItems,
                  physics: const BouncingScrollPhysics(),
                  itemExtent: widget.itemWidth,
                  itemBuilder: (context, index) {
                    final date = getDateFromIndex(index);
                    final isSelected = index == selectedIndex;
                    final isToday = index == todayIndex;

                    return GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        _selectIndex(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: widget.itemWidth,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              isSelected
                                  ? LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primary.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                  : null,
                          color:
                              isSelected
                                  ? null
                                  : isToday
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  )
                                  : Colors.white,
                          border:
                              isToday && !isSelected
                                  ? Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                  : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //DateFormat('MMM').format(date).toUpperCase(),
                              KhmerMonth.fromShortName(DateFormat('MMM').format(date)),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : isToday
                                    ? theme.colorScheme.primary
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('d').format(date),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : isToday
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              //DateFormat('E').format(date).toUpperCase(),
                              KhmerWeekday.fromShortName(DateFormat('E').format(date)),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : isToday
                                    ? theme.colorScheme.primary
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Enhanced navigation controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _selectIndex(selectedIndex - 1),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: jumpToToday,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.today,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _selectIndex(selectedIndex + 1),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final controller = DatePickerController();

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Enhanced Date Picker')),
        body: Center(
          child: GestureDatePicker(
            controller: controller,
            onDateSelected: (date) {
              final formattedDate = DateFormat('yyyy-MM-dd').format(date);
            },
          ),
        ),
      ),
    ),
  );
}
