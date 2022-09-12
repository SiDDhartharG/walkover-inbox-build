import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/app_colors.dart';
import 'package:inbox/constants/utils.dart';
import 'package:inbox/screens/compose_mail.dart';
import 'package:inbox/screens/mail-list.dart';
import 'package:inbox/widget/bottomnavslider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.userEmailAddressId,
    this.emailAddress,
    this.selectedCurrentTag,
    this.selectedCurrentUserName,
    Key key,
  }) : super(key: key);

  String selectedCurrentTag;
  String userEmailAddressId;
  String selectedCurrentUserName;
  Email_address emailAddress;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTag = "YOURS";
  String currentUserName = "gaurav2";
  bool isLoading = false;
  // ignore: non_constant_identifier_names

  Box<Map<dynamic, dynamic>> allMailBox;
  List<AllMailModel> allEmailToShow = [];
  int mailToSkip = 0;

  void findCurrentTag(newTag) {
    setState(() {
      currentTag = newTag;
      setAllEmailToShow();
    });
  }

  @override
  void initState() {
    super.initState();
    allMailBox = Hive.box("allEmails");
    setState(() {
      if (widget.selectedCurrentTag != "") {
        currentTag = widget.selectedCurrentTag ?? "YOURS";
      }
      setAllEmailToShow();
    });
  }

  void setAllEmailToShow() async {
    dynamic allEmailMapList = allMailBox.get(widget.userEmailAddressId);
    setState(() {
      allEmailToShow = [...allEmailMapList[currentTag]];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MailListPage(
          currentTag: currentTag,
          mailToSkip: mailToSkip,
          notifyParent: setAllEmailToShow,
          isLoading: isLoading,
          fetchedMails: allEmailToShow,
          userEmailAddressId: widget.userEmailAddressId,
          currentUserName: widget.selectedCurrentUserName,
          emailAddress: widget.emailAddress),
      bottomNavigationBar: BottomNavSlider(
          customFuction: findCurrentTag,
          dashboardSelectTag: widget.selectedCurrentTag.toString()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      ComposeScreen(emailAddress: widget.emailAddress)))
              .then((value) async {
            await Future.delayed(const Duration(milliseconds: 500));
            await updateAllEmailOfUserEmailAddressId(
                [widget.userEmailAddressId ?? ""], [mailToSkip]);
            setAllEmailToShow();
          });
        },
        child: const Icon(Icons.edit),
        backgroundColor: AppColor.ColorRed,
        hoverColor: Color.fromARGB(255, 214, 9, 9),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
