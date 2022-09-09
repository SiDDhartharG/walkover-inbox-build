import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  final dynamic customFuction;
  String dashboardSelectTag;
  TagsPage({Key key, this.customFuction, this.dashboardSelectTag = ''})
      : super(key: key);

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage>
    with SingleTickerProviderStateMixin {
  List<String> categories = [
    "ALL",
    "UNASSIGNED",
    "YOURS",
    "CLOSED",
    "SENT",
    "SNOOZE",
    "DELETE",
    "FIRST SENDER"
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: categories.length, initialIndex: 0);

    _tabController.addListener(handleTabSelection);
    _tabController.index = !categories.contains(widget.dashboardSelectTag)
        ? 2
        : categories.indexOf(widget.dashboardSelectTag);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleTabSelection() {
    if (_tabController.indexIsChanging) {
      widget.customFuction(categories.elementAt(_tabController.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
            // color: Colors.white,
            decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black12))),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelStyle: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Family Name',
                  fontWeight: FontWeight.bold), //For Selected tab
              unselectedLabelStyle:
                  const TextStyle(fontSize: 18.0, fontFamily: 'Family Name'),
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              labelColor: Colors.black,
              indicatorColor: Colors.green[700],
              indicatorWeight: 5,
              labelPadding:
                  const EdgeInsets.only(top: 4, right: 25, bottom: 4, left: 25),
              tabs: List<Widget>.generate(categories.length, (int index) {
                return Tab(child: Text(categories.elementAt(index)));
              }),
            )));
  }
}
