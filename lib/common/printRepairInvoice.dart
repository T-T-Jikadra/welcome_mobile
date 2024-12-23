// ignore_for_file: depend_on_referenced_packages, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/globals.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:welcome_mob/models/repairModel.dart';

class printRepairInvoice extends StatefulWidget {
  printRepairInvoice({Key? mykey, repairModel? Data}) : super(key: mykey) {
    xModel = Data;
  }

  repairModel? xModel;

  @override
  _printRepairInvoiceState createState() => _printRepairInvoiceState();
}

class _printRepairInvoiceState extends State<printRepairInvoice> {
  String? pdfFilePath;
  var logoImage;

  @override
  void initState() {
    super.initState();
    getPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: eqPrimaryColor,
        title: Text("Repairing Invoice",
            style: TextStyle(fontFamily: 'muli', color: Colors.white)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white),
      ),
      floatingActionButton: share(),
      body: pdfFilePath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(filePath: pdfFilePath),
    );
  }

  FloatingActionButton share() {
    return FloatingActionButton(
      backgroundColor: eqSecondaryColor,
      onPressed: () {
        if (pdfFilePath != null) {
          XFile xFile = XFile(pdfFilePath!);
          Share.shareXFiles([xFile], text: 'Repairing Details:');
        }
      },
      child: const Icon(Icons.picture_as_pdf_sharp),
    );
  }

  Future<void> getPdf() async {
    var path = await generateRepairInvoicePdf(widget.xModel);
    setState(() {
      pdfFilePath = path;
    });
  }


//=-=--=--=--=-=-=-=-=-==-=-//

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/icon/wm.jpg')).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
      margin: const pw.EdgeInsets.all(8),
      pageFormat: PdfPageFormat.a4,
      maxPages: 9999,
      header: (context) {
        return buildTitle();
      },
      footer: (context) {
        return pw.Center(
          child: pw.Column(
            children: [
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text(
                  'Thank You ! \nWelcome Mobile ...  ',
                  style: pw.TextStyle(
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
          buildReportDetails(context),
        ];
      },
    ));

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File(
        '${outputDir.path}/Welcome Mobile_Repair_Invoice_${widget.xModel!.id}.pdf');

    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = file.path;
    });

    print('PDF generated successfully!');
  }

  pw.Widget buildTitle() {
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
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF000000),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  pw.Widget buildReportDetails(pw.Context context) {
    return pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Column(
          children: [
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text(
                'Repairing E - Invoice',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Date : ${widget.xModel!.date}')),
                pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Bill No : ${widget.xModel!.id}')),
              ],
            ),
            // pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Name : ${widget.xModel!.name}')),
                pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Contact No : ${widget.xModel!.mobile}')),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 35),
            pw.Table(
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromInt(0xFF000000)),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFE0E0E0),
                  ),
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Device Model',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Device Problem',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                    ),
                    if (widget.xModel!.wardays.toString().isNotEmpty &&
                        widget.xModel!.wardays.toString() != 'null')
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Warranty *',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                      ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Approx Cost',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                _buildInvoiceRow(
                    widget.xModel!.devModel,
                    widget.xModel!.devFault,
                    widget.xModel!.wardays,
                    widget.xModel!.devCost,
                    true),
              ],
            ),
            pw.SizedBox(height: 23),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total : ${widget.xModel!.devCost} /-',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  pw.TableRow _buildInvoiceRow(
      var model, var problem, var warranty, var cost, bool isOddRow) {
    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: isOddRow
            ? PdfColor.fromInt(0xFFF0F0F0)
            : PdfColor.fromInt(0xFFFFFFFF),
      ),
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(model),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text('$problem'),
        ),
        if (widget.xModel!.wardays.toString().isNotEmpty &&
            widget.xModel!.wardays.toString() != 'null')
          pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Text('$warranty'),
          ),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text('$cost', textAlign: pw.TextAlign.end),
        ),
      ],
    );
  }
}
