import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class OrderViewScreen extends StatefulWidget {
  @override
  _OrderViewScreenState createState() => _OrderViewScreenState();
}

class _OrderViewScreenState extends State<OrderViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ContainedTabBarView(
        tabs: [
          Text('First', style: TextStyle(color: Colors.black)),
          Text('Second', style: TextStyle(color: Colors.black))
        ],
        views: [
          Container(color: Colors.red),
          Container(color: Colors.green),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
