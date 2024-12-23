// ignore_for_file: must_be_immutable, unused_local_variable, prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, file_names

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';

class PdfPreviewPageNew extends StatelessWidget {
  PdfPreviewPageNew(
      {Key? myKey,
      companyId,
      companyName,
      fBeg,
      fEnd,
      fromDate,
      toDate,
      data,
      colInfo,
      RptCaption,
      RptCaption2,
      RptAlias,
      aGroup,
      grp})
      : super(key: myKey) {
    xCompanyId = companyId;
    xCompanyName = companyName;
    xFBeg = fBeg;
    xFEnd = fEnd;
    xFromDate = fromDate;
    xToDate = toDate;
    xData = data;
    xColInfo = colInfo;
    xRptCaption = RptCaption;
    xRptCaption2 = RptCaption2;
    xRptAlias = RptAlias;
    xGroup = aGroup;
    xGrp = grp;
  }

  var xCompanyId;
  var xCompanyName;
  var xFBeg;
  var xFEnd;
  var xFromDate;
  var xToDate;
  var xData;
  var xColInfo;
  var xRptCaption;
  var xRptCaption2;
  var xRptAlias;
  var xGroup;
  var xGrp;

  double TotalWidth = 0;
  double TotalColumn = 0;
  double StdPageWidth = 590; //As Per A4 Size
  double ColumnWidthDiff = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: xRptCaption),
      body: PdfPreview(
          build: (context) => buildPdf(),
          pdfFileName: "Welcome Mobile_$xRptCaption.pdf"),
    );
  }

// To build pdf ..
  Future<Uint8List> buildPdf() async {
    final pdf = pw.Document();
    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    //final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(8),
        pageFormat: PdfPageFormat.a4,
        // orientation: pw.PageOrientation.portrait,
        maxPages: 9999,
        //buildTitle(ReportTitle, ReportTitle2, column);
        header: (context) {
          calculateWidth();
          return buildTitle(xRptCaption, xRptCaption2, xColInfo);
        },
        footer: (context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.SizedBox(height: 1),
            pw.Text(
                'Page No : ' +
                    context.pageNumber.toString() +
                    ' / ' +
                    context.pagesCount.toString() +
                    " - By T.T. JIKADRA",
                style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
          ]));
        },
        build: (context) => [
              buildReportDetails(context, xData, xColInfo, xGrp),
            ]));
    return pdf.save();
  }

