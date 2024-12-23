// ignore_for_file: camel_case_types, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/eqWidget/eqTextField.dart';
import 'package:google_fonts/google_fonts.dart';

class eqDialog extends StatefulWidget {
  final bool showWeight;
  final List<Map<String, dynamic>>? data;
  final void Function(List<Map<String, dynamic>> jsonData)? onSave;

  eqDialog({
    Key? mykey,
    title,
    this.data,
    controlId,
    this.onSave,
    parControlId,
    this.showWeight = false,
  }) : super(key: mykey) {
    xTitle = title;
    xControlId = controlId;
    xparControlId = parControlId;
  }

  @override
  eqDialogState createState() => eqDialogState();

  var xTitle;
  int xControlId = 0;
  int xparControlId = 0;
}

class eqDialogState extends State<eqDialog> {
  List<TextEditingController> mtrListController = [TextEditingController()];
  List<TextEditingController> pcsListController = [
    TextEditingController(text: "1")
  ];
  List<TextEditingController> weightListController = [TextEditingController()];
  List<FocusNode> mtrFocusNodes = [FocusNode()];
  List<FocusNode> pcsFocusNodes = [FocusNode()];
  List<FocusNode> weightFocusNodes = [FocusNode()];

  List<int> id = [0];
  var pcsSum = 0.0;
  var mtrSum = 0.0;
  var weightSum = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      loadData(widget.data!);
    }
    _calculateTotal();
  }

  @override
  void dispose() {
    for (var controller in mtrListController) {
      controller.dispose();
    }
    for (var controller in pcsListController) {
      controller.dispose();
    }
    for (var controller in weightListController) {
      controller.dispose();
    }
    for (var focusNode in mtrFocusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in pcsFocusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in weightFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      actionsPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(),
      actionsOverflowDirection: VerticalDirection.up,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.xTitle, style: GoogleFonts.roboto()),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close))
        ],
      ),
      content: SizedBox(
        height: 400,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                shrinkWrap: true,
                itemCount: mtrListController.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Row(
                      children: [
                        Text("${index + 1}."),
                        SizedBox(width: 10),
                        Expanded(
                            child: EqTextField(
                                controller: pcsListController[index],
                                hintText: "Pcs",
                                labelText: "Pcs",
                                focusNode: pcsFocusNodes[index],
                                keyboardType: TextInputType.number,
                                inputBorder: UnderlineInputBorder(),
                                onChanged: (value) {
                                  _calculateTotal();
                                },
                                onFieldSubmitted: (value) {
                                  if (index < pcsListController.length - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(pcsFocusNodes[index + 1]);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                hPadding: 5,
                                vPadding: 1)),
                        SizedBox(width: 15),
                        Expanded(
                            child: EqTextField(
                                autofocus: true,
                                controller: mtrListController[index],
                                hintText: "Meter",
                                labelText: "Meter",
                                focusNode: mtrFocusNodes[index],
                                keyboardType: TextInputType.number,
                                textInputAction:
                                    index == mtrListController.length - 1
                                        ? TextInputAction.done
                                        : TextInputAction.next,
                                inputBorder: UnderlineInputBorder(),
                                onChanged: (value) {
                                  _calculateTotal();
                                  if (index == mtrListController.length - 1) {
                                    setState(() {
                                      mtrListController
                                          .add(TextEditingController());
                                      pcsListController.add(
                                          TextEditingController(text: "1"));
                                      weightListController
                                          .add(TextEditingController());
                                      mtrFocusNodes.add(FocusNode());
                                      pcsFocusNodes.add(FocusNode());
                                      weightFocusNodes.add(FocusNode());
                                      id.add(0);
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (index < mtrListController.length &&
                                      mtrListController[index].text.isEmpty) {
                                    return 'Value is required';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (index < mtrListController.length - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(mtrFocusNodes[index + 1]);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                hPadding: 3,
                                vPadding: 1)),
                        if (widget.showWeight) ...[
                          const SizedBox(width: 15),
                          Expanded(
                              child: EqTextField(
                                  autofocus: true,
                                  controller: weightListController[index],
                                  hintText: "Weight",
                                  labelText: "Weight",
                                  focusNode: weightFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textInputAction:
                                      index == weightListController.length - 1
                                          ? TextInputAction.done
                                          : TextInputAction.next,
                                  inputBorder: UnderlineInputBorder(),
                                  onChanged: (value) {
                                    _calculateTotal();
                                  },
                                  onFieldSubmitted: (value) {
                                    if (index <
                                        weightListController.length - 1) {
                                      FocusScope.of(context).requestFocus(
                                          weightFocusNodes[index + 1]);
                                    } else {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  hPadding: 3,
                                  vPadding: 1)),
                        ],
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () => _removeRow(index),
                          child: const Icon(Icons.delete,
                              color: Color(0xFF6B74D6), size: 27),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Pcs : ",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(
                    "$pcsSum",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Meter : ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "$mtrSum",
                    style: TextStyle(fontSize: 16),
                  ),
                  if (widget.showWeight) ...[
                    SizedBox(width: 12),
                    Text(
                      "Weight : ",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text("$weightSum", style: TextStyle(fontSize: 16)),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _addRow,
                  child: Center(
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 5),
                        child: Row(
                          children: const [
                            Text(
                              "Add More",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pcsSum = 0;
                    mtrSum = 0;
                    setState(() {
                      mtrListController.clear();
                      pcsListController.clear();
                      weightListController.clear();
                      mtrFocusNodes.clear();
                      pcsFocusNodes.clear();
                      weightFocusNodes.clear();
                      id.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "CLEAR ALL",
                      style: TextStyle(
                          fontSize: 16,
                          color: mtrListController.isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: EqButton(
                text: "CANCEL",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: EqButton(
                color: Colors.blue,
                text: "SAVE",
                onPressed: () {
                  saveData();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  void saveData() {
    final List<Map<String, dynamic>> data = [];
    data.clear();
    for (int i = 0; i < mtrListController.length; i++) {
      if (mtrListController[i].text.isNotEmpty) {
        final item = {
          "id": id[i].toString(),
          "controlid": widget.xControlId,
          "parcontrolid": widget.xparControlId,
          'sub_pcs': pcsListController[i].text,
          'sub_meters': mtrListController[i].text,
          if (widget.showWeight) 'sub_weight': weightListController[i].text,
        };
        data.add(item);
      }
    }

    if (widget.onSave != null) {
      widget.onSave!(data);
    }
  }

  void loadData(List<Map<String, dynamic>> jsonData) {
    setState(() {
      mtrListController.clear();
      pcsListController.clear();
      weightListController.clear();
      mtrFocusNodes.clear();
      pcsFocusNodes.clear();
      weightFocusNodes.clear();
      id.clear();

      for (var item in jsonData) {
        mtrListController
            .add(TextEditingController(text: item['sub_meters'].toString()));
        pcsListController
            .add(TextEditingController(text: item['sub_pcs'].toString()));
        if (widget.showWeight) {
          weightListController.add(TextEditingController(
              text: item['sub_weight']?.toString() ?? ''));
        } else {
          weightListController.add(TextEditingController());
        }
        id.add(int.parse(item['id'].toString()));

        mtrFocusNodes.add(FocusNode());
        pcsFocusNodes.add(FocusNode());
        weightFocusNodes.add(FocusNode());
      }

      mtrListController.add(TextEditingController());
      pcsListController.add(TextEditingController(text: "1"));
      weightListController.add(TextEditingController());
      mtrFocusNodes.add(FocusNode());
      pcsFocusNodes.add(FocusNode());
      weightFocusNodes.add(FocusNode());
      id.add(0);
    });
  }

  void _addRow() {
    setState(() {
      mtrListController.add(TextEditingController());
      pcsListController.add(TextEditingController(text: "1"));
      weightListController.add(TextEditingController());
      mtrFocusNodes.add(FocusNode());
      pcsFocusNodes.add(FocusNode());
      weightFocusNodes.add(FocusNode());
      id.add(0);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newIndex = mtrListController.length - 1;
      FocusScope.of(context).requestFocus(mtrFocusNodes[newIndex]);
    });
  }

  void _removeRow(int index) {
    if (index < 0 || index >= mtrListController.length) return;
    setState(() {
      pcsListController[index].dispose();
      mtrListController[index].dispose();
      weightListController[index].dispose();
      pcsListController.removeAt(index);
      mtrListController.removeAt(index);
      weightListController.removeAt(index);
      pcsFocusNodes.removeAt(index);
      mtrFocusNodes.removeAt(index);
      weightFocusNodes.removeAt(index);
      id.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    double pcsTotal = 0.0;
    double mtrTotal = 0.0;
    double weightTotal = 0.0;

    bool hasValidMtrEntry = false;

    for (int i = 0; i < mtrListController.length; i++) {
      final mtrText = mtrListController[i].text;
      if (mtrText.isNotEmpty && double.tryParse(mtrText) != null) {
        mtrTotal += double.tryParse(mtrText) ?? 0.0;
        hasValidMtrEntry = true;

        // Only calculate pcs and weight if meter is valid
        final pcsText = pcsListController[i].text;
        final weightText = weightListController[i].text;

        if (pcsText.isNotEmpty && double.tryParse(pcsText) != null) {
          pcsTotal += double.tryParse(pcsText) ?? 0.0;
        }

        if (widget.showWeight &&
            weightText.isNotEmpty &&
            double.tryParse(weightText) != null) {
          weightTotal += double.tryParse(weightText) ?? 0.0;
        }
      }
    }

    // Only reset totals if there are no valid meter entries
    if (!hasValidMtrEntry) {
      pcsTotal = 0.0;
      weightTotal = 0.0;
    }

    setState(() {
      pcsSum = pcsTotal;
      mtrSum = mtrTotal;
      weightSum = weightTotal;
    });
  }
}
