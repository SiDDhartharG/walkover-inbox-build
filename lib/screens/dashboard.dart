// ignore_for_file: unnecessary_new

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:inbox/api/api.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/app_colors.dart';
import 'package:inbox/constants/network_url.dart';
import 'package:inbox/constants/styling.dart';
import 'package:inbox/constants/utils.dart';
import 'package:inbox/screens/home_page.dart';
import 'package:inbox/screens/org_list.dart';
import 'package:inbox/utils/logout.dart';
import 'package:overlay_support/overlay_support.dart';

enum Menu { itemOrgList, itemLogout }

class DashBoardPage extends StatefulWidget {
  String userToken;
  DashBoardPage({Key key, this.userToken}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var tagLength = <int>[];

  String url1 = NetworkUrl.defaultUserEmailAddress;
  UserEmailAddressModel myUserEmailAddress;
  // bool isAllUserEmailAddressFetched = false;
  bool isAllUserEmailAddressFetched = true;
  String clickedUserEmailAddressId;
  dynamic selectOrg;

  Box<Map<dynamic, dynamic>> allMailBox;
  Box<String> deviceToken;
  Box<UserEmailAddressModel> userEmailAddressesBox;
  Box<String> activeOrgIdBox;
  Box<String> activeUserIdBox;

  List<String> tags = [
    "ALL",
    "YOURS",
    "UNASSIGNED",
    "SENT",
    "CLOSED",
    "SNOOZE",
    "DELETE",
    "FIRST SENDER",
  ];

  void moveToOrgListPage() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OrgList(),
    ));
  }

  void showUserEmailAddresses() async {
    dynamic myLocalUserEmailAddress =
        userEmailAddressesBox.get("userEmailAddrress");
    if (myLocalUserEmailAddress != null) {
      setState(() {
        // isAllUserEmailAddressFetched = true;
        myUserEmailAddress = myLocalUserEmailAddress;
        tagLength =
            List.generate(myUserEmailAddress.userEmailAddress.length, (i) => 3);
      });
    }
  }

  void fetchCurrentUser() async {
    try {
      final Map<String, dynamic> response = await APICalls.getCurretUser();
      try {
        dynamic user = response;
        activeUserIdBox.put("activeUserId", user['id'] ?? "No CurrentUserId");
        dynamic activeUserId = activeUserIdBox.get("activeUserId");
        if (activeUserId != null && activeUserId != '') {
          fetchAllUserEmailAddress();
        }
      } catch (e) {
        log(e.toString());
      }
    } catch (err) {
      log(err.toString());
    }
  }

  void fetchAllUserEmailAddress() async {
    try {
      String activeOrgId = activeOrgIdBox.get("orgId");
      dynamic activeUserId = activeUserIdBox.get("activeUserId");

      final Map<String, dynamic> parsed =
          await APICalls.getAllUserEmailAddress(activeOrgId, activeUserId);

      final Map<String, dynamic> parsed1 =
          await APICalls.getDefaultUserEmailAddress(activeOrgId, activeUserId);

      try {
        UserEmailAddressModel myUserEmailAddresses =
            UserEmailAddressModel.fromJson(parsed);
        UserEmailAddressModel mydefaultUserEmailAddresses =
            UserEmailAddressModel.fromJson(parsed1);
        List<UserEmailAddress> myUserEmailAddress1 =
            myUserEmailAddresses.userEmailAddress +
                mydefaultUserEmailAddresses.userEmailAddress;
        List<UnreadCount> unreadCount = myUserEmailAddresses.unreadCount;
        UserEmailAddressModel finalUserEmailAddresses = UserEmailAddressModel(
            userEmailAddress: myUserEmailAddress1, unreadCount: unreadCount);
        userEmailAddressesBox.put("userEmailAddrress", finalUserEmailAddresses);
        if (finalUserEmailAddresses.userEmailAddress != null) {
          setState(() {
            // isAllUserEmailAddressFetched = true;
            myUserEmailAddress = finalUserEmailAddresses;
            tagLength = List.generate(
                myUserEmailAddress.userEmailAddress.length, (i) => 3);
          });
          List<String> userEmailAddressIdList = [];
          List<int> mailSkip = [];
          for (int i = 0; i < tagLength.length; i++) {
            mailSkip.add(0);
            userEmailAddressIdList.add(myUserEmailAddress
                .userEmailAddress[i].emailAddressId
                .toString());
          }
          await updateAllEmailOfUserEmailAddressId(
              userEmailAddressIdList, mailSkip);
        }
      } catch (e) {
        log(e.toString());
      }

      setState(() {
        tagLength =
            List.generate(myUserEmailAddress.userEmailAddress.length, (i) => 3);
      });
    } catch (err) {
      log(err.toString());
    }
  }

  void fetchAndSetFCMToken() async {
    String token = deviceToken.get("deviceToken") ?? "";
    // var response = await APICalls.sendFCMToken(token);
    await APICalls.sendFCMToken(token);
  }

  void shownotificationInApp(String title) {
    showSimpleNotification(
      GestureDetector(
        child: Text(title),
        onTap: () {
          fetchAllUserEmailAddress();
        },
      ),
      leading: const Icon(Icons.notifications),
      subtitle: GestureDetector(
        child: const Text("Click To Reload"),
        onTap: () {
          fetchAllUserEmailAddress();
        },
      ),
      background: Colors.black,
      duration: const Duration(seconds: 5),
      // ignore: deprecated_member_use
      slideDismiss: true,
    );
  }

  void fireBaseSetup2() async {
    var androiInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    var fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails('1', 'channelName');
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        fltNotification.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
        shownotificationInApp(notification.title ?? "Inbox Mail");
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      shownotificationInApp(message.notification?.title ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    userEmailAddressesBox = Hive.box("userEmailAddresses");
    deviceToken = Hive.box("deviceToken");
    allMailBox = Hive.box("allEmails");
    activeOrgIdBox = Hive.box("activeOrgId");
    activeUserIdBox = Hive.box("activeUserId");
    fetchAndSetFCMToken();
    showUserEmailAddresses();
    fetchCurrentUser();
  }

  String getUnreadCount(String userEmailAddressId, String tag) {
    try {
      Map<dynamic, dynamic> emailListTagWise =
          allMailBox.get(userEmailAddressId) as Map<dynamic, dynamic>;
      int result = getCountOfStatusFromMallMailModelList(
          "UNREAD", emailListTagWise[tag]);
      if (result == 0) return "";
      return result.toString();
    } catch (e) {
      return "";
    }
  }

  String getTotalCount(String userEmailAddressId, String tag) {
    try {
      Map<dynamic, dynamic> emailListTagWise =
          allMailBox.get(userEmailAddressId) as Map<dynamic, dynamic>;
      if (emailListTagWise[tag] == null) return "";
      int result = emailListTagWise[tag].length;
      if (result == 0) return "";
      if (result > 50) return "50+";
      return result.toString();
    } catch (e) {
      return "";
    }
  }

  Row getLeftSideOfBox(int index, int tagIndex) {
    String unCountEmails = "";
    if (tagLength.elementAt(index) > tagIndex) {
      unCountEmails = getUnreadCount(
          myUserEmailAddress.userEmailAddress[index].emailAddressId.toString(),
          tags[tagIndex]);
    }
    return Row(children: [
      new Text(
        tagLength.elementAt(index) > tagIndex
            ? tags[tagIndex]
            : tagIndex == 3
                ? "MORE"
                : "Less",
        style: tagLength.elementAt(index) > tagIndex
            ? const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 16)
            : Styling.textSize20Blue,
      ),
      const SizedBox(
        width: 10.0,
      ),
      tagLength.elementAt(index) > tagIndex && unCountEmails != ""
          ? (unCountEmails.length < 2
              ? CircleAvatar(
                  backgroundColor: AppColor.colorBadgeBack,
                  foregroundColor: AppColor.colorBadgeText,
                  maxRadius: 9,
                  child: Text(unCountEmails),
                )
              : CircleAvatar(
                  backgroundColor: AppColor.colorBadgeBack,
                  foregroundColor: AppColor.colorBadgeText,
                  maxRadius: 9,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "9",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "+",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )))
          : Container()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorDashboardBackg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColor.colorTopBarIcons,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColor.colorTopBarIcons,
          size: 35.0,
        ),
        // elevation: 4.0,
        // backgroundColor: Colors.black,
        actions: <Widget>[
          // This button presents popup menu items.
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<Menu>(
                icon: Icon(Icons.account_circle_rounded),
                position: PopupMenuPosition.under,
                onSelected: (item) => onSelected(context, item),
                // Callback that sets the selected popup menu item.
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      PopupMenuItem<Menu>(
                          value: Menu.itemOrgList,
                          child: Row(
                            children: [
                              Icon(
                                Icons.amp_stories_outlined,
                                color: AppColor.colorModelTest,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('OrgList'),
                            ],
                          )),
                      PopupMenuItem<Menu>(
                          value: Menu.itemLogout,
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: AppColor.colorModelTest,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('LogOut'),
                            ],
                          )),
                    ]),
          )
        ],
        elevation: 20,
        // automaticallyImplyLeading: false,
        backgroundColor: AppColor.ColorDark,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isAllUserEmailAddressFetched && myUserEmailAddress != null
                ? Container()
                : const Center(child: CircularProgressIndicator()),
            isAllUserEmailAddressFetched && myUserEmailAddress != null
                ? SingleChildScrollView(
                    child: Column(
                        children: List<Widget>.generate(
                            myUserEmailAddress.userEmailAddress.length,
                            (int index) {
                      return Column(
                        children: [
                          new Container(
                            padding: const EdgeInsets.all(15),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text(
                                    myUserEmailAddress.userEmailAddress[index]
                                        .emailAddress.emailName
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: const Icon(Icons.settings),
                                  //   visualDensity: VisualDensity.compact,
                                  // )
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: const BoxDecoration(
                              color: AppColor.colorTopBarIcons,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border(
                                top: Styling.dashboardBorder,
                                left: Styling.dashboardBorder,
                                right: Styling.dashboardBorder,
                                bottom: Styling.dashboardBorder,
                              ),
                            ),
                            child: Column(
                              children: List<Widget>.generate(
                                  tagLength.elementAt(index) + 1,
                                  (int tagIndex) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: tagIndex != 0
                                      ? const BoxDecoration(
                                          border: Border(
                                            top: Styling.dashboardBorder,
                                          ),
                                        )
                                      : null,
                                  child: InkWell(
                                    onTap: () {
                                      if (tagIndex >=
                                          tagLength.elementAt(index)) {
                                        setState(() {
                                          tagIndex == 3
                                              ? tagLength[index] = tags.length
                                              : tagLength[index] = 3;
                                          clickedUserEmailAddressId =
                                              myUserEmailAddress
                                                  .userEmailAddress[0].id;
                                        });
                                      } else {
                                        var userEmailAddressId =
                                            myUserEmailAddress
                                                .userEmailAddress[index]
                                                .emailAddressId;
                                        var userEmailAddressName =
                                            myUserEmailAddress
                                                .userEmailAddress[index]
                                                .emailAddress
                                                .emailName;
                                        var userCurrentTag = tags[tagIndex];
                                        var emailAddress = myUserEmailAddress
                                            .userEmailAddress[index]
                                            .emailAddress;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(
                                              userEmailAddressId:
                                                  userEmailAddressId,
                                              selectedCurrentTag:
                                                  userCurrentTag,
                                              selectedCurrentUserName:
                                                  userEmailAddressName,
                                              emailAddress: emailAddress,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          tagLength.elementAt(index) > tagIndex
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.center,
                                      children: [
                                        getLeftSideOfBox(index, tagIndex),
                                        tagLength.elementAt(index) > tagIndex
                                            ? Row(children: const [
                                                // Text(getTotalCount(
                                                //     myUserEmailAddress!
                                                //         .userEmailAddress![
                                                //             index]
                                                //         .emailAddressId
                                                //         .toString(),
                                                //    tags[tagIndex]
                                                //         )),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: AppColor
                                                      .colorDashboardIcons,
                                                )
                                              ])
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    })),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void onSelected(BuildContext context, Menu item) {
    switch (item) {
      case Menu.itemLogout:
        Logout.logout();
        break;
      case Menu.itemOrgList:
        moveToOrgListPage();
        break;
    }
  }
}
