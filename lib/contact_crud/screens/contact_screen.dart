import 'package:crud_contact/contact_crud/model/contact_model.dart';
import 'package:crud_contact/contact_crud/screens/widgets/create_update_contact.dart';
import 'package:crud_contact/contact_crud/screens/widgets/filter_sheet.dart';
import 'package:crud_contact/contact_crud/service/contact_service.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactData> allContactList = [];
  List<ContactData> filterContactList = [];
  ContactServiceImpl contactService = ContactServiceImpl();
  bool isEmpty = false;
  String filterValue = "All";

  @override
  void initState() {
    super.initState();
    getContactList();
    print(DateTime.now().microsecondsSinceEpoch);
  }

  void getContactList() async {
    ContactModel? contactModel = await contactService.getContacts();
    if (contactModel != null) {
      allContactList = contactModel.contactList ?? [];
      checkEmpty();
      sortContacts();
    }
  }

  void checkEmpty() {
    if (filterValue == "All") {
      if (allContactList.isNotEmpty) {
        isEmpty = false;
      } else {
        isEmpty = true;
      }
    } else {
      if (filterContactList.isNotEmpty) {
        isEmpty = false;
      } else {
        isEmpty = true;
      }
    }
  }

  void sortContacts() {
    setState(() {
      if (filterValue != "All") {
        filterContactList.sort((a, b) => a.contactName!
            .toLowerCase()
            .compareTo(b.contactName!.toLowerCase()));
      } else {
        allContactList.sort((a, b) => a.contactName!
            .toLowerCase()
            .compareTo(b.contactName!.toLowerCase()));
      }
    });
  }

  Widget subTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Text(title),
    );
  }

  Widget buildContactList(List<ContactData> contactList) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subTitle(contactList[index].contactNo.toString()),
                  subTitle(contactList[index].contactType ?? "")
                ],
              ),
              title: Text(
                contactList[index].contactName.toString(),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < allContactList.length; i++) {
                          if (allContactList[i].contactId ==
                              contactList[index].contactId) {
                            allContactList.removeAt(i);
                            break;
                          }
                        }
                        for (int i = 0; i < filterContactList.length; i++) {
                          if (filterContactList[i].contactId ==
                              contactList[index].contactId) {
                            filterContactList.removeAt(i);
                            break;
                          }
                        }
                        checkEmpty();
                      });
                    },
                  ),
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () async {
                      try {
                        final map = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateUpdateContact(
                                      isUpdate: true,
                                      contactData: contactList[index],
                                    )));
                        if (map != null) {
                          for (int i = 0; i < allContactList.length; i++) {
                            if (allContactList[i].contactId ==
                                contactList[index].contactId) {
                              allContactList[i] = map["contactData"];
                              break;
                            }
                          }
                          filterContactList.clear();
                          filterValue = "All";
                          checkEmpty();
                          sortContacts();
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: contactList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contacto"),
          actions: [
            Visibility(
              visible: allContactList.isNotEmpty,
              child: IconButton(
                  onPressed: () async {
                    try {
                      final contactType = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16))),
                                child: FilterSheet(selectedValue: filterValue),
                              ));

                      if (contactType != null) {
                        setState(() {
                          filterValue = contactType;
                          if (contactType == "All") {
                            filterContactList.clear();
                          } else {
                            filterContactList = allContactList
                                .where((element) =>
                                    element.contactType == filterValue)
                                .toList();
                          }
                        });
                        checkEmpty();
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  icon: const Icon(Icons.filter_alt_outlined)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final map = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateUpdateContact(
                          isUpdate: false,
                        )));
            if (map != null) {
              allContactList.add(map["contactData"]);
              filterContactList.clear();
              filterValue = "All";
              checkEmpty();
              sortContacts();
            }
          },
        ),
        body: SafeArea(
          child: !isEmpty
              ? allContactList.isNotEmpty
                  ? filterValue != "All"
                      ? filterContactList.isNotEmpty
                          ? buildContactList(filterContactList)
                          : const Center(child: Text("No contacts available!"))
                      : buildContactList(allContactList)
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : const Center(child: Text("No contacts available!")),
        ));
  }
}
