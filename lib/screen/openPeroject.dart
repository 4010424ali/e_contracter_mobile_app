import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_contracter/provider/auth.dart';
import 'package:e_contracter/provider/perposal.dart';

import 'package:e_contracter/utils/url.dart';

class OpenProject extends StatefulWidget {
  static const routeName = '/openProject';

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends State<OpenProject> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<Auth>(context, listen: false);
    Provider.of<Perposals>(context, listen: false)
        .openProjects(user.user['userId'])
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final open = Provider.of<Perposals>(context);
    final user = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Project'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: open.openProject.length,
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
                                open.openProject[index].status
                                    ? 'open'
                                    : 'close',
                              ),
                              backgroundColor: open.openProject[index].status
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Chip(
                              label: Text(
                                open.openProject[index].accept == 'yes'
                                    ? 'accept'
                                    : 'pending',
                              ),
                              backgroundColor:
                                  open.openProject[index].accept == 'yes'
                                      ? Colors.grey
                                      : Colors.blueGrey,
                            ),
                            open.openProject[index].user['_id'] ==
                                    user.user['userId']
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      open.deketePerposal(
                                          open.openProject[index].id);
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
                                  open.openProject[index].title,
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
                                      'min price:  ${open.openProject[index].minPrice}',
                                    ),
                                    Text(
                                      'max price ${open.openProject[index].maxPrice}',
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
                                  open.openProject[index].description,
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
