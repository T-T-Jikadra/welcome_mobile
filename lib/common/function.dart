// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, prefer_if_null_operators, prefer_const_constructors, deprecated_member_use, prefer_is_empty, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:welcome_mob/globals.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Proggress Indicator widget ..
CircularProgressIndicator showLoading() {
  return CircularProgressIndicator(
    backgroundColor: eqPrimaryColor,
    color: Colors.white,
    strokeWidth: 8,
  );
}

LoadingIndicator Indicate(context) {
  return LoadingIndicator(
    colors: colorRange,
    indicatorType: Indicator.values[3],
    strokeWidth: 3,
    // pause: pause,
    // pathBackgroundColor: Colors.black45,
  );
}

// To display progress indicator ..
void showProgressIndicator(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: showLoading());
      });
}

void customProgress(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          height: 80,
          width: 80,
          child: Center(
            child: LoadingIndicator(
                colors: colorRange,
                indicatorType: Indicator.values[17],
                strokeWidth: 30),
          ),
        ),
      );
    },
  );
}

List<Color> colorRange = [
  Colors.indigo,
  Colors.indigo.shade400,
  Colors.indigo.shade200,
  Colors.indigo.shade50,
];

// To hide progress indicator ..
void hideIndicator(context) {
  Navigator.of(context).pop();
}

// To get value ..
Future<String> getSettings(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString() == "null"
      ? ""
      : prefs.getString(key).toString();
}

// To set value ..
setSettings(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

// To display snakeBar ..
showSnakebar(context, {title, milliseconds, color}) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    duration: Duration(milliseconds: milliseconds),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  Future.delayed(Duration(milliseconds: milliseconds + 100))
      .then((value) => ScaffoldMessenger.of(context).hideCurrentSnackBar());
}

// To diaplay delete pop up ..
void showDeleteDialog(context,
    {String? moduleName,
    bool? mst,
    id,
    required VoidCallback onCancel,
    required VoidCallback onConfirm}) {
  var strId = mst == true ? "id" : "Bill No";
  Dialogs.bottomMaterialDialog(
      msg: 'Are you sure to delete this $moduleName with  $strId : $id?\n'
          'You can\'t undo this action !!!',
      title: 'Delete',
      context: context,
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(BeveledRectangleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.green)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 15),
              Text("Cancel", style: TextStyle(color: Colors.white))
            ],
          ),
          onPressed: () {
            onCancel();
            // Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(BeveledRectangleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete_forever, color: Colors.white),
              SizedBox(width: 15),
              Text("Yes", style: TextStyle(color: Colors.white)),
            ],
          ),
          onPressed: () {
            onConfirm();
            //  DeleteData(id);
            // Navigator.pop(context);
          },
        ),
      ]);
}

// To diaplay delete pop up in grid ..
void showDetDeleteDialog(context,
    {String? moduleName,
    id,
    required VoidCallback onCancel,
    required VoidCallback onConfirm}) {
  Dialogs.materialDialog(
      msg: 'Are you sure to delete this item with Item #$id?\n'
          'You can\'t undo this action !',
      title: "Delete Grid Details !!!",
      color: Colors.white,
      context: context,
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(BeveledRectangleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.green)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text("Cancel", style: TextStyle(color: Colors.white))
            ],
          ),
          onPressed: () {
            onCancel();
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(BeveledRectangleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete_forever, color: Colors.white),
              SizedBox(width: 8),
              Text("Yes", style: TextStyle(color: Colors.white)),
            ],
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
        ),
      ]);
}

List splitText(text) {
  //var x = text.split('').forEach((ch) => print(ch));
  var x = text.split(' ');
  List lst = [];
  //lst.add('x');
  x.forEach((k) => lst.add(k));
  print(lst);
  return lst;
}

String sentenceCapitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

// To convert yyyy-MM-dd to dd-MM-yyy to display date to user ..
String convertViewDate(String dateStr) {
  try {
    // Parse the date from yyyy-MM-dd format
    DateTime date = DateTime.parse(dateStr);

    // Format the date to dd-MM-yyyy
    return DateFormat('dd-MM-yyyy').format(date);
  } catch (e) {
    // print("Error parsing date: $e");
    return dateStr;
  }
}

// To call Dio get with passed URl ..
Future<dynamic> getDio({required String Url}) async {
  final dio = Dio()
    ..options.baseUrl = Url
    ..interceptors.add(LogInterceptor())
    ..httpClientAdapter = Http2Adapter(
      ConnectionManager(idleTimeout: Duration(seconds: 10)),
    );

  final response = await dio.get('');
  return response.data;

  // try {
  //   final response = await dio.get('');
  //   return response;
  // } catch (e) {
  //   print('Error: $e');
  //   rethrow;
  // }
}

