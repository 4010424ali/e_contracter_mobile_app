import 'package:flutter/material.dart';

import 'package:e_contracter/screen/SingleCustomer.dart';

class BottomCardWidget extends StatelessWidget {
  final String cost;
  final String buildTime;
  final int totalSize;
  final String role;
  final String phone;
  final String id;

  BottomCardWidget(
      {@required this.cost,
      @required this.buildTime,
      @required this.totalSize,
      @required this.role,
      @required this.phone,
      @required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$phone",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        RaisedButton(
          color: Theme.of(context).buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SingleCustomer(id)));
          },
          child: Text('More Details'),
        )
      ],
    );
  }
}
