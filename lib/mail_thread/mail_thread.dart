// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_filereader/filereader.dart';
//import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hive/hive.dart';
import 'package:inbox_flutter_app/api/api.dart';
import 'package:inbox_flutter_app/apiModel/data.dart';
import 'package:inbox_flutter_app/apiModel/userEmailAddress.dart';
import 'package:inbox_flutter_app/constants/app_colors.dart';
import 'package:inbox_flutter_app/constants/styling.dart';
import 'package:inbox_flutter_app/constants/utils.dart';
import 'package:inbox_flutter_app/widget/snoozedCommonModel.dart';
import 'package:intl/intl.dart';
import 'package:inbox_flutter_app/screens/compose_mail.dart';
import 'package:inbox_flutter_app/widget/sheet_content.dart';
import 'package:mime/mime.dart';
import 'package:universal_io/io.dart';
//import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class MailThreadList extends StatefulWidget {
  List<String> replyButtonsList = [
    "Reply & Snooze",
    "Reply all & Snooze",
    "Reply & Close",
    "Reply all & Close",
    "Forward & Close"
  ];
  AllMailModel mailItem;
  String currentUserName;
  Email_address? emailAddress;
  String userEmailAddressId;
  final Function() notifyParent;
  int mailToSkip;

  MailThreadList({
    Key? key,
    required this.mailToSkip,
    required this.notifyParent,
    required this.mailItem,
    required this.currentUserName,
    this.emailAddress,
    required this.userEmailAddressId,
  }) : super(key: key);
  @override
  _MailThreadListState createState() => _MailThreadListState();
}

class _MailThreadListState extends State<MailThreadList> {
  Box<String> currentTokenBox = Hive.box("accessToken");
  bool isOpen = false;
  bool showDrop = false;
  bool showDropCC = false;
  bool showDropBCC = false;
  late List<Attachment> attachmentsList;
  @override
  void initState() {
    super.initState();
    attachmentsList = widget.mailItem.mail?.attachments ?? [];
    if (widget.mailItem.status == 'UNREAD') {
      const model = {"status": 'READ'};
      changeMailStatusReadOrUnread(
          widget.mailItem.id!, widget.userEmailAddressId, "READ");
      changeMailsCurrentTag(widget.mailItem.id.toString(), model,
          isUnread: true);
    }
  }

  void changeMailsCurrentTag(String mailId, dynamic model,
      {isUnread = false}) async {
    try {
      await APICalls.changeMailCurrentTagAPI(mailId, model);
      await updateAllEmailOfUserEmailAddressId(
          [widget.userEmailAddressId], [widget.mailToSkip]);
      widget.notifyParent();
      !isUnread ? Navigator.of(context).pop() : null;
    } catch (err) {
      log(err.toString());
    }
  }

  String abc() {
    String? s = widget.mailItem.mail!.body?.data;
    return s.toString();
  }