//For print full long json into the terminal
void flutterLog(String json) {
  const int chunkSize = 500;
  for (int i = 0; i < json.length; i += chunkSize) {
    int end = (i + chunkSize < json.length) ? i + chunkSize : json.length;
    print(json.substring(i, end));
  }
}

// To display snakeBar ..
DottedLineFun() {
  DottedLine(
    direction: Axis.horizontal,
    alignment: WrapAlignment.center,
    lineLength: double.infinity,
    lineThickness: 1.5,
    dashLength: 3.0,
    dashColor: const Color.fromARGB(255, 177, 175, 175),
  );
}

// To get company List from selected Company..
Future<List<Map<String, String>>> getCompanyDetails(String strCompany) async {
  List<String> selectedCom = (strCompany != null && strCompany.isNotEmpty)
      ? strCompany.split(',').map((p) => p.trim()).toList()
      : [];

  String? strCompanyList = await getSettings('company_list');
  List<dynamic> cCompanyData = [];

  if (strCompanyList != null) {
    cCompanyData = jsonDecode(strCompanyList);
  }

  List<Map<String, String>> aCompanyList = [];

  if (cCompanyData.isNotEmpty) {
    for (var record in cCompanyData) {
      Map<String, dynamic> companyData = record;

      for (var company in selectedCom) {
        if (companyData['company'].startsWith(company)) {
          Map<String, String> item = {
            'companyid': companyData['companyid'].toString(),
            'companyname': company
          };
          aCompanyList.add(item);
        }
      }
    }
    print(aCompanyList);
  }
  if (aCompanyList.isEmpty) {
    String companyName = Globals.companyName.split(' [')[0];
    aCompanyList
        .add({'companyid': Globals.companyId, 'companyname': companyName});
  }
  return aCompanyList;
}

Future<String> getFilePath(fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$fileName.json';
}

launchWhatsAppUri(var mob, String msg) async {
  final link = WhatsAppUnilink(phoneNumber: '+91$mob', text: msg);

  await launch(link.asUri().toString());
}

//=======================================//

// To generate repairing pdf in background ..
Future<String> generateRepairInvoicePdf(xModel) async {
  final pdf = pw.Document();
  pw.MemoryImage logoImage;
  final ByteData fontData =
      await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf');
  final font = pw.Font.ttf(fontData.buffer.asByteData());

  // Load the logo image from assets
  logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/icon/WM_p.png')).buffer.asUint8List(),
  );

  // Create a PDF page
  pdf.addPage(pw.MultiPage(
    margin: const pw.EdgeInsets.all(8),
    pageFormat: PdfPageFormat.a4,
    maxPages: 9999,
    header: (context) {
      return pw.Container(
        color: PdfColor.fromInt(0xFFE6E6FA),
        child: buildRepairTitle(logoImage, font),
      );
    },
    footer: (context) {
      return pw.Center(
        child: pw.Column(
          children: [
            pw.Divider(endIndent: 10, indent: 10),
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Text(
                'Thank You ! \nWelcome Mobile ...      ',
                style: pw.TextStyle(
                    font: font,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000)),
              ),
            ),
            pw.SizedBox(height: 1),
            pw.Text(
              'Page No : ${context.pageNumber} / ${context.pagesCount} - By T.T. JIKADRA',
              style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
          ],
        ),
      );
    },
    build: (context) {
      return [
        buildRepairReportDetails(context, xModel, font),
      ];
    },
  ));

  // Save the generated PDF to a file
  final outputDir = await getApplicationDocumentsDirectory();
  final file = File(
      '${outputDir.path}/Welcome_Mobile_Repairing_Invoice_${xModel.id}.pdf');

  // Write PDF to the file
  await file.writeAsBytes(await pdf.save());
  if (file.path != null) {
    // XFile xFile = XFile(file.path);
    // Share.shareXFiles([xFile], text: 'Repairing Details:');
  }

  print('PDF generated and shared successfully!');
  return file.path;
}

pw.Widget buildRepairTitle(logoImage, font) {
  return pw.Center(
    child: pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Image(
            logoImage,
            width: 70,
            height: 70,
          ),
          pw.SizedBox(width: 15),
          pw.Text(
            Globals.companyName,
            style: pw.TextStyle(
              font: font,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF000000),
            ),
          ),
        ],
      ),
      pw.Text('Repairing E - Invoice',
          style: pw.TextStyle(
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center),
      pw.Divider(endIndent: 10, indent: 9),
    ]),
  );
}

