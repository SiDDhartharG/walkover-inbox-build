import 'package:flutter/foundation.dart';
import 'package:inbox/constants/app_colors.dart';
// ignore_for_file: prefer_typing_uninitialized_variablesimport 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inbox/api/api.dart';
import 'package:inbox/apiModel/data.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/widget/sheet_content.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ComposeScreen extends StatefulWidget {
  AllMailModel? mailItem;
  String selectedOption;
  Email_address? emailAddress;
  ComposeScreen(
      {Key? key,
      this.mailItem,
      required this.emailAddress,
      this.selectedOption = ""})
      : super(key: key);

  @override
  State<ComposeScreen> createState() => ComposeScreenState();
}

class ComposeScreenState extends State<ComposeScreen>
    with SingleTickerProviderStateMixin {
  late var to;
  late var cc;
  late var bcc;
  bool showDrop = false;
  bool iconVis = true;

  List<Map<String, dynamic>> attachment = [
    // {
    //   "fileName": "pritam",
    //   "filePath":
    //       "https://www.youtube.com/watch?v=70QpN7DvaK4&ab_channel=SonyMusicIndiaVEVO"
    // }
  ];

  List<String> sendButtonsList = [
    "Send",
    "Send and Snooze for a day",
    "Send and Snooze for 2 day",
    "Send and Snooze for 3 day",
    "Send and Close"
  ];
  double _distanceToField = 0;
  TextfieldTagsController? _toController;
  TextfieldTagsController? _ccController;
  TextfieldTagsController? _bccController;
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  late DateTime pickedDate;
  late TimeOfDay pickedTime;
  late Box<List<String>> emailAddressList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    emailAddressList = Hive.box("allEmailAddress");
    parentEmails = emailAddressList.get("allEmailAddress") ?? [];
    _toController = TextfieldTagsController();
    _ccController = TextfieldTagsController();
    _bccController = TextfieldTagsController();

    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
    _subjectController.text = (widget.selectedOption == "Forward"
            ? "Fwd: ${widget.mailItem!.mail!.subject}"
            : "") ??
        "";
    _bodyController.text = (widget.selectedOption == "Forward"
            ? """
        ---------- Forwarded message --------- 
        From: ${widget.mailItem!.mail!.from!.name} <${widget.mailItem!.mail!.from!.email}> 
        Date & Time: ${widget.mailItem!.mail!.createdAt} 
        Subject: ${widget.mailItem!.mail!.subject}  
        To: ${widget.mailItem!.mail!.to![0].email}   
        \n\n\n${widget.mailItem!.mail!.body!.data}"""
            : "") ??
        "";
    if (widget.selectedOption == "Reply") {
      Future.delayed(const Duration(milliseconds: 70), () {
        var from = widget.mailItem!.mail!.from!.email ??
            widget.mailItem!.mail!.from!.address;
        var to = widget.mailItem!.mail!.to;
        var emailAddressName = widget.emailAddress!.email;
        var toArray =
            List.generate(to!.length, (i) => to[i].email ?? to[i].address);
        if (from != emailAddressName) {
          _toController!.addTag = from.toString();
        } else {
          _toController!.addTag = toArray[0].toString();
        }
      });
    }
    if (widget.selectedOption == "Reply all") {
      Future.delayed(const Duration(milliseconds: 70), () {
        var from = widget.mailItem!.mail!.from!.email ??
            widget.mailItem!.mail!.from!.address;
        var to = widget.mailItem!.mail!.to;
        var cc = widget.mailItem!.mail!.cc;
        var emailAddressName = widget.emailAddress!.email;
        var toArray =
            List.generate(to!.length, (i) => to[i].email ?? to[i].address);
        var ccArray =
            List.generate(cc!.length, (i) => cc[i].email ?? cc[i].email);
        toArray.forEach((element) {
          if (element != emailAddressName)
            _toController?.addTag = element.toString();
        });
        ccArray.forEach((element) {
          if (element != emailAddressName)
            _toController?.addTag = element.toString();
        });
        if (from != emailAddressName) {
          _toController?.addTag = from!;
        }
        // print(toArray.toArray[0].toString());
      });
    }
  }

  @override
  void dispose() {
    _toController!.dispose();
    _ccController!.dispose();
    _bccController!.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool isEmail(var emailAddresses) {
    bool validity = true;
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);

    emailAddresses.forEach((element) => {
          validity = regExp.hasMatch(element.toString()) & validity,
        });

    return validity;
  }

  void _handellsend() {
    to = _toController?.getTags;
    bool toEmailValid = (to.isNotEmpty) ? isEmail(to) : false;
    bool ccEmailValid = true;
    bool bccEmailValid = true;
    if (!iconVis) {
      cc = _ccController?.getTags;
      bcc = _bccController?.getTags;
      ccEmailValid = (cc.isNotEmpty) ? isEmail(cc) : true;
      bccEmailValid = (bcc.isNotEmpty) ? isEmail(bcc) : true;
    }

    if (!toEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('To field is not valid '),
          backgroundColor: AppColor.colorSnackBarWarning,
        ),
      );
    } else if (!ccEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cc field is not valid'),
          backgroundColor: AppColor.colorSnackBarWarning,
        ),
      );
    } else if (!bccEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bcc field is not valid'),
          backgroundColor: AppColor.colorSnackBarWarning,
        ),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 450,
            color: AppColor.colorComposeBackg,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      alignment: Alignment.topRight,
                      icon: const Icon(Icons.close),
                      iconSize: 24,
                      color: AppColor.colorComposeIcons,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SheetContent(
                    options: sendButtonsList, selectedOption: composeMail)
              ],
            ),
          );
        },
      );
    }
  }

  List<String> parentEmails = [];

  selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 5,
      ),
    );
    if (selectedDate != null) {
      setState(() {
        pickedDate = selectedDate;
      });
    }
  }

  void composeMail(selectedOption) async {
    if (sendButtonsList.contains(selectedOption)) {
      var selectedOptionsIndex = sendButtonsList.indexOf(selectedOption);
      dynamic toEmailIds =
          List.generate(to.length, (i) => {"email": to[i].trim()});
      // if expand_more not clicked ccEmailIds,bccEmailIds will be initialised with empty list

      dynamic ccEmailIds = !iconVis
          ? List.generate(cc.length, (i) => {"email": cc[i].trim()})
          : [];
      dynamic bccEmailIds = !iconVis
          ? List.generate(bcc.length, (i) => {"email": bcc[i].trim()})
          : [];
      dynamic model = {
        "to": toEmailIds,
        "from": widget.emailAddress!.id,
        "cc": ccEmailIds,
        "bcc": bccEmailIds,
        "body": {"data": _bodyController.value.text, "type": "text/html"},
        "subject": _subjectController.value.text != ""
            ? _subjectController.value.text
            : "(no subject)",
        "attachments": attachment,
        "request_id": const Uuid().v4(),
        "current_tag": selectedOption != "ALL" ? "ALL" : "SNOOZE",
        "snooze_time": null
      };
      if (selectedOptionsIndex != 0 && selectedOptionsIndex != 5) {
        dynamic now = DateTime.now();
        if (selectedOptionsIndex == 1) {
          model["snooze_time"] =
              now.toIso8601String().substring(0, 10) + 'T18:00:00.000';
        } else {
          if (selectedOptionsIndex == 2) {
            model["snooze_time"] = DateTime(now.year, now.month, now.day + 1,
                    now.hour, now.month, now.second)
                .toIso8601String();
          } else {
            if (selectedOptionsIndex == 3) {
              model["snooze_time"] = DateTime(now.year, now.month, now.day + 2,
                      now.hour, now.month, now.second)
                  .toIso8601String();
            } else {
              if (selectedOptionsIndex == 4) {
                model["current_tag"] = "CLOSED";
              }
            }
          }
        }
      }
      try {
        await APICalls.sendComposedEmail(model);
        // Navigator.pop(context);
        if (widget.selectedOption != null) {
          Navigator.of(context).pop();
        }
        //widget.fetchAllMails();
      } catch (err) {
        log(err.toString());
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Mail Not Sent'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('There was an error while sending the mail'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, withData: true);
    for (var fileObject in result!.files) {
      try {
        int statusCode = 500;
        final Map<String, dynamic> response =
            await APICalls.fileupload(fileObject.name);
        String contentType = lookupMimeType(fileObject.name) ?? "";
        statusCode = await APICalls.uploadFileInAWSWeb(
            response[response.keys.toList().first],
            fileObject.bytes!.toList(),
            contentType);
        if (statusCode == 200) {
          // FILE UPLOAD SUCCESS
          setState(() {
            attachment.add({
              "fileName": fileObject.name,
              "filePath": response[response.keys.toList().first]
                  .toString()
                  .split("?")[0]
            });
          });
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('File Not Attached'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('There was an error while attaching the file'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget autoCompFun(_controller, field) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: AppColor.colorComposeText,
            width: 1.0,
          ),
        )),
        child: Row(children: <Widget>[
          Text("$field"),
          Expanded(
            flex: 12,
            child: Column(
              children: <Widget>[
                Autocomplete<String>(
                  optionsViewBuilder: (context, onSelected, options) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          elevation: 4.0,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic option = options.elementAt(index);
                                return TextButton(
                                  onPressed: () {
                                    onSelected(option);
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text(
                                        option,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    Iterable<String> filteredListFromStoredEmail =
                        parentEmails.where((String option) {
                      return option
                          .contains(textEditingValue.text.toLowerCase());
                    }).toList();
                    Iterable<String> listToReturn =
                        filteredListFromStoredEmail.where((email) {
                      return !_controller!.getTags!.contains(email);
                    });
                    return listToReturn;
                  },
                  onSelected: (String selectedTag) {
                    _controller?.addTag = selectedTag;
                  },
                  fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                    return TextFieldTags(
                      textEditingController: ttec,
                      focusNode: tfn,
                      textfieldTagsController: _controller,
                      initialTags: const [],
                      textSeparators: const [' ', ','],
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(tag)) {
                          return 'Wrong Email address';
                        }
                        if (_controller!.getTags!.contains(tag)) {
                          return 'you already entered that';
                        }
                        return null;
                      },
                      inputfieldBuilder:
                          (context, tec, fn, error, onChanged, onSubmitted) {
                        return ((context, sc, tags, onTagDelete) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: TextField(
                              controller: tec,
                              focusNode: fn,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorText: error,
                                prefixIconConstraints: BoxConstraints(
                                    maxWidth: _distanceToField * 0.74),
                                prefixIcon: tags.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 1.0, vertical: 4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12.0)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      tag,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0)),
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    InkWell(
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        size: 14.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      onTap: () {
                                                        onTagDelete(tag);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                      )
                                    : null,
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                            ),
                          );
                        });
                      },
                    );
                  },
                )
              ],
            ),
          ),
          Visibility(
            visible: iconVis,
            child: InkWell(
                onTap: () {
                  setState(() {
                    showDrop = true;
                    iconVis = false;
                  });
                },
                child: Icon(Icons.expand_more)),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colorComposeBackg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: AppColor.colorComposeIcons,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Save",
          style: TextStyle(color: AppColor.colorComposeIcons),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _pickFile();
              },
              icon: const Icon(
                Icons.attachment_outlined,
                color: AppColor.colorComposeIcons,
              )),
          IconButton(
            onPressed: _handellsend,
            icon: const Icon(Icons.send),
            iconSize: 24,
            color: AppColor.colorComposeIcons,
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.expand_more),
          //   iconSize: 24,
          //   color: AppColor.colorComposeIcons,
          // ),
        ],
      ),
      body: Column(
        children: [
          autoCompFun(_toController, "To"),
          Visibility(
            visible: showDrop,
            child: Column(
              children: [
                autoCompFun(_ccController, "Cc"),
                autoCompFun(_bccController, "Bcc")
              ],
            ),
          ),
          TextFormField(
            controller: _subjectController,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  top: kPadding - 7,
                  left: kPadding - 10,
                  right: kPadding - 10,
                  bottom: kPadding - 7),
              hintText: 'Subject',
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _bodyController,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    top: kPadding - 10,
                    left: kPadding - 10,
                    right: kPadding - 10),
                hintText: 'Compose mail',
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
            ),
          ),
          attachment.isNotEmpty
              ? Expanded(
                  child: Column(
                  children: attachment.map((a) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                              child: Text(a?["fileName"] ?? '',
                                  textAlign: TextAlign.left),
                              onPressed: () {
                                if (kIsWeb) {
                                  _launchURL(a["filePath"]!);
                                } else {
                                  OpenFile.open(a["filePath"]!);
                                }
                              },
                            )),
                            TextButton(
                              onPressed: () {
                                int index = attachment.indexWhere((element) {
                                  return element["filePath"] == a["filePath"];
                                });
                                if (index >= 0) {
                                  setState(() {
                                    attachment.removeAt(index);
                                  });
                                }
                              },
                              child: Icon(Icons.close),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ))
              : Container(),
        ],
      ),
    );
  }
}

_launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
