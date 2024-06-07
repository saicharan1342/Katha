import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SaveCust.dart';
import 'customers.dart';

class AddcustDialog extends StatefulWidget {

  const AddcustDialog({Key? key, required this.loadd}) : super(key: key);
  final VoidCallback loadd;
  @override
  _AddcustDialogState createState() => _AddcustDialogState();
}

class _AddcustDialogState extends State<AddcustDialog> {
  var namecon=TextEditingController();
  var phonecon=TextEditingController();
  var towncon=TextEditingController();
  double c=0,d=0;
  List<Customers> cust = [];
  List<Customers> cust1=[];
  void submitForm() {
    if (_validateInputs()) {
      setState(() {
        cust.add(
          Customers(
            name: namecon.text,
            phone: phonecon.text,
            town: towncon.text,
          ),
        );
        CustomerStorage.saveCustomerDetails(
          Customers(
            name: namecon.text,
            phone: phonecon.text,
            town: towncon.text,
          ),
        );
        namecon.clear();
        phonecon.clear();
        towncon.clear();
      });
      widget.loadd(); // Trigger reload after adding customer
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: namecon,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter name';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,
              ),
              TextFormField(
                controller: phonecon,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Enter 10 digits';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,

                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: towncon,
                decoration: const InputDecoration(labelText: 'Town'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter town';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_validateInputs()) {
                    submitForm();
                  }
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    // You can add additional validation logic here if needed
    return namecon.text.isNotEmpty &&
        phonecon.text.isNotEmpty &&
        phonecon.text.length == 10 &&
        towncon.text.isNotEmpty;
  }

  @override
  void dispose() {
    namecon.dispose();
    phonecon.dispose();
    towncon.dispose();
    super.dispose();
  }
}