pw.Widget buildRepairReportDetails(pw.Context context, xModel, font) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(8),
    child: pw.Column(
      children: [
        // pw.SizedBox(height: 5),
        // pw.Center(
        //   child: pw.Text(
        //     'Repairing E - Invoice',
        //     style: pw.TextStyle(
        //       fontSize: 17,
        //       fontWeight: pw.FontWeight.bold,
        //     ),
        //   ),
        // ),
        // pw.SizedBox(height: 5),
        // pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Date :',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('${xModel.date}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(1),
                child: pw.Text('Bill No  : ',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child:
                    pw.Text('${xModel.id}', style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Name : ',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('${xModel.name}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('Contact No :',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('${xModel.mobile}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
          ],
        ),
        pw.Divider(),
        pw.SizedBox(height: 35),
        pw.Table(
          columnWidths: {
            0: pw.FixedColumnWidth(17),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(14),
            3: pw.FixedColumnWidth(12),
          },
          border:
              pw.TableBorder.all(width: 1, color: PdfColor.fromInt(0xFF000000)),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE6E6FA),
              ),
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Device Model',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Device Problem',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                if (xModel.wardays.toString().isNotEmpty &&
                    xModel.wardays.toString() != 'null')
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Warranty *',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Approx Cost',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
            buildRepairInvoiceRow(xModel, xModel.devModel, xModel.devFault,
                xModel.wardays, xModel.devCost, true, font),
          ],
        ),
        pw.SizedBox(height: 23),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Total : ${xModel.devCost} /-',
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.TableRow buildRepairInvoiceRow(xModel, var model, var problem, var warranty,
    var cost, bool isOddRow, font) {
  return pw.TableRow(
    decoration: pw.BoxDecoration(
      color: isOddRow
          ? PdfColor.fromInt(0xFFF0F0F0)
          : PdfColor.fromInt(0xFFFFFFFF),
    ),
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text(model, style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child:
            pw.Text('$problem', style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
      if (xModel.wardays.toString().isNotEmpty &&
          xModel.wardays.toString() != 'null')
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text('$warranty Days',
              textAlign: pw.TextAlign.end,
              style: pw.TextStyle(font: font, fontSize: 9.4)),
        ),
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text('$cost',
            textAlign: pw.TextAlign.end,
            style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
    ],
  );
}

//===================================================//

// To generate sales pdf in background ..
Future<String> generateSalesInvoicePdf(xModel) async {
  final pdf = pw.Document();
  pw.MemoryImage logoImage;
  final ByteData fontData =
      await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf');
  final font = pw.Font.ttf(fontData.buffer.asByteData());

  // Load the logo image from assets
  logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/icon/WM_p.png')).buffer.asUint8List(),
  );

  // Create a PDF page
  pdf.addPage(pw.MultiPage(
    margin: const pw.EdgeInsets.all(8),
    pageFormat: PdfPageFormat.a4,
    maxPages: 9999,
    header: (context) {
      return pw.Container(
        color: PdfColor.fromInt(0xFFE6E6FA),
        child: buildSalesTitle(logoImage, font),
      );
    },
    footer: (context) {
      return pw.Center(
        child: pw.Column(
          children: [
            pw.Divider(endIndent: 10, indent: 10),
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Text(
                'Thank You ! \nWelcome Mobile ...     ',
                style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF000000)),
              ),
            ),
            pw.SizedBox(height: 1),
            pw.Text(
              'Page No : ${context.pageNumber} / ${context.pagesCount} - By T.T. JIKADRA',
              style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
          ],
        ),
      );
    },
    build: (context) {
      return [
        buildSalesReportDetails(context, xModel, font),
      ];
    },
  ));

  // Save the generated PDF to a file
  final outputDir = await getApplicationDocumentsDirectory();
  final file =
      File('${outputDir.path}/Welcome_Mobile_Sales_Invoice_${xModel.id}.pdf');

  // Write PDF to the file
  await file.writeAsBytes(await pdf.save());
  if (file.path != null) {
    // XFile xFile = XFile(file.path);
    // Share.shareXFiles([xFile], text: 'Sales Details:');
  }

  print('PDF generated and shared successfully!');
  return file.path;
}

pw.Widget buildSalesTitle(logoImage, font) {
  return pw.Center(
    child: pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Image(
            logoImage,
            width: 70,
            height: 70,
          ),
          pw.SizedBox(width: 15),
          pw.Text(
            Globals.companyName,
            style: pw.TextStyle(
              font: font,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF000000),
            ),
          ),
        ],
      ),
      pw.Text('Sales E - Invoice',
          style: pw.TextStyle(
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center),
      pw.Divider(endIndent: 10, indent: 9),
      // pw.SizedBox(height: 10),
    ]),
  );
}

