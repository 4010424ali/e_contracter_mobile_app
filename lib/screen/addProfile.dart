import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:provider/provider.dart';

// screen file
import 'package:e_contracter/screen/profile.dart' as pro;

// prodvider file
import 'package:e_contracter/provider/profileInfo.dart';

class AddProfile extends StatefulWidget {
  static const routeName = '/addProfile';
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _shortDescription = FocusNode();
  final _experience = FocusNode();
  final _phone = FocusNode();
  final _age = FocusNode();
  final _education = FocusNode();
  final _address = FocusNode();
  final _jobRole = FocusNode();

  Map<String, Object> _profileData = {
    'nikename': '',
    'shortDescription': '',
    'JobRole': 'user',
    'experience': '',
    'phone': '',
    'age': '',
    'education': '',
    'address': ''
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

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<ProfileDetails>(context, listen: false)
          .createProfile(
              _profileData['nikename'],
              _profileData['shortDescription'],
              _profileData['JobRole'],
              _profileData['experience'],
              _profileData['phone'],
              _profileData['age'],
              _profileData['education'],
              _profileData['address'])
          .then((_) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushNamed(pro.Profile.routeName);
      });
    } catch (err) {
      _showDialog(err.response.data['error']);
    }
  }

  @override
  void dispose() {
    _address.dispose();
    _shortDescription.dispose();
    _experience.dispose();
    _age.dispose();
    _education.dispose();
    _phone.dispose();
    _jobRole.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
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
                  initialValue: _profileData['nikename'],
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
                    labelText: "username",
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
                    hintText: 'username',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_shortDescription);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the username';
                    }
                    return null;
                  },
                  onChanged: (value) => _profileData['nikename'] = value,
                  onSaved: (value) => _profileData['nikename'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['shortDescription'],
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
                  focusNode: _shortDescription,
                  maxLength: 200,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_experience);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add the description';
                    }
                    return null;
                  },
                  onSaved: (value) => _profileData['shortDescription'] = value,
                  onChanged: (value) =>
                      _profileData['shortDescription'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['experience'],
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
                    labelText: "Experience",
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
                    hintText: 'Experience',
                  ),
                  keyboardType: TextInputType.number,
                  focusNode: _experience,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phone);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add Experence';
                    }
                    return null;
                  },
                  onSaved: (value) => _profileData['experience'] = value,
                  onChanged: (value) => _profileData['experience'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['phone'],
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
                    FocusScope.of(context).requestFocus(_age);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _profileData['phone'] = value,
                  onChanged: (value) => _profileData['phone'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['age'],
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
                    labelText: "Age",
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
                    hintText: 'Age',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _age,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_education);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add edcation';
                    }
                    return null;
                  },
                  onSaved: (value) => _profileData['age'] = value,
                  onChanged: (value) => _profileData['age'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['education'],
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
                    labelText: "Education",
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
                    hintText: 'Edcation',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _education,
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
                  onSaved: (value) => _profileData['education'] = value,
                  onChanged: (value) => _profileData['education'] = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _profileData['address'],
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
                    FocusScope.of(context).requestFocus(_jobRole);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add Address';
                    }
                    return null;
                  },
                  onSaved: (value) => _profileData['address'] = value,
                  onChanged: (value) => _profileData['address'] = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: DropDownFormField(
                    titleText: 'role',
                    hintText: 'Please select the role',
                    value: _profileData['JobRole'],
                    onSaved: (value) {
                      setState(() {
                        _profileData['JobRole'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _profileData['JobRole'] = value;
                      });
                    },
                    dataSource: [
                      {'display': 'contracter', 'value': 'contracter'},
                      {'display': 'Plumber', 'value': 'plumber'},
                      {'display': 'Designer', 'value': 'designer'},
                      {'display': 'User', 'value': 'user'},
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
                    child: Text('Submit Profile'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
