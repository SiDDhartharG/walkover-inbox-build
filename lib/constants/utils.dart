//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inbox_flutter_app/api/api.dart';
import 'package:inbox_flutter_app/apiModel/userEmailAddress.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
}

List<String> ALL_TAGS = [
  "ALL",
  "UNASSIGNED",
  "YOURS",
  "CLOSED",
  "SENT",
  "SNOOZE",
  "DELETE",
  "FIRST SENDER",
];

// Map<String, List<AllMailModel>> EMPTY_ARRAY_OBJECT_OF_ALL_EMAIL_TAGS = {
//   "ALL": [],
//   "UNASSIGNED": [],
//   "YOURS": [],
//   "CLOSED": [],
//   "SENT": [],
//   "SNOOZE": [],
//   "DELETE": [],
//   "FIRST SENDER": []
// };

int getCountOfStatusFromMallMailModelList(
    String status, List<dynamic> mailList) {
  int result = 0;
  for (var mailObject in mailList) {
    if (mailObject.status == status) result++;
  }
  return result;
}

Future<void> updateAllEmailOfUserEmailAddressId(
    List<String> userEmailAddressIdList, List<int> mailList) async {
  Box allMailBox = Hive.box<Map<dynamic, dynamic>>("allEmails");

  for (int i = 0; i < userEmailAddressIdList.length; i++) {
    // fetch all email
    await allMailBox.put(
        userEmailAddressIdList[i],
        await functionToGiveAllEmailTagwise(
            userEmailAddressIdList[i], mailList[i]));
  }
}

void changeMailStatusReadOrUnread(
    String mailId, String userEmailAddressId, String newStatus) async {
  // GET DATA FROM HIVE TO VAR
  Box allMailBox = Hive.box<Map<dynamic, dynamic>>("allEmails");

  Map<String, List<AllMailModel>> dataFromHive =
      allMailBox.get(userEmailAddressId) as Map<String, List<AllMailModel>>;

  // UPDATE DATA IN VAR

  int? index = dataFromHive["ALL"]
      ?.indexWhere((emailObjetc) => emailObjetc.id == mailId);

  if (index == null || index == -1) {
    return;
  }

  dataFromHive["ALL"]?[index].status = newStatus;

  String? currentStatusOfEmail = dataFromHive["ALL"]?[index].currentTag;
  if (currentStatusOfEmail != "ALL") {
    index = dataFromHive[currentStatusOfEmail]
        ?.indexWhere((emailObjetc) => emailObjetc.id == mailId);
    if (index == null || index == -1) {
      return;
    }
    dataFromHive[currentStatusOfEmail]?[index].status = newStatus;
  }

  // UPDATE DATA IN HIVE
  await allMailBox.put(userEmailAddressId, dataFromHive);
}

Future<Map<String, List<AllMailModel>>> functionToGiveAllEmailTagwise(
    String userEmailAddressId, int skipMail) async {
  final response =
      await APICalls.getAllEmails(userEmailAddressId, 'ALL', skipMail);
  List<AllMailModel> allEmailList = response
      .map<AllMailModel>((dynamic json) => AllMailModel.fromJson(json))
      .toList();

  Map<String, List<AllMailModel>> allList;

  if (skipMail == 0) {
    allList = {
      "ALL": [],
      "UNASSIGNED": [],
      "YOURS": [],
      "CLOSED": [],
      "SENT": [],
      "SNOOZE": [],
      "DELETE": [],
      "FIRST SENDER": []
    };
  } else {
    Box allMailBox = Hive.box<Map<dynamic, dynamic>>("allEmails");
    allList =
        allMailBox.get(userEmailAddressId)!.cast<String, List<AllMailModel>>();
  }
  // ignore: unnecessary_cast
  allList = await addTagInRspectiveMap(allList, allEmailList)
      as Map<String, List<AllMailModel>>;
  storeAllEmailFromAllMailModelAndStoreInHive(allList['ALL'] ?? []);
  return allList;
}

Future<Map<String, List<AllMailModel>>> addTagInRspectiveMap(
    Map<String, List<AllMailModel>> allList,
    List<AllMailModel> allEmailList) async {
  var res1 = await APICalls.getCurretUser();
// var you eamil = ""
  for (var emailObject in allEmailList) {
    allList['ALL'] = addInGivenArray(allList['ALL'] ?? [], emailObject);
    if ("ALL" != emailObject.currentTag.toString()) {
      allList[emailObject.currentTag.toString()] =
          addInGivenArray(allList[emailObject.currentTag] ?? [], emailObject);
    }

    if (emailObject.mail!.from!.email
            .toString()
            .replaceAll('@okskul.com', '') ==
        res1['email'].toString().replaceAll("@gmail.com", '')) {
      allList["SENT"] = addInGivenArray(allList["SENT"] ?? [], emailObject);
    }
  }

  return allList;
}

void storeAllEmailFromAllMailModelAndStoreInHive(
    List<AllMailModel> allEmailObject) async {
  // IMPORT HIVR
  Box allEmailAddress;
  allEmailAddress = Hive.box<List<String>>("allEmailAddress");

  // STORE ALL EMAIL ADDRESS IN VAR
  Set<String> allEmailAddressToStore = {};
  for (var emailObject in allEmailObject) {
    // allEmails.add
    emailObject.mail?.to?.forEach((email) {
      allEmailAddressToStore.add(email.email.toString());
    });
    allEmailAddressToStore.add(emailObject.mailOwner.toString());
  }

  // STORE VAR IN HIVE
  allEmailAddress.put("allEmailAddress", allEmailAddressToStore.toList());
}

List<AllMailModel> addInGivenArray(
    List<AllMailModel>? list, AllMailModel object) {
  try {
    List<AllMailModel>? result = [];
    if (list != null) {
      result = list.cast<AllMailModel>();
    }
    result.add(object);
    return result;
  } catch (e) {
    return [];
  }
}
