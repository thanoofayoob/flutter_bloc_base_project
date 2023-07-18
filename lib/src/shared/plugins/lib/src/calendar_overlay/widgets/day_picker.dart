import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/utils/utils.dart';

import '../calendar_overlay.dart';
import '../calendar_overlay_controller.dart';

// ignore: must_be_immutable
class DayWidget extends StatefulWidget {
  ValueNotifier<DateTime> dateTime;
  // ValueNotifier<CalendarMode> calendarMode;
  Function(DateTime) onTap;

  DayWidget({
    Key? key,
    required this.dateTime,
    // required this.calendarMode,
    required this.onTap,
  }) : super(key: key);

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.dateTime,
      builder: (ctx, value, _) {
        const startDay = DateTime.sunday;

        final date = widget.dateTime.value;
        final firstDay = DateTime(date.year, date.month);

        final daysMonth = DateUtils.getDaysInMonth(date.year, date.month);
        final lastDay = DateTime(date.year, date.month, daysMonth);

        int prefixOffset;

        if (firstDay.weekday == 7) {
          prefixOffset = 0;
        } else {
          prefixOffset = (startDay - firstDay.weekday - 7).abs();
        }

        int suffixOffset;

        if (lastDay.weekday == 7) {
          suffixOffset = 6;
        } else {
          suffixOffset = DateTime.saturday - lastDay.weekday;
        }

        int total = daysMonth + suffixOffset + prefixOffset;

        final selected = widget.dateTime;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                DateTime.daysPerWeek,
                (index) => Expanded(
                  flex: 1,
                  child: Text(
                    DateTime(
                      date.year,
                      date.month,
                      ((index + 1) - prefixOffset),
                    ).weekdayFormat(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Palette.gray3,
                    ),
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 0.0),
            GridView.count(
              crossAxisCount: DateTime.daysPerWeek,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              children: List.generate(
                total,
                (idx) {
                  final day = DateTime(
                    date.year,
                    date.month,
                    ((idx + 1) - prefixOffset),
                  );
                  Color color = Palette.gray6;
                  final isNotInTheMonth =
                      day.isBefore(firstDay) || day.isAfter(lastDay);
                  if (isNotInTheMonth) {
                    color = Palette.gray4;
                  }
                  final isToday = day.isToday;
                  if (isToday) {
                    color = Colors.white;
                  }
                  final isSelected = selected.value.isInTheSameDay(day);

                  if (isSelected) {
                    color = Theme.of(context).primaryColor;
                  }

                  Color textColor;

                  if (isNotInTheMonth) {
                    textColor = Palette.gray2;
                    if (isSelected) {
                      textColor = Colors.white;
                    }
                  } else {
                    if (day.weekday > DateTime.friday) {
                      textColor = context.theme.primaryColor;
                    } else {
                      textColor = Colors.black;
                    }
                    if (isSelected) {
                      textColor = Colors.white;
                    }
                  }

                  return CupertinoButton(
                    onPressed: () => widget.onTap(day),
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        border: isToday && !isSelected
                            ? Border.all(color: context.theme.primaryColor)
                            : null,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ).paddingSymmetric(horizontal: 6.0),
          ],
        );
      },
    );
  }
}