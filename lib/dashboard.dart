// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:welcome_mob/menuFunction/dashbFunc.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqGridCard.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List menuList = [];

  @override
  void initState() {
    super.initState();
    menuList.add({'title': 'Masters', 'callback': fun_Masters});
    menuList.add({'title': 'Transactions', 'callback': fun_Trancastions});
    menuList.add({'title': 'Reports', 'callback': fun_Reports});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EqAppBar(TitleText: "Dashboard", centerTitle: true),
        body: eqGridCard(listData: menuList, iconName: 'shield'));
  }
}
