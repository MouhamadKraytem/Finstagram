// ignore_for_file: unused_field, prefer_const_constructors, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FireBaseServices? _fireBaseServices;
  double? _deviceHeight, _deviceWidth;
  @override
  void initState() {
    super.initState();
    _fireBaseServices = GetIt.instance.get<FireBaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight!,
      width: _deviceWidth!,
      child: _postListView(),
    );
  }

  Widget _postListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireBaseServices!.getLatestPost(),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            //print(_snapshot.data!.docs);
            List _posts = _snapshot.data!.docs.map((e) => e.data()).toList();
            return ListView.builder(
              itemBuilder: (BuildContext _contetx, int index) {
                Map _post = _posts[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: _deviceHeight! * 0.01,
                    horizontal: _deviceWidth! * 0.05 
                  ),
                  height: _deviceHeight! * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_post['image']),
                    ),
                  ),
                );
              },
              itemCount: _posts.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
