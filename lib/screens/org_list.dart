import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inbox_flutter_app/api/api.dart';
import 'package:inbox_flutter_app/constants/app_colors.dart';
import 'package:inbox_flutter_app/orgModel/orgs.dart';
import 'package:inbox_flutter_app/orgModel/activeOrg.dart';
import 'package:inbox_flutter_app/screens/dashboard.dart';
import 'package:inbox_flutter_app/utils/logout.dart';

class OrgList extends StatefulWidget {
  const OrgList({Key? key}) : super(key: key);

  @override
  State<OrgList> createState() => _OrgListState();
}

class _OrgListState extends State<OrgList> {
  bool isAllActiveOrgDataFetched = false;
  ActiveOrg? myCurrentUser;
  late Box<String> activeOrgIdBox;

  @override
  void initState() {
    super.initState();
    activeOrgIdBox = Hive.box("activeOrgId");
    fetchOrgList();
  }

// for fetching Orgs
  void fetchOrgList() async {
    try {
      final response = await APICalls.fetchOrgList();
      try {
        myCurrentUser = ActiveOrg.fromJson(response);
        if (myCurrentUser != null) {
          setState(() {
            isAllActiveOrgDataFetched = true;
          });
        }
      } catch (e) {
        log(e.toString());
      }
    } catch (err) {
      log(err.toString());
    }
  }

  void saveSelectedOrgData(Orgs model) async {
    activeOrgIdBox.put("orgId", model.id);

    //redirect to DashboardPage
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DashBoardPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorOrglistBackg,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Org-List',
              style: TextStyle(
                color: AppColor.colorTopBarIcons,
              ),
            ),
            TextButton(
                onPressed: () {
                  Logout.logout();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColor.colorTopBarIcons,
                    fontSize: 18,
                  ),
                )),
          ],
        ),
        elevation: 0,
        // automaticallyImplyLeading: false,
        backgroundColor: AppColor.colorTopBarBackg,
      ),
      body: isAllActiveOrgDataFetched
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: myCurrentUser!.orgs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              saveSelectedOrgData(myCurrentUser!.orgs[index]);
                            },
                            child:
                                ShowOrgsList(org: myCurrentUser!.orgs[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: Text('data loading...')),
    );
  }
}

// Widget for showing single org
class ShowOrgsList extends StatelessWidget {
  ShowOrgsList({Key? key, required this.org}) : super(key: key);

  Orgs org;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          org.name,
          style: const TextStyle(
              color: AppColor.colorOrglistText,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      color: AppColor.colorOrglistTextBackg,
    );
  }
}
