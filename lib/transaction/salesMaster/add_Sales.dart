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
import 'package:welcome_mob/common/list/list_Function.dart';
import 'package:welcome_mob/globals.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/masters/companyMaster/add_Company.dart';
import 'package:welcome_mob/masters/itemMaster/add_item.dart';
import 'package:welcome_mob/models/salesModel.dart';

class AddSales extends StatefulWidget {
  AddSales({Key? mykey, id, readOnly, addstateText = '', salesModel? salesData})
      : super(key: mykey) {
    xId = id;
    xBoolValue = readOnly;
    xaddStateText = addstateText;
    xsalesModel = salesData;
  }

  int xId = 0;
  String xState = '';
  String xaddStateText = '';
  bool? xBoolValue;
  salesModel? xsalesModel;

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _custNameController = TextEditingController();
  final TextEditingController _custMobController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _wardaysController = TextEditingController();

  List selComValue = [[], []];
  List selItemValue = [[], []];

  final FocusNode _custNameFocusNode = FocusNode();
  final FocusNode _custMobFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();
  final FocusNode itemnameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  var visible = true;

  String loadState = "";
  String strDate = "";

  int _nextId = 1;
  List<salesModel> sales = [];

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    strDate = _dateController.text = DateFormat("dd-MM-yyyy").format(date);
    // strDate = DateFormat("yyyy-MM-dd").format(date);
    // if (widget.xaddStateText.toString().isNotEmpty) {
    //   _custNameController.text = widget.xaddStateText.toString();
    // }
    loadSales();
    loadData();

