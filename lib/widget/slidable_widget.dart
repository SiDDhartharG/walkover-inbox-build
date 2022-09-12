// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/app_colors.dart';
import 'package:inbox/constants/app_string.dart';

enum SlidableAction { snooze, closed, open }

class SlidableWidget extends StatelessWidget {
  final Widget child;
  final AllMailModel mailObject;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    this.child,
    this.onDismissed,
    this.mailObject,
    Key key,
  }) : super(key: key);

  List<Widget> getRandomWidgetArray() {
    if (mailObject.currentTag == 'CLOSED') {
      return <Widget>[
        IconSlideAction(
          caption: AppString.open,
          color: AppColor.colorSlideablRightOpen,
          icon: Icons.file_open,
          onTap: () => onDismissed(SlidableAction.open),
        ),
      ];
    }
    return <Widget>[
      IconSlideAction(
        caption: AppString.closed,
        color: AppColor.colorSlideablRightClose,
        icon: Icons.close_fullscreen_outlined,
        onTap: () => onDismissed(SlidableAction.closed),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: child,

      ///left side
      actions: <Widget>[
        IconSlideAction(
          caption: AppString.snooze,
          color: AppColor.colorSlideablLeft,
          icon: Icons.lock_clock_rounded,
          onTap: () => onDismissed(SlidableAction.snooze),
        ),
      ],

      ///right side
      secondaryActions: getRandomWidgetArray());
}
