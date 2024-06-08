import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SaveCust.dart';
import 'Transactions.dart';
import 'customers.dart';

class AddTransactionDialog extends StatefulWidget {
  final Customers customer;
  final bool edit;
  final int? index;
  const AddTransactionDialog({
    required this.customer,
    required this.edit,
    this.index,
    super.key
  });

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  var type;

  late DateTime selectedDateTime ;
  var amcon=TextEditingController();
  var typecon=TextEditingController();
  var decon=TextEditingController();
  late int selectedIndex ;// Assuming widget.index is declared as int?

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    selectedIndex = widget.index!; // Assuming widget.index is declared as int?

    type = 'Select';
    if(widget.edit==true){
      amcon.text = (widget.index != null && widget.customer.trans[widget.index!] != null)
          ? widget.customer.trans[widget.index!].amount.toString()
          : '';
      type=(widget.index != null && widget.customer.trans[widget.index!] != null)
          ? widget.customer.trans[widget.index!].type
          : 'Select';
      decon.text=(widget.index != null && widget.customer.trans[widget.index!] != null)
          ? widget.customer.trans[widget.index!].details
          : '';
      selectedDateTime = DateTime.fromMicrosecondsSinceEpoch(
        (widget.index != null && widget.customer.trans[widget.index!] != null)
            ? widget.customer.trans[widget.index!].dateTime
            : DateTime.now().microsecondsSinceEpoch,
      );

    }
  }

  void onTypeChanged(value){
    setState(() {
      type=value;
    });
  }



  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  onSubmit(){
    setState(() {
      setState(() {

        if(widget.edit && widget.index!=null){
          if(widget.customer.trans[selectedIndex].type=='Credit'){
            widget.customer.balance+=widget.customer.trans[selectedIndex].amount;
            for(int i=0;i<selectedIndex;i++){
              widget.customer.trans[i].balance+=widget.customer.trans[selectedIndex].amount;
            }
          }
          else{
            widget.customer.balance-=widget.customer.trans[selectedIndex].amount;
            for(int i=0;i<selectedIndex;i++){
              widget.customer.trans[i].balance-=widget.customer.trans[selectedIndex].amount;
            }
          }
          widget.customer.trans.removeAt(selectedIndex);
          CustomerStorage.saveCustomerDetails(widget.customer);
        }

        if (type == 'Credit') {
          widget.customer.balance -= double.parse(amcon.text);
        }
        else {
          widget.customer.balance += double.parse(amcon.text);
        }
        // Create a new list with updated transactions
        List<Transactions> updatedTransactions = List.from(
            widget.customer.trans);
        updatedTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        double balance2=0,amou=double.parse(amcon.text);
        for(int i=0;i<updatedTransactions.length;i++){
          if(updatedTransactions[i].dateTime<selectedDateTime.microsecondsSinceEpoch){
            balance2=updatedTransactions[i].balance;
            break;
          }
        }
        if(type=='Credit'){
          balance2-=double.parse(amcon.text);
        }
        else{
          balance2+=double.parse(amcon.text);
        }
        updatedTransactions.add(
          Transactions(
            amount: double.parse(amcon.text),
            type: type,
            dateTime: selectedDateTime.microsecondsSinceEpoch,
            details: decon.text,
            balance: balance2,
          ),
        );
        for(int i=0;i<updatedTransactions.length;i++){
          if(updatedTransactions[i].dateTime>selectedDateTime.microsecondsSinceEpoch){
            if(type=='Credit'){
              updatedTransactions[i].balance-=amou;
            }
            else{
              updatedTransactions[i].balance+=amou;
            }
          }
        }

        // Update the state with the new list
        widget.customer.trans = updatedTransactions;
        // Save updated customer details

        CustomerStorage.saveCustomerDetails(widget.customer);
        amcon.clear();
        decon.clear();
      });

      // Update customer details, save to storage, etc.
      // Clear text controllers
      amcon.clear();
      decon.clear();
    });
    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: amcon,
              decoration: const InputDecoration(label: Text('Amount')),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter amount';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.always,
            ),
            TextFormField(
              controller: decon,
              decoration: const InputDecoration(label: Text('Details')),
            ),
            DropdownButtonFormField(
              value:type,
              items: [
                DropdownMenuItem(child: Text("Select"), value: "Select"),
                DropdownMenuItem(child: Text("You received"), value: "Credit"),
                DropdownMenuItem(child: Text("You paid"), value: "Debit"),
              ],
              validator: (value){
                if(value=='Select'){
                  return 'Select type';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  type = value!;
                  onTypeChanged(type);
                });
              },
              autovalidateMode: AutovalidateMode.always,
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async => await _selectDateTime(context),
              child: Text(DateFormat('dd-MM-yyyy HH:mm').format(selectedDateTime)),
            ),
            ElevatedButton(
              onPressed:onSubmit,
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
