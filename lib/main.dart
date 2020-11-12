import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// provider import
import 'package:e_contracter/provider/auth.dart';
import 'package:e_contracter/provider/customer.dart';
import 'package:e_contracter/provider/customerDetail.dart';
import 'package:e_contracter/provider/perposal.dart';
import 'package:e_contracter/provider/profileInfo.dart' as profileDetail;

// Screen import
import 'package:e_contracter/screen/login.dart';
import 'package:e_contracter/screen/profile.dart';
import 'package:e_contracter/screen/customers.dart';
import 'package:e_contracter/screen/addPerposal.dart';
import 'package:e_contracter/screen/openPeroject.dart';
import 'package:e_contracter/screen/projectClose.dart';
import 'package:e_contracter/screen/Register.dart';
import 'package:e_contracter/screen/addCustomerProject.dart';
import 'package:e_contracter/screen/addProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  bool auth = false;

  @override
  void initState() {
    autologin();
    super.initState();
  }

  void autologin() async {
    final token = await storage.read(key: 'token');

    if (!JwtDecoder.isExpired(token)) {
      setState(() {
        auth = true;
      });
      return;
    }

    auth = false;

    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Customers(),
        ),
        ChangeNotifierProvider.value(
          value: CustomerDetails(),
        ),
        ChangeNotifierProvider.value(
          value: Perposals(),
        ),
        ChangeNotifierProvider.value(
          value: profileDetail.ProfileDetails(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-contracter',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          buttonColor: Colors.green[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: auth ? Profile() : Login(),
        routes: {
          Profile.routeName: (context) => Profile(),
          Login.routeName: (context) => Login(),
          AllCustomers.routeName: (context) => AllCustomers(),
          AddPerposal.routeName: (context) => AddPerposal(),
          OpenProject.routeName: (context) => OpenProject(),
          ProjectClose.routeName: (context) => ProjectClose(),
          Register.routeName: (context) => Register(),
          AddCustomerProject.routeName: (context) => AddCustomerProject(),
          AddProfile.routeName: (context) => AddProfile()
        },
      ),
    );
  }
}
