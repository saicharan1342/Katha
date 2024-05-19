import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  final TextEditingController amcon;
  final TextEditingController decon;
  final Function(String) onTypeChanged;
  final Function(DateTime) onDateTimeChanged;
  final VoidCallback onSubmit;

  const AddTransactionDialog({
    required this.amcon,
    required this.decon,
    required this.onTypeChanged,
    required this.onDateTimeChanged,
    required this.onSubmit,
  });

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  late DateTime selectedDateTime;
  late String type;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    type = 'Select';
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
        widget.onDateTimeChanged(selectedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: widget.amcon,
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
              controller: widget.decon,
              decoration: const InputDecoration(label: Text('Details')),
            ),
            DropdownButtonFormField(
              value: 'Select',
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
                  widget.onTypeChanged(type);
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
              onPressed: widget.onSubmit,
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
