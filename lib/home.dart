import 'package:flutter/material.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/feature/home/presentation/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Study Hub',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: MyColors.black),
          ),
        ),
        body: HomePage());
  }
}
