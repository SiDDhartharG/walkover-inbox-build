// /// _id : "Y8IfgW13wscclE5i"
// /// mail_owner : "gaurav2@devsmail.intospace.io"
// /// type : "CC"
// /// mail_id : "UlWeKpeNBz8kJJEk"
// /// assign : null
// /// current_tag : "ALL"
// /// status : "READ"
// /// publisher_status : null
// /// receiver_status : "received"
// /// snooze_time : null
// /// updatedBy : "2tP6vAHic9lp05Tf"
// /// createdAt : "2021-12-15T13:48:09.629Z"
// /// updatedAt : "2021-12-18T12:59:37.973Z"
// /// mail : {"_id":"UlWeKpeNBz8kJJEk","to":[{"email":"gaurav@devsmail.intospace.io"}],"from":{"email":"gaurav@devsmail.intospace.io","name":"Gaurav  Singh "},"cc":[{"email":"gaurav@devsmail.intospace.io"},{"email":"rohit@devsmail.intospace.io"},{"email":"gaurav2@devsmail.intospace.io"}],"bcc":[{"email":"dipa@g.com"}],"subject":"testing the reply","body":{"data":"<p>Hello Everyone😍😍😍😍</p>","type":"text/html"},"message_id":"<1639576084-iEPa6kgHamlh2YVn@devsmail.intospace.io>","isSent":true,"thread_id":"376188","attachments":[""],"in_reply_to":"false","replyTo":null,"createdBy":"2tP6vAHic9lp05Tf","createdAt":"2021-12-15T13:48:03.973Z","updatedAt":"2021-12-15T13:48:04.631Z"}
// /// mail_notes : [""]

// class AllMailModel {
//   String? _id;
//   String? _mailOwner;
//   String? _type;
//   String? _mailId;
//   dynamic _assign;
//   String? _currentTag;
//   String? _status;
//   dynamic _publisherStatus;
//   String? _receiverStatus;
//   dynamic _snoozeTime;
//   String? _updatedBy;
//   String? _createdAt;
//   String? _updatedAt;
//   Mail? _mail;
//   List<String>? _mailNotes;

//   String? get id => _id;
//   String? get mailOwner => _mailOwner;
//   String? get type => _type;
//   String? get mailId => _mailId;
//   dynamic get assign => _assign;
//   String? get currentTag => _currentTag;
//   String? get status => _status;
//   dynamic get publisherStatus => _publisherStatus;
//   String? get receiverStatus => _receiverStatus;
//   dynamic get snoozeTime => _snoozeTime;
//   String? get updatedBy => _updatedBy;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   Mail? get mail => _mail;
//   List<String>? get mailNotes => _mailNotes;

//   AllMailModel(
//       {String? id,
//       String? mailOwner,
//       String? type,
//       String? mailId,
//       dynamic assign,
//       String? currentTag,
//       String? status,
//       dynamic publisherStatus,
//       String? receiverStatus,
//       dynamic snoozeTime,
//       String? updatedBy,
//       String? createdAt,
//       String? updatedAt,
//       Mail? mail,
//       List<String>? mailNotes}) {
//     _id = id;
//     _mailOwner = mailOwner;
//     _type = type;
//     _mailId = mailId;
//     _assign = assign;
//     _currentTag = currentTag;
//     _status = status;
//     _publisherStatus = publisherStatus;
//     _receiverStatus = receiverStatus;
//     _snoozeTime = snoozeTime;
//     _updatedBy = updatedBy;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _mail = mail;
//     _mailNotes = mailNotes;
//   }

