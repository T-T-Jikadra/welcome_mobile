// ignore_for_file: avoid_types_as_parameter_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:welcome_mob/common/report/show_dfReport.dart';
import 'package:welcome_mob/globals.dart';

class dfReport {
  var xData;
  var xGrp;

  var calias = '';
  var cRptCaption = '';
  var cRptCaption2 = '';

  var aColnfo = [];

  bool allowsort = true;

  Map Grp1Total = {};
  Map NetTotal = {};

  dfReport(Data, Grp) {
    xData = Data;
    xGrp = Grp;
  }

  // Method to add colmn in report ..
  addColumn(String field, String Heading, String DataType, String Width,
      String Decimal, String Align, String Aggregate,
      [bool suppress = false, bool visible = true]) {
    aColnfo.add({
      'field': field,
      'heading': Heading,
      'datatype': DataType,
      'width': Width,
      'decimal': Decimal,
      'align': Align,
      'aggregate': Aggregate,
      'visible': visible,
      'suppress': suppress
    });

    NetTotal[field] = 0;
  }

  putTotal(iCtr, xData, Grp1Total) {
    var atotal = [];
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      if (aColnfo[colCtr]['aggregate'] == 'sum') {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        atotal.add(Grp1Total[field].toStringAsFixed(int.parse(decimal)));
        print(atotal);
      } else {
        atotal.add('');
      }
    }
    xData[iCtr]['grp1total'] = atotal;
    xData[iCtr]['nettotal'] = [];
  }

  putNetTotal(xData, Grp1Total) {
    var atotal = {};
    atotal['auto'] = '';
    atotal['autoword'] = '';
    atotal['bold'] = '';
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      String field = aColnfo[colCtr]['field'];
      atotal[field.toString()] = '';
    }
    atotal['grp1total'] = [];
    atotal['nettotal'] = [];
    xData.add(atotal);

    var atotal2 = [];
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      if (aColnfo[colCtr]['aggregate'] == 'sum') {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        atotal2.add(NetTotal[field].toStringAsFixed(int.parse(decimal)));
      } else {
        atotal2.add('');
      }
    }
    xData[xData.length - 1]['nettotal'] = atotal2;
    print("HELLOWWW");
    print(xData);
  }

  void suppressRecord(List<dynamic> xData) {
    List<Map<String, dynamic>> copiedData = List<Map<String, dynamic>>.from(
        xData.map((item) => Map<String, dynamic>.from(item)));

    List<String> suppressedColumns = [];
    for (var columnInfo in aColnfo) {
      if (columnInfo['suppress'] != null &&
          columnInfo['suppress'].toString() == "true") {
        suppressedColumns.add(columnInfo['field'].toString());
      }
    }

    // Set<String> displayedIds = {};
    Map<String, List<Map<String, dynamic>>> idToRecords = {};

    // Collect records by their ID
    for (var record in copiedData) {
      var id = record['id']?.toString() ?? '';
      if (id.isNotEmpty) {
        if (idToRecords.containsKey(id)) {
          idToRecords[id]!.add(record);
        } else {
          idToRecords[id] = [record];
        }
      }
    }

    // for (var record in copiedData) {
    //   var id = record['id'];
    //   if (idToRecords.containsKey(id)) {
    //     idToRecords[id]!.add(record);
    //   } else {
    //     idToRecords[id] = [record];
    //   }
    // }

    for (var id in idToRecords.keys) {
      var records = idToRecords[id]!;
      if (records.length > 1) {
        // var firstRecord = records.first;
        for (var record in records.skip(1)) {
          for (var column in suppressedColumns) {
            if (record.containsKey(column)) {
              record[column] = '';
            }
          }
        }
      }
    }

    print("Suppressed columns: $suppressedColumns");
    print("Updated copied data: $copiedData");
    xData.clear();
    xData.addAll(copiedData);
  }

  prepareReport() {
    var iCtr;
    var colCtr;
    // var cGrp1Total = '';

    List xData2 = [];
    // List xData3 = xData as List;

    for (int xCtr = 0; xCtr < xData.length; xCtr++) {
      var element = {};
      for (var xKey in xData[0].keys) {
        for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['field'].toString().toLowerCase() ==
              xKey.toString().toLowerCase()) {
            element[xKey] = xData[xCtr][xKey];
          }
        }
      }
      xData2.add(element);
    }
    for (int xCtr = 0; xCtr < xData.length; xCtr++) {
      xData2[xCtr]['bold'] = xData[xCtr]['bold'];
      xData2[xCtr]['auto'] = xData[xCtr]['auto'];
      xData2[xCtr]['autoword'] = xData[xCtr]['autoword'];
    }

    //print('xData2....');
    //print(xData2);
    xData = xData2;

    //print(this.xGrp.length);
    if (xGrp.length == 1) {
      if (allowsort) {
        xData.sort((a, b) => a[xGrp[0]['field']]
            .toString()
            .compareTo(b[xGrp[0]['field']].toString()));
      }
      var cValue = '';
      var chValue = '';
      var cOldValue = '';
      for (int iCtr = 0; iCtr < xData.length; iCtr++) {
        cValue = xData[iCtr][xGrp[0]['field']].toString();
        chValue = xGrp[0]['heading'].toString();

        //print(xData[iCtr]);

        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
        xData[iCtr]['grp1total'] = [];
        xData[iCtr]['nettotal'] = [];

        if ((((iCtr + 1) < xData.length) && (cValue != cOldValue)) ||
            iCtr == 0) {
          if ((iCtr + 1) < xData.length) {
            //cNextValue = _datalist[ictr + 1][xGroupBy].toString();
          }
          cOldValue = cValue;

          xData[iCtr]['auto'] = 'Y';
          xData[iCtr]['autoword'] =
              '$chValue : $cValue';
          xData[iCtr]['bold'] = 'Y';
          xData[iCtr]['grp1total'] = [];
          xData[iCtr]['nettotal'] = [];

          if (iCtr != 0) {
            putTotal(iCtr, xData, Grp1Total);
          }
          //Reset Group Total
          for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
            if (aColnfo[colCtr]['aggregate'] == 'sum') {
              String field = aColnfo[colCtr]['field'];
              Grp1Total[field] = 0;
            }
          }
        }

        //Start Group Total
        // for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
        //   if (aColnfo[colCtr]['aggregate'] == 'sum') {
        //     String field = aColnfo[colCtr]['field'];
        //     print(field);
        //     if (xData[iCtr][field] != '') {
        //       Grp1Total[field] = Grp1Total[field] +
        //           double.parse(xData[iCtr][field].toString());

        //       NetTotal[field] =
        //           NetTotal[field] + double.parse(xData[iCtr][field].toString());
        //       print("nettt");
        //     }
        //     print(NetTotal[field]);
        //     print(Grp1Total[field]);
        //   }
        // }

        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];

            if (xData[iCtr][field] != null) {
              var value = xData[iCtr][field];

              if (value is String) {
                if (value.isNotEmpty) {
                  Grp1Total[field] = Grp1Total[field] + double.parse(value);
                  NetTotal[field] = NetTotal[field] + double.parse(value);
                }
              } else if (value is double) {
                Grp1Total[field] = Grp1Total[field] + value;
                NetTotal[field] = NetTotal[field] + value;
              } else {
                print('Unexpected type for field $field: ${value.runtimeType}');
              }
            }
          }
        }

        if (iCtr == (xData.length - 1)) {
          putTotal(iCtr, xData, Grp1Total);
        }
      }
      putNetTotal(xData, Grp1Total);

      // //First Group Pattern Report
      // var cgroup = '';
      // var cNextGroup = '';
      // for (int iCtr = 0; iCtr < xData.length; iCtr++) {

      //   xData[iCtr]['auto'] = '';
      //   xData[iCtr]['autoword'] = '';
      //   xData[iCtr]['bold'] = '';

      //   if ((iCtr + 1) < xData.length) {
      //       cNextGroup = xData[iCtr + 1][xGrp[0]['field']].toString();

      //       if (cNextGroup != cgroup) {
      //         if (iCtr != 0) {
      //           xData[iCtr + 1]['auto'] = 'Y';

      //           // //Put Total
      //           // var total = {};
      //           // for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //           //   String field = aColnfo[colCtr]['field'];
      //           //   if(aColnfo[colCtr]['aggregate']== 'sum')
      //           //   {
      //           //     total[field] = Grp1Total[field];
      //           //   }
      //           //   else
      //           //   {
      //           //     total[field] = '';
      //           //   }
      //           // }
      //           // total['auto'] = '';
      //           // total['autoword'] = '';
      //           // total['bold'] = 'Y';
      //           // xData.add(total);

      //           //iCtr = iCtr + 1;

      //         } else {
      //           xData[iCtr]['auto'] = 'Y';
      //         }
      //         cgroup = xData[iCtr][xGrp[0]['field']].toString();
      //         xData[iCtr]['autoword'] = cgroup;
      //         xData[iCtr]['bold'] = 'Y';

      //         //Reset Group Total
      //         for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //             if(aColnfo[colCtr]['aggregate']== 'sum')
      //             {
      //               String field = aColnfo[colCtr]['field'];
      //               Grp1Total[field]= 0;
      //             }
      //         }
      //     }
      //     else
      //     {
      //       xData[iCtr]['auto'] = '';
      //       cgroup = xData[iCtr][xGrp[0]['field']].toString();
      //       xData[iCtr]['autoword'] = '';
      //       xData[iCtr]['bold'] = '';

      //       //Start Group Total
      //       for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //           if(aColnfo[colCtr]['aggregate']== 'sum')
      //           {
      //             String field = aColnfo[colCtr]['field'];
      //             Grp1Total[field]= Grp1Total[field] + double.parse(xData[iCtr][field]);
      //           }
      //       }
      //     }
      //   }

      //   cgroup = xData[iCtr][xGrp[0]['field']].toString();
      // }
      // print(xData);
    } else {
      //Start Net Total
      // for (iCtr = 0; iCtr < xData.length; iCtr++) {
      //   for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //     if (aColnfo[colCtr]['aggregate'] == 'sum') {
      //       String field = aColnfo[colCtr]['field'];
      //       if (xData[iCtr][field] != '') {
      //         NetTotal[field] =
      //             NetTotal[field] + double.parse(xData[iCtr][field].toString());
      //       }
      //     }
      //   }
      //   xData[iCtr]['auto'] = '';
      //   xData[iCtr]['autoword'] = '';
      //   xData[iCtr]['bold'] = '';
      //   xData[iCtr]['grp1total'] = [];
      //   xData[iCtr]['nettotal'] = [];
      // }

      for (iCtr = 0; iCtr < xData.length; iCtr++) {
        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];

            var value = xData[iCtr][field];

            if (value != null) {
              if (value is String) {
                if (value.isNotEmpty) {
                  NetTotal[field] =
                      (NetTotal[field] ?? 0) + double.parse(value);
                }
              } else if (value is double) {
                NetTotal[field] = (NetTotal[field] ?? 0) + value;
              } else if (value is int) {
                NetTotal[field] = (NetTotal[field] ?? 0) + value.toDouble();
              } else {
                print('Unexpected type for field $field: ${value.runtimeType}');
              }
            }
          }
        }

        // Initialize additional fields
        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
        xData[iCtr]['grp1total'] = [];
        xData[iCtr]['nettotal'] = [];
      }

      //Put Net Total
      var total = {};
      for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        if (aColnfo[colCtr]['aggregate'] == 'sum') {
          total[field] = NetTotal[field].toStringAsFixed(int.parse(decimal));
        } else {
          total[field] = '';
        }
      }
      total['auto'] = '';
      total['autoword'] = '';
      total['bold'] = 'Y';
      total['grp1total'] = [];
      total['nettotal'] = [];
      // xData.add(total);
      putNetTotal(xData, Grp1Total);
    }
    suppressRecord(xData);
  }

  void GenerateReport(BuildContext context) async {
    // var result = await
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowdfReportNew(
                companyid: Globals.companyId,
                companyname: Globals.companyName,
                fbeg: Globals.startdate,
                fend: Globals.enddate,
                fromdate: Globals.startdate,
                todate: Globals.enddate,
                data: xData,
                colinfo: aColnfo,
                RptCaption: cRptCaption,
                RptCaption2: cRptCaption2,
                Rptalias: calias,
                aGroup: xGrp)));
  }

  // prepareReport1() {
  //   var iCtr;
  //   var colCtr;
  //   // ignore: unused_local_variable
  //   var cGrp1Total = '';
  //   //print(this.xGrp.length);
  //   if (xGrp.length == 1) {
  //     if (allowsort) {
  //       xData.sort((a, b) => a[xGrp[0]['field']]
  //           .toString()
  //           .compareTo(b[xGrp[0]['field']].toString()));
  //     }
  //     var cValue = '';
  //     var chValue = '';
  //     var cOldValue = '';
  //     for (int iCtr = 0; iCtr < xData.length; iCtr++) {
  //       cValue = xData[iCtr][xGrp[0]['field']].toString();
  //       chValue = xGrp[0]['heading'].toString();
  //       xData[iCtr]['auto'] = '';
  //       xData[iCtr]['autoword'] = '';
  //       xData[iCtr]['bold'] = '';
  //       if ((((iCtr + 1) < xData.length) && (cValue != cOldValue)) ||
  //           iCtr == 0) {
  //         if ((iCtr + 1) < xData.length) {
  //           //cNextValue = _datalist[ictr + 1][xGroupBy].toString();
  //         }
  //         cOldValue = cValue;
  //         xData[iCtr]['auto'] = 'Y';
  //         xData[iCtr]['autoword'] =
  //             chValue.toString() + ' : ' + cValue.toString();
  //         xData[iCtr]['bold'] = 'Y';
  //         if (iCtr != 0) {
  //           //puttotal(iCtr, xData, Grp1Total);
  //         }
  //         //Reset Group Total
  //         for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
  //           if (aColnfo[colCtr]['aggregate'] == 'sum') {
  //             String field = aColnfo[colCtr]['field'];
  //             Grp1Total[field] = 0;
  //           }
  //         }
  //       }
  //       //Start Group Total
  //       for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
  //         if (aColnfo[colCtr]['aggregate'] == 'sum') {
  //           String field = aColnfo[colCtr]['field'];
  //           if (xData[iCtr][field] != '') {
  //             Grp1Total[field] =
  //                 Grp1Total[field] + double.parse(xData[iCtr][field]);
  //             NetTotal[field] =
  //                 NetTotal[field] + double.parse(xData[iCtr][field]);
  //           }
  //         }
  //       }
  //       if (iCtr == (xData.length - 1)) {
  //         //puttotal(iCtr, xData, Grp1Total);
  //       }
  //     }
  //     putnettotal(xData, Grp1Total);
  //   } else {
  //     //Start Net Total
  //     for (iCtr = 0; iCtr < xData.length; iCtr++) {
  //       for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
  //         if (aColnfo[colCtr]['aggregate'] == 'sum') {
  //           String field = aColnfo[colCtr]['field'];
  //           if (xData[iCtr][field] != '') {
  //             NetTotal[field] =
  //                 NetTotal[field] + double.parse(xData[iCtr][field]);
  //           }
  //         }
  //       }
  //       xData[iCtr]['auto'] = '';
  //       xData[iCtr]['autoword'] = '';
  //       xData[iCtr]['bold'] = '';
  //     }

  //     //Put Net Total
  //     var total = {};
  //     for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
  //       String field = aColnfo[colCtr]['field'];
  //       String decimal = aColnfo[colCtr]['decimal'];
  //       if (aColnfo[colCtr]['aggregate'] == 'sum') {
  //         total[field] = NetTotal[field].toStringAsFixed(int.parse(decimal));
  //       } else {
  //         total[field] = '';
  //       }
  //     }
  //     total['auto'] = '';
  //     total['autoword'] = '';
  //     total['bold'] = 'Y';
  //     xData.add(total);
  //   }
  //   //print(xData);
  // }

  // void GenerateReport1(BuildContext context) async {
  //   // ignore: unused_local_variable
  //   var result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => ShowdfReportNew(
  //               companyid: Globals.companyid,
  //               companyname: Globals.companyname,
  //               fbeg: Globals.startdate,
  //               fend: Globals.enddate,
  //               fromdate: Globals.startdate,
  //               todate: Globals.enddate,
  //               data: xData,
  //               colinfo: aColnfo,
  //               RptCaption: cRptCaption,
  //               RptCaption2: cRptCaption2,
  //               Rptalias: calias,
  //               aGroup: xGrp)));
  // }
}

