// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userEmailAddress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEmailAddressModelAdapter extends TypeAdapter<UserEmailAddressModel> {
  @override
  final int typeId = 0;

  @override
  UserEmailAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEmailAddressModel()
      .._userEmailAddress = (fields[0] as List?)?.cast<UserEmailAddress>()
      .._unreadCount = (fields[1] as List?)?.cast<UnreadCount>();
  }

  @override
  void write(BinaryWriter writer, UserEmailAddressModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._userEmailAddress)
      ..writeByte(1)
      ..write(obj._unreadCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEmailAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnreadCountAdapter extends TypeAdapter<UnreadCount> {
  @override
  final int typeId = 1;

  @override
  UnreadCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnreadCount()
      .._mailOwner = fields[0] as String?
      .._count = fields[1] as int?;
  }

  @override
  void write(BinaryWriter writer, UnreadCount obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._mailOwner)
      ..writeByte(1)
      ..write(obj._count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnreadCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserEmailAddressAdapter extends TypeAdapter<UserEmailAddress> {
  @override
  final int typeId = 2;

  @override
  UserEmailAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEmailAddress()
      .._id = fields[0] as String?
      .._userId = fields[1] as String?
      .._emailAddressId = fields[2] as String?
      .._orgId = fields[3] as String?
      .._status = fields[4] as String?
      .._signature = (fields[5] as List?)?.cast<String>()
      .._lastVisitedAt = fields[6] as String?
      .._addedBy = fields[7] as String?
      .._updatedBy = fields[8] as String?
      .._createdAt = fields[9] as String?
      .._updatedAt = fields[10] as String?
      .._emailAddress = fields[11] as Email_address?;
  }

  @override
  void write(BinaryWriter writer, UserEmailAddress obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._userId)
      ..writeByte(2)
      ..write(obj._emailAddressId)
      ..writeByte(3)
      ..write(obj._orgId)
      ..writeByte(4)
      ..write(obj._status)
      ..writeByte(5)
      ..write(obj._signature)
      ..writeByte(6)
      ..write(obj._lastVisitedAt)
      ..writeByte(7)
      ..write(obj._addedBy)
      ..writeByte(8)
      ..write(obj._updatedBy)
      ..writeByte(9)
      ..write(obj._createdAt)
      ..writeByte(10)
      ..write(obj._updatedAt)
      ..writeByte(11)
      ..write(obj._emailAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEmailAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailaddressAdapter extends TypeAdapter<Email_address> {
  @override
  final int typeId = 4;

  @override
  Email_address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Email_address()
      .._tags = (fields[0] as List?)?.cast<String>()
      .._email = fields[1] as String?
      .._id = fields[2] as String?
      .._emailName = fields[3] as String?
      .._typeEmail = fields[4] as String?
      .._orgId = fields[5] as String?
      .._isEnabled = fields[6] as bool?
      .._createdBy = fields[7] as String?
      .._updatedBy = fields[8] as String?
      .._domainId = fields[9] as String?
      .._mailCount = fields[10] as int?
      .._createdAt = fields[11] as String?
      .._updatedAt = fields[12] as String?
      .._emailDomainOrg = fields[13] as Email_domain_org?
      .._userEmailAddresses =
          (fields[14] as List?)?.cast<User_email_addresses>();
  }

  @override
  void write(BinaryWriter writer, Email_address obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj._tags)
      ..writeByte(1)
      ..write(obj._email)
      ..writeByte(2)
      ..write(obj._id)
      ..writeByte(3)
      ..write(obj._emailName)
      ..writeByte(4)
      ..write(obj._typeEmail)
      ..writeByte(5)
      ..write(obj._orgId)
      ..writeByte(6)
      ..write(obj._isEnabled)
      ..writeByte(7)
      ..write(obj._createdBy)
      ..writeByte(8)
      ..write(obj._updatedBy)
      ..writeByte(9)
      ..write(obj._domainId)
      ..writeByte(10)
      ..write(obj._mailCount)
      ..writeByte(11)
      ..write(obj._createdAt)
      ..writeByte(12)
      ..write(obj._updatedAt)
      ..writeByte(13)
      ..write(obj._emailDomainOrg)
      ..writeByte(14)
      ..write(obj._userEmailAddresses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailaddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UseremailaddressesAdapter extends TypeAdapter<User_email_addresses> {
  @override
  final int typeId = 5;

  @override
  User_email_addresses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User_email_addresses()
      .._userId = fields[0] as String?
      .._status = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, User_email_addresses obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._userId)
      ..writeByte(1)
      ..write(obj._status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseremailaddressesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmaildomainorgAdapter extends TypeAdapter<Email_domain_org> {
  @override
  final int typeId = 6;

  @override
  Email_domain_org read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Email_domain_org()
      .._id = fields[0] as String?
      .._orgId = fields[1] as String?
      .._domain = fields[2] as String?
      .._status = fields[3] as String?
      .._verified = fields[4] as bool?
      .._createdBy = fields[5] as String?
      .._updatedBy = fields[6] as String?
      .._createdAt = fields[7] as String?
      .._updatedAt = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, Email_domain_org obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._orgId)
      ..writeByte(2)
      ..write(obj._domain)
      ..writeByte(3)
      ..write(obj._status)
      ..writeByte(4)
      ..write(obj._verified)
      ..writeByte(5)
      ..write(obj._createdBy)
      ..writeByte(6)
      ..write(obj._updatedBy)
      ..writeByte(7)
      ..write(obj._createdAt)
      ..writeByte(8)
      ..write(obj._updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmaildomainorgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllMailModelAdapter extends TypeAdapter<AllMailModel> {
  @override
  final int typeId = 7;

  @override
  AllMailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllMailModel()
      .._id = fields[0] as String?
      .._mailOwner = fields[1] as String?
      .._type = fields[2] as String?
      .._mailId = fields[3] as String?
      .._assign = fields[4] as dynamic
      .._currentTag = fields[5] as String?
      .._status = fields[6] as String?
      .._publisherStatus = fields[7] as dynamic
      .._receiverStatus = fields[8] as String?
      .._snoozeTime = fields[9] as dynamic
      .._updatedBy = fields[10] as String?
      .._createdAt = fields[11] as String?
      .._updatedAt = fields[12] as String?
      .._mail = fields[13] as Mail?
      .._mailNotes = (fields[14] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, AllMailModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._mailOwner)
      ..writeByte(2)
      ..write(obj._type)
      ..writeByte(3)
      ..write(obj._mailId)
      ..writeByte(4)
      ..write(obj._assign)
      ..writeByte(5)
      ..write(obj._currentTag)
      ..writeByte(6)
      ..write(obj._status)
      ..writeByte(7)
      ..write(obj._publisherStatus)
      ..writeByte(8)
      ..write(obj._receiverStatus)
      ..writeByte(9)
      ..write(obj._snoozeTime)
      ..writeByte(10)
      ..write(obj._updatedBy)
      ..writeByte(11)
      ..write(obj._createdAt)
      ..writeByte(12)
      ..write(obj._updatedAt)
      ..writeByte(13)
      ..write(obj._mail)
      ..writeByte(14)
      ..write(obj._mailNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllMailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MailAdapter extends TypeAdapter<Mail> {
  @override
  final int typeId = 8;

  @override
  Mail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mail()
      .._id = fields[0] as String?
      .._to = (fields[1] as List?)?.cast<To>()
      .._from = fields[2] as From?
      .._cc = (fields[3] as List?)?.cast<Cc>()
      .._bcc = (fields[4] as List?)?.cast<Bcc>()
      .._subject = fields[5] as String?
      .._body = fields[6] as Body?
      .._messageId = fields[7] as String?
      .._isSent = fields[8] as bool?
      .._threadId = fields[9] as String?
      .._attachments = (fields[10] as List?)?.cast<Attachment>()
      .._inReplyTo = fields[11] as String?
      .._replyTo = fields[12] as dynamic
      .._createdBy = fields[13] as String?
      .._createdAt = fields[14] as String?
      .._updatedAt = fields[15] as String?;
  }

  @override
  void write(BinaryWriter writer, Mail obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._to)
      ..writeByte(2)
      ..write(obj._from)
      ..writeByte(3)
      ..write(obj._cc)
      ..writeByte(4)
      ..write(obj._bcc)
      ..writeByte(5)
      ..write(obj._subject)
      ..writeByte(6)
      ..write(obj._body)
      ..writeByte(7)
      ..write(obj._messageId)
      ..writeByte(8)
      ..write(obj._isSent)
      ..writeByte(9)
      ..write(obj._threadId)
      ..writeByte(10)
      ..write(obj._attachments)
      ..writeByte(11)
      ..write(obj._inReplyTo)
      ..writeByte(12)
      ..write(obj._replyTo)
      ..writeByte(13)
      ..write(obj._createdBy)
      ..writeByte(14)
      ..write(obj._createdAt)
      ..writeByte(15)
      ..write(obj._updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyAdapter extends TypeAdapter<Body> {
  @override
  final int typeId = 9;

  @override
  Body read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Body()
      .._data = fields[0] as String?
      .._type = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Body obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._data)
      ..writeByte(1)
      ..write(obj._type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BccAdapter extends TypeAdapter<Bcc> {
  @override
  final int typeId = 10;

  @override
  Bcc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bcc(
      email: fields[1] as String?,
    ).._email = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Bcc obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._email)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BccAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CcAdapter extends TypeAdapter<Cc> {
  @override
  final int typeId = 11;

  @override
  Cc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cc(
      email: fields[1] as String?,
    ).._email = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Cc obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._email)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CcAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FromAdapter extends TypeAdapter<From> {
  @override
  final int typeId = 12;

  @override
  From read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return From()
      .._email = fields[0] as String?
      .._name = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, From obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._email)
      ..writeByte(1)
      ..write(obj._name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FromAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToAdapter extends TypeAdapter<To> {
  @override
  final int typeId = 13;

  @override
  To read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return To().._email = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, To obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentAdapter extends TypeAdapter<Attachment> {
  @override
  final int typeId = 14;

  @override
  Attachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attachment()
      .._fileName = fields[0] as String?
      .._filePath = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Attachment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._fileName)
      ..writeByte(1)
      ..write(obj._filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
