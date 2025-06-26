import 'package:flutter/material.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:study_hub/feature/home/presentation/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Study Hub',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? MyColors.white : MyColors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout,
                  color: isDarkMode ? MyColors.white : MyColors.black),
              tooltip: 'Sign Out',
              onPressed: () async {
                final shouldSignOut = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          isDarkMode ? MyColors.MyDarkTheme : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Text(
                        'Confirm Sign Out',
                        style: TextStyle(
                          color: isDarkMode ? MyColors.white : MyColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to sign out?',
                        style: TextStyle(
                          color: isDarkMode ? MyColors.white : MyColors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            width: 120,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyColors.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (shouldSignOut == true) {
                  await FirebaseAuth.instance.signOut();
                  final snackBar = SnackBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    behavior: SnackBarBehavior.floating,
                    content: AwesomeSnackbarContent(
                      title: 'Signed Out',
                      message: 'You have been signed out successfully.',
                      contentType: ContentType.success,
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(snackBar);
                }
              },
            ),
          ],
        ),
        body: HomePage());
  }
}
