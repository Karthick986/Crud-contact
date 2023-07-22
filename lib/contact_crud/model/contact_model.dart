class ContactModel {
  List<ContactData>? contactList;

  ContactModel({required this.contactList});

  factory ContactModel.fromJson(List json) => ContactModel(
      contactList:
          List<ContactData>.from(json.map((x) => ContactData.fromJson(x))));
}

class ContactData {
  dynamic contactId;
  String? contactName;
  String? contactNo;
  String? contactType;

  ContactData(
      {this.contactId, this.contactName, this.contactNo, this.contactType});

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
      contactId: json["contactId"],
      contactName: json["contactName"],
      contactNo: json["contactNo"],
      contactType: json["contactType"]);
}
