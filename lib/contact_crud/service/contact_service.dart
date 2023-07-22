import 'dart:convert';
import 'package:crud_contact/contact_crud/model/contact_model.dart';
import 'package:http/http.dart' as http;

abstract class ContactService {
  Future<ContactModel?> getContacts();
}

class ContactServiceImpl extends ContactService {
  @override
  Future<ContactModel?> getContacts() async {
    try {
      final response = await http.get(Uri.parse(
          "https://raw.githubusercontent.com/Karthick986/todo_bloc/main/todo.json"));
      return ContactModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }
}
