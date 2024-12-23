// ignore_for_file: must_be_immutable, depend_on_referenced_packages, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_const_constructors, avoid_print, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, prefer_is_empty, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:welcome_mob/common/printSalesInvoice.dart';
import 'package:welcome_mob/globals.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:welcome_mob/transaction/salesMaster/add_Sales.dart';
import 'package:welcome_mob/models/salesModel.dart';

class salesView extends StatefulWidget {
  final VoidCallback onAdd;
  final VoidCallback onBack;
  final void Function(int) onPDF;
  final void Function(int) onDel;
  final void Function(int, Map<String, dynamic>) onEdit;
  final void Function(int, Map<String, dynamic>) onView;
  //final VoidCallback onPDF;
  //final VoidCallback onDel;
  //const ModuleVIew(
  //{super.key, companyid, companyname, fbeg, fend, required this.onAdd});

  salesView(
      {Key? mykey,
      api,
      Data,
      DataFormat,
      Title,
      TableName,
      defSearch,
      fileNanme,
      modelName,
      date = '',
      serial = '',
      amt = '',
      srchr = '',
      required this.onAdd,
      required this.onBack,
      required this.onPDF,
      required this.onDel,
      required this.onEdit,
      required this.onView
      //required this.onDel
      })
      : super(key: mykey) {
    xcompanyid = Globals.companyId;
    xcompanyname = Globals.companyName;
    xfbeg = Globals.fbeg;
    xfend = Globals.fend;

    _api = api;
    _Data = Data;
    // _date = date;
    // _serial = serial;
    xFileNanme = fileNanme;
    xModelName = modelName;
    _amt = amt;
    // _srchr = srchr;
    _TableName = TableName;
    _defSearch = defSearch;
    _DataFormat = DataFormat;
    //_orgData = Data;
  }

  var xcompanyid;
  var xcompanyname;
  var xFileNanme;
  var xModelName;
  var xfbeg;
  var xfend;
  // var _date;
  // var _serial;
  var _amt;
  // var _srchr;

  String _api = '';
  // ignore: unused_field
  String _TableName = '';
  String _defSearch = '';
  String _DataFormat = '';
  List<salesModel> _Data = [];
  // List _orgData = [];

  @override
  _ModuleViewPageState createState() => _ModuleViewPageState();
}

class _ModuleViewPageState extends State<salesView> {
  //bool _searchBoolean = false;
  String _filter = "";
  String _filterCol = "";
  String searchValue = "";
  int _selectedIndex = -1;
  String dropdownPrintFormat = 'Print Format';

  List PrintFormatDetails = [];
  List PrintidDetails = [];

  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<dynamic>> _streamDataController =
      StreamController<List<dynamic>>();

