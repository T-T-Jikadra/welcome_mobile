// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_collection_literals, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/report/reportPDFPreview.dart';
import 'package:welcome_mob/common/report/reportSettingView.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:welcome_mob/globals.dart';

class ShowdfReportNew extends StatefulWidget {
  ShowdfReportNew(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      fromdate,
      todate,
      data,
      colinfo,
      RptCaption,
      RptCaption2,
      Rptalias,
      aGroup})
      : super(key: mykey) {
    xCompanyId = companyid;
    xCompanyName = companyname;
    xFBeg = fbeg;
    xFBnd = fend;
    xFromDate = fromdate;
    xToDate = todate;
    xData = data;
    xColInfo = colinfo;
    xRptCaption = RptCaption;
    xRptCaption2 = RptCaption2;
    xRptAlias = Rptalias;
    xGroup = aGroup;
  }

  var xColInfo;
  var xData;
  var xGroup;
  var xRptCaption;
  var xRptCaption2;
  var xRptAlias;
  var xCompanyId;
  var xCompanyName;
  var xFBeg;
  var xFBnd;
  var xFromDate;
  var xGrp = '';
  var xToDate;

  @override
  _ShowdfReportNewPageState createState() => _ShowdfReportNewPageState();
}

class _ShowdfReportNewPageState extends State<ShowdfReportNew> {
  // bool _isChecked = false;
  var loading = true;
  List _companydetails = [];
  final Set<int> _selectedRows = Set<int>();

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    print("ababc");
    print(widget.xGroup);
    super.initState();
    loaddetails();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colInfo = widget.xColInfo;
    // var companyid = widget.xCompanyId;
    // var cRptalias = widget.xRptAlias;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 117, 175, 223),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: Colors.blue.shade200,
            title: Text(
              "${widget.xCompanyName} \n( ${widget.xFBeg} - ${widget.xFBnd} )",
              style: TextStyle(color: Colors.white),
            ),
            leading: Image.asset("assets/icon/WM_p.png", height: 50),
            // Icon(Icons.business_center_rounded,
            //     color: Colors.white, size: 45),
          ),
        ),
      ),
      appBar: AppBar(
          backgroundColor: eqPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white),
          title: RichText(
            // textAlign: TextAlign.center,
            text: TextSpan(
                text: widget.xRptCaption,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'muli',
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n' + widget.xRptCaption2,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'muli',
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ]),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PdfPreviewPageNew(
              companyId: Globals.companyId,
              companyName: Globals.companyName,
              fBeg: Globals.startdate,
              fEnd: Globals.enddate,
              fromDate: Globals.startdate,
              toDate: Globals.enddate,
              data: widget.xData,
              colInfo: widget.xColInfo,
              RptCaption: widget.xRptCaption,
              RptCaption2: widget.xRptCaption2,
              RptAlias: widget.xRptAlias,
              aGroup: widget.xGroup,
              grp: widget.xGrp,
            );
          }));
        },
        backgroundColor: eqPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.picture_as_pdf_sharp),
      ),
      // body: (loading)
      //     ? Center(child: CircularProgressIndicator())
      //     : SingleChildScrollView(
      body: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Scrollbar(
          controller: _verticalController,
          thickness: 7,
          interactive: true,
          thumbVisibility: true,
          trackVisibility: true,
          radius: Radius.circular(10),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _verticalController,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Scrollbar(
                  controller: _horizontalController,
                  thickness: 7,
                  interactive: true,
                  thumbVisibility: true,
                  trackVisibility: true,
                  radius: Radius.circular(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // For column heading ..
                          Row(
                            children: [
                              for (int i = 0; i < colInfo.length; i++) ...[
                                if (colInfo[i]['visible'].toString() ==
                                    'true') ...[
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    padding: EdgeInsets.all(3.0),
                                    width:
                                        double.parse(colInfo[i]['width']) * 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color.fromARGB(
                                            255, 126, 187, 238)),
                                    child: Text(colInfo[i]['heading'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ],
                          ),
                          // For Grp Total ..
                          for (int i = 0; i < _companydetails.length; i++) ...[
                            if ((_companydetails[i]['grp1total'].length > 0) &&
                                (i != _companydetails.length - 2)) ...[
                              // if ((_companydetails[i]['grp1total'].length > 0) &&
                              //     (i < _companydetails.length) &&
                              //     // (_companydetails[i]['grp1total'].length > 0) &&
                              //     // print(_companydetails[i][widget.xGroup[0]["field"]]);
                              //     (_companydetails[i][widget.xGroup[0]["field"]] !=
                              //         _companydetails[i + 1]
                              //             [widget.xGroup[0]["field"]])) ...[
                              Row(
                                children: [
                                  for (int j = 0; j < colInfo.length; j++) ...[
                                    if (colInfo[j]['visible'].toString() ==
                                        'true') ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Divider(
                                                color: Colors.black, height: 7),
                                            Text(
                                                _companydetails[i]['grp1total']
                                                        [j]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color.fromARGB(
                                                        255, 31, 7, 243),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            DottedLine(
                                                dashLength: 3.0,
                                                lineThickness: 1.5,
                                                direction: Axis.horizontal,
                                                lineLength: double.infinity,
                                                alignment: WrapAlignment.center,
                                                dashColor: const Color.fromARGB(
                                                    255, 92, 91, 91)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ],
                            if (_companydetails[i]['autoword'] != '') ...[
                              Column(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 137, 172, 235)),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(_companydetails[i]['autoword'],
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'muli',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )
                            ],
                            // Data rows ..
                            Row(
                              children: [
                                // Checkbox(
                                //   value: _selectedRows.contains(i),
                                //   onChanged: (bool? isChecked) {
                                //     setState(() {
                                //       if (isChecked == true) {
                                //         _selectedRows.add(i);
                                //       } else {
                                //         _selectedRows.remove(i);
                                //       }
                                //       // if (_selectedRows.contains(i)) {
                                //       //   _selectedRows.remove(i);
                                //       // } else {
                                //       //   _selectedRows.add(i);
                                //       // }
                                //     });
                                //   },
                                // ),
                                for (int j = 0; j < colInfo.length; j++) ...[
                                  if (colInfo[j]['visible'].toString() ==
                                      'true') ...[
                                    if (_companydetails[i]
                                                [colInfo[j]['field']]
                                            .toString() ==
                                        ".00") ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Text("0.00",
                                            textAlign:
                                                (colInfo[j]['align'] == 'r'
                                                    ? TextAlign.right
                                                    : TextAlign.left),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ] else if (_companydetails[i]
                                                [colInfo[j]['field']]
                                            .toString() ==
                                        ".000") ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Text("0.000",
                                            textAlign:
                                                (colInfo[j]['align'] == 'r'
                                                    ? TextAlign.right
                                                    : TextAlign.left),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ] else if (_companydetails[i]
                                                [colInfo[j]['field']]
                                            .toString() ==
                                        ".0000") ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Text("0.00",
                                            textAlign:
                                                (colInfo[j]['align'] == 'r'
                                                    ? TextAlign.right
                                                    : TextAlign.left),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ] else ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: Text(
                                            _companydetails[i]
                                                    [colInfo[j]['field']]
                                                .toString(),
                                            textAlign:
                                                (colInfo[j]['align'] == 'r'
                                                    ? TextAlign.right
                                                    : TextAlign.left),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ],
                                ],
                              ],
                            ),
                            // Grp Total ..
                            if ((_companydetails[i]['grp1total'].length > 0) &&
                                (i == _companydetails.length - 2)) ...[
                              //if ( (this._companydetails[i]['grp1total'].length >0) )...[
                              Row(
                                children: [
                                  for (int j = 0; j < colInfo.length; j++) ...[
                                    if (colInfo[j]['visible'].toString() ==
                                        'true') ...[
                                      Container(
                                        margin: EdgeInsets.all(6.0),
                                        padding: EdgeInsets.all(3.0),
                                        width:
                                            double.parse(colInfo[j]['width']) *
                                                10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Divider(
                                                color: Colors.black, height: 7),
                                            Text(
                                                _companydetails[i]['grp1total']
                                                        [j]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 31, 7, 243),
                                                )),
                                            DottedLine(
                                              dashLength: 3.0,
                                              lineThickness: 1.5,
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              alignment: WrapAlignment.center,
                                              dashColor: const Color.fromARGB(
                                                  255, 92, 91, 91),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              )
                            ],
                            // Net total ..
                            if ((_companydetails[i]['nettotal'].length >
                                0)) ...[
                              Row(
                                children: [
                                  for (int j = 0; j < colInfo.length; j++) ...[
                                    if (colInfo[j]['visible'].toString() ==
                                        'true') ...[
                                      Container(
                                          margin: EdgeInsets.all(6.0),
                                          padding: EdgeInsets.all(3.0),
                                          width: double.parse(
                                                  colInfo[j]['width']) *
                                              10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Divider(
                                                  color: Colors.red, height: 9),
                                              Text(
                                                  _companydetails[i]['nettotal']
                                                              [j]
                                                          .toString()
                                                          .isNotEmpty
                                                      ? NumberFormat(
                                                              "##0.00", "en_US")
                                                          .format(double.tryParse(
                                                                  _companydetails[i]
                                                                              [
                                                                              'nettotal']
                                                                          [j]
                                                                      .toString()) ??
                                                              0.0)
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red)),
                                              DottedLine(
                                                dashLength: 3.0,
                                                lineThickness: 1.5,
                                                dashColor: Colors.red,
                                                direction: Axis.horizontal,
                                                lineLength: double.infinity,
                                                alignment: WrapAlignment.center,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ],
                                ],
                              )
                            ],
                          ]
                        ]),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void _toggleRowSelection(int index) {
    setState(() {
      if (_selectedRows.contains(index)) {
        _selectedRows.add(index);
      } else {
        _selectedRows.remove(index);
      }
    });
  }

  void _printSelectedRows() {
    double sum = 0.0;
    for (int index in _selectedRows) {
      print('Row $index: ${_companydetails[index]}');
      String netamtString = _companydetails[index]['netamt'];
      double netamt = double.parse(netamtString);
      sum += netamt;
    }
    print("Total Sum: $sum");
  }

  Future<bool> loadreportsetting() async {
    // String uri = '';
    // var companyid = widget.xcompanyid;
    // var dbname = Globals.db;
    // var cRptCaption = widget.xRptCaption;
    // var ccalias = widget.xRptalias;
    // var colInfo = widget.xColInfo;
    // var grp = '';
    // if (widget.xGroup.length > 0) {
    //   grp = widget.xGroup[0]['field'];
    //   print(grp);
    //   widget.xgrp = grp;
    // }
    //
    // uri =
    //     'https://www.cloud.equalsoftlink.com/api/api_reportsettinglist?dbname=$dbname&cno=$companyid&alias=' +
    //         ccalias +
    //         cRptCaption +
    //         'Setting';
    // var response = await http.get(Uri.parse(uri));
    // print(uri);
    // var jsonData = jsonDecode(response.body);
    // jsonData = jsonData['Data'];
    // print(jsonData);
    // for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
    //   for (int i = 0; i < colInfo.length; i++) {
    //     if (jsonData[iCtr]['heading'].toString() ==
    //         colInfo[i]['heading'].toString()) {
    //       if (jsonData[iCtr]['visible'].toString() == '0') {
    //         colInfo[i]['visible'] = 'false';
    //       } else if (jsonData[iCtr]['visible'].toString() == 'false') {
    //         colInfo[i]['visible'] = 'false';
    //       }
    //       if (jsonData[iCtr]['visible'].toString() == 'true') {
    //         colInfo[i]['visible'] = 'true';
    //       } else if (jsonData[iCtr]['visible'].toString() == '1') {
    //         colInfo[i]['visible'] = 'true';
    //       }
    //     }
    //   }
    // }
    // setState(() {
    //   loading = false;
    // });
    return true;
  }

  void gotoReportSettings(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => reportSettingView(
                companyid: widget.xCompanyId,
                companyname: widget.xCompanyName,
                fbeg: '',
                fend: '',
                cRptCaption: '${widget.xRptCaption}Setting',
                ColInfo: widget.xColInfo,
                calias: widget.xRptAlias)));
  }

  Future<bool> loaddetails() async {
    setState(() {
      loadreportsetting();
      _companydetails = widget.xData;
      print("widget");
      print(widget.xData);
      print(_companydetails);
      print("abc123");
      print(_companydetails.length);
      for (int i = 0; i < _companydetails.length; i++) {
        // print(_companydetails[i][widget.xGroup[0]["field"]]);

        print(_companydetails[i]['autoword']);
        print(_companydetails[i]);
      }
      print(_companydetails[_companydetails.length - 1]);
    });

    return true;
  }
}

void execDelete(BuildContext context, int index, int id, String name) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Country ??'),
      content: Text('Do you want to delete this country $name ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {},
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return;
}

void doNothing(BuildContext context) {}
