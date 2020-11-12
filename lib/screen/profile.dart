import 'dart:io';
import 'dart:ui';
import 'package:e_contracter/screen/addCustomerProject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

// Provider
import 'package:e_contracter/provider/auth.dart';
import 'package:e_contracter/provider/profileInfo.dart';

// Screen file
import 'package:e_contracter/screen/login.dart';
import 'package:e_contracter/screen/customers.dart';
import 'package:e_contracter/screen/openPeroject.dart';
import 'package:e_contracter/screen/projectClose.dart';
import 'package:e_contracter/screen/addProfile.dart';

// url file
import 'package:e_contracter/utils/url.dart';

enum Option { LoginOut, Other }

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isloading = false;
  final picker = ImagePicker();
  File _image;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Provider.of<Auth>(context, listen: false).getUser().then((_) {
      setState(() {
        _isloading = false;
      });
    });

    setState(() {
      _isloading = true;
    });
    Provider.of<ProfileDetails>(context, listen: false)
        .getCurrentUserProfile()
        .then((_) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final profile = Provider.of<ProfileDetails>(context);

    Future getImage() async {
      try {
        final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );
        _image = File(pickedFile.path);

        auth.uploadImage(_image);
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: const Text(
            "Image upload sucessfully",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 4),
          elevation: 6.0,
        ));
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage('$url/uploads/${auth.user['image']}'),
                    maxRadius: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      '${auth.user['email']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Customer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AllCustomers.routeName);
              },
            ),
            ListTile(
              title: Text("Item two"),
              onTap: () {
                print("Item Two");
              },
            ),
            ExpansionTile(
              expandedAlignment: Alignment.topLeft,
              title: Text(
                'Projects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(OpenProject.routeName);
                  },
                  title: Text('Open Project'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProjectClose.routeName);
                  },
                  title: Text('Close Project'),
                ),
              ],
            )
          ],
        ),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[500],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '$url/uploads/${auth.user['image']}',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: Tooltip(
                                  message: 'Upload new photo',
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                    onPressed: getImage,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  auth.user['role'] == 'user'
                                      ? RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                AddCustomerProject.routeName);
                                          },
                                          color: Colors.green[200],
                                          child: Text(
                                            "Add Project",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(AddProfile.routeName);
                                    },
                                    icon: Icon(Icons.person_add),
                                    label: Text(
                                      "Add Profile",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${auth.user['name']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Email: ${auth.user['email']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Role: ${auth.user['role']}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Username: @${profile.profile['data'].username}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'Experience: ${profile.profile['data'].experience} ${int.parse(profile.profile['data'].experience) == 1 ? 'Year' : 'Years'}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "Description",
                                // textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${profile.profile['data'].shortDescription}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${profile.profile['data'].phone}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.book,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${profile.profile['data'].education}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.post_add,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${profile.profile['data'].address}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
