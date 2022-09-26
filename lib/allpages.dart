import 'package:counterapp/counter_three.dart';
import 'package:counterapp/counter_two.dart';
import 'package:counterapp/main.dart';
import 'package:flutter/material.dart';

import 'counter_one.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? counter;

  int _currentIndex = 0;
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Counterone(
          title: 'Counter One',
        );
        break;
      case 1:
        return Countertwo(
          title: 'Counter Two',
        );
        break;
      default:
        return Counterthree(
          title: 'Counter Three',
        );
        break;
    }
  }

  final List _children = [
    Counterone(title: 'Counter One'),
    Countertwo(title: 'Counter Two'),
    Counterthree(title: 'Counter Three')
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counters'),
        actions: [
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('counterone', true);
              await prefs.setBool('countertwo', true);
              await prefs.setBool('counterthree', true);
              setState(() {
                counter = 0;
                //counter=1;
              });
            },
            child: Container(
              height: 30,
              width: 100,
              color: Colors.amber,
              child: Center(
                child: Text('RESET'),
              ),
            ),
          )
        ],
      ),
      body: getPage(_currentIndex), //_children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(0xff1B2C4B),
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.grey))),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff1B2C4B),
          onTap: onTabTapped,
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Text(
                'Counter 1',
                style: TextStyle(
                    height: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        _currentIndex == 0 ? Color(0xff03C8DA) : Colors.white),
              ), //Icon(Icons.home,color:  _currentIndex==0?Color(0xff03C8DA):Colors.white,size: 33,),
              label:
                  '', //style: TextStyle(letterSpacing: .3,fontSize: 7,fontWeight: FontWeight.w500,color: Color(0xff000000).withOpacity(1),)),
            ),
            BottomNavigationBarItem(
              icon: Text(
                'Counter 2',
                style: TextStyle(
                    height: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        _currentIndex == 1 ? Color(0xff03C8DA) : Colors.white),
              ),
              label: '',
              // title: new Text('',style: TextStyle(letterSpacing: .3,fontSize: 7,fontWeight: FontWeight.w500,color: Color(0xff000000).withOpacity(1),)),
            ),
            BottomNavigationBarItem(
              icon: Text(
                'Counter 3',
                style: TextStyle(
                    height: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        _currentIndex == 2 ? Color(0xff03C8DA) : Colors.white),
              ),
              label: '',
              // title: new Text('',style: TextStyle(letterSpacing: .3,fontSize: 7,fontWeight: FontWeight.w500,color: Color(0xff000000).withOpacity(1),)),
            ),
          ],
        ),
      ),
    );
  }
}