  // Icon cusIcon = Icon(Icons.search);
  List _salesDetails = [];
  List _filteredData = [];
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _filterCol = widget._defSearch;
    loadData().then((value) => isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      floatingActionButton: _isFabVisible ? floatingButton() : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.scrollDelta! > 0) {
              setState(() {
                _isFabVisible = false;
              });
            } else if (scrollNotification.scrollDelta! < 0) {
              setState(() {
                _isFabVisible = true;
              });
            }
          }
          return true;
        },
        child: Column(children: <Widget>[
          _searchTextField(),
          SizedBox(
            height: 40,
            child: buildFilterListView(),
          ),
          if (_filteredData.isEmpty)
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("No Data Found !!!")],
            )),
          if (isLoading)
            Expanded(
                child: Skeletonizer(
              enabled: true,
              enableSwitchAnimation: true,
              child: ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  String _DataFormat2 = widget._DataFormat;
                  // for (var xkey in widget._Data[0].keys) {
                  //   _DataFormat2 = _DataFormat2.replaceAll(
                  //       '#' + xkey + '#', widget._Data[index][xkey].toString());
                  // }
                  List lst = splitText(_DataFormat2);
                  return Card(
                    surfaceTintColor: Colors.white,
                    color: (index % 2 == 0) ? Colors.white : Colors.grey[300],
                    elevation: 3,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  for (int i = 0; i < lst.length; i++) ...[
                                    if (lst[i].toString().contains('<b>')) ...[
                                      TextSpan(
                                          text: lst[i]
                                              .toString()
                                              .replaceAll('<b>', ''),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'muli',
                                              fontWeight: FontWeight.bold))
                                    ] else ...[
                                      TextSpan(
                                          text: lst[i],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'muli'))
                                    ],
                                    TextSpan(text: ' '),
                                  ]
                                ],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward))),
                  );
                },
              ),
            ))
          else
            Expanded(
                child: RefreshIndicator(
              onRefresh: _refreshData,
              child: SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.builder(
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    var salesModel;
                    String formattedData = '';
                    salesModel = _salesDetails[index];
                    formattedData = _formatData(salesModel, widget._DataFormat);

                    // String _DataFormat2 = widget._DataFormat;
                    // String _Date = widget._date;
                    // String _Serial = widget._serial;
                    String _amt = widget._amt;
                    // String _srchr = widget._srchr;

                    List lst = splitText(formattedData);
                    // List dateData = splitText(_Date);
                    // List serialData = splitText(_Serial);
                    List amtData = splitText(_amt);
                    // List srchrData = splitText(_srchr);

                    return Slidable(
                        key: ValueKey(index),
                        startActionPane:
                            ActionPane(motion: const DrawerMotion(), children: [
                          SlidableAction(
                              onPressed: (context) => {
                                    // execPDF(id),
                                    //  widget.onPDF(int.parse(id))
                                  },
                              icon: Icons.picture_as_pdf,
                              label: 'PDF',
                              backgroundColor: Colors.blueAccent),
                          SlidableAction(
                              onPressed: (context) async {
                                await del(salesModel).then((onValue) {
                                  loadData();
                                });
                              },
                              icon: Icons.delete_forever,
                              label: 'Delete',
                              backgroundColor: Color(0xFFFE4A49)),
                          SlidableAction(
                              onPressed: (context) async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddSales(
                                            id: salesModel.id,
                                            salesData: salesModel)));
                                if (res) {
                                  loadData();
                                }
                              },
                              // widget.onEdit(int.parse(id),
                              //     widget._Data[index])

                              icon: Icons.edit_calendar_outlined,
                              label: 'Edit',
                              backgroundColor: Colors.green)
                        ]),
                        child: LayoutBuilder(builder: (context, constraints) {
                          // double screenWidth = constraints.maxWidth;
                          // double iconScaleFactor =
                          //     screenWidth < 600 ? 0.8 : 1.5;
                          // double textScaleFactor =
                          //     screenWidth < 600 ? 0.7 : 0.9;

                          return Card(
                            // shape: RoundedRectangleBorder(
                            //     side: BorderSide(
                            //   //color: Colors.grey,
                            // )),
                            //shape: ShapeDecoration(shape: shape),
                            surfaceTintColor: Colors.white,
                            //color: Colors.white,
                            color:
                                // (index % 2 == 0)
                                //     ?
                                Colors.white,
                            // : Colors.grey[300]
                            //color: (index % 2 == 0) ? Colors.white : Colors.grey[100],
                            elevation: 3,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                                onTap: () async {
                                                  var res = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => AddSales(
                                                              id: salesModel.id,
                                                              salesData:
                                                                  salesModel)));
                                                  if (res) {
                                                    loadData();
                                                  }
                                                },
                                                title: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      for (int i = 0;
                                                          i < lst.length;
                                                          i++) ...[
                                                        if (lst[i]
                                                            .toString()
                                                            .contains(
                                                                '<b>')) ...[
                                                          TextSpan(
                                                              text: lst[i]
                                                                  .toString()
                                                                  .replaceAll(
                                                                      '<b>',
                                                                      ''),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'muli',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ] else ...[
                                                          TextSpan(
                                                              text: lst[i],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'muli'))
                                                        ],
                                                        TextSpan(text: ' '),
                                                      ]
                                                    ],
                                                  ),
                                                ))),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  "Bill No : ${salesModel.id}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                  convertViewDate(
                                                      salesModel.date),
                                                  textAlign: TextAlign.end,
                                                  style:
                                                      TextStyle(fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        children: [
                                          if (widget._amt.isNotEmpty)
                                            Row(
                                              children: [
                                                Text(
                                                  " Bill Amt : ₹ ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${amtData[0]}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          Spacer(),
                                          // SizedBox(width: 100,),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              await del(salesModel)
                                                  .then((onValue) {
                                                loadData();
                                              });
                                            },
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                          SizedBox(width: 17),
                                          InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        printSalesInvoice(
                                                            Data: salesModel),
                                                  ));
                                              // launchWhatsAppUri(
                                              //     salesModel.mobile,
                                              //     'Repairing Details : \n*Name :* ${salesModel.name} ' +
                                              //         '\n*Mobile no :* ${salesModel.mobile} \n' +
                                              //         '*Company :* ${salesModel.company} \n' +
                                              //         '*Itemname :* ${salesModel.itemname} \n' +
                                              //         '*Price :* ${salesModel.price} \n' +
                                              //         '*Date :* ${salesModel.date} \n' +
                                              //         '*Bill No :* ${salesModel.id} \n' +
                                              //         '*THANKS FOR COMING ~* ```WELCOME MOBILE```');
                                            },
                                            child: FaIcon(
                                                FontAwesomeIcons.whatsapp,
                                                color: Colors.green),
                                          ),
                                          SizedBox(width: 17),
                                          InkWell(
                                            onTap: () async {
                                              var path =
                                                  await generateSalesInvoicePdf(
                                                      salesModel);
                                              XFile xFile = XFile(path);
                                              Share.shareXFiles([xFile],
                                                  text: 'Sales Details:');
                                              // Share.share('Sales Details : \n*Name :* ${salesModel.name} ' +
                                              //     '\n*Mobile no :* ${salesModel.mobile} \n' +
                                              //     '*Company :* ${salesModel.company} \n' +
                                              //     '*Itemname :* ${salesModel.itemname} \n' +
                                              //     '*Price :* ${salesModel.price} \n' +
                                              //     '*Date :* ${salesModel.date} \n' +
                                              //     '*Bill No :* ${salesModel.id} \n' +
                                              //     '*THANKS FOR COMING ~* ```WELCOME MOBILE```');
                                            },
                                            child: Icon(Icons.share,
                                                color: Colors.blueGrey),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }));
                  },
                ),
              ),
            )),
        ]),
      ),
    );
  }

  Future<bool> del(salesModel) async {
    widget.onDel(salesModel.id);
    return true;
  }

  Future<bool> loadDetails() async {
    // showIndicator(context);
    String url = '';
    url = widget._api;

    if ((_filterCol != '') && (_filter != '')) {
      url = widget._api + '&field=$_filterCol&value=$_filter';
    } else {
      url = widget._api + "&field=&value=";
    }
    print(url);

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    print(jsonData);

    setState(() {
      widget._Data = jsonData['data'];
      print(widget._Data);
      _streamDataController.sink.add(widget._Data);
      // widget._orgData = widget._Data;
    });

    // hideIndicator(context);

    return true;
  }

  Future<bool> loadData() async {
    final filePath = await getFilePath(Globals.file_sales);
    final file = File(filePath);
    print("filePath : $filePath");

    if (await file.exists()) {
      final fileContent = await file.readAsString();
      List<dynamic> decoded = json.decode(fileContent);
      setState(() {
        _salesDetails =
            decoded.map((data) => salesModel.fromMap(data)).toList();
        _filteredData = _salesDetails;
        _filteredData.sort((a, b) {
          DateTime dateA = DateFormat("dd-MM-yyyy").parse(a.date);
          DateTime dateB = DateFormat("dd-MM-yyyy").parse(b.date);

          int dateComparison = dateB.compareTo(dateA);
          if (dateComparison != 0) {
            return dateComparison;
          }

          return b.id!.compareTo(a.id!);
          // return dateB.compareTo(dateA);
        });
      });
    } else {
      print("No sales data file found.");
    }

    return true;
  }

  FloatingActionButton floatingButton() {
    return FloatingActionButton(
        backgroundColor: eqPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.of(context)
              .push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddSales(id: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ))
              .then((value) {
            loadData();
          });
        },
        child: Icon(Icons.add));
  }

  Widget _searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _searchController,
        onChanged: (String s) {
          _searchController.value = TextEditingValue(
              text: s.toUpperCase(), selection: _searchController.selection);
          _filter = s;
          print(s);
          SearchData(s);
          if (s.isEmpty) {
            // _selectedIndex = -1;
            // _filterCol = widget._defSearch;
            loadData();
          }
        },
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          //suffixIcon: IconButton(onPressed: (){}), icon:Icon(Icons.filter)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.orange
              //fontSize: 20,
              ),
        ),
      ),
    );
  }

  TextFormField buildSearchFormField() {
    return TextFormField(
        //controller: _srchController,
        onChanged: (value) {
          //checkUserName(value);
        },
        validator: (value) {
          //checkUserName(value);
          return null;
        },
        autofocus: true,
        //keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Search...',
          labelText: "Search...",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // suffixIcon: CustomSuffixIcon(icon: Icons.search),
        ));
  }

  Padding buildFilterListView() {
    List colList = [];
    if (_salesDetails.isEmpty) {
      colList.add('none');
    } else {
      var firstItem = _salesDetails[0];
      var keys = firstItem.toMap().keys.toList();
      print("dtaaa");
      print(keys);
      colList.addAll(keys);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        itemCount: colList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
              // color: Colors.black12.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
              onTap: () {
                if (_selectedIndex == index) {
                  setState(() {
                    _searchController.text = '';
                    _selectedIndex = -1;
                    _filterCol = widget._defSearch;
                    _filter = '';
                    loadData();
                  });
                } else {
                  setState(() {
                    _selectedIndex = index;
                    _filterCol = colList[index];
                  });
                }
              },
              child: Container(
                height: 4,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: FittedBox(
                      child: Text(colList[index],
                          style: TextStyle(
                              color: (_selectedIndex >= 0 &&
                                      _selectedIndex == index)
                                  ? Colors.red
                                  : Colors.black38,
                              fontWeight: FontWeight.bold))),
                ),
              )),
        ),
      ),
    );
  }

  SearchData(s) {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _salesDetails.where((item) {
        return item
                .toMap()[_filterCol]
                ?.toString()
                .toLowerCase()
                .contains(query) ??
            false;
      }).toList();
    });
    if (s != '') {
      //List xData2 = [];
      //List aData = [];

      // if ((widget._orgData.length >= 0) && (_filterCol == '')) {
      //   for (var xkey in widget._orgData[0].keys) {
      //     _filterCol = xkey;
      //     break;
      //   }
      // }
      // loadDetails();

      // for (var xkey in widget._orgData[0].keys) {
      //   if (_filterCol != '') {
      //     loadDetails();
      //     // xData2 = widget._orgData
      //     //     .where((element) => element[_filterCol]
      //     //         .toString()
      //     //         .toUpperCase()
      //     //         .contains(s.toUpperCase()))
      //     //     .toList();
      //   } else {
      //     _filterCol = xkey;
      //     loadDetails();
      //     // xData2 = widget._orgData
      //     //     .where((element) => element[xkey]
      //     //         .toString()
      //     //         .toUpperCase()
      //     //         .contains(s.toUpperCase()))
      //     //     .toList();
      //   }
      //   break;
      // }
      // setState(() {
      //   widget._Data = xData2;
      // });
    } else {
      // loadDetails();
      // setState(() {
      //   widget._Data = widget._orgData;
      // });
    }
  }

  void doPrint(id) async {
    // await setprintformat(dropdownPrintFormat, widget._TableName)
    //     .then((value) => setState(() {
    //           PrintidDetails = value;
    //         }));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PdfViewerPagePrint(
    //         id: id.toString(),
    //         cPW: "PDF",
    //         formatid: PrintidDetails[0]['formatid'],
    //         printid: PrintidDetails[0]['printid'],
    //       ),
    //     ));
  }

  void execPDF(id) async {
    // if (widget._TableName == '') {
    //   widget.onPDF(int.parse(id));
    //   return;
    // }
    // showProgressIndicator(context);
    // await loadprintformat(widget._TableName).then((value) => setState(() {
    //       PrintFormatDetails = value;
    //     }));
    // hideIndicator(context);

    // showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       backgroundColor: Colors.white,
    //       title: const Text('Select Format To Print',
    //           style: TextStyle(fontFamily: 'muli')),
    //       content: SizedBox(
    //         //color: Colors.orange,
    //         height: 70,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Expanded(
    //               child: DropdownButtonFormField(
    //                   style: TextStyle(fontFamily: 'muli', color: Colors.black),
    //                   //value: items.first,
    //                   decoration: const InputDecoration(
    //                       labelText: 'Print Format', hintText: "Print Format"),
    //                   items: PrintFormatDetails.map<DropdownMenuItem<String>>(
    //                       (items) {
    //                     return DropdownMenuItem<String>(
    //                         value: items['caption'],
    //                         child: Text(items['caption']));
    //                   }).toList(),
    //                   icon: const Icon(Icons.arrow_drop_down_circle),
    //                   onChanged: (String? newValue) {
    //                     setState(() {
    //                       dropdownPrintFormat = newValue!;
    //                     });
    //                   }),
    //             )
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         // DefaultButton(
    //         //     text: 'PDF',
    //         //     press: () {
    //         //       if (dropdownPrintFormat == 'Print Format') {
    //         //         AwesomeDialog(
    //         //                 context: context,
    //         //                 dialogType: DialogType.warning,
    //         //                 animType: AnimType.topSlide,
    //         //                 showCloseIcon: true,
    //         //                 title: 'Warning',
    //         //                 desc: 'Invalid Printing Format',
    //         //                 btnCancelOnPress: () {},
    //         //                 btnOkOnPress: () {})
    //         //             .show();
    //         //       } else {
    //         //         doPrint(id);
    //         //       }
    //         //     }),
    //         // DefaultButton(
    //         //     text: 'WhatsApp',
    //         //     press: () {
    //         //       Navigator.push(
    //         //           context,
    //         //           MaterialPageRoute(
    //         //             builder: (context) => PdfViewerPagePrint(
    //         //                 id: id.toString(),
    //         //                 cPW: "WhatsApp",
    //         //                 formatid: PrintidDetails[0]['formatid'],
    //         //                 printid: PrintidDetails[0]['printid']),
    //         //           ));
    //         //     }),
    //         // DefaultButton(
    //         //   text: 'Cancel',
    //         //   press: () {
    //         //     Navigator.of(context).pop();
    //         //   },
    //         // ),
    //       ],
    //     );
    //   },
    //   //onPressed: (context) => {execWhatsApp(int.parse(id))},
    // );
  }

  String _formatData(var data, String format) {
    // format = format.replaceAll("<b>", "");
    RegExp regExp = RegExp(r'#(\w+)#');

    Iterable<Match> matches = regExp.allMatches(format);

    for (var match in matches) {
      String keyword = match.group(0)!;

      String key = keyword.substring(1, keyword.length - 1);

      var value = _getFieldValue(data, key);

      format = format.replaceAll(keyword, value ?? "N/A");
    }

    return format;
  }

  String? _getFieldValue(var data, String key) {
    if (data is salesModel) {
      switch (key) {
        case "id":
          return data.id.toString();
        case "date":
          return data.date;
        case "name":
          return data.name;
        case "mobile":
          return data.mobile;
        case "company":
          return data.company;
        case "itemname":
          return data.itemname;
        case "price":
          return data.price;
        default:
          return null;
      }
    } else {
      return null;
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 1450));
    setState(() {
      loadData();
    });
  }

  Widget appBarTitle = Text(
    "Search Sample",
    style: TextStyle(color: Colors.white),
  );
}
