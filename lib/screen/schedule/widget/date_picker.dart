import'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    this.itemWidth = 80.0,
    this.height = 100.0,
    this.initialDate,
  });

  @override
  GestureDatePickerState createState() =>
      GestureDatePickerState();
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

    // Defer scrolling until after layout
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

    // Calculate position to center the date in the viewport
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

  // Inside _InfiniteGestureDatePickerState class
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayIndex = today.difference(startDate).inDays;
    _viewportWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Remove the automatic snapping behavior
              // Let the scroll position stay where the user left it
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
                  child: Container(
                    width: widget.itemWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                      isSelected
                          ? widget.selectedDateColor ??
                          theme.colorScheme.primary.withOpacity(0.2)
                          : Colors.transparent,
                      border:
                      isToday
                          ? Border.all(
                        color:
                        widget.todayHighlightColor ??
                            theme.colorScheme.primary,
                      )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            isSelected ? theme.colorScheme.primary : null,
                          ),
                        ),
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color:
                            isSelected ? theme.colorScheme.primary : null,
                          ),
                        ),
                        Text(
                          DateFormat('E').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            isSelected ? theme.colorScheme.primary : null,
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

        // Improved navigation controls
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  // Only change selection when button is pressed
                  _selectIndex(selectedIndex - 1);
                },
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              TextButton.icon(
                onPressed: jumpToToday,
                icon: const Icon(Icons.today, size: 16),
                label: const Text('Today'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // Only change selection when button is pressed
                  _selectIndex(selectedIndex + 1);
                },
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final controller = DatePickerController();

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Infinite Gesture Date Picker')),
        body: Center(
          child: GestureDatePicker(
            controller: controller,
            onDateSelected: (date) {
              final formattedDate = DateFormat('yyyy-MM-dd').format(date);
              print('Selected date: $formattedDate');

              // Load data for this date
              // context.read<ClassBloc>().add(FetchClassesByDate(formattedDate));
            },
          ),
        ),
      ),
    ),
  );
}
