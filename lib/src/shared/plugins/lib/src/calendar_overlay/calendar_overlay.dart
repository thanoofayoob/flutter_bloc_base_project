import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/calendar_overlay/widgets/year_picker.dart';
import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/utils/utils.dart';
import 'calendar_overlay_controller.dart';
import 'package:flutter/material.dart';

import 'widgets/day_picker.dart';
import 'widgets/month_picker.dart';

enum CalendarMode {
  day,
  month,
  year,
}

// extension DateTimeFormat on DateTime {
//   String locale(BuildContext context) =>
//       Localizations.localeOf(context).languageCode;

//   String monthFormat(BuildContext context) {
//     final _monthformat = DateFormat('MMMM', locale(context));
//     return _monthformat.format(this);
//   }

//   String calendarFormat(BuildContext context) {
//     final _calendar = DateFormat('MMM, y', locale(context));
//     return _calendar.format(this);
//   }

//   String yearFormat(BuildContext context) {
//     final _yearFormat = DateFormat.y(locale(context));
//     return _yearFormat.format(this);
//   }

//   bool isInTheSameDay(DateTime other) =>
//       year == other.year && month == other.month && day == other.day;

//   bool get isToday {
//     final other = DateTime.now();
//     return year == other.year && month == other.month && day == other.day;
//   }
// }

class CalendarOverlay extends StatefulWidget {
  final DateTime? date;
  final CalendarMode mode;
  const CalendarOverlay({Key? key, this.date, required this.mode})
      : super(key: key);

  @override
  State<CalendarOverlay> createState() => _CalendarOverlayState();
}

ValueNotifier<String> title = ValueNotifier('');
DateTime selectedDate = DateTime.now();

ValueNotifier<CalendarMode> calendarMode = ValueNotifier(CalendarMode.day);

ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());

late CalendarMode returnMode;

final years = <int>[];

class _CalendarOverlayState extends State<CalendarOverlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.date != null) {
      selectedDate = widget.date!;
      currentDate.value = widget.date!;
    }
    returnMode = widget.mode;
    calendarMode.value = widget.mode;

    years.addAll(List.generate(100, (index) => index));
    onDate(currentDate.value);
    calendarMode.addListener;
    super.didChangeDependencies();
  }

  void onCalendar(mode) => onDate(currentDate.value);

  void onDate(DateTime date) {
    if (calendarMode.value == CalendarMode.day) {
      title.value = currentDate.value.calendarFormat(context);
    } else if (calendarMode.value == CalendarMode.month) {
      title.value = currentDate.value.yearFormat(context);
    }
  }

  void onTapTitle() {
    if (calendarMode.value == CalendarMode.day) {
      calendarMode.value = CalendarMode.month;
    } else if (calendarMode.value == CalendarMode.month) {
      calendarMode.value = CalendarMode.year;
    }
  }

  void next() {
    if (calendarMode.value == CalendarMode.month) {
      currentDate.value = currentDate.value.copyWith(
        year: currentDate.value.year + 1,
      );
    } else {
      currentDate.value = currentDate.value.copyWith(
        month: currentDate.value.month + 1,
      );
    }
    title.value = currentDate.value.calendarFormat(context);
  }

  void back() {
    if (calendarMode.value == CalendarMode.month) {
      currentDate.value = currentDate.value.copyWith(
        year: currentDate.value.year - 1,
      );
    } else {
      currentDate.value = currentDate.value.copyWith(
        month: currentDate.value.month - 1,
      );
    }
    title.value = currentDate.value.calendarFormat(context);
  }

  void onTapDay(DateTime day) {
    Navigator.pop(
      context,
      DateTime(
        day.year,
        day.month,
        day.day,
        selectedDate.hour,
        selectedDate.minute,
        selectedDate.second,
        selectedDate.minute,
      ),
    );
  }

  void onTapMonth(int month) {
    final date = currentDate.value.copyWith(month: month);
    if (returnMode == CalendarMode.month) {
      Navigator.pop(context);
      return;
    }
    currentDate.value = date;
    // currentDate.refresh();
    calendarMode.value = CalendarMode.day;
  }

  void onTapYear(int year) {
    final date = currentDate.value.copyWith(year: year);
    if (returnMode == CalendarMode.year) {
      Navigator.pop(context);
      return;
    }
    currentDate.value = date;
    // currentDate.refresh();

    calendarMode.value = CalendarMode.month;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: radius8,
          topRight: radius8,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: radius8,
              topRight: radius8,
            ),
          ),
          constraints: BoxConstraints(minHeight: context.h * .5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CupertinoButton(
              //         padding: zero,
              //         child: const Icon(Icons.close),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         }),
              //     Text(
              //       'Calendar',
              //       style: context.h6,
              //     ),
              //     CupertinoButton(
              //       padding: zero,
              //       onPressed: () {},
              //       child: Text('Today'),
              //     ).paddingOnly(right: 6.0),
              //   ],
              // ).paddingSymmetric(horizontal: 6.0),

              SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                  valueListenable: calendarMode,
                  builder: (ctx, calendarMode, _) {
                    if (calendarMode == CalendarMode.year ||
                        calendarMode == CalendarMode.month) {
                      return emptyWidget;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: zero,
                          child: const Icon(Icons.arrow_back_ios),
                          onPressed: back,
                        ),
                        ValueListenableBuilder(
                            valueListenable: title,
                            builder: (ctx, title, _) {
                              return InkWell(
                                onTap: onTapTitle,
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: context.s1,
                                ),
                              );
                            }),
                        CupertinoButton(
                          padding: zero,
                          child: const Icon(Icons.arrow_forward_ios),
                          onPressed: next,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 6.0);
                  }),
              ValueListenableBuilder(
                  valueListenable: calendarMode,
                  builder: (ctx, calendarMode, _) {
                    if (calendarMode == CalendarMode.day) {
                      return DayWidget(
                        dateTime: currentDate,
                        onTap: (val) {
                          onTapDay(val);
                        },
                      );
                    } else {
                      return MonthWidget(
                        datetime: currentDate,
                        years: years,
                        onTapYear: (val) {
                          onTapYear(val);
                        },
                        onTapMonth: (val) {
                          onTapMonth(val);
                        },
                      );
                    }

                    //  switch (calendarMode) {
                    //   CalendarMode.day => DayWidget(
                    //       dateTime: currentDate,
                    //       onTap: (val) {
                    //         onTapDay(val);
                    //       },
                    //     ),
                    //   CalendarMode.month => MonthWidget(
                    //       datetime: currentDate,
                    //       years: years,
                    //       onTapYear: (val) {
                    //         onTapYear(val);
                    //       },
                    //       onTapMonth: (val) {
                    //         onTapMonth(val);
                    //       },
                    //     ),
                    //   CalendarMode.year => YearWidget(
                    //       years: years,
                    //       datetime: currentDate,
                    //       onTapYear: (val) {
                    //         onTapYear(val);
                    //       },
                    //     ),
                  })
            ],
          ),
        ),
      ),
    );
  }
}