// var response = await http.get(Uri.parse(uri));
//         var jsonData = jsonDecode(response.body);
//         var aGroup = [];
//         jsonData = jsonData['data'];
//         print(jsonData);
//         DialogBuilder(context).hideOpenDialog();
//
//         if (dropdownTrnType.toLowerCase() == 'partywise') {
//           aGroup = [
//             {'field': 'party', 'heading': 'Party'}
//           ];
//           jsonData.sort(
//               (a, b) => a['party'].toString().compareTo(b['party'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'agentwise') {
//           aGroup = [
//             {'field': 'agent', 'heading': 'agent'}
//           ];
//           jsonData.sort(
//               (a, b) => a['agent'].toString().compareTo(b['agent'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'hastewise') {
//           aGroup = [
//             {'field': 'haste', 'heading': 'haste'}
//           ];
//           jsonData.sort(
//               (a, b) => a['haste'].toString().compareTo(b['haste'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'transportwise') {
//           aGroup = [
//             {'field': 'Transport', 'heading': 'Transport'}
//           ];
//           jsonData.sort((a, b) =>
//               a['Transport'].toString().compareTo(b['Transport'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'stationwise') {
//           aGroup = [
//             {'field': 'Station', 'heading': 'Station'}
//           ];
//           jsonData.sort((a, b) =>
//               a['Station'].toString().compareTo(b['Station'].toString()));
//         }
//
//
//         String calias = 'sale';
//         String cRptCaption = 'Sale Bill Report';
//         String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
//         dfReport oReport = new dfReport(jsonData, aGroup);
//         oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
//         oReport.addColumn('serial', 'Serial', 'C', '8', '0', 'l', '');
//         oReport.addColumn('srchr', 'Srchr', 'C', '8', '0', 'l', '');
//         oReport.addColumn('party', 'Party', 'C', '20', '0', 'l', '');
//         oReport.addColumn('itemname', 'itemname', 'C', '20', '0', 'l', '');
//         oReport.addColumn('agent', 'Agent', 'C', '15', '0', 'l', '');
//         oReport.addColumn('pcs', 'Pcs', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('cut', 'cut', 'N', '12', '2', 'r', '');
//         oReport.addColumn('meters', 'Meters', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('foldmtr', 'foldmtr', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('rate', 'rate', 'N', '12', '2', 'r', '');
//         oReport.addColumn('amount', 'amount', 'N', '12', '2', 'r', '');
//         oReport.prepareReport();
//         oReport.calias = calias;
//         oReport.cRptCaption = cRptCaption;
//         oReport.cRptCaption2 = cRptCaption2;
//         oReport.GenerateReport(context);
