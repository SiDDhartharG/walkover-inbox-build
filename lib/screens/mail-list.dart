// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_final_fields, must_be_immutable

import 'dart:developer';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:inbox/api/api.dart';
import 'package:inbox/apiModel/data.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/app_colors.dart';
import 'package:inbox/mail_thread/mail_thread.dart';
import 'package:inbox/constants/utils.dart';
import 'package:inbox/widget/slidable_widget.dart';
import 'package:intl/intl.dart';
import 'package:inbox/widget/snoozedCommonModel.dart';

import 'dashboard.dart';

class MailListPage extends StatefulWidget {
  final dynamic currentTag;
  int mailToSkip;
  final Function() notifyParent;
  List<AllMailModel> fetchedMails;
  String currentUserName;
  bool isLoading;
  String userEmailAddressId;
  Email_address emailAddress;
  MailListPage({
    Key key,
    this.currentTag,
    this.mailToSkip,
    this.notifyParent,
    this.isLoading,
    this.fetchedMails,
    this.userEmailAddressId,
    this.currentUserName,
    this.emailAddress,
  }) : super(key: key);

  @override
  State<MailListPage> createState() => _MailListPageState();
}

class _MailListPageState extends State<MailListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isSuggestionLoading = false;
  bool isAllMailFetched = false;

  void _onRefresh() async {
    try {
      await updateAllEmailOfUserEmailAddressId(
          [widget.userEmailAddressId], [widget.mailToSkip]);
      widget.notifyParent();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    try {
      Box allMailBox = Hive.box<Map<dynamic, dynamic>>("allEmails");
      dynamic allEmailObject = allMailBox.get(widget.userEmailAddressId);
      int oldMailListLength = allEmailObject['ALL'].length;
      await updateAllEmailOfUserEmailAddressId(
          [widget.userEmailAddressId], [allEmailObject['ALL'].length]);
      widget.notifyParent();
      _refreshController.loadComplete();
      if (oldMailListLength == allEmailObject['ALL'].length) {
        setState(() {
          isAllMailFetched = true;
        });
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  // int _selectedItem = 0;
  bool _searchVisibility = false;
  int unReadCount = 5;
  Box<String> activeOrgIdBox;
  Box<String> activeUserIdBox;
  String activeUserId;

  @override
  void initState() {
    super.initState();
    activeOrgIdBox = Hive.box("activeOrgId");
    activeUserIdBox = Hive.box("activeUserId");
    setState(() {
      activeUserId = activeUserIdBox.get("activeUserId");
    });
  }

  //perform mail-searching operations---------------------//
  getMailsSuggestions(String query) async {
    try {
      if (query == '') {
        return [];
      }
      String activeOrgId = activeOrgIdBox.get("orgId");
      setState(() {
        isSuggestionLoading = true;
      });
      final Map<String, dynamic> response = await APICalls.searchMailDelveUrl(
          query, widget.emailAddress.email.toString(), activeOrgId);
      setState(() {
        isSuggestionLoading = false;
      });
      try {
        if (response['hits']['hits'] = null) {
          return response['hits']['hits'].where((suggetions) {
            Map mapValue = Map.from(suggetions);
            return mapValue["_score"].toString() != "0";
          }).toList();
        } else {
          return [];
        }
      } catch (e) {
        log(e.toString());
      }
    } catch (err) {
      log(err.toString());
    }
  }

  searchMailById(String mailId) async {
    try {
      final Map<String, dynamic> response = await APICalls.getMailViaId(mailId);
      try {
        AllMailModel searchedMail = AllMailModel.fromJson(response);
        setState(() {
          _searchVisibility = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MailThreadList(
                mailItem: searchedMail,
                currentUserName: widget.currentUserName,
                emailAddress: widget.emailAddress,
                userEmailAddressId: widget.userEmailAddressId,
              );
            },
          ),
        );
        // }
      } catch (e) {
        log(e.toString());
      }
    } catch (err) {
      log(err.toString());
    }
  }

  void onTabEmailRowClick(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MailThreadList(
              mailItem: widget.fetchedMails[index],
              currentUserName: widget.currentUserName,
              emailAddress: widget.emailAddress,
              userEmailAddressId: widget.userEmailAddressId);
        },
      ),
    ).then((value) => {widget.notifyParent()});
  }

  @override
  Widget build(BuildContext context) {
    mySize = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _searchVisibility
            ? Row(
                children: [
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.only(left: 16),
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 24,
                      color: AppColor.colorTopBarIcons,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DashBoardPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : null,
        actions: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _searchVisibility
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: AppColor.colorSearchBoxBackg,
                      ),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: true,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppColor.colorTopBarIcons),
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: AppColor.colorSearchTextHint),
                              hintText: 'Search here',
                            )),
                        suggestionsCallback: (pattern) async {
                          return await getMailsSuggestions(pattern);
                        },
                        itemBuilder: (context, dynamic suggestion) {
                          return ListTile(
                            leading: Icon(Icons.message_rounded),
                            title: Text(suggestion['_source']['subject']),
                            subtitle: Text(
                                suggestion['_source']['toEmails'].length > 0 &&
                                        suggestion['_source']['toEmails'][0] !=
                                            null
                                    ? suggestion['_source']['toEmails'][0]
                                    : ''),
                          );
                        },
                        onSuggestionSelected: (dynamic suggestion) async {
                          searchMailById(suggestion['_id']);
                        },
                      ),
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(
                        widget.currentUserName,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(
              _searchVisibility ? Icons.search : Icons.close,
              size: 28,
              color: AppColor.colorTopBarIcons,
            ),
            onPressed: () {
              setState(() {
                _searchVisibility = _searchVisibility;
              });
            },
          ),
        ],
        elevation: 0,
        backgroundColor: AppColor.colorTopBarBackg,
      ),
      body: widget.fetchedMails.length > 0
          ? SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(),
              footer: isAllMailFetched
                  ? ClassicFooter(
                      idleText: "Loading Complete", idleIcon: Icon(Icons.done))
                  : ClassicFooter(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              controller: _refreshController,
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: widget.fetchedMails.length,
                itemBuilder: (context, index) {
                  if (widget.currentTag == "ALL" &&
                      widget.fetchedMails[index].currentTag == "CLOSED") {
                    return SizedBox(
                      height: 0,
                    );
                  }
                  return ListTile(
                    hoverColor: AppColor.colorMailListhover,
                    // focusColor: Color.fromARGB(255, 175, 138, 28),
                    onTap: () {
                      onTabEmailRowClick(index);
                    },
                    title: SlidableWidget(
                        child: ShowMailsList(
                            selectedMail: widget.fetchedMails[index]),
                        onDismissed: (action) => dismissSlidableItem(context,
                            widget.fetchedMails[index].id.toString(), action),
                        mailObject: widget.fetchedMails[index]),
                  );
                },
              ),
            )
          : Center(
              child: Image.asset(
                "empty.png",
                height: 250,
                width: 250,
              ),
              heightFactor: 2.5,
            ),
    );
  }

  void changeMailsCurrentTag(String mailId, dynamic model, String tag) async {
    try {
      // await changeMailTag(mailId, widget.userEmailAddressId, tag);
      await APICalls.changeMailCurrentTagAPI(mailId, model);
      await updateAllEmailOfUserEmailAddressId(
          [widget.userEmailAddressId], [widget.mailToSkip]);
      widget.notifyParent();
      // widget.fetchAllMails();
    } catch (err) {
      log(err.toString());
    }
  }

  void dismissSlidableItem(
      BuildContext context, String mailId, SlidableAction action) async {
    switch (action) {
      case SlidableAction.snooze:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Snooze Time'),
                  CloseButton(onPressed: () {
                    Navigator.of(context).pop();
                  })
                ]),
            content: SnoozeCommonModel(
              selectedMailId: mailId,
              updateCurrentTag: changeMailsCurrentTag,
            ),
          ),
        );
        break;
      case SlidableAction.closed:
        var model = {
          "current_tag": 'CLOSED',
          "toastMessage": "Moved to CLOSED SuccessFully",
        };
        changeMailsCurrentTag(mailId, model, "CLOSED");
        Utils.showSnackBar(context, 'Moved to CLOSED');
        break;
      case SlidableAction.open:
        var model = {
          "current_tag": 'ALL',
          "toastMessage": "Moved to OPEN SuccessFully",
        };
        changeMailsCurrentTag(mailId, model, "ALL");
        Utils.showSnackBar(context, 'Moved to ALL');
        break;
    }
    widget.notifyParent();
  }
}

