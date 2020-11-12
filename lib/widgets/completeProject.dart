import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_contracter/provider/customer.dart';

class CompleteProject extends StatefulWidget {
  final id;

  CompleteProject(this.id);
  @override
  _CompleteProjectState createState() => _CompleteProjectState();
}

class _CompleteProjectState extends State<CompleteProject> {
  bool _isInit = true;
  // ignore: unused_field
  bool _isloading = false;
  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });
    if (_isInit) {
      Provider.of<Customers>(context).getCompletePerposal(widget.id).then((_) {
        setState(() {
          _isloading = true;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<Customers>(context);
    return Container(
      child: ListView.builder(
        itemCount: customer.customers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(customer.customers[index].name),
            trailing: Icon(Icons.arrow_downward),
          );
        },
      ),
    );
  }
}
