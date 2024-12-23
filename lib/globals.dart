// Global file to sotre global values to be used in different modules ..

import 'package:flutter/cupertino.dart';

TextStyle eqGridTextStyle =
    TextStyle(fontFamily: 'muli', fontWeight: FontWeight.w900);

class Globals {
  // Domain Url to add at starting ..
  static String domainUrl =
      "https://welcome-mob-node.netlify.app/.netlify/functions/api";

  // Save post API to append in the API ..
  static String saveUrl =
      "&sysdb=${Globals.db}&dbname=${Globals.companyId}&acompanylist=${Globals.companyId}&username=${Globals.username}&costartdate=${Globals.startdate}&coenddate=${Globals.enddate}";

  // common post fix API to LOAD in list ..
  static String list_delUrl =
      "&sysdb=${Globals.db}&dbname=${Globals.companyId}&username=${Globals.username}&costartdate=${Globals.startdate}&coenddate=${Globals.enddate}";

  // common API to for view API
  static String commonViewUrl =
      "&sysdb=${Globals.db}&dbname=${Globals.companyId}&costartdate=${Globals.startdate}&coenddate=${Globals.enddate}";

  // static variables ..
  static int nRecord = 30;

  static String key = '';
  //User Name
  static String username = '';
  //password
  static String pwd = '';
  //Database Name  -- sysdb
  static String db = '';
  //Company id  --  Ex. = eq20242025
  static String companyId = '';
  //Company Name
  static String companyName = 'WELCOME MOBILE';
  //Company City
  static String comCity = '';
  //Company State
  static String comState = '';
  static String cno = '';
  static String fbeg = '';
  static String fend = '';
  static String startdate = '2024-04-01';
  static String enddate = '2025-03-31';
  static String usrType = '';
  static String partyId = '';
  static String deviceName = '';
  static String model = '';
  static String token = '';
  static String orderChr = '';
  static int orderNo = 0;

  //Master file names
  static String file_company = 'company';
  static String file_item = 'item';
  
  // Transcation file names
  static String file_repair = 'repairing';
  static String file_sales = 'sales';
}
