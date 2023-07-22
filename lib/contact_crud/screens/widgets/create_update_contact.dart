import 'package:crud_contact/contact_crud/model/contact_model.dart';
import 'package:flutter/material.dart';

class CreateUpdateContact extends StatefulWidget {
  final ContactData? contactData;
  final bool isUpdate;
  final int index;

  const CreateUpdateContact(
      {super.key,
      required this.isUpdate,
      this.contactData,
      required this.index});

  @override
  State<CreateUpdateContact> createState() => _CreateUpdateContactState();
}

class _CreateUpdateContactState extends State<CreateUpdateContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      nameController.text = widget.contactData!.contactName.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isUpdate ? "Edit contact" : "Add contact"),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Contact Name"),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Mobile No."),
                controller: mobileController,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        mobileController.text.isNotEmpty) {
                      if (widget.isUpdate) {
                        Map map = {
                          "contactData": ContactData(
                              contactId: widget.contactData!.contactId,
                              contactNo: mobileController.text,
                              contactName: nameController.text,
                              contactType: nameController.text),
                          "isUpdate": widget.isUpdate
                        };
                        Navigator.pop(context, map);
                      } else {
                        Map map = {
                          "contactData": ContactData(
                              contactId: widget.index+1,
                              contactNo: mobileController.text,
                              contactName: nameController.text,
                              contactType: nameController.text),
                          "isUpdate": widget.isUpdate
                        };
                        Navigator.pop(context, map);
                      }
                    }
                  },
                  child: Text(widget.isUpdate ? "Update" : "Create"))
            ],
          ),
        ));
  }
}
