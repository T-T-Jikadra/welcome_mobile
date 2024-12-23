// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, file_names, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/transaction/repairingMaster/repairingView.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/globals.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/transaction/repairingMaster/add_Repairing.dart';
import 'package:welcome_mob/models/repairModel.dart';

class RepairingMaster extends StatefulWidget {
  const RepairingMaster({super.key});

  @override
  State<RepairingMaster> createState() => _RepairingMasterState();
}

class _RepairingMasterState extends State<RepairingMaster> {
  String url = '';
  // List _repairingDetails = [];
  List<repairModel> repairData = [];

  @override
  void initState() {
    super.initState();
    // loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "List of Repairing"),
      body: FutureBuilder<List<repairModel>>(
        future: loadDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<repairModel> repairData = snapshot.data!;
            return repairingVIew(
                api: url,
                DataFormat: '<b>#name#<b>  \n' +
                    '<b>Contact <b>No :<b> #custMob#  \n<b>Device <b>Model :<b> #devModel# \n' +
                    '<b>Problem :<b> #devFault# \n' +
                    '<b>Cost :<b> ₹<b> #devCost# ',
                // '\n<b>Bill <b>No :<b> #id# ',
                onAdd: onAdd,
                onBack: onBack,
                onPDF: onPDF,
                onDel: onDel,
                onEdit: onEdit,
                onView: onView,
                modelName: "repairing",
                fileNanme: "repairing",
                TableName: 'statemst',
                defSearch: 'name',
                Data: repairData);
          }
        },
      ),
    );
  }

  void onAdd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddRepairing(
                  id: 0,
                ))).then((value) {
      loadDetails();
    });
  }

  void onEdit(id, data) {
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddRepairing(id: id)))
        .then((value) {
      loadDetails();
    });
  }

  void onView(id, data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddRepairing(id: id, readOnly: true)));
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
    print('Del Clicked... $id');
    showDeleteDialog(
      context,
      moduleName: "Repair",
      id: id,
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        deleteRepair(id);
        // Navigator.pop(context);
      },
    );
  }

  Future<void> deleteRepair(int id) async {
    setState(() {
      print("$repairData");
      print("IIDD   $id");
      repairData.removeWhere((record) => record.id == id);
    });
    await _saveTaskToFile(id: id);
    await loadDetails();
  }

  Future<void> _saveTaskToFile({int? id = 0}) async {
    final filePath = await getFilePath(Globals.file_repair);
    final file = File(filePath);

    List<Map<String, dynamic>> taskMapList =
        repairData.map((task) => task.toMap()).toList();

    String jsonString = jsonEncode(taskMapList);
    print("errep");
    print(jsonString);
    await file.writeAsString(jsonString);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc: "Repair - $id Deleted Successfully",
        btnOkOnPress: () {
          Navigator.pop(context, true);
        }).show();
  }

  Future<bool> DeleteData(id) async {
    String uri = "${Globals.domainUrl}/delRepair?id=$id";

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

  Future<List<repairModel>> loadDetails() async {
    final filePath = await getFilePath(Globals.file_repair);
    final file = File(filePath);
    // print("filePath1 : $filePath");

    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      // setState(() {
      repairData = decoded.map((data) => repairModel.fromMap(data)).toList();
      // });
      // print("found----------");
      // print(repairData);
      // print(fileContent);
    } else {
      print("No project data file found.");
    }

    // var url = "${Globals.domainUrl}/getRepair?id=&field=&value=";
    // print(url);
    // // final dio = Dio()
    // //   ..options.baseUrl = url
    // //   ..interceptors.add(LogInterceptor())
    // //   ..httpClientAdapter = Http2Adapter(
    // //     ConnectionManager(idleTimeout: Duration(seconds: 10)),
    // //   );
    // // Response response;
    // // response = await dio.get('');
    // // print(response);
    // // var jsonData = response.data;
    // var response = await http.get(Uri.parse(url));
    // var jsonData = jsonDecode(response.body);
    // print(jsonData);
    // print(jsonData['data']);
    // setState(() {
    //   _repairingDetails = jsonData['data'];
    // });

    return repairData;
  }
}
