import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_contracter/provider/perposal.dart';
import 'package:e_contracter/provider/auth.dart';

import 'package:e_contracter/utils/url.dart';

class ProjectClose extends StatefulWidget {
  static const routeName = '/porjectClose';

  @override
  _ProjectCloseState createState() => _ProjectCloseState();
}

class _ProjectCloseState extends State<ProjectClose> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<Auth>(context, listen: false);
    Provider.of<Perposals>(context, listen: false)
        .closeProjects(user.user['userId'])
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final close = Provider.of<Perposals>(context);
    final user = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Close Project'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: close.projectClose.length,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Chip(
                              label: Text(
                                close.projectClose[index].status
                                    ? 'open'
                                    : 'close',
                              ),
                              backgroundColor: close.projectClose[index].status
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Chip(
                              label: Text(
                                close.projectClose[index].accept == 'yes'
                                    ? 'accept'
                                    : 'pending',
                              ),
                              backgroundColor:
                                  close.projectClose[index].accept == 'yes'
                                      ? Colors.grey
                                      : Colors.blueGrey,
                            ),
                            close.projectClose[index].user['_id'] ==
                                    user.user['userId']
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      close.deketePerposal(
                                          close.projectClose[index].id);
                                      // setState(() {
                                      //   per.closeProjext.removeAt(index);
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
                                  close.projectClose[index].title,
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
                                      'min price:  ${close.projectClose[index].minPrice}',
                                    ),
                                    Text(
                                      'max price ${close.projectClose[index].maxPrice}',
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
                                  close.projectClose[index].description,
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
    );
  }
}
