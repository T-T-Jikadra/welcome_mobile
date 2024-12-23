// ignore_for_file: unused_local_variable, unused_field, prefer_is_empty, depend_on_referenced_packages, non_constant_identifier_names, camel_case_types, must_be_immutable, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/eqWidget/eqAppbar.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/function.dart';

class open_List extends StatefulWidget {
  open_List({
    Key? myKey,
    api,
    title,
    acctype,
    selValue,
    fileName,
    filterCol,
    defFilter,
    this.onAdd,
    dataFormat,
    exFormat,
    multiSelection,
    filterCondition,
  }) : super(key: myKey) {
    xApi = api;
    xTitle = title;
    xAcctype = acctype;
    xFileName = fileName;
    xRetValue = selValue;
    xFormat = dataFormat;
    xDefFilter = defFilter;
    xFilterCol = filterCol;
    xMulti = multiSelection;
    xFilterCondition = filterCondition;
  }

  // int xId = 0;
  Future<List<dynamic>?> Function()? onAdd;

  String xApi = '';
  String xTitle = '';
  String xFormat = '';
  String xAcctype = '';
  String xFileName = '';
  String xDefFilter = '';
  String xFilterCol = '';
  List<String> xFilterCondition = [];
  List xRetValue = [];
  bool? xMulti;
  @override
  OpenListState createState() => OpenListState();
}

class OpenListState extends State<open_List> {
  final TextEditingController _searchController = TextEditingController();

  String AccType = '';
  String Title = '';
  String argsApi = '';
  String filterCol = '';
  String dataFormat = '';
  String exDataFormat = '';
  String imageUrl = '';
  bool multiSelection = false;

  List _partyList = [];
  List _orgPartyList = [];
  List _partySelected = [];
  List _partySelected2 = [];
  List _retParamSelected = [];

  List<bool> _selected = [];
  String query = '';

  String api = '';
  String _filterCol = "";
  String _filter = "";
  bool isLoading = true;
  bool isLocalSearch = false;
  String? strNewState;
  final GlobalKey<EqButtonState> eqBtnKey = GlobalKey<EqButtonState>();

