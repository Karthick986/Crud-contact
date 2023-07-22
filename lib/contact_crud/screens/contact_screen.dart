import 'package:crud_contact/contact_crud/model/contact_model.dart';
import 'package:crud_contact/contact_crud/screens/widgets/create_update_contact.dart';
import 'package:crud_contact/contact_crud/service/contact_service.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactData> contactList = [];
  ContactServiceImpl contactService = ContactServiceImpl();
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();

    getContactList();
  }

  void getContactList() async {
    ContactModel? contactModel = await contactService.getContacts();
    if (contactModel != null) {
      contactList = contactModel.contactList ?? [];
      if (contactList.isNotEmpty) {
        isEmpty = false;
      } else {
        isEmpty = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contacto"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateUpdateContact(
                          isUpdate: false,
                          index: contactList.length + 1,
                        )));
          },
        ),
        body: SafeArea(
          child: !isEmpty
              ? contactList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            "${index + 1}. ${contactList[index].contactName}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              contactList.removeAt(index);
                            },
                          ),
                          onTap: () async {
                            try {
                              final map = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateUpdateContact(
                                            isUpdate: true,
                                            index: contactList.length + 1,
                                            contactData: contactList[index],
                                          )));
                              if (map != null) {
                                if (map["isUpdate"]) {
                                  contactList[index] = map["contactData"];
                                } else {
                                  contactList.add(map["contactData"]);
                                }
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        );
                      },
                      itemCount: contactList.length)
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Text("No contacts available!"),
        ));
  }
}
