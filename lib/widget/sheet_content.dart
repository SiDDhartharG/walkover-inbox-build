// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:inbox/constants/styling.dart';

class SheetContent extends StatelessWidget {
  final List options;
  final selectedOption;
  const SheetContent({
    this.options,
    this.selectedOption,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: Styling.dashboardBorder,
                  bottom: Styling.dashboardBorder,
                  left: Styling.dashboardBorder,
                  right: Styling.dashboardBorder,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: InkWell(
                splashColor: Color.fromARGB(255, 255, 0, 0),
                onTap: () {
                  selectedOption(options.elementAt(index));
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      options.elementAt(index),
                      style: Styling.textSize20Blue,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
