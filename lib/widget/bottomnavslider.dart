import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:inbox/constants/app_colors.dart';

class BottomNavSlider extends StatefulWidget {
  Function customFuction;
  String dashboardSelectTag;
  BottomNavSlider({Key key, this.customFuction, this.dashboardSelectTag = ''})
      : super(key: key);

  @override
  _BootamNavState createState() => _BootamNavState();
}

class _BootamNavState extends State<BottomNavSlider> {
  int currentIndex = 0;

  List<String> categories = [
    "ALL",
    "YOURS",
    "UNASSIGNED",
    "SENT",
  ];
  @override
  void initState() {
    super.initState();
    if (widget.dashboardSelectTag == "ALL") {
      currentIndex = 0;
    } else if (widget.dashboardSelectTag == "YOURS") {
      currentIndex = 1;
    } else if (widget.dashboardSelectTag == "UNASSIGNED") {
      currentIndex = 2;
    } else {
      currentIndex = 3;
    }
  }

  void changePage(int index) {
    widget.customFuction(categories[index]);
    setState(() {
      currentIndex = index;
    });
  }

  Icon _getOtherIcon(var a) {
    setState(() {
      categories[3] = widget.dashboardSelectTag;
    });
    if (widget.dashboardSelectTag == "CLOSED") {
      return Icon(
        a == 1 ? Icons.done : Icons.done_outline,
        color:
            a == 1 ? AppColor.colorIconNavBar : AppColor.colorIconNavBarAction,
      );
    } else if (widget.dashboardSelectTag == "SNOOZE") {
      return Icon(
        a == 1 ? Icons.snooze : Icons.snooze_outlined,
        color:
            a == 1 ? AppColor.colorIconNavBar : AppColor.colorIconNavBarAction,
      );
    } else if (widget.dashboardSelectTag == "DELETE") {
      return Icon(
        a == 1 ? Icons.delete : Icons.delete_outline,
        color:
            a == 1 ? AppColor.colorIconNavBar : AppColor.colorIconNavBarAction,
      );
    } else if (widget.dashboardSelectTag == "FIRST SENDER") {
      {
        return Icon(
          a == 1 ? Icons.question_mark : Icons.question_mark_rounded,
          color: a == 1
              ? AppColor.colorIconNavBar
              : AppColor.colorIconNavBarAction,
        );
      }
    } else {
      setState(() {
        categories[3] = "SENT";
      });
      return Icon(
        a == 1 ? Icons.send : Icons.send_outlined,
        color:
            a == 1 ? AppColor.colorIconNavBar : AppColor.colorIconNavBarAction,
      );
    }
  }

  String _getOtherText() {
    if (widget.dashboardSelectTag == "ALL" ||
        widget.dashboardSelectTag == "YOURS" ||
        widget.dashboardSelectTag == "UNASSIGNED" ||
        widget.dashboardSelectTag == "SENT") {
      return "SENT";
    } else {
      return widget.dashboardSelectTag;
    }
  }

  bool isMob(BuildContext context) => MediaQuery.of(context).size.width < 400;
  bool isWeb(BuildContext context) => MediaQuery.of(context).size.width > 600;
  @override
  Widget build(BuildContext context) {
    return BubbleBottomBar(
      backgroundColor: const Color.fromARGB(255, 231, 225, 225),
      // backgroundColor: Color.fromARGB(255, 255, 251, 193),
      hasNotch: true,
      fabLocation: BubbleBottomBarFabLocation.end,
      opacity: .2,
      currentIndex: currentIndex,
      onTap: changePage,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      tilesPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      items: <BubbleBottomBarItem>[
        const BubbleBottomBarItem(
          backgroundColor: AppColor.colorIconNavBarAction,
          icon: Icon(
            Icons.dashboard,
            color: AppColor.colorIconNavBar,
          ),
          activeIcon: Icon(
            Icons.dashboard_outlined,
            color: AppColor.colorIconNavBarAction,
          ),
          title: Text(
            "ALL",
            style: TextStyle(fontSize: 12),
          ),
        ),
        const BubbleBottomBarItem(
          backgroundColor: AppColor.colorIconNavBarAction,
          icon: Icon(
            Icons.folder,
            color: AppColor.colorIconNavBar,
          ),
          activeIcon: Icon(
            Icons.folder_open,
            color: AppColor.colorIconNavBarAction,
          ),
          title: Text(
            "YOURS",
            style: TextStyle(fontSize: 12),
          ),
        ),
        BubbleBottomBarItem(
          backgroundColor: AppColor.colorIconNavBarAction,
          icon: const Icon(
            Icons.list_alt,
            color: AppColor.colorIconNavBar,
          ),
          activeIcon: const Icon(
            Icons.list_alt_outlined,
            color: AppColor.colorIconNavBarAction,
          ),
          // title: Text("UNASSIGNED")),
          title: isMob(context)
              ? const Text(
                  "UNASS.. ",
                  style: TextStyle(fontSize: 11),
                )
              : const Text('UNASSIGNED'),
        ),
        BubbleBottomBarItem(
            backgroundColor: AppColor.colorIconNavBarAction,
            icon: _getOtherIcon(1),
            activeIcon: _getOtherIcon(0),
            title: Text(
              _getOtherText() == "FIRST SENDER"
                  ? (isMob(context)
                      ? 'FS..'
                      : isWeb(context)
                          ? 'FIRST SENDER'
                          : 'FIRST\nSENDER')
                  : _getOtherText(),
              style: const TextStyle(fontSize: 12),
            )),
      ],
    );
  }
}