// To build Report Details in pdf ..
  buildReportDetails(context, reportData, column, groupBy) {
    final List items = [];

    print(reportData);

    var grp = '';
    // if(groupby.length>0){
    //     grp = groupby.xGroup[0]['field'];
    //     print(grp);
    // }
    grp = groupBy;
    var count = reportData.length;

    // var colCount = column.length;
    //
    // var netTotal = [];
    // var grpTotal1 = [];
    //
    // var iCtr = 0;
    //
    // for (iCtr = 0; iCtr < colCount; iCtr++) {
    //   netTotal.add(0);
    //   grpTotal1.add(0);
    // }
    //
    // var nCtr = 0;
    //
    // if (grp != '') {
    //   var cgroup = '';
    //   var cNextGroup = '';
    //   for (iCtr = 0; iCtr < reportdata.length; iCtr++) {
    //     print(iCtr);
    //     if ((iCtr + 1) < reportdata.length) {
    //       cNextGroup = reportdata[iCtr + 1][grp].toString();
    //     }
    //     if (cNextGroup != cgroup) {
    //       if (iCtr != 0) {
    //         if ((iCtr + 1) < reportdata.length) {
    //           reportdata[iCtr + 1]['auto'] = 'Y';
    //         }
    //
    //         for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //           //field = column[jCtr]['field'].toString();
    //           if (column[jCtr]['aggregate'] == 'sum') {
    //             if (reportdata[iCtr][column[jCtr]['field']].toString()!='')
    //             {
    //             grpTotal1[jCtr] = grpTotal1[jCtr] +
    //                 double.parse(
    //                     reportdata[iCtr][column[jCtr]['field']].toString());
    //
    //             netTotal[jCtr] = netTotal[jCtr] +
    //                 double.parse(
    //                     reportdata[iCtr][column[jCtr]['field']].toString());
    //              }
    //           } else if (column[jCtr]['aggregate'] == 'COUNT') {
    //             grpTotal1[jCtr] += 1;
    //             netTotal[jCtr] += 1;
    //           }
    //         }
    //
    //         var newRow = {};
    //         for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //           if ((column[jCtr]['aggregate'] == 'sum') ||
    //               (column[jCtr]['aggregate'] == 'COUNT')) {
    //             newRow[column[jCtr]['field']] = grpTotal1[jCtr];
    //           } else {
    //             newRow[column[jCtr]['field']] = '';
    //           }
    //         }
    //         newRow['bold'] = 'Y';
    //         newRow['line'] = 'Y';
    //
    //         grpTotal1 = [];
    //         for (var xCtr = 0; xCtr < colCount; xCtr++) {
    //           grpTotal1.add(0);
    //
    //         }
    //
    //         cgroup = reportdata[iCtr][grp].toString();
    //         reportdata[iCtr]['autoword'] = cgroup;
    //
    //         reportdata.insert(iCtr + 1, newRow);
    //         iCtr = iCtr + 1;
    //
    //         print(iCtr);
    //         print(reportdata.length);
    //
    //       } else {
    //         reportdata[iCtr]['auto'] = 'Y';
    //
    //         cgroup = reportdata[iCtr][grp].toString();
    //         reportdata[iCtr]['autoword'] = cgroup;
    //         reportdata[iCtr]['bold'] = 'Y';
    //
    //         for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //
    //           if (column[jCtr]['aggregate'] == 'sum') {
    //
    //             if (reportdata[iCtr][column[jCtr]['field']].toString()!='')
    //             {
    //               grpTotal1[jCtr] = grpTotal1[jCtr] +
    //                 double.parse(
    //                     reportdata[iCtr][column[jCtr]['field']].toString());
    //
    //             netTotal[jCtr] = netTotal[jCtr] +
    //                 double.parse(
    //                     reportdata[iCtr][column[jCtr]['field']].toString());
    //             }
    //
    //           } else if (column[jCtr]['aggregate'] == 'COUNT') {
    //             grpTotal1[jCtr] += 1;
    //             netTotal[jCtr] += 1;
    //           }
    //         }
    //       }
    //     } else {
    //       reportdata[iCtr]['auto'] = '';
    //       cgroup = reportdata[iCtr][grp].toString();
    //       reportdata[iCtr]['autoword'] = '';
    //       reportdata[iCtr]['bold'] = '';
    //
    //       for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //
    //         if (column[jCtr]['aggregate'] == 'sum') {
    //           if (reportdata[iCtr][column[jCtr]['field']].toString()!='')
    //           {
    //               grpTotal1[jCtr] = grpTotal1[jCtr] +
    //               double.parse(
    //                   reportdata[iCtr][column[jCtr]['field']].toString());
    //
    //           netTotal[jCtr] = netTotal[jCtr] +
    //               double.parse(
    //                   reportdata[iCtr][column[jCtr]['field']].toString());
    //           }
    //         } else if (column[jCtr]['aggregate'] == 'COUNT') {
    //           grpTotal1[jCtr] += 1;
    //           netTotal[jCtr] += 1;
    //         }
    //       }
    //     }
    //   }
    // }
    //
    // var newRow = {};
    // for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //   if ((column[jCtr]['aggregate'] == 'sum') ||
    //       (column[jCtr]['aggregate'] == 'COUNT')) {
    //     newRow[column[jCtr]['field']] = netTotal[jCtr];
    //   } else {
    //     newRow[column[jCtr]['field']] = '';
    //   }
    // }
    // newRow['bold'] = 'Y';
    // //print(newRow);
    //
    // reportdata.add(newRow);
    //
    // //print(netTotal);
    count = reportData.length;
    for (var iCtr = 0; iCtr < count; iCtr++) {
      items.add({'1', '2', '3', '4'});
    }

    // var cgroup = '';
    // var cNextGroup = '';
    // var cnextgroup = '';
    //
    // print("jatin panshul");
    // print(reportdata);

    return pw.Column(children: <pw.Widget>[
      for (int i = 0; i < items.length; i++) ...[
        // if ((reportData[i]['grp1total'].length > 0))
        if ((reportData[i]['grp1total'].length > 0) &&
            (i != reportData.length - 2)) ...[
          pw.Row(
            children: [
              for (int j = 0; j < column.length; j++) ...[
                if (column[j]['visible'].toString() == 'true') ...[
                  pw.Container(
                    width: double.parse(column[j]['width']) * 8,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(reportData[i]['grp1total'][j].toString(),
                        textAlign: (column[j]['align'] == 'r'
                            ? pw.TextAlign.right
                            : pw.TextAlign.left),
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ],
            ],
          )
        ],
        if (reportData[i]['auto'] == 'Y') ...[
          // if (i != 0) ...[
          //   Container(
          //       width: double.infinity,
          //       child: Text('xxxx',
          //           style: TextStyle(
          //               fontSize: 16,
          //               color: PdfColors.blue,
          //               fontWeight: FontWeight.bold))),
          // ],
          pw.Container(
              width: double.infinity,
              // decoration: pw.BoxDecoration(
              //     border: pw.Border.all(color: PdfColors.black)),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
                  top: pw.BorderSide(width: 1.0, color: PdfColors.black),
                ),
              ),
              child: pw.Text(reportData[i]['autoword'].toString(),
                  style: pw.TextStyle(
                      fontSize: 13,
                      color: PdfColors.blue,
                      fontWeight: pw.FontWeight.bold))),
        ],
        pw.Container(
            width: double.infinity,
            child: pw.Row(children: <pw.Widget>[
              for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
                if (column[colCtr]['visible'].toString() == 'true') ...[
                  if (reportData[i][column[colCtr]['field']].toString() ==
                      ".00") ...[
                    pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        width:
                            (double.parse(column[colCtr]['width'].toString()) *
                                    8) -
                                ColumnWidthDiff,
                        child: pw.Align(
                            alignment: column[colCtr]['align'].toString() == 'r'
                                ? pw.Alignment.centerRight
                                : pw.Alignment.centerLeft,
                            child: pw.Column(children: [
                              pw.Text("0.00",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontWeight:
                                          (reportData[i]['bold'].toString() ==
                                                      'Y' &&
                                                  reportData[i]['auto']
                                                          .toString() !=
                                                      'Y')
                                              ? pw.FontWeight.bold
                                              : pw.FontWeight.normal)),
                            ])))
                  ] else if (reportData[i][column[colCtr]['field']]
                          .toString() ==
                      ".000") ...[
                    pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        width:
                            (double.parse(column[colCtr]['width'].toString()) *
                                    8) -
                                ColumnWidthDiff,
                        child: pw.Align(
                            alignment: column[colCtr]['align'].toString() == 'r'
                                ? pw.Alignment.centerRight
                                : pw.Alignment.centerLeft,
                            child: pw.Column(children: [
                              pw.Text("0.000",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontWeight:
                                          (reportData[i]['bold'].toString() ==
                                                      'Y' &&
                                                  reportData[i]['auto']
                                                          .toString() !=
                                                      'Y')
                                              ? pw.FontWeight.bold
                                              : pw.FontWeight.normal)),
                            ])))
                  ] else if (reportData[i][column[colCtr]['field']]
                          .toString() ==
                      ".0000") ...[
                    pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        width:
                            (double.parse(column[colCtr]['width'].toString()) *
                                    8) -
                                ColumnWidthDiff,
                        child: pw.Align(
                            alignment: column[colCtr]['align'].toString() == 'r'
                                ? pw.Alignment.centerRight
                                : pw.Alignment.centerLeft,
                            child: pw.Column(children: [
                              pw.Text("0.00",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontWeight:
                                          (reportData[i]['bold'].toString() ==
                                                      'Y' &&
                                                  reportData[i]['auto']
                                                          .toString() !=
                                                      'Y')
                                              ? pw.FontWeight.bold
                                              : pw.FontWeight.normal)),
                            ])))
                  ] else ...[
                    pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            left: pw.BorderSide(
                                color: PdfColors.black,
                                width: 0.5,
                                style: pw.BorderStyle.solid),
                            right: pw.BorderSide(
                                color: PdfColors.black, width: 0.5),
                            top: pw.BorderSide(
                                color: PdfColors.black, width: 0.5),
                            bottom: pw.BorderSide(
                                color: PdfColors.black, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        width:
                            (double.parse(column[colCtr]['width'].toString()) *
                                    8) -
                                (ColumnWidthDiff),
                        child: pw.Align(
                            alignment: column[colCtr]['align'].toString() == 'r'
                                ? pw.Alignment.centerRight
                                : pw.Alignment.centerLeft,
                            child: pw.Column(children: [
                              pw.Text(
                                  softWrap: true,
                                  tightBounds: true,
                                  reportData[i][column[colCtr]['field']]
                                          .toString()
                                          .isNotEmpty
                                      ? (reportData[i][column[colCtr]['field']] == 'Days'
                                          ? _calculateDays(reportData[i]
                                              [column[colCtr]['date2']])
                                          : reportData[i][column[colCtr]['field']]
                                              .toString())
                                      : "-",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontSize: (reportData[i]['bold'].toString() ==
                                                  'Y' &&
                                              reportData[i]['auto'].toString() !=
                                                  'Y')
                                          ? 14
                                          : 10,
                                      fontWeight:
                                          (reportData[i]['bold'].toString() == 'Y' &&
                                                  reportData[i]['auto'].toString() != 'Y')
                                              ? pw.FontWeight.bold
                                              : pw.FontWeight.normal)),
                            ])))
                  ]
                ]
              ]
            ])),

        // Grp Total ..
        if ((reportData[i]['grp1total'].length > 0) &&
            (i == reportData.length - 2)) ...[
          pw.Row(
            children: [
              for (int j = 0; j < column.length; j++) ...[
                if (column[j]['visible'].toString() == 'true') ...[
                  pw.Container(
                    width: double.parse(column[j]['width']) * 8,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(reportData[i]['grp1total'][j].toString(),
                        textAlign: (column[j]['align'] == 'r'
                            ? pw.TextAlign.right
                            : pw.TextAlign.left),
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ],
            ],
          )
        ],
        if ((reportData[i]['nettotal'].length > 0)) ...[
          pw.Row(
            children: [
              for (int j = 0; j < column.length; j++) ...[
                if (column[j]['visible'].toString() == 'true') ...[
                  pw.Container(
                    width: double.parse(column[j]['width']) * 8,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(reportData[i]['nettotal'][j].toString(),
                        textAlign: (column[j]['align'] == 'r'
                            ? pw.TextAlign.right
                            : pw.TextAlign.left),
                        style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.red,
                            fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ],
            ],
          )
        ],
      ]
    ]);
  }

  String _calculateDays(String dateString) {
    try {
      // Parse the date from reportData
      DateTime reportDate = DateFormat('dd mm yyyy').parse(dateString);

      // Get the current date
      DateTime endDate = DateTime.now();

      // Calculate the difference
      Duration difference = endDate.difference(reportDate);

      // Return the number of days
      return difference.inDays.toString();
    } catch (e) {
      // If parsing fails, return a placeholder message or handle the error
      return "Error";
    }
  }

// To build Heading Section in pdf ..
  buildTitle(ReportTitle, ReportTitle2, column) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(xCompanyName,
              style: pw.TextStyle(
                  fontSize: 15,
                  color: PdfColors.red,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 3),
          pw.Text(ReportTitle,
              style: pw.TextStyle(
                  fontSize: 13,
                  color: PdfColors.blue,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 2),
          pw.Text(ReportTitle2,
              style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Container(
              // width: double.infinity,
              height: 15,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Row(children: <pw.Widget>[
                for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
                  if (column[colCtr]['visible'].toString() == 'true') ...[
                    pw.Container(
                        //color: PdfColors.grey200,
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black)),
                        width:
                            (double.parse(column[colCtr]['width'].toString()) *
                                    8) -
                                ColumnWidthDiff,
                        child: pw.Align(
                            alignment: column[colCtr]['align'].toString() == 'r'
                                ? pw.Alignment.center
                                : pw.Alignment.center,
                            child: pw.Column(children: [
                              pw.Text(column[colCtr]['heading'].toString(),
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      //background:PdfColors.grey,
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold)),
                            ])))
                  ]
                ]
              ]))
        ],
      );

  void calculateWidth() {
    TotalWidth = 0;
    TotalColumn = 0;
    for (int colCtr = 0; colCtr < xColInfo.length; colCtr++) {
      if (xColInfo[colCtr]['visible'].toString() == 'true') {
        TotalWidth += double.parse(xColInfo[colCtr]['width'].toString()) * 8;
        TotalColumn += 1;
      }
    }
    double widthDiff = 0;
    if (TotalWidth > StdPageWidth) {
      widthDiff = TotalWidth - StdPageWidth;
      if (widthDiff > 0) {
        ColumnWidthDiff = widthDiff / TotalColumn;
      }
    }
  }
}
