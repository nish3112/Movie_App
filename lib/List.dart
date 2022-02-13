import 'dart:convert';
import 'package:like_button/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/addMov.dart';
import 'dbhelper.dart';
import 'login.dart';
import 'models.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late DatabaseHandler handler;
  late Future<List<todo>> _todo;
  final auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        _todo = getList();
      });
    });
  }

  Future<List<todo>> getList() async {
    return await handler.todos();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _todo = getList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 6,),
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Movies",
                style:
                    TextStyle(color: Colors.white, backgroundColor: Colors.black),
              ),
            ),
            Spacer(flex: 3,),
            TextButton(
              onPressed: () {
                auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addMov()));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<todo>>(
        future: _todo,
        builder: (BuildContext context, AsyncSnapshot<List<todo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error : ${snapshot.error}");
          } else {
            final items = snapshot.data ?? <todo>[];
            return Container(
              color: Colors.black,
              child: Scrollbar(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 10,
                                height: MediaQuery.of(context).size.height/4,
                                color: Colors.black,
                                child: Image.memory(base64.decode(items[index].photo),
                                ),
                            ),
                            Container(
                              key: ValueKey<int>(items[index].id),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 75,
                                    width: MediaQuery.of(context).size.width/1.5,
                                    child: Card(
                                      child: ListTile(
                                        tileColor: Colors.black,
                                        title: Center(
                                            child: Text(
                                              items[index].title + " by " + items[index].description,
                                              style: TextStyle(color: Colors.white,fontSize: 18),
                                            )),
                                      ),
                                    ),
                                  ),
                              LikeButton(
                                size: 30,
                                circleColor:
                                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Color(0xff33b5e5),
                                  dotSecondaryColor: Color(0xff0099cc),
                                ),
                              ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await handler.deletetodo(items[index].id);
                                      setState(() {
                                        items.remove(items[index]);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
