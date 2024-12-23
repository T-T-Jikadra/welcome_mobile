// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, file_names, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/globals.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/models/itemModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/masters/itemMaster/add_item.dart';
import 'package:welcome_mob/masters/itemMaster/itemView.dart';

class ItemMaster extends StatefulWidget {
  const ItemMaster({super.key});

  @override
  State<ItemMaster> createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemMaster> {
  String url = '';
  List<itemModel> itemData = [];

  @override
  void initState() {
    super.initState();
    // loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "List of Items"),
      body: FutureBuilder<List<itemModel>>(
        future: loadDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<itemModel> item = snapshot.data!;
            return itemView(
                api: url,
                DataFormat: '<b>#name#<b> ',
                onAdd: onAdd,
                onBack: onBack,
                onPDF: onPDF,
                onDel: onDel,
                onEdit: onEdit,
                onView: onView,
                TableName: 'itemmst',
                defSearch: 'name',
                Data: item);
          }
        },
      ),
    );
  }

  void onAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddItem(id: 0)))
        .then((value) {
      loadDetails();
    });
  }

  void onEdit(id, data) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddItem(id: id)))
        .then((value) {
      loadDetails();
    });
  }

  void onView(id, data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddItem(id: id, readOnly: true)));
  }

  void onBack() {
    print('You Clicked Back..');
    Navigator.pop(context);
  }

  void onPDF(id) {
    print(id);
    print('Clicked PDF');
  }

  void onDel(id) {
    print('Del Clicked...');
    showDeleteDialog(
      mst: true,
      context,
      moduleName: "Item",
      id: id,
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        deleteItem(id);
        // Navigator.pop(context);
      },
    );
  }

  Future<void> deleteItem(int id) async {
    setState(() {
      itemData.removeWhere((record) => record.id == id);
    });
    await _saveTaskToFile(id: id);
    await loadDetails();
  }

  Future<void> _saveTaskToFile({int? id = 0}) async {
    final filePath = await getFilePath(Globals.file_item);
    final file = File(filePath);

    List<Map<String, dynamic>> taskMapList =
        itemData.map((task) => task.toMap()).toList();

    String jsonString = jsonEncode(taskMapList);
    await file.writeAsString(jsonString);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc: "Item - $id Deleted Successfully",
        btnOkOnPress: () {
          Navigator.pop(context, true);
        }).show();
  }

  Future<bool> DeleteData(id) async {
    String uri = "${Globals.domainUrl}/delAccessories?id=$id";

    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData['Code'];
    print(jsonData['Code']);
    if (jsonData['success']) {
      loadDetails();
      showSnakebar(
          title: "Record Deleted Successfully ..",
          context,
          color: Colors.red,
          milliseconds: 1200);
    } else {
      loadDetails();
      showSnakebar(
          title: "No Record Deleted ..",
          context,
          color: Colors.grey,
          milliseconds: 1000);
    }
    return true;
  }

  Future<List<itemModel>> loadDetails() async {
    final filePath = await getFilePath(Globals.file_item);
    final file = File(filePath);

    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      // setState(() {
      itemData = decoded.map((data) => itemModel.fromMap(data)).toList();
      // });
    } else {
      print("No project data file found.");
    }

    return itemData;
  }
}