    if (widget.xBoolValue == true) {
      visible = false;
    }
  }

  @override
  void dispose() {
    _custNameController.dispose();
    _custMobController.dispose();
    _companyController.dispose();
    _itemnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "Sales Master"),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  salesForm(),
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
                        updateSales(widget.xId);
                      } else {
                        saveSales();
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  salesForm() {
    return Center(
      child: Form(
          child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildDateField(),
                    buildCustNameField(),
                    buildCustMobField(),
                    buildCompanyField(),
                    buildItemField(),
                    buildPriceField(),
                    Row(
                      children: [
                        Expanded(child: buildWarDaysField()),
                        Expanded(child: buildCodeField()),
                      ],
                    ),
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
      controller: _custNameController,
      hintText: "Enter Customer Name",
      labelText: "Customer Name",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _custNameFocusNode.requestFocus();
          return "Customer Name can't be empty ";
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

  EqTextField buildCompanyFiel1d() {
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

  // EqTextField buildCompanyField1() {
  //   String api = "${Globals.domainUrl}/BookWhn?acctype=SALE BOOK&search=";
  //   print(api);
  //   String dataFormat = '<b>#text#<b>';

  //   return EqTextField(
  //     autofocus: true,
  //     enabled: visible,
  //     controller: _companyController,
  //     hintText: "Enter Company Name",
  //     labelText: "Company Name",
  //     selValue: selComValue,
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return "Please Select Company";
  //       }
  //       return null;
  //     },
  //     onTap: () {
  //       if (_companyController.text != '') {
  //         selComValue = [
  //           [_companyController.text],
  //           [0]
  //         ];
  //       }
  //       openSearchList(context, 'Company List', false, api, dataFormat,
  //               'text', addCompany, [selComValue[0], selComValue[1]])
  //           .then((value) => {
  //                 if (value != null)
  //                   {
  //                     setState(() {
  //                       print(value);
  //                       _companyController.text =
  //                           value[2][0]['text'].toString();
  //                     }),
  //                   }
  //               });
  //     },
  //   );
  // }

  EqTextField buildCompanyField() {
    String dataFormat = '#name# ';

    return EqTextField(
      enabled: visible,
      controller: _companyController,
      hintText: 'Select Company',
      labelText: 'Company',
      selValue: selComValue,
      onTap: () {
        if (_companyController.text != '') {
          selComValue = [
            [_companyController.text],
            [0]
          ];
        }
        openSearchList(context, 'Company List', false, "api", "company", 'name',
                dataFormat, 'name', [''], addCompany, [selComValue[0], selComValue[1]])
            .then((value) => {
                  {
                    print(value),
                    setState(() {
                      _companyController.text = value[2][0]['name'].toString();
                      selComValue = [value[0], value[1]];
                    }),
                  }
                });
      },
    );
  }

  Future<List<dynamic>?> addCompany() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddCompany(id: 0)),
    );
    return result;
  }

  EqTextField buildItemField() {
    String dataFormat = '#name# ';

    return EqTextField(
      enabled: visible,
      controller: _itemnameController,
      hintText: 'Select Item',
      labelText: 'Item',
      selValue: selItemValue,
      onTap: () {
        if (_itemnameController.text != '') {
          selItemValue = [
            [_itemnameController.text],
            [0]
          ];
        }
        openSearchList(context, 'Item List', false, "api", "item", 'name',
                dataFormat, 'name', [''], addItem, [selItemValue[0], selItemValue[1]])
            .then((value) => {
                  {
                    print(value),
                    setState(() {
                      _itemnameController.text = value[2][0]['name'].toString();
                      selItemValue = [value[0], value[1]];
                    }),
                  }
                });
      },
    );
  }

  Future<List<dynamic>?> addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddItem(id: 0)),
    );
    return result;
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

    String strCustName = _custNameController.text.trim();
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
            desc: "Sales : $strItemname - Saved Successfully",
            btnOkOnPress: () {
              Navigator.pop(context, stateDetails);
            }).show();
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Error !!!!',
            desc: "Error While Saving Sales $strItemname",
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

  Future<void> saveSales() async {
    String strDate = _dateController.text.trim();
    String strCustName = _custNameController.text.trim();
    String strCustMob = _custMobController.text.trim();
    String strDevModel = _companyController.text.trim();
    String strDevFault = _itemnameController.text.trim();
    String strDevCost = _priceController.text.trim();
    String strCode = _codeController.text.trim();
    String strWarDays = _wardaysController.text.trim();
    setState(() {
      salesModel record = salesModel(
        id: _nextId++,
        date: strDate,
        name: strCustName,
        mobile: strCustMob,
        company: strDevModel,
        itemname: strDevFault,
        price: strDevCost,
        code: strCode,
        wardays: strWarDays,
      );
      sales.add(record);
    });
    await _saveSalesToFile();
  }

  Future<void> updateSales(int id) async {
    setState(() {
      salesModel date = sales.firstWhere((item) => item.id == id);
      salesModel name = sales.firstWhere((item) => item.id == id);
      salesModel mobile = sales.firstWhere((item) => item.id == id);
      salesModel company = sales.firstWhere((item) => item.id == id);
      salesModel itemname = sales.firstWhere((item) => item.id == id);
      salesModel price = sales.firstWhere((item) => item.id == id);
      salesModel wardays = sales.firstWhere((item) => item.id == id);
      salesModel code = sales.firstWhere((item) => item.id == id);
      date.date = _dateController.text.trim();
      name.name = _custNameController.text.trim();
      mobile.mobile = _custMobController.text.trim();
      company.company = _companyController.text.trim();
      itemname.itemname = _itemnameController.text.trim();
      price.price = _priceController.text.trim();
      wardays.wardays = _wardaysController.text.trim();
      code.code = _codeController.text.trim();
    });
    await _saveSalesToFile();
  }

  Future<void> _saveSalesToFile() async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);

    List<Map<String, dynamic>> salesMapList =
        sales.map((task) => task.toMap()).toList();

    String jsonString = jsonEncode(salesMapList);

    await file.writeAsString(jsonString);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc: "Sales : ${_itemnameController.text.trim()} - Saved Successfully",
        btnOkOnPress: () {
          Navigator.pop(context, true);
        }).show();
  }

  Future<bool> loadData() async {
    if (widget.xId <= 0) {
      return true;
    }

    print(widget.xId);
    setState(() {
      strDate = widget.xsalesModel!.date;
      _dateController.text = convertViewDate(widget.xsalesModel!.date);
      _custNameController.text = widget.xsalesModel!.name;
      _custMobController.text = widget.xsalesModel!.mobile;
      _companyController.text = widget.xsalesModel!.company;
      _itemnameController.text = widget.xsalesModel!.itemname;
      _priceController.text = widget.xsalesModel!.price;
      _wardaysController.text = widget.xsalesModel!.wardays!;
      _codeController.text = widget.xsalesModel!.code!;
    });
    return true;
  }

  Future<void> loadSales() async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);
    print(filePath);
    print("filePath");
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      setState(() {
        sales = decoded.map((data) => salesModel.fromMap(data)).toList();
        _nextId = sales.isEmpty ? 1 : sales.last.id! + 1;
      });
    } else {
      print("No Task data file found.");
    }
  }
}
