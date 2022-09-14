import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class OffersViewScreen extends StatefulWidget {
  @override
  _OffersViewScreenState createState() => _OffersViewScreenState();
}

class _OffersViewScreenState extends State<OffersViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offer Made"),
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
