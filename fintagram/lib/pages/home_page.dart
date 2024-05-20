// ignore_for_file: prefer_const_constructors, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fintagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import './feed_page.dart';
import './profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  List<Widget> _pages = [
    FeedPage(),
    ProfilePage(),
  ];
  FireBaseServices? _fireBaseServices;
  @override
  void initState() {
    super.initState();
    _fireBaseServices = GetIt.instance.get<FireBaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Finstagram"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: GestureDetector(
              onTap: () {
                _postImage();
              },
              child: Icon(Icons.add_a_photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: GestureDetector(
              onTap: ()async {
                await _fireBaseServices!.logout();
                Navigator.popAndPushNamed(context, 'login');
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
      body: SafeArea(child: _pages[_currentPage]),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (_int) {
        setState(() {
          _currentPage = _int;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Profile',
        ),
      ],
    );
  }

  void _postImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (_result != null) {
      File _image = File(_result.files.first.path!);
      await _fireBaseServices!.postImage(_image);
    }
  }

  
}