pw.Widget buildSalesReportDetails(pw.Context context, xModel, font) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(8),
    child: pw.Column(
      children: [
        // pw.SizedBox(height: 5),
        // pw.Center(
        //   child: pw.Text(
        //     'Sales E - Invoice',
        //     style: pw.TextStyle(
        //       fontSize: 17,
        //       fontWeight: pw.FontWeight.bold,
        //     ),
        //   ),
        // ),
        // pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Date :',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('${xModel.date}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(1),
                child: pw.Text('Bill No  : ',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child:
                    pw.Text('${xModel.id}', style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Name : ',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('${xModel.name}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
            pw.Row(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(0),
                child: pw.Text('Contact No :',
                    style: pw.TextStyle(
                        fontSize: 9.3, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('${xModel.mobile}',
                    style: pw.TextStyle(fontSize: 9.3)),
              ),
            ]),
          ],
        ),
        pw.Divider(),
        pw.SizedBox(height: 35),
        pw.Table(
          columnWidths: {
            0: pw.FixedColumnWidth(17),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(14),
            3: pw.FixedColumnWidth(12),
          },
          border:
              pw.TableBorder.all(width: 1, color: PdfColor.fromInt(0xFF000000)),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE6E6FA),
              ),
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Compnay',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Itemname',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                if (xModel.wardays.toString().isNotEmpty &&
                    xModel.wardays.toString() != 'null')
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Warranty *',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Approx Price',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
            buildSalesInvoiceRow(xModel, xModel.company, xModel.itemname,
                xModel.wardays, xModel.price, true, font),
          ],
        ),
        pw.SizedBox(height: 23),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Total : ${xModel.price} /-',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.TableRow buildSalesInvoiceRow(xModel, var company, var itemname,
    var warranty, var price, bool isOddRow, font) {
  return pw.TableRow(
    decoration: pw.BoxDecoration(
      color: isOddRow
          ? PdfColor.fromInt(0xFFF0F0F0)
          : PdfColor.fromInt(0xFFFFFFFF),
    ),
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text(company, style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text('$itemname',
            style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
      if (xModel.wardays.toString().isNotEmpty &&
          xModel.wardays.toString() != 'null')
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text('$warranty Days',
              textAlign: pw.TextAlign.end,
              style: pw.TextStyle(font: font, fontSize: 9.4)),
        ),
      pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text('$price',
            textAlign: pw.TextAlign.end,
            style: pw.TextStyle(font: font, fontSize: 9.4)),
      ),
    ],
  );
}

// To read json from file .

// To Read json data from Local file by filters ..
Future<List<dynamic>> readJsonFromFileList1(String filename,
    {List<String> filters = const [], String? sortBy}) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    print(filePath);
    final file = File(filePath);

    String jsonData = await file.readAsString();
    List<dynamic> jsonList = json.decode(jsonData);
    List<dynamic> filteredList = [];

    if (filters.isEmpty) {
      return jsonList;
    }

    filteredList = jsonList.where((item) {
      return filters.every((filter) {
        return filter.isEmpty ||
            item.toString().toLowerCase().contains(filter.toLowerCase());
      });
    }).toList();

    // if (sortBy != null && sortBy.isNotEmpty) {
    //   filteredList.sort((a, b) {
    //     var aValue = a[sortBy]?.toString() ?? '';
    //     var bValue = b[sortBy]?.toString() ?? '';

    //     List<int>? aParts;
    //     List<int>? bParts;

    //     if (aValue.isNotEmpty) {
    //       aParts = aValue.split('/').map(int.parse).toList();
    //     }
    //     if (bValue.isNotEmpty) {
    //       bParts = bValue.split('/').map(int.parse).toList();
    //     }

    //     if (aParts != null && bParts != null) {
    //       if (aParts[2] != bParts[2]) {
    //         return aParts[2].compareTo(bParts[2]);
    //       }
    //       if (aParts[1] != bParts[1]) {
    //         return aParts[1].compareTo(bParts[1]);
    //       }
    //       return aParts[0].compareTo(bParts[0]);
    //     } else if (aParts != null) {
    //       return -1;
    //     } else if (bParts != null) {
    //       return 1;
    //     } else {
    //       return 0;
    //     }
    //   });
    // }

    return filteredList;
  } catch (e) {
    print('Error reading JSON data: $e');
    return [];
  }
}
