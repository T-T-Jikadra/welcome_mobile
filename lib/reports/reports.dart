import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqGridCard.dart';
import 'package:welcome_mob/menuFunction/dashbFunc.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List reportMenuList = [];

  @override
  void initState() {
    super.initState();
    reportMenuList
        .add({'title': 'Repairing Report', 'callback': fun_RepairRpt});
    reportMenuList.add({'title': 'Sales Report', 'callback': fun_salesRpt});
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EqAppBar(TitleText: "All Reports"),
        body: eqGridCard(listData: reportMenuList, iconName: "shield"));
  }
}
