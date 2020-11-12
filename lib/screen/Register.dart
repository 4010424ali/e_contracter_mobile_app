import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

// Provider file
import 'package:e_contracter/provider/auth.dart';

// Screen file
import 'package:e_contracter/screen/profile.dart';
import 'package:e_contracter/screen/login.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final storage = FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> _authData = {
    'name': '',
    "email": "",
    'role': 'user',
    'password': '',
    'confirmPassword': ''
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

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
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).register(
          _authData['name'],
          _authData['email'],
          _authData['password'],
          _authData['role']);

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(Profile.routeName);
    } catch (e) {
      if (e.response.data['success'] == false) {
        _showDialog(e.response.data['error']);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("E-contracter"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(80),
                bottomRight: const Radius.circular(80),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "name"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please add name';
                      }
                      return null;
                    },
                    onSaved: (value) => _authData['name'] = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (value) => _authData['email'] = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: DropDownFormField(
                      titleText: 'role',
                      hintText: 'Please select the role',
                      value: _authData['role'],
                      onSaved: (value) {
                        setState(() {
                          _authData['role'] = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _authData['role'] = value;
                        });
                      },
                      dataSource: [
                        {'display': 'user', 'value': 'user'},
                        {'display': 'publisher', 'value': 'publisher'}
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      if (value != _passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['confirmPassword'] = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    RaisedButton(
                      child: Text("Register"),
                      onPressed: _submit,
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  Row(
                    children: <Widget>[
                      Text("already have account",
                          style: const TextStyle(fontSize: 15)),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Login.routeName);
                        },
                        child: Text(
                          'Login',
                          style: const TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
