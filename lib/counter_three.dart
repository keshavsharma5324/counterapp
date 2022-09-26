import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counterthree extends StatefulWidget {
  Counterthree({Key? key, required this.title});

  final String title;

  @override
  State<Counterthree> createState() => _CounterthreeState();
}

class _CounterthreeState extends State<Counterthree> {
  DocumentSnapshot? documentSnapshot;
  int _counter = 0;
  final CollectionReference _Counterthree =
      FirebaseFirestore.instance.collection('counter3');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
    }
    if (action == 'create') {
      await _Counterthree.add({"name": 'Counterthree', "value": _counter});
    }
    if (action == 'update') {
      await _Counterthree.doc(documentSnapshot!.id)
          .update({"name": 'Counterthree', "value": _counter});
    }
  }

  void _incrementCounter([DocumentSnapshot? documentSnapshot]) async {
    setState(() {
      _counter++;
    });
    _createOrUpdate(documentSnapshot);
  }

  void reset() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? reset = prefs.getBool('counterthree');
    if (reset == true) {
      if (documentSnapshot != null) {
        _counter = 0;
        _createOrUpdate(documentSnapshot);
      }
    }
    await prefs.setBool('counterthree', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _Counterthree.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                //final DocumentSnapshot
                documentSnapshot = streamSnapshot.data!.docs[index];
                _counter = streamSnapshot.data!.docs[index]['value'];
                reset();
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Counter 3',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              'You have pushed the button this many times \n Counter:',
                            ),
                            Text(
                              documentSnapshot!['value'].toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            InkWell(
                                onTap: () {
                                  _incrementCounter(documentSnapshot);
                                },
                                child: Container(
                                  color: Colors.blue,
                                  height: 30,
                                  width: 110,
                                  child: Center(
                                      child: Text(
                                    'Increment me!',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffFFFFFF)),
                                  )),
                                ))
                          ],
                        ),
                      ),
                    ),
                    /* Positioned(bottom: 200,left: 100,child: FloatingActionButton(
        onPressed:(){_incrementCounter(documentSnapshot);} ,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), )*/
                  ],
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter(documentSnapshot);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
