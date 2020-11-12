import 'package:e_contracter/provider/customer.dart';
import 'package:e_contracter/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

// Details Providers
import 'package:e_contracter/provider/customerDetail.dart';
import 'package:e_contracter/provider/perposal.dart';
import 'package:e_contracter/provider/auth.dart';

// Screen File
import 'package:e_contracter/screen/map.dart';
import 'package:e_contracter/screen/addPerposal.dart';

// url file
import 'package:e_contracter/utils/url.dart';

class SingleCustomer extends StatefulWidget {
  static const routeName = '/singleCustomer';

  final String id;
  SingleCustomer(this.id);

  @override
  _SingleCustomerState createState() => _SingleCustomerState();
}

class _SingleCustomerState extends State<SingleCustomer> {
  bool _isLoading = false;
  bool _isSheetLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<CustomerDetails>(context, listen: false)
        .getSignleCustomer(widget.id)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    setState(() {
      _isSheetLoading = true;
    });
    Provider.of<Perposals>(context, listen: false)
        .getPerposals(widget.id)
        .then((_) {
      setState(() {
        _isSheetLoading = false;
      });
    });
    super.initState();
  }

  decoration() {
    return BoxDecoration(
      color: Colors.grey[300],
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<CustomerDetails>(context);
    final per = Provider.of<Perposals>(context);
    final user = Provider.of<Auth>(context);

    void _showDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Customer Delete"),
          content: Text('Are you sure, you want to delete prject'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Provider.of<Customers>(context, listen: false)
                    .deleteCustomer(customer.customerDetail['data'].id)
                    .then((_) {
                  Navigator.of(context).pushNamed(Profile.routeName);
                });
              },
              child: Text('Okay'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            )
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'E-contracter',
        ),
        backgroundColor: Color(0x44000000),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          per.perposals.length > 0 && user.user['role'] == 'user'
              ? Container()
              : IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Add Perposal',
                  onPressed: () {
                    String customerId = widget.id;
                    Navigator.of(context).pushNamed(
                      AddPerposal.routeName,
                      arguments: customerId,
                    );
                  })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 25),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            '$url/uploads/${customer.customerDetail['data'].image}',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: decoration(),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          Text(
                            customer.customerDetail['data'].userName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: decoration(),
                      child: Text(
                        customer.customerDetail['data'].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.phone),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          customer.customerDetail['data'].phone,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.place),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${customer.customerDetail['data'].location['city']} ${customer.customerDetail['data'].location['state']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: decoration(),
                      child: Text(
                        customer.customerDetail['data'].description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: decoration(),
                            child: Column(
                              children: <Widget>[
                                const Text("Cost"),
                                Text(customer.customerDetail['data'].cost)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width * 0.50,
                            decoration: decoration(),
                            child: Column(
                              children: <Widget>[
                                const Text("Build Time"),
                                Text(customer.customerDetail['data'].buidTime)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      margin: const EdgeInsets.all(10),
                      decoration: decoration(),
                      child: Column(
                        children: <Widget>[
                          const Text("Place Size"),
                          Text(
                            customer.customerDetail['data'].totalSize
                                .toString(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          OutlineButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Map(
                                    lat: customer.customerDetail['data']
                                        .location['coordinates'][1],
                                    lon: customer.customerDetail['data']
                                        .location['coordinates'][0],
                                  ),
                                ),
                              );
                            },
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text("Map"),
                            highlightColor: Colors.green,
                            highlightedBorderColor: Colors.green,
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hoverColor: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          customer.customerDetail['data'].user ==
                                  user.user['userId']
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: _showDialog,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
      bottomSheet: SolidBottomSheet(
        headerBar: Container(
          decoration: BoxDecoration(
            color: Colors.green[300],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 50,
          child: Center(
            child: Text("Perposal details"),
          ),
        ),
        body: _isSheetLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : per.perposals.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "No Perposal found",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: per.perposals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          elevation: 15,
                          shadowColor: Theme.of(context).primaryColor,
                          child: Column(
                            children: <Widget>[
                              if (per.perposals.length == 0)
                                Text("data")
                              else
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Chip(
                                      label: Text(
                                        per.perposals[index].status
                                            ? 'open'
                                            : 'close',
                                      ),
                                      backgroundColor:
                                          per.perposals[index].status
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Chip(
                                      label: Text(
                                        per.perposals[index].accept == 'yes'
                                            ? 'accept'
                                            : 'pending',
                                      ),
                                      backgroundColor:
                                          per.perposals[index].accept == 'yes'
                                              ? Colors.grey
                                              : Colors.blueGrey,
                                    ),
                                    per.perposals[index].user['_id'] ==
                                            user.user['userId']
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              per.deketePerposal(
                                                  per.perposals[index].id);
                                              // setState(() {
                                              //   per.perposals.removeAt(index);
                                              // });
                                            })
                                        : null
                                  ],
                                ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          '$url/uploads/${user.user['image']}',
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        per.perposals[index].title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                        left: 15,
                                        bottom: 15,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'min price:  ${per.perposals[index].minPrice}',
                                          ),
                                          Text(
                                            'max price ${per.perposals[index].maxPrice}',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  left: 15,
                                  bottom: 15,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        per.perposals[index].description,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// var id = ModalRoute.of(context).settings.arguments;
