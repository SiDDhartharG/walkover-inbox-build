import 'package:flutter/material.dart';
import 'package:inbox/constants/styling.dart';

class SnoozeCommonModel extends StatefulWidget {
  final String selectedMailId;
  dynamic updateCurrentTag;
  SnoozeCommonModel({
    Key key,
    this.selectedMailId,
    this.updateCurrentTag,
  }) : super(key: key);
  @override
  _SnoozeCommonModelState createState() => _SnoozeCommonModelState();
}

class _SnoozeCommonModelState extends State<SnoozeCommonModel> {
  List<String> snoozeOptions = [
    "Later Today",
    "One day",
    "Two day",
    "Three day",
  ];
  var tagLength = 4;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  selectDate() async {
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 5,
      ),
    );
    if (selectedDate != null) {
      setState(() {
        pickedDate = selectedDate;
        selectTime(selectedDate);
      });
    }
  }

  selectTime([DateTime selectedDate, String otherValue]) async {
    if (otherValue == null) {
      TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: pickedTime,
      );
      if (selectedTime != null) {
        setState(() {
          pickedTime = selectedTime;
          String selectedDateAndTime = selectedDate
              .toIso8601String()
              .replaceFirst(
                  'T00:00', 'T${selectedTime.toString().substring(10, 15)}');
          var model = {
            "current_tag": 'SNOOZE',
            "toastMessage": "Moved to SNOOZE SuccessFully",
            "snooze_time": selectedDateAndTime
          };
          widget.updateCurrentTag(widget.selectedMailId, model);
          Navigator.of(context).pop();
        });
      }
    } else {
      var model = {
        "current_tag": 'SNOOZE',
        "toastMessage": "Moved to SNOOZE SuccessFully",
        "snooze_time": otherValue
      };
      widget.updateCurrentTag(widget.selectedMailId, model);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top: Styling.dashboardBorder,
          left: Styling.dashboardBorder,
          right: Styling.dashboardBorder,
          bottom: Styling.dashboardBorder,
        ),
      ),
      child: Column(
        children: List<Widget>.generate(
          snoozeOptions.length + 1,
          (int index) {
            return Container(
              padding: const EdgeInsets.all(5),
              decoration: index != 0
                  ? const BoxDecoration(
                      border: Border(
                        top: Styling.dashboardBorder,
                      ),
                    )
                  : null,
              child: InkWell(
                onTap: () {
                  if (index == 4) {
                    selectDate();
                  } else if (index != 4) {
                    final now = DateTime.now();
                    if (index == 0) {
                      dynamic laterToday =
                          now.toIso8601String().substring(0, 10) +
                              'T18:00:00.000';
                      selectTime(null, laterToday);
                    } else if (index == 1) {
                      dynamic laterToday = DateTime(now.year, now.month,
                              now.day + 1, now.hour, now.month, now.second)
                          .toIso8601String();
                      selectTime(null, laterToday);
                    } else if (index == 2) {
                      dynamic laterToday = DateTime(now.year, now.month,
                              now.day + 2, now.hour, now.month, now.second)
                          .toIso8601String();
                      selectTime(null, laterToday);
                    } else if (index == 3) {
                      dynamic laterToday = DateTime(now.year, now.month,
                              now.day + 3, now.hour, now.month, now.second)
                          .toIso8601String();
                      selectTime(null, laterToday);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: tagLength > index
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      tagLength > index
                          ? snoozeOptions.elementAt(index)
                          : index == 4
                              ? "Custom"
                              : '',
                      style: tagLength > index
                          ? Styling.textSize20Black
                          : Styling.textSize20Blue,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
