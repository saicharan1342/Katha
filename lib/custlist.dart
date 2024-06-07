import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kt/customers.dart';

import 'Custpage.dart';
import 'Dashboard.dart';


class Custlist extends StatefulWidget {
  const Custlist({Key? key, required this.customer, required this.reloaddash}) : super(key: key);
  final List<Customers> customer;
  final VoidCallback reloaddash;

  @override
  State<Custlist> createState() => _CustlistState();
}

class _CustlistState extends State<Custlist> {
  @override
  Widget build(BuildContext context) {
    var cust1 = widget.customer;

    return SingleChildScrollView( // Wrap with SingleChildScrollView
      child: Column( // Column for stacking widgets vertically
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable list scrolling
            shrinkWrap: true,
            itemCount: cust1.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Custpage(
                        customer: cust1[index],
                        reloadDashboard: widget.reloaddash,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cust1[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              cust1[index].phone,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Row(
                        children: [
                          Text(
                            cust1[index].balance.abs().toString(),
                            style: TextStyle(
                              color: cust1[index].balance >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
