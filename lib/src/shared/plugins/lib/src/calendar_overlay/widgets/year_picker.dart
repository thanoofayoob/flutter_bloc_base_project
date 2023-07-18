import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/utils/utils.dart';

// ignore: must_be_immutable
class YearWidget extends StatefulWidget {
  ValueNotifier<DateTime> datetime;
  List<int> years;
  Function(int) onTapYear;

  YearWidget({
    Key? key,
    required this.datetime,
    required this.years,
    required this.onTapYear,
  }) : super(key: key);

  @override
  State<YearWidget> createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  ScrollController _scrollController = ScrollController();
  PageController _pageController = PageController();
  final int yearsPerPage = 10;
  final int totalYears = 100;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      constraints: BoxConstraints(maxHeight: context.h * .2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                padding: zero,
                child: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 1),
                      curve: Curves.bounceIn);
                },
              ),
              Text(
                'Year',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: context.s1,
              ),
              CupertinoButton(
                padding: zero,
                child: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 1),
                      curve: Curves.bounceIn);
                },
              ),
            ],
          ),

          Expanded(
            child: PageView.builder(
                controller: _pageController,
                itemCount: (widget.years.length / yearsPerPage).ceil(),
                itemBuilder: (ctx, index) {
                  print(index);

                  List<int> buildingData = [];

                  buildingData.addAll(List.generate(15, (index) => index));

                  print(buildingData);

                  return GridView.count(
                    crossAxisCount: 5,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    childAspectRatio: 16 / 6,
                    scrollDirection: Axis.vertical,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    children: buildingData.map((index) {
                      final year = (now.year + 10) - index;
                      final isSelected = year == widget.datetime.value.year;
                      return CupertinoButton(
                        onPressed: () => widget.onTapYear(year),
                        padding: EdgeInsets.zero,
                        child: Container(
                          // height: 20,
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
                            '$year',
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          )

          // GridView.count(
          //   crossAxisCount: 5,

          //   physics: const AlwaysScrollableScrollPhysics(),
          //   controller: _scrollController,
          //   padding: EdgeInsets.zero,
          //   childAspectRatio: 16 / 6,
          //   scrollDirection: Axis.vertical,
          //   mainAxisSpacing: 10,
          //   crossAxisSpacing: 10,
          //   shrinkWrap: true,
          //   // reverse: true,
          //   children: widget.years.map(
          //     (idx) {
          //       final year = (now.year + 10) - idx;
          //       final isSelected = year == widget.datetime.value.year;
          //       return CupertinoButton(
          //         onPressed: () => widget.onTapYear(year),
          //         padding: EdgeInsets.zero,
          //         child: Container(
          //           height: 20,
          //           // constraints: const BoxConstraints.expand(),
          //           decoration: BoxDecoration(
          //             color: isSelected
          //                 ? Theme.of(context).primaryColor
          //                 : Palette.gray5,
          //             borderRadius: const BorderRadius.all(
          //               Radius.circular(4.0),
          //             ),
          //           ),
          //           alignment: Alignment.center,
          //           padding: const EdgeInsets.all(4.0),
          //           child: Text(
          //             '$year',
          //             style: TextStyle(
          //               fontSize: 14,
          //               color: isSelected ? Colors.white : Colors.black,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       );
          //     },
          //   ).toList(),
          // ).paddingSymmetric(horizontal: 6.0),
        ],
      ),
    );
  }
}
