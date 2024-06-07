import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kt/Custpage.dart';
import 'package:kt/custlist.dart';
import 'package:kt/customers.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'SaveCust.dart';
import 'newcust.dart';

class Dashboard extends StatefulWidget {
  const Dashboard( {super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}
void reloadDashboard(BuildContext context) {
  _DashboardState dashboardState = context.findAncestorStateOfType<_DashboardState>()!;
  dashboardState.reloadDashboard();
}
class _DashboardState extends State<Dashboard> {
  var namecon=TextEditingController();
  var phonecon=TextEditingController();
  var towncon=TextEditingController();
  double c=0,d=0;
  List<Customers> cust = [];
  List<Customers> cust1=[];
  var hh;
  submitForm() {
    setState(() {
      cust.add(
        Customers(
          name: namecon.text,
          phone: phonecon.text,
          town: towncon.text,
        ),
      );
      CustomerStorage.saveCustomerDetails(Customers(
        name: namecon.text,
        phone: phonecon.text,
        town: towncon.text,
      ));
      namecon.clear();
      phonecon.clear();
      towncon.clear();
  _loadCustomers();
      // Move the navigation logic here
      Navigator.pop(context);
    });
  }

  void addcust(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddcustDialog(
          loadd: _loadCustomers
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    cust=[];
    c=0;
    d=0;
    List<Customers> savedCustomers = await CustomerStorage.getSavedCustomers();
    setState(() {
      cust.addAll(savedCustomers);
      cust.forEach((element) {
        if(element.balance<0){
          d+=element.balance.abs();
        }
        else{
          c+=element.balance;
        }
      });
      cust1 = List.from(cust);
      cust1.sort((a, b) => b.edited.compareTo(a.edited));

    });
  }
  void reloadDashboard() {
    setState(() {
      // Reload logic here, such as resetting state variables
      _loadCustomers();
    });
  }
  void dispose() {
    _searchFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  final FocusNode _searchFocusNode = FocusNode();
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Katha',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30,bottom: 10,left: 10,right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                    ),
                    child: Row(
                      children: [
                        CardOne(color: Colors.green, text: 'You will receive', arrow: (Icons.arrow_upward), cord:'${c}',theme: false,),
                        const SizedBox(
                          width: 10,
                        ),
                        CardOne(color: Colors.red, text: 'You should pay', arrow: (Icons.arrow_downward), cord: '$d',theme: false,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Customers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: TextField(
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Search Customer',
                          contentPadding: EdgeInsets.fromLTRB(10, 5,0, 10)
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          setState(() {
                            hh=value;
                            cust1=cust.where((element) => element.name.toLowerCase().startsWith(value.toLowerCase())).toList();
                          });
                        }
                        else {
                          setState(() {
                            cust1=cust;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded( // Wrap the Column with Expanded
              child: Padding(
                padding: const EdgeInsets.all(10),
                child:cust.length<=0?Text('No customers') :cust1.length <= 0 ? Text('Not Found') : Custlist(customer: cust1, reloaddash:reloadDashboard,),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            addcust(context);
          },
          backgroundColor: Colors.blue.shade900,
          label: Text('Add Customer',style: TextStyle(color: Colors.white),),
          icon: Icon(Icons.add,color: Colors.white,),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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