//showing mail in this widget-----------------------------------//
class ShowMailsList extends StatelessWidget {
  ShowMailsList({Key key, this.selectedMail}) : super(key: key);

  AllMailModel selectedMail;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.colorMailListSeparator),
        ),
        color: AppColor.colorMailListMailBackg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    child: selectedMail.mail.from.name != null
                        ? Text(selectedMail.mail.from.name
                                    .toString()
                                    .split(" ")
                                    .length >
                                1
                            ? selectedMail.mail.from.name
                                    .toString()
                                    .split(" ")[0][0]
                                    .toUpperCase() +
                                selectedMail.mail.from.name
                                    .toString()
                                    .split(" ")[1][0]
                                    .toUpperCase()
                            : selectedMail.mail.from.name
                                .toString()
                                .toUpperCase()
                                .substring(0, 2))
                        : Text(selectedMail.mail.from.address
                            .toString()
                            .toUpperCase()
                            .substring(0,
                                2))), //need to add address field in AllMailModel class section
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Text(
                          selectedMail.mail.from.name != null
                              ? selectedMail.mail.from.name.toString()
                              : selectedMail.mail.from.address.toString(),
                          style: TextStyle(
                            color: AppColor.colorMailListMailName,
                            fontSize: 15,
                            fontWeight: selectedMail.status == 'READ'
                                ? FontWeight.w300
                                : FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 2, top: 3),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                selectedMail.mail.subject.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.colorMailListMailSubject,
                                  fontSize: 13,
                                  fontWeight: selectedMail.status == 'READ'
                                      ? FontWeight.w300
                                      : FontWeight.w800,
                                ),
                              ),
                            ),
                            (DateTime.now().day ==
                                    DateFormat("yyyy-MM-dd")
                                        .parse(selectedMail.mail.createdAt
                                            .toString())
                                        .day)
                                ? Text(
                                    // selectedMail.mail.createdAt.toString(),
                                    // 2022-01-05T11:58:39.462Z
                                    DateFormat.jm()
                                        .format(DateTime.parse(selectedMail
                                                .mail.createdAt
                                                .toString())
                                            .toLocal())
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selectedMail.status == 'READ'
                                          ? FontWeight.w300
                                          : FontWeight.w800,
                                    ),
                                  )
                                : Text(
                                    // selectedMail.mail.createdAt.toString(),
                                    // 2022-01-05T11:58:39.462Z

                                    DateFormat('d MMM, yyyy').format(
                                        DateFormat("yyyy-MM-dd").parse(
                                            selectedMail.mail.createdAt
                                                .toString())),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selectedMail.status == 'READ'
                                          ? FontWeight.w300
                                          : FontWeight.w800,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      selectedMail.mail.body.data.toString() != '<p></p>'
                          ? Html(
                              data: selectedMail.mail.body.data.toString(),
                              // data: '<h5>this is an awesome test</h5>',
                              style: {
                                '#': Style(
                                    color: AppColor.colorMailListMailBody,
                                    fontSize: FontSize(13),
                                    fontWeight: selectedMail.status == 'READ'
                                        ? FontWeight.w300
                                        : FontWeight.w800,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                    margin: EdgeInsets.only(
                                        top: 1, right: 0, bottom: 1, left: 0)),
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
