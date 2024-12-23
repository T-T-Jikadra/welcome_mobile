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
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:welcome_mob/models/repairModel.dart';

enum ImageFrom { camera, gallery }

class AddRepairing extends StatefulWidget {
  AddRepairing(
      {Key? mykey, id, readOnly, addstateText = '', repairModel? repairData})
      : super(key: mykey) {
    xId = id;
    xBoolValue = readOnly;
    xaddStateText = addstateText;
    xRepairModel = repairData;
  }

  int xId = 0;
  String xState = '';
  String xaddStateText = '';
  bool? xBoolValue;
  repairModel? xRepairModel;

  @override
  State<AddRepairing> createState() => _AddRepairingState();
}

class _AddRepairingState extends State<AddRepairing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _custNameController = TextEditingController();
  final TextEditingController _custMobController = TextEditingController();
  final TextEditingController _deviceModelController = TextEditingController();
  final TextEditingController _deviceFaultController = TextEditingController();
  final TextEditingController _devCostController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _wardaysController = TextEditingController();

  final FocusNode _custNameFocusNode = FocusNode();
  final FocusNode _custMobFocusNode = FocusNode();
  final FocusNode _devModelFocusNode = FocusNode();
  final FocusNode _devFaultFocusNode = FocusNode();
  final FocusNode _devCostFocusNode = FocusNode();

  var visible = true;

  String loadState = "";
  String strDate = "";
  String strDeliveryDate = "";
  String strStatus = "";

  int _nextId = 1;
  bool isPicked = false;
  List<repairModel> repairs = [];
  List<File> pickedImageFiles = [];

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    DateTime deliveryDate = date.add(Duration(days: 1));
    strDate = _dateController.text = DateFormat("dd-MM-yyyy").format(date);
    strDeliveryDate = _deliveryDateController.text =
        DateFormat("dd-MM-yyyy").format(deliveryDate);
    // strDate = DateFormat("yyyy-MM-dd").format(date);
    // if (widget.xaddStateText.toString().isNotEmpty) {
    //   _custNameController.text = widget.xaddStateText.toString();
    // }
    loadRepairs();
    loadData();
    if (widget.xBoolValue == true) {
      visible = false;
    }
  }

  @override
  void dispose() {
    _custNameController.dispose();
    _custMobController.dispose();
    _deviceModelController.dispose();
    _deviceFaultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: "Repairing Master"),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  repairingForm(),
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
                        updateRepair(widget.xId);
                      } else {
                        saveRepair();
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  repairingForm() {
    return Center(
      child: Form(
          child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(child: buildDateField()),
                        Expanded(child: buildDeliveryDateField()),
                      ],
                    ),
                    buildCustNameField(),
                    buildCustMobField(),
                    buildDeviceModelField(),
                    buildDeviceFaultField(),
                    buildDevCostField(),
                    Row(
                      children: [
                        Expanded(child: buildWarDaysField()),
                        Expanded(child: buildCodeField()),
                      ],
                    ),
                    // SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.attachment_rounded,
                                  size: 22, color: Colors.grey),
                              SizedBox(width: 10),
                              Text("Attachments :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17)),
                            ],
                          ),
                          GestureDetector(
                            onTap: showSourceDialog,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey[300],
                                ),
                                child: Icon(Icons.add,
                                    size: 35, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          if (pickedImageFiles.isNotEmpty)
                            Expanded(
                              child: SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pickedImageFiles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              String filepath =
                                                  pickedImageFiles[index].path;
                                              OpenFile.open(filepath);
                                            },
                                            child: Container(
                                              width: 130,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey[300],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  pickedImageFiles[index],
                                                  width: 120,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => deleteImage(index),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                        ]),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select Date";
          }
          return null;
        });
  }

  EqDateField buildDeliveryDateField() {
    return EqDateField(
      enabled: visible,
      onDateSelected: (value) {
        strDeliveryDate = value;
      },
      controller: _deliveryDateController,
      hintText: "Select Delivery Date",
      lblText: "Delivery Date",
    );
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
      length: 10,
      enabled: visible,
      autofocus: !visible,
      controller: _custMobController,
      keyboardType: TextInputType.number,
      hintText: "Enter Customer Mobile No",
      labelText: "Customer Mobile No",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _custMobFocusNode.requestFocus();
          return "Customer Mobile No can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildDeviceModelField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      controller: _deviceModelController,
      hintText: "Enter Device Model",
      labelText: "Device Model",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _devModelFocusNode.requestFocus();
          return "Device Model can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildDeviceFaultField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      controller: _deviceFaultController,
      hintText: "Enter Device Fault",
      labelText: "Device Fault",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _devFaultFocusNode.requestFocus();
          return "Device Fault can't be empty ";
        }
        return null;
      },
    );
  }

  EqTextField buildDevCostField() {
    return EqTextField(
      autofocus: !visible,
      enabled: visible,
      keyboardType: TextInputType.number,
      controller: _devCostController,
      hintText: "Enter Device Cost",
      labelText: "Device Cost",
      validator: (value) {
        if (value == null || value.isEmpty) {
          _devCostFocusNode.requestFocus();
          return "Device Fault can't be empty ";
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

  Future<void> saveRepair() async {
    String strDate = _dateController.text.trim();
    String strDeliveryDate = _deliveryDateController.text.trim();
    String strCustName = _custNameController.text.trim();
    String strCustMob = _custMobController.text.trim();
    String strDevModel = _deviceModelController.text.trim();
    String strDevFault = _deviceFaultController.text.trim();
    String strDevCost = _devCostController.text.trim();
    String strCode = _codeController.text.trim();
    String strWarDays = _wardaysController.text.trim();
    setState(() {
      repairModel taskk = repairModel(
          id: _nextId++,
          deldate: strDeliveryDate,
          date: strDate,
          name: strCustName,
          mobile: strCustMob,
          devModel: strDevModel,
          devFault: strDevFault,
          devCost: strDevCost,
          status: "P",
          code: strCode,
          wardays: strWarDays,
          images: pickedImageFiles.map((file) => file.path).toList());
      repairs.add(taskk);
    });
    await _saveRepairToFile();
  }

  Future<void> _saveRepairToFile() async {
    final filePath = await getFilePath(Globals.file_repair);
    final file = File(filePath);
    print(file);
    print("file");

    List<Map<String, dynamic>> repairMapList =
        repairs.map((record) => record.toMap()).toList();

    String jsonString = jsonEncode(repairMapList);

    await file.writeAsString(jsonString);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Success !!!!',
        desc: "Repairng Saved Successfully",
        btnOkOnPress: () {
          Navigator.pop(context, true);
        }).show();
  }

  Future<void> updateRepair(int id) async {
    setState(() {
      repairModel date = repairs.firstWhere((item) => item.id == id);
      repairModel deldate = repairs.firstWhere((item) => item.id == id);
      repairModel name = repairs.firstWhere((item) => item.id == id);
      repairModel mobile = repairs.firstWhere((item) => item.id == id);
      repairModel devModel = repairs.firstWhere((item) => item.id == id);
      repairModel devFault = repairs.firstWhere((item) => item.id == id);
      repairModel devCost = repairs.firstWhere((item) => item.id == id);
      repairModel status = repairs.firstWhere((item) => item.id == id);
      repairModel wardays = repairs.firstWhere((item) => item.id == id);
      repairModel code = repairs.firstWhere((item) => item.id == id);
      date.date = _dateController.text.trim();
      deldate.deldate = _deliveryDateController.text.trim();
      name.name = _custNameController.text.trim();
      mobile.mobile = _custMobController.text.trim();
      devModel.devModel = _deviceModelController.text.trim();
      devFault.devFault = _deviceFaultController.text.trim();
      devCost.devCost = _devCostController.text.trim();
      status.status = strStatus;
      wardays.wardays = _wardaysController.text.trim();
      code.code = _codeController.text.trim();
      mobile.images = pickedImageFiles.map((file) => file.path).toList();
    });
    await _saveRepairToFile();
  }

  showSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Source : ',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () => pickCameraImage(ImageFrom.camera),
                title: const Text('Camera'),
                leading: Icon(Icons.camera_alt),
              ),
              ListTile(
                  title: const Text('Gallery'),
                  onTap: () => pickGalleryImage(ImageFrom.gallery),
                  leading: Icon(Icons.image)),
            ],
          ),
        );
      },
    );
  }

  pickCameraImage(ImageFrom camera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) {
      setState(() {
        pickedImageFiles.add(File(image.path));

        isPicked = true;
        Navigator.pop(context);
      });
    }
  }

  pickGalleryImage(ImageFrom gallery) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImageFiles.add(File(image.path));

        isPicked = true;
        Navigator.pop(context);
      });
    }
  }

  deleteImage(int index) {
    setState(() {
      pickedImageFiles.removeAt(index);

      isPicked = true;
    });
  }

  Future<bool> loadData() async {
    if (widget.xId <= 0) {
      return true;
    }

    print(widget.xId);
    setState(() {
      strDate = widget.xRepairModel!.date;
      strDeliveryDate = widget.xRepairModel!.deldate!;
      _dateController.text = convertViewDate(widget.xRepairModel!.date);
      _deliveryDateController.text =
          convertViewDate(widget.xRepairModel!.deldate!);
      _custNameController.text = widget.xRepairModel!.name;
      _custMobController.text = widget.xRepairModel!.mobile;
      _deviceModelController.text = widget.xRepairModel!.devModel;
      _deviceFaultController.text = widget.xRepairModel!.devFault;
      _devCostController.text = widget.xRepairModel!.devCost;
      strStatus = widget.xRepairModel!.status;
      _wardaysController.text = widget.xRepairModel!.wardays!;
      _codeController.text = widget.xRepairModel!.code!;

      pickedImageFiles =
          widget.xRepairModel!.images.map((path) => File(path)).toList();
    });
    return true;
  }

  Future<void> loadRepairs() async {
    final filePath = await getFilePath(Globals.file_repair);
    final file = File(filePath);
    print(filePath);
    print("filePath");
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      setState(() {
        repairs = decoded.map((data) => repairModel.fromMap(data)).toList();
        _nextId = repairs.isEmpty ? 1 : repairs.last.id! + 1;
      });
    } else {
      print("No Task data file found.");
    }
  }

  Future<bool> saveData() async {
    showProgressIndicator(context);

    var id = 0;
    id = widget.xId;

    String strCustName = _custNameController.text.trim();
    String strCustMob = _custMobController.text.trim();
    String strDevModel = _deviceModelController.text.trim();
    String strDevFault = _deviceFaultController.text.trim();
    String strDevCost = _devCostController.text.trim();

    var url = "${Globals.domainUrl}/addRepair";
    var data = {
      'id': id,
      'date': strDate,
      'custName': strCustName,
      'custMob': strCustMob,
      'devModel': strDevModel,
      'devFault': strDevFault,
      'devCost': strDevCost,
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
            desc: "Repairng : $strCustName - Saved Successfully",
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
            desc: "Error While Saving Repairing $strCustName",
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
}
