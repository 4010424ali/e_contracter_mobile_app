import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_contracter/provider/perposal.dart';

import 'package:e_contracter/screen/SingleCustomer.dart';

class AddPerposal extends StatefulWidget {
  static const routeName = '/addPerposal';
  @override
  _AddPerposalState createState() => _AddPerposalState();
}

class _AddPerposalState extends State<AddPerposal> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _descriptionNode = FocusNode();
  final _maxPrice = FocusNode();
  final _minPrice = FocusNode();
  final _totalTeamMemeber = FocusNode();
  Map<String, dynamic> _perposalData = {
    'title': '',
    'description': '',
    'maxPrice': '',
    'minPrice': '',
    'totalTeamMemeber': ''
  };

  bool _isLoading = false;

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

  @override
  void dispose() {
    _descriptionNode.dispose();
    _maxPrice.dispose();
    _minPrice.dispose();
    _totalTeamMemeber.dispose();
    super.dispose();
  }

  Future<void> _submit(String id) async {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<Perposals>(context, listen: false)
          .addPerposal(
              id,
              _perposalData['title'],
              _perposalData['description'],
              _perposalData['maxPrice'],
              _perposalData['minPrice'],
              _perposalData['totalTeamMemeber'])
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SingleCustomer(id)));
    } catch (err) {
      _showDialog(err);
    }
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
                  initialValue: _perposalData['title'],
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
                    labelText: "Title",
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
                    hintText: 'Title',
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 100,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the Title';
                    }
                    return null;
                  },
                  onSaved: (value) => _perposalData['title'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _perposalData['description'],
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
                    FocusScope.of(context).requestFocus(_maxPrice);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the description';
                    }
                    return null;
                  },
                  onSaved: (value) => _perposalData['description'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _perposalData['maxPrice'],
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
                    labelText: "Max Price",
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
                    hintText: 'Max Price',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _maxPrice,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_minPrice);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add maximum Price';
                    }
                    return null;
                  },
                  onSaved: (value) => _perposalData['maxPrice'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _perposalData['minPrice'],
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
                    labelText: "Min Price",
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
                    hintText: 'Min Price',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _minPrice,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_totalTeamMemeber);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the minimum Price';
                    }
                    return null;
                  },
                  onSaved: (value) => _perposalData['minPrice'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _perposalData['totalTeamMemeber'],
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
                    labelText: "Total Team Member",
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    hintText: 'Total Team Member',
                  ),
                  keyboardType: TextInputType.number,
                  focusNode: _totalTeamMemeber,
                  onFieldSubmitted: (_) {
                    String customerId =
                        ModalRoute.of(context).settings.arguments as String;
                    _submit(customerId);
                  },
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add Team size';
                    }
                    return null;
                  },
                  onSaved: (value) => _perposalData['totalTeamMemeber'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  RaisedButton(
                    onPressed: () {
                      var customerId =
                          ModalRoute.of(context).settings.arguments;
                      _submit(customerId);
                    },
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
