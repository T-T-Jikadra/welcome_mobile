import 'package:flutter/material.dart';
import 'package:welcome_mob/menuFunction/dashbFunc.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqGridCard.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {
  List masterMenuList = [];

  @override
  void initState() {
    super.initState();
    masterMenuList.add({
      'title': 'Company Master',
      'callback': fun_Company,
      "addcallback": fun_AddCompany,
    });
    masterMenuList.add({
      'title': 'Item Master',
      'callback': fun_Item,
      "addcallback": fun_AddItem,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EqAppBar(TitleText: "All Masters"),
        body: eqGridCard(
            listData: masterMenuList, iconName: "shield", add: true));
  }
}
