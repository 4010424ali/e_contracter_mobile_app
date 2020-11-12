import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

//provider
import 'package:e_contracter/provider/auth.dart';
import 'package:e_contracter/provider/customer.dart';

// screen
import 'package:e_contracter/screen/login.dart';

// Widget files
import 'package:e_contracter/widgets/topCardWeight.dart';
import 'package:e_contracter/widgets/bottomCardWidget.dart';

enum Option { LoginOut, Other }

class AllCustomers extends StatefulWidget {
  static const routeName = '/customers';

  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Customers>(context, listen: false).getCustomers().then((_) {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final customer = Provider.of<Customers>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[500],
        elevation: 0,
        centerTitle: true,
        title: const Text("e-contracter"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Option option) {
              setState(() {
                if (option == Option.LoginOut) {
                  auth.logout();
                  Navigator.of(context).pushNamed(Login.routeName);
                } else {
                  ///....
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('logout'),
                value: Option.LoginOut,
              ),
            ],
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: customer.customers.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SlimyCard(
                    color: Theme.of(context).primaryColor,
                    width: MediaQuery.of(context).size.width * 0.9,
                    topCardHeight: 400,
                    bottomCardHeight: MediaQuery.of(context).size.height * 0.2,
                    borderRadius: 15,
                    slimeEnabled: true,
                    topCardWidget: TopCardWidget(
                      name: customer.customers[index].name,
                      description: customer.customers[index].description,
                      address: customer
                          .customers[index].location['formattedAddress'],
                      status: customer.customers[index].status,
                    ),
                    bottomCardWidget: BottomCardWidget(
                      cost: customer.customers[index].cost,
                      buildTime: customer.customers[index].buidTime,
                      totalSize: customer.customers[index].totalSize,
                      role: customer.customers[index].role,
                      phone: customer.customers[index].phone,
                      id: customer.customers[index].id,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
