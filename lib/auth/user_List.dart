// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/auth/final_reg.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/globals.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> _users = [];

  Future<void> fetchUsers() async {
    try {
      var uri = "${Globals.domainUrl}/getUser";
      print(uri);

      final response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          _users = data['data'];
        });
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      var uri = "${Globals.domainUrl}/delUser?id=$id";
      final response = await http.get(Uri.parse(uri));
      print(uri);
      print(response);
      print(response.body);

      final data = json.decode(response.body);
      if (data['success']) {
        // If deletion is successful, fetch the updated user list
        fetchUsers();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete user: ${data['message']}'),
        ));
      }
    } catch (error) {
      print('Error deleting user: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting user'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user['id'].toString()),
                    ),
                    title: Text(user['username']),
                    subtitle: Text(user['password']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        showProgressIndicator(context);
                        // Call deleteUser method when icon is pressed
                        await deleteUser(user['id']);
                        hideIndicator(context);
                      },
                    ),
                    onTap: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegScreen(id: user['id'])));
                      if (res) {
                        fetchUsers();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
