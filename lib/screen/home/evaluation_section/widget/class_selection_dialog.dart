// class_selection_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/class/class_bloc.dart';
import '../../../../bloc/class/class_event.dart';
import '../../../../bloc/class/class_state.dart';
import '../../../../data/model/class.dart';

class ClassSelectionDialog extends StatelessWidget {
  final Function(Class selectedClass) onSelected;

  const ClassSelectionDialog({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('សូមជ្រើសរើសថ្នាក់បង្រៀន សម្រាប់ការបន្តសកម្មភាព'),
      content: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          if (state.status == ClassStatus.loading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state.status == ClassStatus.loaded) {
            final classes = state.classes ?? [];
            if (classes.isEmpty) {
              return const SizedBox(
                width: 300,
                child: Text('អ្នកមិនមានថ្នាក់បង្រៀនសម្រាប់ការប្រឡងទេ សូមធ្វើការកំណត់ថ្នាក់មុនពេលបញ្ចូលពិន្ទុ។'),
              );
            }
            return _ClassList(
              classes: classes,
              onSelected: (selectedClass) {
                Navigator.pop(context);
                onSelected(selectedClass);
              },
            );
          } else if (state.status == ClassStatus.error) {
            return SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.errorMessage ?? 'Unknown error'}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ClassBloc>().add(const FetchClasses());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _ClassList extends StatefulWidget {
  final List<Class> classes;
  final Function(Class selectedClass) onSelected;

  const _ClassList({required this.classes, required this.onSelected});

  @override
  State<_ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<_ClassList> {
  Class? selectedClass;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 450,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: widget.classes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final classItem = widget.classes[index];
                return RadioListTile<Class>(
                  value: classItem,
                  groupValue: selectedClass,
                  onChanged: (Class? value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                  title: Text(
                    '${classItem.subject.subjectName.toUpperCase()}}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('បញ្ឈប់'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: selectedClass != null
                    ? () => widget.onSelected(selectedClass!)
                    : null,
                child: const Text('បន្ត'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
