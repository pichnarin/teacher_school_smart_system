import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, late }

class StudentAttendanceCard extends StatelessWidget {
  final String fullName;
  final String studentId;
  final AttendanceStatus? selectedStatus;
  final void Function(AttendanceStatus?) onStatusChanged; // ✅ allows null
  final bool isGrid;
  final Widget? leading;
  final Widget? trailing;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const StudentAttendanceCard({
    super.key,
    required this.fullName,
    required this.studentId,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.isGrid = false,
    this.leading,
    this.trailing,
    this.elevation,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 360;

    final avatarWidget = leading ?? _buildAvatar(theme);

    final nameWidget = Text(
      fullName,
      style: const TextStyle(fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
      maxLines: isGrid ? 2 : 1,
      textAlign: isGrid ? TextAlign.center : TextAlign.start,
    );

    final buttonsWidget = _buildAttendanceButtons(isSmallScreen);

    final cardPadding =
        padding ??
        (isGrid
            ? const EdgeInsets.all(12)
            : EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 6 : 8,
            ));

    final finalBorderRadius =
        borderRadius ?? BorderRadius.circular(isGrid ? 16 : 12);

    if (isGrid) {
      return Card(
        elevation: elevation ?? 1,
        shape: RoundedRectangleBorder(borderRadius: finalBorderRadius),
        child: Padding(
          padding: cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              avatarWidget,
              const SizedBox(height: 8),
              nameWidget,
              if (studentId.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildStudentIdBadge(theme),
              ],
              const SizedBox(height: 12),
              buttonsWidget,
              if (trailing != null) ...[const SizedBox(height: 8), trailing!],
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: elevation ?? 1,
        shape: RoundedRectangleBorder(borderRadius: finalBorderRadius),
        child: Padding(
          padding: cardPadding,
          child: Row(
            children: [
              avatarWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nameWidget,
                    const SizedBox(height: 4),
                    _buildStudentIdBadge(theme),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              buttonsWidget,
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      );
    }
  }

  Widget _buildAvatar(ColorScheme theme) {
    final nameParts = fullName.split(' ');
    final initials =
        nameParts.length >= 2
            ? nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase()
            : fullName.isNotEmpty
            ? fullName[0].toUpperCase()
            : '?';

    return CircleAvatar(
      radius: isGrid ? 28 : 24,
      backgroundColor: theme.primary.withOpacity(0.1),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: isGrid ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: theme.primary,
        ),
      ),
    );
  }

  Widget _buildStudentIdBadge(ColorScheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "ID: $studentId",
        style: TextStyle(
          fontSize: 11,
          color: theme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAttendanceButtons(bool isSmallScreen) {
    final Map<AttendanceStatus, IconData> statusIcons = {
      AttendanceStatus.present: Icons.check_circle,
      AttendanceStatus.absent: Icons.cancel,
      AttendanceStatus.late: Icons.access_time,
    };

    final Map<AttendanceStatus, String> statusLabels = {
      AttendanceStatus.present: 'P',
      AttendanceStatus.absent: 'A',
      AttendanceStatus.late: 'L',
    };

    return Wrap(
      alignment: isGrid ? WrapAlignment.center : WrapAlignment.start,
      spacing: 8,
      children:
          AttendanceStatus.values.map((status) {
            final isSelected = selectedStatus == status;

            return ChoiceChip(
              label:
                  isSmallScreen
                      ? Icon(
                        statusIcons[status],
                        size: 16,
                        color: isSelected ? Colors.white : _statusColor(status),
                      )
                      : Text(statusLabels[status] ?? '?'),
              selected: isSelected,
              selectedColor: _statusColor(status),
              onSelected: (_) {
                // ✅ Toggle selection (allow deselect)
                if (isSelected) {
                  onStatusChanged(null);
                } else {
                  onStatusChanged(status);
                }
              },
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 4 : 8,
                vertical: 0,
              ),
            );
          }).toList(),
    );
  }

  Color _statusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.orange;
    }
  }
}
