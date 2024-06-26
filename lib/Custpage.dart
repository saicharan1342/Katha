
import 'package:flutter/material.dart';
import 'package:kt/Addtrans.dart';
import 'package:kt/Custdepage.dart';
import 'package:kt/Report.dart';
import 'package:kt/SaveCust.dart';
import 'package:kt/Transactions.dart';
import 'package:kt/customers.dart';
import 'package:intl/intl.dart';

class Custpage extends StatefulWidget {

  const Custpage({super.key, required this.customer,required this.reloadDashboard});
  final Customers customer;
  final VoidCallback reloadDashboard;
  @override
  State<Custpage> createState() => _CustpageState();
}

class _CustpageState extends State<Custpage> {
  var type;

  late DateTime selectedDateTime ;
  var amcon=TextEditingController();
  var typecon=TextEditingController();
  var decon=TextEditingController();


  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Select"), value: "Select"),
    DropdownMenuItem(child: Text("You received"), value: "Credit"),
    DropdownMenuItem(child: Text("You paid"), value: "Debit"),
  ];
  Future<void> showdia(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddTransactionDialog(
        customer: widget.customer, edit: false,
      ),
    );

    // Handle the result
    if (result == true) {
      setState(() {});
    }
  }

  void deletedialog(int index){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Are you sure?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {

                          if(widget.customer.trans[index].type=='Credit'){
                            widget.customer.balance+=widget.customer.trans[index].amount;
                            for(int i=0;i<index;i++){
                              widget.customer.trans[i].balance+=widget.customer.trans[index].amount;
                            }
                          }
                          else{
                            widget.customer.balance-=widget.customer.trans[index].amount;
                            for(int i=0;i<index;i++){
                              widget.customer.trans[i].balance-=widget.customer.trans[index].amount;
                            }
                          }
                          widget.customer.trans.removeAt(index);
                          CustomerStorage.saveCustomerDetails(widget.customer);

                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void editdialog(int index){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: SingleChildScrollView(
              child:Column(
                children: [
                  Text('Edit?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => AddTransactionDialog(
                                customer: widget.customer, edit: true,index: index,
                              ),
                            );

                            // Handle the result
                            if (result == true) {
                              setState(() {});
                            }
                          },
                          child: Text('Edit')
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    widget.customer.trans.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Custdetail(customer: widget.customer,reloadDashboard:widget.reloadDashboard))).then((value){
              if (value == true) {
                widget.reloadDashboard();
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text('${widget.customer.name}',style: TextStyle(color: Colors.white,fontSize: 25),),
              Text('Click to edit',style: TextStyle(color: Colors.white),)
            ],
          ),

        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Call reloadDashboard callback when navigating back
            widget.reloadDashboard();
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){

            setState(() {
              selectedDateTime = DateTime.now();
            });
            showdia(context);
          },
          label: Text('Add Transaction',style: TextStyle(color: Colors.white),),
          icon: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        color: Colors.blue.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  CardOne(color: widget.customer.balance >= 0 ? Colors.green : Colors.red, text: widget.customer.balance >= 0 ? 'You will receive' : 'You need to pay', arrow: widget.customer.balance >= 0 ? Icons.arrow_downward : Icons.arrow_upward, cord: widget.customer.balance.abs().toString()),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(customer: widget.customer)));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf),
                      Text('Report'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: widget.customer.trans.isEmpty
                    ? Center(child: Text('No Transactions'))
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                                        separatorBuilder: (context,index)=>SizedBox(height: 10,),
                                        itemCount: widget.customer.trans.length,
                                        itemBuilder: (context, index) {
                      final transaction = widget.customer.trans[index];
                      return Dismissible(
                        key: Key(transaction.dateTime.toString()),
                        direction: DismissDirection.horizontal,
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
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
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if(direction==DismissDirection.endToStart){
                             deletedialog(index);
                          }
                          else if(direction==DismissDirection.startToEnd){
                            editdialog(index);
                          }
                          return null;
                        },
                        child: Container(
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
                                  'Detail: ${transaction.details.toString()}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
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
                        )
                      );
                      },
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({
    Key? key,
    required this.color,
    required this.text,
    required this.arrow,
    required this.cord,
    this.theme,
  }) : super(key: key);

  final bool? theme;
  final String cord;
  final Color color;
  final String text;
  final IconData arrow;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme ?? false
              ? color.withOpacity(0.5)
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹$cord",
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(arrow, color: color),
            ],
          ),
        ),
      ),
    );
  }
}


