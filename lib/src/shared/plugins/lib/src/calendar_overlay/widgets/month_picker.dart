import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/calendar_overlay/widgets/year_picker.dart';
import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/utils/utils.dart';

import '../calendar_overlay_controller.dart';

class MonthWidget extends StatefulWidget {
  ValueNotifier<DateTime> datetime;
  Function(int) onTapMonth;
  List<int> years;
  Function(int) onTapYear;

  MonthWidget({
    Key? key,
    required this.datetime,
    required this.onTapMonth,
    required this.years,
    required this.onTapYear,
  }) : super(key: key);

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Month',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        GridView.count(
          crossAxisCount: 5,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          childAspectRatio: 16 / 6,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          shrinkWrap: true,
          children: List.generate(
            12,
            (idx) {
              final date = DateTime(
                widget.datetime.value.year,
                idx + 1,
              );
              final isSelected = widget.datetime.value.month == idx + 1;
              return CupertinoButton(
                onPressed: () => widget.onTapMonth(idx + 1),
                padding: EdgeInsets.zero,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Palette.gray5,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    date.monthFormat(context).substring(0, 3),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        YearWidget(
            datetime: widget.datetime,
            years: widget.years,
            onTapYear: widget.onTapYear)
      ],
    ).paddingSymmetric(horizontal: 6);
  }
}
