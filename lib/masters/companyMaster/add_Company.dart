// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks, unnecessary_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/eqWidget/eqDateField.dart';
import 'package:welcome_mob/common/eqWidget/eqTextField.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/globals.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/models/companyModel.dart';

class AddCompany extends StatefulWidget {
  AddCompany(
      {Key? mykey, id, readOnly, addstateText = '', companyModel? companyData})
      : super(key: mykey) {
    xId = id;
    xBoolValue = readOnly;
    xaddStateText = addstateText;
    xComModel = companyData;
  }

  int xId = 0;
  String xState = '';
  String xaddStateText = '';
  bool? xBoolValue;
  companyModel? xComModel;

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _comNameController = TextEditingController();
  final TextEditingController _custMobController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _wardaysController = TextEditingController();

  final FocusNode _comNameFocusNode = FocusNode();
  final FocusNode _custMobFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();
  final FocusNode itemnameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  var visible = true;
  var companyDetails = [];

  String loadState = "";
  String strDate = "";

  int _nextId = 1;
  List<companyModel> company = [];

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    strDate = _dateController.text = DateFormat("dd-MM-yyyy").format(date);

    loadCompany();
    loadData();

    if (widget.xBoolValue == true) {
      visible = false;
    }
  }

  @override
  void dispose() {
    _comNameController.dispose();
    _custMobController.dispose();
    _companyController.dispose();
    _itemnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "Company Master"),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  companyForm(),
                ],
              ),
            )),
            Visibility(
              visible: visible,
              child: EqButton(
                  text: "Save",
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (widget.xId > 0) {
                        updateCompany(widget.xId);
                      } else {
                        saveCompany();
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  companyForm() {
    return Center(
      child: Form(
          child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // buildDateField(),
                    buildCustNameField(),
                    // buildCustMobField(),
                    // buildCompanyField(),
                    // buildItemnameField(),
                    // buildPriceField(),
                    // Row(
                    //   children: [
                    //     Expanded(child: buildWarDaysField()),
                    //     Expanded(child: buildCodeField()),
                    //   ],
                    // ),
                  ],
                ),
              ))),
    );
  }

  EqDateField buildDateField() {
    return EqDateField(
        enabled: visible,
        onDateSelected: (value) {
          strDate = value;
        },
        controller: _dateController,
        hintText: "Select Date",
        lblText: "Date",
        // focusNode: _dateFocusNode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            // _dateFocusNode.requestFocus();
            return "Please select Date";
          }
          return null;
        });
  }

  EqTextField buildCustNameField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      controller: _comNameController,
      hintText: "Enter Company Name",
      labelText: "Company Name",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _comNameFocusNode.requestFocus();
          return "Company Name can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildCustMobField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      length: 10,
      keyboardType: TextInputType.number,
      controller: _custMobController,
      hintText: "Enter Custoemr Mob No",
      labelText: "Customer Mob No",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _custMobFocusNode.requestFocus();
          return "Customer Mob No can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildCompanyField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      controller: _companyController,
      hintText: "Enter Company Name",
      labelText: "Company Name",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _companyFocusNode.requestFocus();
          return "Company Name can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildItemnameField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      controller: _itemnameController,
      hintText: "Enter Itemname",
      labelText: "Itemname",
      validator: (value) {
        if (value == null || value.isEmpty) {
          itemnameFocusNode.requestFocus();
          return "Itemname can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildPriceField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      keyboardType: TextInputType.number,
      controller: _priceController,
      hintText: "Enter Price",
      labelText: "Price",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _priceFocusNode.requestFocus();
          return "Price can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildCodeField() {
    return EqTextField(
        autofocus: !visible,
        enabled: visible,
        controller: _codeController,
        hintText: "Enter Code",
        labelText: "Code");
  }

  EqTextField buildWarDaysField() {
    return EqTextField(
        autofocus: !visible,
        enabled: visible,
        keyboardType: TextInputType.number,
        controller: _wardaysController,
        hintText: "Enter Warranty Days",
        labelText: "Warranty Days");
  }

  Future<bool> saveData() async {
    showProgressIndicator(context);

    var id = 0;
    id = widget.xId;

    String strCustName = _comNameController.text.trim();
    String strCustMob = _custMobController.text.trim();
    String strCompany = _companyController.text.trim();
    String strItemname = _itemnameController.text.trim();
    String strPrice = _priceController.text.trim();

    var url = "${Globals.domainUrl}/addAccessories";
    var data = {
      'id': id,
      'date': strDate,
      'custName': strCustName,
      'custMob': strCustMob,
      'company': strCompany,
      'itemname': strItemname,
      'price': strPrice,
    };
    print(data);

    var body = json.encode(data);
    print("Request URL: $url");
    print("Request Body: $body");

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      print(response);
      print(response.body);
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      hideIndicator(context);
      var stateDetails = [];

      stateDetails.add({'text': strCustName, "code": strCustMob});

      if (jsonData['success']) {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Success !!!!',
            desc: "Company : $strItemname - Saved Successfully",
            btnOkOnPress: () {
              print(stateDetails);
              Navigator.pop(context, stateDetails);
            }).show();
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Error !!!!',
            desc: "Error While Saving Company $strItemname",
            btnOkOnPress: () {
              Navigator.pop(context);
            }).show();
      }
    } catch (error) {
      print("Error: $error");

      // Hide progress indicator and show error dialog
      hideIndicator(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Error !!!!',
        desc: "Unexpected error occurred. Please try again.",
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
      return false;
    }
    return true;
  }

  Future<void> saveCompany() async {
    String strComName = _comNameController.text.trim();
    setState(() {
      companyModel record = companyModel(
        id: _nextId++,
        name: strComName,
      );
      company.add(record);
    });
    await _saveCompanyToFile();
  }

  Future<void> updateCompany(int id) async {
    setState(() {
      companyModel name = company.firstWhere((item) => item.id == id);
      name.name = _comNameController.text.trim();
    });
    await _saveCompanyToFile();
  }

  Future<void> _saveCompanyToFile() async {
    final filePath = await getFilePath(Globals.file_company);
    final file = File(filePath);

    List<Map<String, dynamic>> companyMapList =
        company.map((task) => task.toMap()).toList();

    String jsonString = jsonEncode(companyMapList);

    await file.writeAsString(jsonString);

    companyDetails.add({'name': _comNameController.text.trim()});
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc:
            "Company : ${_itemnameController.text.trim()} - Saved Successfully",
        btnOkOnPress: () {
          Navigator.pop(context, companyDetails);
        }).show();
  }

  Future<bool> loadData() async {
    if (widget.xId <= 0) {
      return true;
    }

    print(widget.xId);
    setState(() {
      _comNameController.text = widget.xComModel!.name;
    });
    return true;
  }

  Future<void> loadCompany() async {
    final filePath = await getFilePath(Globals.file_company);
    final file = File(filePath);
    print(filePath);
    print("filePath");
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      setState(() {
        company = decoded.map((data) => companyModel.fromMap(data)).toList();
        _nextId = company.isEmpty ? 1 : company.last.id! + 1;
      });
    } else {
      print("No Task data file found.");
    }
  }
}
