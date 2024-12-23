// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqGridCard.dart';
import 'package:welcome_mob/menuFunction/dashbFunc.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List transactionMenuList = [];

  @override
  void initState() {
    super.initState();
    transactionMenuList.add({
      'title': 'Repairing Section',
      'callback': fun_Repair,
      "addcallback": fun_AddRepair
    });
    transactionMenuList.add({
      'title': 'Sales Section',
      'callback': fun_Sales,
      "addcallback": fun_AddSales
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EqAppBar(TitleText: "Transaction"),
        body: eqGridCard(
            listData: transactionMenuList, iconName: "shield", add: true));
  }
}
