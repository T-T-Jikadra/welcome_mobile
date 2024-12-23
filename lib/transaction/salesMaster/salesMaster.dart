// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, file_names, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/globals.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:welcome_mob/models/salesModel.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/transaction/salesMaster/add_Sales.dart';
import 'package:welcome_mob/transaction/salesMaster/salesView.dart';

class salesMaster extends StatefulWidget {
  const salesMaster({super.key});

  @override
  State<salesMaster> createState() => _salesMasterState();
}

class _salesMasterState extends State<salesMaster> {
  String url = '';
  List<salesModel> salesData = [];

  @override
  void initState() {
    super.initState();
    // loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "List of Sales"),
      body: FutureBuilder<List<salesModel>>(
        future: loadDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<salesModel> salesData = snapshot.data!;
            return salesView(
                api: url,
                DataFormat: '<b>#name# <b> \n' +
                    '<b>Contact <b>No :<b> #mobile#  \n<b>Company :<b> #company# \n' +
                    '<b>Itemname :<b> #itemname# \n' +
                    '<b>Price : ₹<b> #price# ',
                onAdd: onAdd,
                onBack: onBack,
                onPDF: onPDF,
                onDel: onDel,
                onEdit: onEdit,
                onView: onView,
                TableName: 'statemst',
                defSearch: 'custName',
                Data: salesData);
          }
        },
      ),
    );
  }

  void onAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddSales(id: 0)))
        .then((value) {
      loadDetails();
    });
  }

  void onEdit(id, data) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddSales(id: id)))
        .then((value) {
      loadDetails();
    });
  }

  void onView(id, data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddSales(id: id, readOnly: true)));
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
      context,
      moduleName: "Sales",
      id: id,
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        deleteSales(id);
        // Navigator.pop(context);
      },
    );
  }

  Future<void> deleteSales(int id) async {
    setState(() {
      print("$salesData");
      print("IIDD   $id");
      salesData.removeWhere((record) => record.id == id);
    });
    await _saveTaskToFile(id: id);
    await loadDetails();
  }

  Future<void> _saveTaskToFile({int? id = 0}) async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);

    List<Map<String, dynamic>> taskMapList =
        salesData.map((task) => task.toMap()).toList();
    print("er");
    print(salesData);

    String jsonString = jsonEncode(taskMapList);
    print(jsonString);
    await file.writeAsString(jsonString);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc: "Sale - $id Deleted Successfully",
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

  Future<List<salesModel>> loadDetails() async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);
    print("filePath : $filePath");

    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      // setState(() {
      salesData = decoded.map((data) => salesModel.fromMap(data)).toList();
      // });
      print("found----------");
      print(salesData);
      print(fileContent);
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

    return salesData;
  }
}
