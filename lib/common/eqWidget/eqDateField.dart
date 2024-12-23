// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EqDateField extends StatelessWidget {
  final String lblText;
  final String hintText;
  final bool? enabled;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final Function(String)? onDateSelected;
  final String? Function(String?)? validator;

  const EqDateField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.lblText,
      this.enabled,
      this.validator,
      this.focusNode,
      this.onDateSelected});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd-MM-yyyy').parse(controller.text),
        firstDate: DateTime(2015),
        lastDate: DateTime(2201));
    if (picked != null) {
      String yyFormat = DateFormat('yyyy-MM-dd').format(picked);
      String ddFormat = DateFormat('dd-MM-yyyy').format(picked);

      controller.text = ddFormat;
      onDateSelected!(yyFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            enabled: enabled,
            readOnly: true,
            // autofocus: true,
            focusNode: focusNode,
            validator: validator,
            controller: controller,
            style: TextStyle(fontFamily: 'muli'),
            decoration: InputDecoration(
              labelStyle:
                  TextStyle(fontFamily: 'muli', fontWeight: FontWeight.bold),
              hintStyle: TextStyle(fontFamily: 'muli', fontSize: 10),
              border: OutlineInputBorder(),
              hintText: hintText,
              labelText: lblText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(CupertinoIcons.calendar),
            ),
          ),
        ),
      ),
    );
  }
}
