// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, file_names, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_is_empty, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/eqWidget/eqDateField.dart';
import 'package:welcome_mob/common/eqWidget/eqDropdownField.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/common/report/dfReport.dart';
import 'package:welcome_mob/globals.dart';

class salesReport extends StatefulWidget {
  const salesReport({super.key});

  @override
  State<salesReport> createState() => _salesReportState();
}

class _salesReportState extends State<salesReport> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  final FocusNode _fromDateFocusNode = FocusNode();
  final FocusNode _toDateFocusNode = FocusNode();

  String strFromDate = "";
  String strToDate = "";
  var visible = true;

  String companyText = "";
  String companyValue = "";
  List<Map> CompanyData = [];
  String companyJson = "";

  List<String> companyTexts = [];
  List<String> companyValues = [];

  List selBookValue = [[], []];
  List selPartyValue = [[], []];
  List selAgentValue = [[], []];
  List selHasteValue = [[], []];
  List selTransportValue = [[], []];
  List selStationValue = [[], []];
  List selItemNameValue = [[], []];
  List selDesignValue = [[], []];
  List selColorValue = [[], []];
  List selCompanyValue = [[], []];
  List<Map<String, dynamic>> dailyReport = [];

  String typeValue = 'Regular';
  var typeItems = [
    'Regular',
    'Itemwise Summary',
    'Company Wise Summary',
    'Daily Sales Summary'
  ];

  var _jsonData = [];
  List<dynamic> selectedGroup = [];

  @override
  void initState() {
    super.initState();
    _fromDateController.text = Globals.startdate;
    _toDateController.text = Globals.enddate;
    DateTime date = DateTime.parse(Globals.startdate);

    // date = DateFormat('dd-MM-yyyy').parse(Globals.startdate);
    _fromDateController.text = DateFormat("dd-MM-yyyy").format(date);
    strFromDate = DateFormat("yyyy-MM-dd").format(date);
    print(_fromDateController.text);
    print(strFromDate);

    DateTime toDate = DateTime.parse(Globals.enddate);
    print("Date" + toDate.toString());
    _toDateController.text = DateFormat("dd-MM-yyyy").format(toDate);
    strToDate = DateFormat("yyyy-MM-dd").format(toDate);
    print(Globals.enddate);
    print(_toDateController.text);
    print(strToDate);
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "Sales Report"),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  repairReportForm(),
                ],
              ),
            )),
            Visibility(
              visible: visible,
              child: EqButton(
                  text: "Generate Report",
                  onPressed: () {
                    genReport();
                  }),
            )
          ],
        ),
      ),
    );
  }

  repairReportForm() {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: buildFromDateField()),
                  Expanded(child: buildToDateField()),
                ],
              ),
              buildTypeField()
            ],
          )),
    );
  }

  EqDateField buildFromDateField() {
    return EqDateField(
        enabled: visible,
        onDateSelected: (value) {
          strFromDate = value;
        },
        controller: _fromDateController,
        hintText: "Select From Date",
        lblText: "From Date",
        focusNode: _fromDateFocusNode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            _fromDateFocusNode.requestFocus();
            return "Please select Date";
          }
          return null;
        });
  }

  EqDateField buildToDateField() {
    return EqDateField(
        enabled: visible,
        onDateSelected: (value) {
          strToDate = value;
        },
        controller: _toDateController,
        hintText: "Select To Date",
        lblText: "To Date",
        focusNode: _toDateFocusNode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            _toDateFocusNode.requestFocus();
            return "Please select To Date";
          }
          return null;
        });
  }

  eqDropdownField buildTypeField() {
    return eqDropdownField(
      value: typeValue,
      items: typeItems,
      enabled: visible,
      labelText: 'Report Type',
      hintText: 'Report Type',
      onChanged: (newValue) {
        setState(() {
          typeValue = newValue!;
        });
      },
    );
  }

  void genReport() async {
    // fromDate = _fromdateController.text;
    // toDate = _todateController.text;

    await getReportData();

    var aGroup = [];

    // if (typeValue == "Regular") {
    //   aGroup = [
    //     {"field": "date", "heading": "Date"}
    //   ];
    // }

    String calias = 'salesrpt';
    String cRptCaption = '';
    String cRptCaption2 =
        'Reporting Period From ${_fromDateController.text}  To ${_toDateController.text}';

    dfReport oReport = dfReport(_jsonData, aGroup);
    if (typeValue == "Daily Sales Summary") {
      cRptCaption = 'Daily Sales Summary Report';
      oReport.addColumn('date', 'Date', 'N', '15', '0', 'r', '', true);
      oReport.addColumn(
          'price', 'Daily Sales', 'C', '16', '0', 'r', 'sum', true);
    } else if (typeValue == "Itemwise Summary") {
      cRptCaption = 'Itemwise Sales Summary Report';
      oReport.addColumn('itemName', 'Item Name', 'N', '12', '0', 'l', '', true);
      oReport.addColumn(
          'totalSales', 'Total Sales', 'N', '12', '0', 'r', 'sum', true);
      oReport.addColumn('count', 'Count', 'N', '7', '0', 'r', 'sum', true);
    } else if (typeValue == "Company Wise Summary") {
      cRptCaption = 'Company Wise Sales Summary Report';
      oReport.addColumn(
          'compnay', 'Company Name', 'N', '12', '0', 'l', '', true);
      oReport.addColumn(
          'totalSales', 'Total Sales', 'N', '12', '0', 'r', 'sum', true);
      oReport.addColumn('count', 'Count', 'N', '7', '0', 'r', 'sum', true);
    } else {
      cRptCaption = 'Daily Sales Report';
      oReport.addColumn('id', 'Bill No', 'N', '6', '0', 'r', '', true);
      oReport.addColumn('date', 'Date', 'N', '7.8', '0', 'l', '', true);
      oReport.addColumn('name', 'Customer Name', 'C', '13', '0', 'l', '', true);
      oReport.addColumn('mobile', 'Contact no', 'N', '9', '0', 'r', '', true);
      oReport.addColumn('company', 'Company', 'N', '15', '0', 'l', '', true);
      oReport.addColumn('itemname', 'Item Name', 'N', '13.4', '0', 'l', '', true);
      oReport.addColumn('price', 'Price', 'N', '8', '0', 'r', 'sum', true);
    }

    oReport.prepareReport();
    oReport.calias = calias;
    oReport.cRptCaption = cRptCaption;
    oReport.cRptCaption2 = cRptCaption2;
    oReport.GenerateReport(context);

    return;
  }

  Future<bool> getReportData() async {
    showProgressIndicator(context);

    await loadData();
    hideIndicator(context);

    return true;
  }

  Future<bool> loadData() async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);
    Map<String, Map<String, dynamic>> itemSummary = {};

    if (await file.exists()) {
      final fileContent = await file.readAsString();

      // Daily Sales Summary ..
      if (typeValue == "Daily Sales Summary") {
        dailyReport = calculateDailyCost(fileContent);
        _jsonData = dailyReport;
        _jsonData.sort((a, b) {
          DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
          DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
          return dateA.compareTo(dateB);
        });

        DateTime startDate =
            DateFormat('dd-MM-yyyy').parse(_fromDateController.text);
        DateTime endDate =
            DateFormat('dd-MM-yyyy').parse(_toDateController.text);

        _jsonData = _jsonData.where((item) {
          DateTime itemDate = DateFormat('dd-MM-yyyy').parse(item['date']);
          return itemDate.isAfter(startDate.subtract(Duration(days: 1))) &&
              itemDate.isBefore(endDate.add(Duration(days: 1)));
        }).toList();
        // Itemwise Summary ..
      } else if (typeValue == "Itemwise Summary") {
        _jsonData = json.decode(fileContent);
        for (var item in _jsonData) {
          String itemName = item['itemname'];
          double itemSales = double.tryParse(item['price'].toString()) ?? 0.0;

          if (!itemSummary.containsKey(itemName)) {
            itemSummary[itemName] = {
              'itemname': itemName,
              'totalSales': 0.0,
              'count': 0,
            };
          }

          itemSummary[itemName]!['totalSales'] += itemSales;
          itemSummary[itemName]!['count'] += 1;
        }

        _jsonData = itemSummary.entries.map((entry) {
          return {
            'itemName': entry.key,
            'totalSales': entry.value['totalSales'],
            'count': entry.value['count']
          };
        }).toList();
        //Normal report ..
      } else if (typeValue == "Company Wise Summary") {
        _jsonData = json.decode(fileContent);
        for (var item in _jsonData) {
          String itemName = item['company'];
          double itemSales = double.tryParse(item['price'].toString()) ?? 0.0;

          if (!itemSummary.containsKey(itemName)) {
            itemSummary[itemName] = {
              'compnay': itemName,
              'totalSales': 0.0,
              'count': 0,
            };
          }

          itemSummary[itemName]!['totalSales'] += itemSales;
          itemSummary[itemName]!['count'] += 1;
        }

        _jsonData = itemSummary.entries.map((entry) {
          return {
            'compnay': entry.key,
            'totalSales': entry.value['totalSales'],
            'count': entry.value['count']
          };
        }).toList();
        //Normal report ..
      } else {
        List<dynamic> decoded = json.decode(fileContent);
        _jsonData = decoded;
        _jsonData.sort((a, b) {
          DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
          DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
          return dateA.compareTo(dateB);
        });

        DateTime startDate =
            DateFormat('dd-MM-yyyy').parse(_fromDateController.text);
        DateTime endDate =
            DateFormat('dd-MM-yyyy').parse(_toDateController.text);

        _jsonData = _jsonData.where((item) {
          DateTime itemDate = DateFormat('dd-MM-yyyy').parse(item['date']);
          return itemDate.isAfter(startDate.subtract(Duration(days: 1))) &&
              itemDate.isBefore(endDate.add(Duration(days: 1)));
        }).toList();
      }

      print("JJKK");
      print(_jsonData);
    } else {
      print("No project data file found.");
    }

    return true;
  }

  List<Map<String, dynamic>> calculateDailyCost(String jsonData) {
    List<dynamic> dataList = jsonDecode(jsonData);

    Map<String, double> dailyCostMap = {};

    for (var item in dataList) {
      String date = item['date'];
      double cost = double.parse(item['price']);

      if (dailyCostMap.containsKey(date)) {
        dailyCostMap[date] = dailyCostMap[date]! + cost;
      } else {
        dailyCostMap[date] = cost;
      }
    }

    List<Map<String, dynamic>> dailyReport = [];
    dailyCostMap.forEach((date, totalCost) {
      dailyReport.add({'date': date, 'price': totalCost});
    });

    dailyReport.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
      return dateA.compareTo(dateB);
    });

    print("aabbvv");
    print(dailyReport);

    return dailyReport;
  }
}