//   AllMailModel.fromJson(dynamic json) {
//     _id = json['_id'];
//     _mailOwner = json['mail_owner'];
//     _type = json['type'];
//     _mailId = json['mail_id'];
//     _assign = json['assign'];
//     _currentTag = json['current_tag'];
//     _status = json['status'];
//     _publisherStatus = json['publisher_status'];
//     _receiverStatus = json['receiver_status'];
//     _snoozeTime = json['snooze_time'];
//     _updatedBy = json['updatedBy'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//     _mail = json['mail'] != null ? Mail.fromJson(json['mail']) : null;
//     _mailNotes =
//         json['mail_notes'] != null ? json['mail_notes'].cast<String>() : [];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['mail_owner'] = _mailOwner;
//     map['type'] = _type;
//     map['mail_id'] = _mailId;
//     map['assign'] = _assign;
//     map['current_tag'] = _currentTag;
//     map['status'] = _status;
//     map['publisher_status'] = _publisherStatus;
//     map['receiver_status'] = _receiverStatus;
//     map['snooze_time'] = _snoozeTime;
//     map['updatedBy'] = _updatedBy;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     if (_mail != null) {
//       map['mail'] = _mail?.toJson();
//     }
//     map['mail_notes'] = _mailNotes;
//     return map;
//   }
// }

// /// _id : "UlWeKpeNBz8kJJEk"
// /// to : [{"email":"gaurav@devsmail.intospace.io"}]
// /// from : {"email":"gaurav@devsmail.intospace.io","name":"Gaurav  Singh "}
// /// cc : [{"email":"gaurav@devsmail.intospace.io"},{"email":"rohit@devsmail.intospace.io"},{"email":"gaurav2@devsmail.intospace.io"}]
// /// bcc : [{"email":"dipa@g.com"}]
// /// subject : "testing the reply"
// /// body : {"data":"<p>Hello Everyone😍😍😍😍</p>","type":"text/html"}
// /// message_id : "<1639576084-iEPa6kgHamlh2YVn@devsmail.intospace.io>"
// /// isSent : true
// /// thread_id : "376188"
// /// attachments : [""]
// /// in_reply_to : "false"
// /// replyTo : null
// /// createdBy : "2tP6vAHic9lp05Tf"
// /// createdAt : "2021-12-15T13:48:03.973Z"
// /// updatedAt : "2021-12-15T13:48:04.631Z"

// class Mail {
//   String? _id;
//   List<To>? _to;
//   From? _from;
//   List<Cc>? _cc;
//   List<Bcc>? _bcc;
//   String? _subject;
//   Body? _body;
//   String? _messageId;
//   bool? _isSent;
//   String? _threadId;
//   List<String>? _attachments;
//   String? _inReplyTo;
//   dynamic _replyTo;
//   String? _createdBy;
//   String? _createdAt;
//   String? _updatedAt;

