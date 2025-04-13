import 'package:flutter/material.dart';

class TimePeriodButtons extends StatefulWidget {
  final Function(String) onTimePeriodSelected;
  const TimePeriodButtons({super.key, required this.onTimePeriodSelected});

  @override
  State<TimePeriodButtons> createState() => _TimePeriodButtonsState();
}

class _TimePeriodButtonsState extends State<TimePeriodButtons> {
  final timePeriods = [
    "3h",
    "12h",
    "24h",
    "7d",
    "30d",
    "3m",
    "1y",
    "3y",
    "5y",
  ];
  String selectedTimePeriod = "7d";

  @override
  void initState() {
    super.initState();
    widget.onTimePeriodSelected(selectedTimePeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: timePeriods.map((period) {
        return ChoiceChip(
          label: Text(period),
          selected: selectedTimePeriod == period,
          onSelected: (selected) {
            setState(() {
              selectedTimePeriod = period;
            });
            widget.onTimePeriodSelected(period);
          },
        );
      }).toList(),
    );
  }
}