  final StreamController<List<dynamic>> _streamDataController =
      StreamController<List<dynamic>>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getPartyList();
      final localSearchList = {"getSaleorderpendinglist"};
      if (widget.xApi.toString().contains("getSaleorderpendinglist")) {
        isLocalSearch = true;
      }
      loadDetails().then((_) => {
            isLoading = false
            // If an item was added, select it after loading details
            // if (strNewState != null) {selectNewState(strNewState!)}
          });
    });

    setState(() {
      AccType = widget.xAcctype.toString();
      Title = widget.xTitle.toString();
      List selValue = widget.xRetValue;

      if ((selValue.length > 0) && (_partySelected.length <= 0)) {
        if (widget.xMulti!) {
          List<String> items = List<String>.from(selValue[0]);
          print('Items from selValue[0]: $items');

          for (var item in items) {
            var splitItems = item.split(',').map((i) => i.trim()).toList();

            for (var splitItem in splitItems) {
              print('Itemdata: $splitItem');
              if (!_partySelected.contains(splitItem)) {
                _partySelected.add(splitItem);
              }

              var newItem = {'text': splitItem, 'value': splitItem};

              _retParamSelected.add(newItem);
              print('_retParamSelected : $_retParamSelected');
            }
          }

          print('Updated _partySelected: $_partySelected');
          print('Length of _partySelected: ${_partySelected.length}');
        } else {
          _partySelected = selValue[0];
        }

        _partySelected2 = selValue[1];
      }

      argsApi = widget.xApi;
      filterCol = widget.xFilterCol;
      setState(() {
        _filterCol = filterCol;
      });

      setState(() {
        dataFormat = widget.xFormat;
        multiSelection = widget.xMulti!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EqAppBar(TitleText: widget.xTitle),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: FloatingActionButton(
          backgroundColor: eqPrimaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            final result = await widget.onAdd?.call();
            print("aa");
            print(result);
            if (result != null) {
              print("-result-");
              print(result);
              if (result != null) {
                print(result);
                // _res = value;
                _retParamSelected = result;
                print(_retParamSelected);
                isLoading = true;
                strNewState = result[0]['text'];
                eqBtnKey.currentState?.trigger();
              }
            }
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          buildSearchTextBox(),
          SizedBox(
            height: 40,
            child: buildSelectedListView(),
          ),
          isLoading
              ? Expanded(
                  child: Column(
                  children: [
                    Spacer(),
                    showLoading(),
                    Spacer(),
                  ],
                ))
              : StreamBuilder(
                  stream: _streamDataController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Expanded(
                          child: Column(
                        children: [
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel),
                              SizedBox(width: 10),
                              _searchController.text.length > 0
                                  ? Text(
                                      "No result found for - ${_searchController.text}  \nAdd new item here ..")
                                  : Text("No Data found !!! "),
                            ],
                          ),
                          Spacer()
                        ],
                      ));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _partyList.length,
                        itemBuilder: (context, index) {
                          String dataFormat2 = dataFormat;

                          for (var xKey in _partyList[0].keys) {
                            dataFormat2 = dataFormat2.replaceAll(
                                '${'#' + xKey}#',
                                _partyList[index][xKey].toString());
                          }
                          List lst = splitText(dataFormat2);

                          var id = _partyList[index]['state'].toString();
                          String value =
                              _partyList[index][filterCol].toString();

                          return Column(
                            children: [
                              ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      for (int i = 0; i < lst.length; i++) ...[
                                        if (lst[i]
                                            .toString()
                                            .contains('<b>')) ...[
                                          TextSpan(
                                              text: lst[i]
                                                  .toString()
                                                  .replaceAll('<b>', ''),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'muli',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold))
                                        ] else ...[
                                          TextSpan(
                                              text: lst[i],
                                              style: TextStyle(
                                                  fontFamily: 'muli',
                                                  color: Colors.black))
                                        ],
                                        TextSpan(text: ' '),
                                      ]
                                    ],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  setSelection(value, id, _partyList[index]);
                                },
                              ),
                              Padding(
                                // padding: const EdgeInsets.only(left: 15,right: 15),
                                padding: const EdgeInsets.all(8),
                                child: DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.5,
                                  dashLength: 3.0,
                                  dashColor:
                                      const Color.fromARGB(255, 177, 175, 175),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }),
          EqButton(
            key: eqBtnKey,
            text: 'Select',
            onPressed: () {
              Navigator.pop(context,
                  [_partySelected, _partySelected2, _retParamSelected] as List);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> getPartyList() async {
    //var response;
    //var db = globals.dbname;

    api = argsApi;
    var limit = 20;
    // var cno = Globals.cno;
    // var clientId = Globals.db;

    // api =
    //     "https://www.cloud.equalsoftlink.com/api/api_partylist?dbname=$clientid&cno=$cno&limit=$limit&acctype=$AccType";

    //var response = await http.get(Uri.parse(api));
    // if (AccType != '') {

    //   // response = await http.get(Uri.parse(
    //   //     'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=' +
    //   //         db +
    //   //         '&acctype=' +
    //   //         AccType));
    // } else {
    //   response = await http.get(Uri.parse(
    //       'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=' +
    //           db +
    //           '&acctype='));
    // }

    // var jsonData = jsonDecode(response.body);

    // jsonData = jsonData['Data'];

    // this.setState(() {
    //   _partylist = jsonData;
    //   _orgpartylist = jsonData;
    //   _selected = List.generate(jsonData.length, (i) => false);
    // });
    return true;
  }

  Future<bool> loadDetails() async {
    var partyJson = await readJsonFromFileList1('${widget.xFileName}.json',
        filters: widget.xFilterCondition);
    List<dynamic> filteredJson;

    String searchTerm = _searchController.text.toLowerCase();
    print("Search term: $searchTerm");

    if (searchTerm.isNotEmpty) {
      // If the search term is not empty, filter based on it
      filteredJson = partyJson.where((party) {
        if (party[widget.xFilterCol] is String) {
          return party[widget.xFilterCol].toLowerCase().contains(searchTerm);
        }
        return false;
      }).toList();

      // Sort the filtered results
      filteredJson.sort((a, b) {
        String partyA = a[widget.xFilterCol].toLowerCase();
        String partyB = b[widget.xFilterCol].toLowerCase();
        int indexA = partyA.indexOf(searchTerm);
        int indexB = partyB.indexOf(searchTerm);
        return indexA.compareTo(indexB);
      });

      print("Filtered results count: ${filteredJson.length}");
    } else {
      filteredJson = partyJson.where((party) {
        // print(party);
        return widget.xFilterCondition.any((filter) => party[widget.xDefFilter]
            .toLowerCase()
            .contains(filter.toLowerCase()));
      }).toList();
    }

    print(filteredJson);

    setState(() {
      _partyList = filteredJson;
      _streamDataController.sink.add(_partyList);

      print(_partyList.length);
      print(_partyList);
      _orgPartyList = filteredJson;
      _selected = List.generate(filteredJson.length, (i) => false);
    });

    return true;
  }

  cloudSearch(s) {
    loadDetails();
  }

  Widget add() {
    if (query.length >= 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                //print('Add Clicked..');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PartyMaster(
                //       companyid: widget.xcompanyid,
                //       companyname: widget.xcompanyname,
                //       fbeg: widget.xfbeg,
                //       fend: widget.xfend,
                //       id: '0',
                //       acctype: "SALE PARTY",
                //       newParty: query,
                //     ),
                //   ),
                // );
              },
              child: Text('Add'),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  setSelection(account, id, data) {
    if (!multiSelection) {
      setState(() {
        _partySelected = [];
        _partySelected2 = [];
        _retParamSelected = [];
        _partySelected.add(account);
        // _partySelected2.add(id);
        _retParamSelected.add(data);
      });
    } else {
      print('in multi abc');
      print(_retParamSelected);
      bool found = _partySelected.contains(account);
      if (!found) {
        setState(() {
          _partySelected.add(account);
          _retParamSelected.add(data);
          // _partySelected2.add(id);
        });
      } else {
        print('else in multi');
        print(data);
        //int index = _partySelected.indexOf(account);
        setState(() {
          print(_retParamSelected.length);
          _retParamSelected.remove(data);
          _partySelected.remove(account);
          _partySelected2.remove(id);
        });
        print(_retParamSelected);
      }
    }

    //setState(() => _selected[index] = !_selected[index]);
  }

  ListView buildSelectedListView() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _partySelected.length,
      itemBuilder: (context, index) => InkWell(
          child: Stack(
        //alignment: Alignment.topRight,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: FittedBox(
                  child: InkWell(
                child: Text(_partySelected[index],
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              )),
            ),
          ),
          InkWell(
              onTap: () {
                if (!multiSelection) {
                  setState(() {
                    _partySelected.remove(_partySelected[index]);
                    _partySelected2.remove(_partySelected2[index]);
                  });
                } else {
                  print(_partySelected[index]);
                  // print(_partySelected2[index]);
                  setSelection(_partySelected[index], [], []);
                }
              },
              child: Icon(
                Icons.cancel,
                color: Colors.black,
                size: 15,
              )),
        ],
      )),
    );
  }

  Padding buildSearchTextBox() {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextFormField(
            controller: _searchController,
            onChanged: (value) {
              _searchController.value = TextEditingValue(
                  text: value.toUpperCase(),
                  selection: _searchController.selection);
              loadDetails();
              // setState(() {
              // _filter = value;
              // });
              isLocalSearch ? localSearch(value) : cloudSearch(value);
            },
            validator: (value) {
              return null;
            },
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Type To Search',
                labelText: "Search",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                icon: Icon(Icons.search, color: eqPrimaryColor),
                suffixIcon: _searchController.text != ''
                    ? GestureDetector(
                        child: Icon(Icons.close, color: Colors.grey),
                        onTap: () {
                          setState(() {
                            _filter = _searchController.text = '';
                          });
                          loadDetails();
                        },
                      )
                    : null)));
  }

  void localSearch(String query) {
    // if (query.length >= 2) {
    final party = _orgPartyList.where((party) {
      print("ABCDXYZ");
      print(party);
      final titleLower = party.toString().toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
    print(party);

    setState(() {
      this.query = query;
      _partyList = party;
    });
    // print(_partylist);
    // }
  }

  void selectNewState(String newState) {
    // Find the item in _partylist by ID and select it
    var item = _partyList.firstWhere((e) => e['text'].toString() == newState,
        orElse: () => null);
    if (item != null) {
      setState(() {
        _partySelected.add(item['text']);
        _partySelected2.add(newState);
        _retParamSelected.add(item);
      });
    }
  }
}
