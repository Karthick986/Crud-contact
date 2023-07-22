import 'package:crud_contact/contact_crud/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateUpdateContact extends StatefulWidget {
  final ContactData? contactData;
  final bool isUpdate;

  const CreateUpdateContact(
      {super.key, required this.isUpdate, this.contactData});

  @override
  State<CreateUpdateContact> createState() => _CreateUpdateContactState();
}

class _CreateUpdateContactState extends State<CreateUpdateContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String? contactType;
  List<String> contactTypeList = ["Family", "Friend", "Business"];

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      nameController.text = widget.contactData!.contactName.toString();
      mobileController.text = widget.contactData!.contactNo.toString();
      contactType = widget.contactData!.contactType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isUpdate ? "Edit contact" : "Add contact"),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Contact Name"),
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Mobile No.",
                ),
                controller: mobileController,
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: DropdownButton(
                  value: contactType,
                  underline: Container(),
                  icon: Container(),
                  hint: const Text("Contact Type"),
                  items: contactTypeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      contactType = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter name")));
                    } else if (mobileController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter mobile no.")));
                    } else {
                      if (widget.isUpdate) {
                        Map map = {
                          "contactData": ContactData(
                              contactId: widget.contactData!.contactId,
                              contactNo: mobileController.text,
                              contactName: nameController.text,
                              contactType: contactType),
                        };
                        Navigator.pop(context, map);
                      } else {
                        Map map = {
                          "contactData": ContactData(
                              contactId: DateTime.now().microsecondsSinceEpoch,
                              contactNo: mobileController.text,
                              contactName: nameController.text,
                              contactType: contactType),
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
