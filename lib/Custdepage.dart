import 'package:flutter/material.dart';
import 'package:kt/Dashboard.dart';
import 'package:kt/SaveCust.dart';
import 'package:kt/customers.dart';

class Custdetail extends StatefulWidget {
  const Custdetail({super.key, required this.customer,required this.reloadDashboard});
  final Customers customer;
final VoidCallback reloadDashboard;
  @override
  State<Custdetail> createState() => _CustdetailState();
}

class _CustdetailState extends State<Custdetail> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _townController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${widget.customer.name}');
    _phoneController = TextEditingController(text: '${widget.customer.phone}');
    _townController = TextEditingController(text: '${widget.customer.town}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _townController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _deleteCustomer() async {
    try {
      await CustomerStorage.clearCustomerDetails(widget.customer.name);
      Navigator.pop(context,true);
      Navigator.pop(context);

      widget.reloadDashboard;
    } catch (e) {
      print('Error deleting customer: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Customer Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if(_isEditing==true){
                setState(() {
                  widget.customer.name=_nameController.text;
                  widget.customer.phone=_phoneController.text;
                  widget.customer.town=_townController.text;
                });
                await CustomerStorage.saveCustomerDetails(widget.customer);

              }
              _toggleEdit();

            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteCustomer,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              enabled: false,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _townController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Town'),
            ),
          ],
        ),
      ),
    );
  }
}