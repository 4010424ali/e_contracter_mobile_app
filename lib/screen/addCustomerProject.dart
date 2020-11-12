import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

// Provider files
import 'package:e_contracter/provider/customer.dart';

// Screen
import 'package:e_contracter/screen/profile.dart';

class AddCustomerProject extends StatefulWidget {
  static const routeName = '/addCustomerProject';
  @override
  _AddCustomerProjectState createState() => _AddCustomerProjectState();
}

class _AddCustomerProjectState extends State<AddCustomerProject> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final _descriptionNode = FocusNode();
  final _phone = FocusNode();
  final _roleNode = FocusNode();
  final _totalSize = FocusNode();
  final _cost = FocusNode();
  final _buidTime = FocusNode();
  final _address = FocusNode();
  bool _isLoading = false;

  Map<String, dynamic> _customerData = {
    'name': '',
    'description': '',
    'phone': '',
    'role': 'completeHouse',
    'totalSize': '',
    'cost': '',
    'buidTime': '',
    'address': ''
  };

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Authencation Error"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<Customers>(context, listen: false)
          .createProject(
        _customerData['name'],
        _customerData['description'],
        _customerData['phone'],
        _customerData['role'],
        _customerData['totalSize'],
        _customerData['cost'],
        _customerData['buidTime'],
        _customerData['address'],
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Navigator.of(context).pushNamed(Profile.routeName);
    } catch (err) {
      _showDialog(err.response.data['error']);
    }
  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _phone.dispose();
    _roleNode.dispose();
    _totalSize.dispose();
    _cost.dispose();
    _buidTime.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Perposla'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _customerData['name'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Name",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Name',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 200,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the title';
                    }
                    return null;
                  },
                  onChanged: (value) => _customerData['name'] = value,
                  onSaved: (value) => _customerData['name'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['description'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Description",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Descritpion',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _descriptionNode,
                  maxLength: 200,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phone);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the description';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['description'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['phone'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Phone",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Phone',
                  ),
                  keyboardType: TextInputType.number,
                  focusNode: _phone,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_totalSize);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add phone';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['phone'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['totalSize'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Total size of place",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Total Size of Place',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _totalSize,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_cost);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add total sized of place';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['totalSize'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['cost'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Cost",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Cost',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _cost,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_buidTime);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add cost';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['cost'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['buidTime'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Build Tiime",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Build Time',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _buidTime,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_address);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add cost';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['buidTime'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _customerData['address'],
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: "Address",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Address',
                  ),
                  keyboardType: TextInputType.streetAddress,
                  focusNode: _address,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_roleNode);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add Address';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerData['address'] = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: DropDownFormField(
                    titleText: 'role',
                    hintText: 'Please select the role',
                    value: _customerData['role'],
                    onSaved: (value) {
                      setState(() {
                        _customerData['role'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _customerData['role'] = value;
                      });
                    },
                    dataSource: [
                      {'display': 'contracter', 'value': 'completeHouse'},
                      {'display': 'Plumber', 'value': 'plumber'},
                      {'display': 'Designer', 'value': 'designer'},
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  RaisedButton(
                    onPressed: _submit,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text('Submit Perposal'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
