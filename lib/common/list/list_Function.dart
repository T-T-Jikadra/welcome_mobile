// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:welcome_mob/common/list/open_List.dart';

// Common method to open common search list across the app ..
Future<List> openSearchList(
    BuildContext context,
    String title,
    bool multiSelection,
    String api,
    String fileName,
    String defFilter,
    String dataFormat,
    String filterCol,
    List<String>? filterCondition,
    Future<List<dynamic>?> Function() onAddFun,
    [List? value]) async {
  List retValue = [];
  print(value);
  if (value != null) {
    retValue = value;
  }

  var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => open_List(
            api: api,
            acctype: "",
            title: title,
            onAdd: onAddFun,
            selValue: retValue,
            fileName: fileName,
            defFilter: defFilter,
            filterCol: filterCol,
            dataFormat: dataFormat,
            filterCondition: filterCondition,
            multiSelection: multiSelection),
      ));
  return res as List;
}
