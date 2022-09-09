import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final Function setList;
  final String hint;
  final List<String> parentEmails;

  const EmailInput(Key key, this.setList, this.hint, this.parentEmails)
      : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  TextEditingController _emailController = TextEditingController();
  String lastValue = '';
  List<String> emails = [];
  FocusNode focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    focus.addListener(() {
      if (!focus.hasFocus) {
        updateEmails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
              minWidth: 0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: <Widget>[
                  ...emails
                      .map(
                        (email) => Chip(
                          avatar: CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                const Color.fromARGB(255, 62, 60, 60),
                            child: Text(
                              email.substring(0, 1),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                          labelPadding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          backgroundColor: Colors.grey,
                          label: Text(
                            email,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black),
                          ),
                          onDeleted: () => {
                            setState(() {
                              emails.removeWhere((element) => email == element);
                            })
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration.collapsed(hintText: widget.hint),
            controller: _emailController,
            autofillHints: widget.parentEmails,
            focusNode: focus,
            onChanged: (String val) {
              setState(() {
                if (val != lastValue) {
                  lastValue = val;
                  if (val.endsWith(' ') && validateEmail(val.trim())) {
                    if (!emails.contains(val.trim())) {
                      emails.add(val.trim());
                      widget.setList(emails);
                    }
                    _emailController.clear();
                  } else if (val.endsWith(' ') && !validateEmail(val.trim())) {
                    _emailController.clear();
                  }
                }
              });
            },
            onEditingComplete: () {
              updateEmails();
            },
          )
        ],
      ),
    );
  }

  updateEmails() {
    setState(() {
      if (validateEmail(_emailController.text)) {
        if (!emails.contains(_emailController.text)) {
          emails.add(_emailController.text.trim());
          widget.setList(emails);
        }
        _emailController.clear();
      } else if (!validateEmail(_emailController.text)) {
        _emailController.clear();
      }
    });
  }

  setEmails(List<String> emails) {
    this.emails = emails;
  }
}

bool validateEmail(String value) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);

  return emailValid;
}