  _launchURL(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _handel() {
    var model = {};
    if (widget.mailItem.currentTag == 'DELETE') {
      model = {
        "current_tag": 'ALL',
        "toastMessage": "RESTORE SuccessFully",
      };
    } else {
      model = {
        "current_tag": 'DELETE',
        "toastMessage": "Moved to DELETE SuccessFully",
      };
    }
    changeMailsCurrentTag(widget.mailItem.id!, model);
  }

  bool opened = true;
  String fromMail() {
    String? s = widget.mailItem.mail!.from!.email.toString();
    return s;
  }

  Mail mail() {
    Mail? ss = widget.mailItem.mail!;
    return ss;
  }

  Widget makewidget(dynamic text) {
    return Expanded(
      flex: isSmallMob(context)
          ? 3
          : isWeb(context)
              ? 2
              : 3,
      child: Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: SelectableText(
          '${text}',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget createList(List<dynamic> list, String text) {
    if (list.length > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          makewidget('${text}:'),
          Expanded(
            flex: isSmallMob(context) ? 7 : 8,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list.map((e) {
                  var temp = (SelectableText("${e.email}"));
                  return Padding(
                      padding: EdgeInsets.only(bottom: 3), child: temp);
                }).toList()),
          )
        ],
      );
    }
    return SizedBox(height: 0);
  }

  bool isSmallMob(BuildContext context) =>
      MediaQuery.of(context).size.width < 350;
  bool isWeb(BuildContext context) => MediaQuery.of(context).size.width > 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.ColorDark,
        elevation: 0,
        title: Text("${widget.currentUserName}"),
        titleSpacing: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: AppColor.colorTopBarIcons,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
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
                    selectedMailId: widget.mailItem.id.toString(),
                    updateCurrentTag: changeMailsCurrentTag,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.alarm_add_rounded),
            color: AppColor.colorTopBarIcons,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ColoredBox(
                color: AppColor.colorMailThredModelBackg,
                child: Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.only(left: 15, top: 15),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(right: 8.0),
                    //         child: CircleAvatar(
                    //           radius: 12,
                    //           backgroundColor: Colors.blue,
                    //           child: Text(
                    //             'G',
                    //             style: TextStyle(
                    //               fontSize: 10,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Text(
                    //         widget.mailItem.assign == '2tP6vAHic9lp05Tf'
                    //             ? "Assigned to Gaurav"
                    //             : "",
                    //         style: TextStyle(color: Colors.black),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 6.0),
                    //         child: Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: 12,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 6, bottom: 10, left: 6),
                              // width: MySize - 10,
                              child: Text(
                                widget.mailItem.mail!.subject.toString(),
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.colorMailThredModelText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColor.colorMailThredDivider,
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),

            //-----------Mail Heading Widget

            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: 4, vertical: kPadding - 14),
              padding: const EdgeInsets.only(top: 10, left: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 18,
                      child: widget.mailItem.mail!.from!.email != null
                          ? Text(widget.mailItem.mail!.from!.email
                              .toString()
                              .toUpperCase()
                              .substring(0, 1))
                          : Text(widget.mailItem.mail!.from!.address
                              .toString()
                              .toUpperCase()
                              .substring(0, 1))),
                  SizedBox(
                    width: kPadding - 12,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.mailItem.mail!.from!.email != null
                                          ? widget.mailItem.mail!.from!.email
                                              .toString()
                                          : widget.mailItem.mail!.from!.address
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              widget.mailItem.status == 'UNREAD'
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                          color: AppColor.colorMailThredText),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 2),
                                      child: Text(
                                        DateFormat('d MMM, yyyy').format(
                                            DateFormat("yyyy-MM-dd").parse(
                                                widget.mailItem.createdAt
                                                    .toString())),
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   child: _buildPanel(),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: SelectableText(
                                            widget.mailItem.mail!.to![0]
                                                        .email !=
                                                    null
                                                ? "To: ${widget.mailItem.mail!.to![0].email}"
                                                : "To: ${widget.mailItem.mail!.to![0].address}",
                                            // style: Styling.fontSize13,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        widget.mailItem.mail!.to!.length > 1
                                            ? Text('+ '
                                                '${(widget.mailItem.mail!.to!.length) - 1}')
                                            : Text(''),
                                        InkWell(
                                          child: Icon(Icons.expand_more),
                                          onTap: () {
                                            // opened = !opened;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 10,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      maxHeight: 350,
                                                      maxWidth: 450,
                                                      minWidth: 400,
                                                      minHeight: 100,
                                                    ),
                                                    margin: EdgeInsets.all(12),
                                                    // height: 150,
                                                    // width: 300,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              makewidget(
                                                                  'From :'),
                                                              Expanded(
                                                                  flex: isSmallMob(
                                                                          context)
                                                                      ? 7
                                                                      : 8,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      mail().from!.name !=
                                                                              null
                                                                          ? SelectableText(
                                                                              "${mail().from!.name.toString().toUpperCase()}\n<${mail().from!.email!.toString()}>")
                                                                          : SelectableText(
                                                                              "${mail().from!.email!.toString()}"),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                          // makewidget('To'),
                                                          createList(
                                                              mail().to!, 'To'),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              makewidget(
                                                                  'Date :'),
                                                              Expanded(
                                                                flex: isSmallMob(
                                                                        context)
                                                                    ? 7
                                                                    : 8,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SelectableText(
                                                                      DateFormat('d MMM, yyyy').format(DateFormat("yyyy-MM-dd").parse(widget
                                                                          .mailItem
                                                                          .createdAt
                                                                          .toString())),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              makewidget(
                                                                  'Subject :'),
                                                              Expanded(
                                                                flex: isSmallMob(
                                                                        context)
                                                                    ? 7
                                                                    : 8,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SelectableText(mail()
                                                                        .subject
                                                                        .toString())
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          // makewidget('CC'),
                                                          createList(
                                                              mail().cc!, 'CC'),
                                                          createList(
                                                              mail().bcc!,
                                                              'BCC'),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              makewidget(
                                                                  'Mailed-by : '),
                                                              Expanded(
                                                                flex: isSmallMob(
                                                                        context)
                                                                    ? 7
                                                                    : 8,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SelectableText(fromMail().substring(
                                                                        fromMail().indexOf('@') +
                                                                            1,
                                                                        fromMail()
                                                                            .length)),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(""),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<int>(
                              child: Icon(Icons.more_vert),
                              itemBuilder: (c) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Mark as unread'),
                                  onTap: () {
                                    if (widget.mailItem.status == 'READ') {
                                      const model = {"status": 'UNREAD'};
                                      changeMailStatusReadOrUnread(
                                          widget.mailItem.id!,
                                          widget.userEmailAddressId,
                                          "UNREAD");
                                      changeMailsCurrentTag(
                                          widget.mailItem.id.toString(), model,
                                          isUnread: true);
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: widget.mailItem.currentTag == 'DELETE'
                                      ? Text('Restore')
                                      : Text('Delete'),
                                  onTap: _handel,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kPadding - 10,
            ),
            _details(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Card(
                        elevation: 0,
                        // color: AppColor.colorMailThredModelBackg,
                        color: Colors.grey[50],
                        margin: EdgeInsets.all(0),
                        child: SelectableLinkify(
                            text: abc(),
                            onOpen: (link) {
                              _launchURL(Uri.parse(link.url));
                            })),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kPadding + 100,
            ),
            ...?widget.mailItem.mail?.attachments!.map((attachmentObject) {
              return InkWell(
                  child: Text(
                    attachmentObject.toJson()["fileName"]!,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () {
                    if (Platform.isWindows || Platform.isMacOS) {
                      _launchURL(
                          Uri.parse(attachmentObject.toJson()["filePath"]!));
                    } else {
                      downloadFile(
                          Uri.parse(attachmentObject.toJson()["filePath"]!),
                          attachmentObject.toJson()["fileName"]!);
                    }
                  });
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: Styling.dashboardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: AppColor.colorMailThredModelButtonText,
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                var model = {};
                if (widget.mailItem.currentTag == 'CLOSED') {
                  model = {
                    "current_tag": 'ALL',
                    "toastMessage": "Moved to OPEN SuccessFully",
                  };
                } else {
                  model = {
                    "current_tag": 'CLOSED',
                    "toastMessage": "REOPENED SuccessFully",
                  };
                }

                changeMailsCurrentTag(widget.mailItem.id!, model);
              },
              child: Text(
                widget.mailItem.currentTag == 'CLOSED' ? "Open" : 'Done',
                style: Styling.textSize20BlueBold,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: AppColor.colorMailThredModelButtonText,
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 450,
                      color: AppColor.colorMailThredModelBackg,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.close),
                                iconSize: 24,
                                color: AppColor.colorMailThredModelIcon,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary:
                                      AppColor.colorMailThredModelButtonText,
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: Styling.dashboardBorder,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ComposeScreen(
                                          emailAddress: widget.emailAddress,
                                          mailItem: widget.mailItem,
                                          selectedOption: "Reply"),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.reply,
                                      color: AppColor.colorMailThredModelIcon,
                                    ),
                                    Text("Reply")
                                  ],
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary:
                                      AppColor.colorMailThredModelButtonText,
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: Styling.dashboardBorder,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ComposeScreen(
                                          emailAddress: widget.emailAddress,
                                          mailItem: widget.mailItem,
                                          selectedOption: "Reply all"),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.reply_all,
                                      color: AppColor.colorMailThredModelIcon,
                                    ),
                                    Text("Reply all")
                                  ],
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary:
                                      AppColor.colorMailThredModelButtonText,
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: Styling.dashboardBorder,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ComposeScreen(
                                          mailItem: widget.mailItem,
                                          selectedOption: "Forward",
                                          emailAddress: widget.emailAddress)));
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.forward_to_inbox,
                                      color: AppColor.colorMailThredModelIcon,
                                    ),
                                    Text("Forward")
                                  ],
                                ),
                              ),
                              // TextButton(
                              //   style: TextButton.styleFrom(
                              //     primary: AppColor.colorMailThredModelButtonText,
                              //     padding: EdgeInsets.all(20),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(15)),
                              //       side: Styling.dashboardBorder,
                              //     ),
                              //   ),
                              //   onPressed: () {},
                              //   child: Column(
                              //     children: const <Widget>[
                              //       Icon(
                              //         Icons.note,
                              //         color: Colors.black,
                              //       ),
                              //       Text("Note")
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SheetContent(options: widget.replyButtonsList)
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Reply',
                style: Styling.textSize20BlueBold,
              ),
            )
          ],
        ),
      ),
    );
  }

  //Not being used here for now
  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isOpen = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: Colors.grey[50],
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Text("to ");
            },
            body: Container(),
            isExpanded: isOpen)
      ],
    );
  }

  Widget _details() {
    return Visibility(
      visible: showDrop,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: showDrop,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("To ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.mailItem.mail!.to!.map((e) {
                                var temp = Text("  ${e.email}");
                                return temp;
                              }).toList()),
                          SizedBox(width: 2, height: 3),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Visibility(
                  visible: showDropCC,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Cc ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.mailItem.mail!.cc!.map((e) {
                                var temp = Text("  ${e.email}");
                                return temp;
                              }).toList()),
                          SizedBox(width: 2, height: 3),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Visibility(
                  visible: showDropBCC,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Bcc ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.mailItem.mail!.bcc!.map((e) {
                                var temp = Text("  ${e.email}");
                                return temp;
                              }).toList()),
                          SizedBox(width: 2, height: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool downloading = false;

  String progress = '0';

  bool isDownloaded = false;

  Future<void> downloadFile(uri, fileName) async {
    setState(() {
      downloading = true;
    });

    String savePath = await getFilePath(fileName);

    Dio dio = Dio();

    dio.downloadUri(uri, savePath);
    OpenFile.open(savePath);
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    if (!kIsWeb) {
      Directory dir = await getApplicationDocumentsDirectory() as Directory;

      path = '${dir.path}/$uniqueFileName';

      return path;
    }
    return '';
  }
}
