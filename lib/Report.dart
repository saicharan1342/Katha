import 'dart:io';


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kt/Transactions.dart';
import 'package:kt/customers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_downloader/flutter_downloader.dart';


class ReportPage extends StatefulWidget {

  const ReportPage({super.key,required this.customer});
  final Customers customer;
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {




  DateTime startDateTime = DateTime.now().toLocal().subtract(Duration(hours:DateTime.now().hour,minutes: DateTime.now().minute ));
  DateTime endDateTime = DateTime.now().toLocal().add(Duration(days: 1)).subtract(Duration(hours:DateTime.now().hour,minutes: DateTime.now().minute ));
  Future<void> _selectDateTime(BuildContext context, bool isStartDateTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDateTime ? startDateTime : endDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
        setState(() {
          if (isStartDateTime) {
            startDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              00,
              00
            );
          } else {
            endDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
            );
          }
        });

    }
  }
  List<Transactions> t=[];
  double op=0;
  Future<void> _savePdf(List<Transactions> transactions) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        header: (pw.Context context) {
          return pw.Container(
            color: PdfColors.blue,
            alignment: pw.Alignment.center,
            child: pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Text('Khatha', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 18)),
                pw.SizedBox(height: 10),
              ]
            )
          );
        },
        build: (context) {

          return <pw.Widget>[
            pw.SizedBox(height: 10),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('${widget.customer.name} Statement', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('Phone Number: ${widget.customer.phone}', style: pw.TextStyle( fontSize: 16)),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Container(
                  padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 0),
                  child: pw.Text('From: ${DateFormat('dd/MM/yyyy').format(startDateTime)}',style: pw.TextStyle( fontSize: 16))
                ),
                pw.SizedBox(width: 50),
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: pw.Text('To: ${DateFormat('dd/MM/yyyy').format(endDateTime)}',style: pw.TextStyle( fontSize: 16))
                ),

              ]
            ),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: pw.EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: pw.Text('Opening Balance: $op', style: pw.TextStyle( fontSize: 16)),
            ),
            pw.Container(
              padding: pw.EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: pw.Table.fromTextArray(

                border: pw.TableBorder.all(width: 1, color: PdfColors.grey100),
                cellAlignment: pw.Alignment.center,
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                headerHeight: 25,
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                },
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                data: [
                  ['Date', 'Detail', 'Credit', 'Debit', 'Balance'],
                  ...transactions.map((tx) => [
                    '${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(tx.dateTime))}',
                    '${tx.details}',
                    tx.type == 'Credit' ? '${tx.amount}' : '',
                    tx.type == 'Debit' ? '${tx.amount}' : '',
                    '${tx.balance}',
                  ]),
                ],
              ),
            )
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(30),
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Computer Generated Statement on: $formattedDate'),
          );
        },
      ),
    );
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final file = File('${generalDownloadDir.path}/KhathaStatement_${DateTime.now().microsecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    // final fileUri = Uri.file('${generalDownloadDir!.path}/KhathaStatement_${DateTime.now().microsecondsSinceEpoch}.pdf');
    // final taskId = await FlutterDownloader.enqueue(
    //   url: 'data:application/pdf;base64,${base64Encode(await pdf.save())}',
    //   savedDir: generalDownloadDir.path,
    //   fileName: 'KhathaStatement_${DateTime.now().microsecondsSinceEpoch}.pdf',
    //   showNotification: true,
    //   openFileFromNotification: true,
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pdf saved at ${generalDownloadDir.path}'),
      ),
    );

    // Optionally, you can print the path to the saved PDF file
    // print('PDF saved to: ${file.path}');
  }


  @override
  Widget build(BuildContext context) {
    widget.customer.trans.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Report',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Name: ${widget.customer.name}',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              'Phone Number: ${widget.customer.phone}',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10), // Adds some spacing between the previous Text widgets and the Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Start Date', style: TextStyle(fontSize: 20)),
                ),
                Expanded(child: SizedBox()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('End Date', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: Colors.black)
                      ),
                      backgroundColor: Colors.white
                    ),
                    onPressed: () {
                      _selectDateTime(context, true);
                    },
                    child: Text(DateFormat('dd-MM-yyyy').format(startDateTime)),
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: BorderSide(color: Colors.black)
                        ),
                        backgroundColor: Colors.white
                    ),
                    onPressed: () {
                      _selectDateTime(context, false);
                    },
                    child: Text(DateFormat('dd-MM-yyyy').format(endDateTime)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5,right: 1),
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          t.clear();
                          for (int i = 0; i < widget.customer.trans.length; i++) {
                            if (widget.customer.trans[i].dateTime>=(startDateTime.microsecondsSinceEpoch) &&
                                DateTime.fromMicrosecondsSinceEpoch(widget.customer.trans[i].dateTime).isBefore(endDateTime)) {
                              t.add(widget.customer.trans[i]);
                            }
                          }
                          int i;
                          for( i = 0; i < widget.customer.trans.length; i++){
                            if(DateTime.fromMicrosecondsSinceEpoch(widget.customer.trans[i].dateTime).isBefore(startDateTime)){
                              break;
                            }
                          }
                          if(i>=widget.customer.trans.length-1){
                            op=0;
                          }
                          else{
                            op=widget.customer.trans[i+1].balance;
                          }
        
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(color: Colors.black)
                          ),
                          backgroundColor: Colors.white
                      ),
                      child: Text('Get')
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                      onPressed:() async{
                        await _savePdf(t);
                        ScaffoldMessenger(child: Text('Genereated'),);
                      },
                      style: ElevatedButton.styleFrom(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(color: Colors.black)
                          ),
                          backgroundColor: Colors.white
                      ),
                      child: Text('Save')
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: t.length,
                  itemBuilder: (context, index) {
                    final transaction = t[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        title: Text(
                          DateFormat('dd MMM, hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(transaction.dateTime)),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance: ${transaction.balance.toString()}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Detail: ${transaction.details}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Credit: ${transaction.type == "Credit" ? transaction.amount.toString() : "0"}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Debit: ${transaction.type == "Debit" ? transaction.amount.toString() : "0"}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                        
                  }, separatorBuilder: ( context,  index) =>SizedBox(height: 10,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