//   String? get id => _id;
//   List<To>? get to => _to;
//   From? get from => _from;
//   List<Cc>? get cc => _cc;
//   List<Bcc>? get bcc => _bcc;
//   String? get subject => _subject;
//   Body? get body => _body;
//   String? get messageId => _messageId;
//   bool? get isSent => _isSent;
//   String? get threadId => _threadId;
//   List<String>? get attachments => _attachments;
//   String? get inReplyTo => _inReplyTo;
//   dynamic get replyTo => _replyTo;
//   String? get createdBy => _createdBy;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Mail(
//       {String? id,
//       List<To>? to,
//       From? from,
//       List<Cc>? cc,
//       List<Bcc>? bcc,
//       String? subject,
//       Body? body,
//       String? messageId,
//       bool? isSent,
//       String? threadId,
//       List<String>? attachments,
//       String? inReplyTo,
//       dynamic replyTo,
//       String? createdBy,
//       String? createdAt,
//       String? updatedAt}) {
//     _id = id;
//     _to = to;
//     _from = from;
//     _cc = cc;
//     _bcc = bcc;
//     _subject = subject;
//     _body = body;
//     _messageId = messageId;
//     _isSent = isSent;
//     _threadId = threadId;
//     _attachments = attachments;
//     _inReplyTo = inReplyTo;
//     _replyTo = replyTo;
//     _createdBy = createdBy;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   Mail.fromJson(dynamic json) {
//     _id = json['_id'];
//     if (json['to'] != null) {
//       _to = [];
//       json['to'].forEach((v) {
//         _to?.add(To.fromJson(v));
//       });
//     }
//     _from = json['from'] != null ? From.fromJson(json['from']) : null;
//     if (json['cc'] != null) {
//       _cc = [];
//       json['cc'].forEach((v) {
//         _cc?.add(Cc.fromJson(v));
//       });
//     }
//     if (json['bcc'] != null) {
//       _bcc = [];
//       json['bcc'].forEach((v) {
//         _bcc?.add(Bcc.fromJson(v));
//       });
//     }
//     _subject = json['subject'];
//     _body = json['body'] != null ? Body.fromJson(json['body']) : null;
//     _messageId = json['message_id'];
//     _isSent = json['isSent'];
//     _threadId = json['thread_id'];
//     _attachments =
//         json['attachments'] != null ? json['attachments'].cast<String>() : [];
//     _inReplyTo = json['in_reply_to'];
//     _replyTo = json['replyTo'];
//     _createdBy = json['createdBy'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['_id'] = _id;
//     if (_to != null) {
//       map['to'] = _to?.map((v) => v.toJson()).toList();
//     }
//     if (_from != null) {
//       map['from'] = _from?.toJson();
//     }
//     if (_cc != null) {
//       map['cc'] = _cc?.map((v) => v.toJson()).toList();
//     }
//     if (_bcc != null) {
//       map['bcc'] = _bcc?.map((v) => v.toJson()).toList();
//     }
//     map['subject'] = _subject;
//     if (_body != null) {
//       map['body'] = _body?.toJson();
//     }
//     map['message_id'] = _messageId;
//     map['isSent'] = _isSent;
//     map['thread_id'] = _threadId;
//     map['attachments'] = _attachments;
//     map['in_reply_to'] = _inReplyTo;
//     map['replyTo'] = _replyTo;
//     map['createdBy'] = _createdBy;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }
// }

// /// data : "<p>Hello Everyone😍😍😍😍</p>"
// /// type : "text/html"

// class Body {
//   String? _data;
//   String? _type;

//   String? get data => _data;
//   String? get type => _type;

//   Body({String? data, String? type}) {
//     _data = data;
//     _type = type;
//   }

//   Body.fromJson(dynamic json) {
//     _data = json['data'];
//     _type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['data'] = _data;
//     map['type'] = _type;
//     return map;
//   }
// }

// /// email : "dipa@g.com"

// class Bcc {
//   String? _email;

//   String? get email => _email;

//   Bcc({String? email}) {
//     _email = email;
//   }

//   Bcc.fromJson(dynamic json) {
//     _email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['email'] = _email;
//     return map;
//   }
// }

// /// email : "gaurav@devsmail.intospace.io"

// class Cc {
//   String? _email;

//   String? get email => _email;

//   Cc({String? email}) {
//     _email = email;
//   }

//   Cc.fromJson(dynamic json) {
//     _email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['email'] = _email;
//     return map;
//   }
// }

// /// email : "gaurav@devsmail.intospace.io"
// /// name : "Gaurav  Singh "

// class From {
//   String? _email;
//   String? _name;

//   String? get email => _email;
//   String? get name => _name;

//   From({String? email, String? name}) {
//     _email = email;
//     _name = name;
//   }

//   From.fromJson(dynamic json) {
//     _email = json['email'];
//     _name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['email'] = _email;
//     map['name'] = _name;
//     return map;
//   }
// }

// /// email : "gaurav@devsmail.intospace.io"

// class To {
//   String? _email;

//   String? get email => _email;

//   To({String? email}) {
//     _email = email;
//   }

//   To.fromJson(dynamic json) {
//     _email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['email'] = _email;
//     return map;
//   }
// }
