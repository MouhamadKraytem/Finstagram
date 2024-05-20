// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_final_fields, unused_field, prefer_is_empty, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fintagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  FireBaseServices? _fireBaseServices;
  String? _name, _email, _pass;
  File? _image;
  @override
  void initState() {
    super.initState();
    _fireBaseServices = GetIt.instance.get<FireBaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleApp(),
                _profileImageWidget(),
                _registerForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleApp() {
    return Text(
      "Finstagram",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight! * 0.35,
      child: Form(
        key: _registerKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _nameTextField(),
            _emailTextField(),
            _passTextField(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageWidget() {
    var _imageProvider = _image != null
        ? FileImage(_image!)
        : NetworkImage("https://i.pravatar.cc/600");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          setState(() {
            _image = File(_result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _deviceHeight! * 0.10,
        width: _deviceWidth! * 0.10,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      validator: (value) => value!.length == 0 ? "Empty field" : null,
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
      decoration: InputDecoration(
        hintText: "Name...",
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      validator: (value) {
        bool _result = value!.contains(RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"));
        return _result ? null : "please enter a valide email";
      },
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      decoration: InputDecoration(
        hintText: "Email...",
      ),
    );
  }

  Widget _passTextField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        return value!.length > 6
            ? null
            : "Please enter a pass greater than 6 char";
      },
      onSaved: (_value) {
        setState(() {
          _pass = _value;
        });
      },
      decoration: InputDecoration(
        hintText: "Password...",
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: () {
        _registerUser();
      },
      minWidth: _deviceWidth! * 0.7,
      height: _deviceHeight! * 0.06,
      color: Colors.red,
      child: Text(
        "Register",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  void _registerUser() async {
    if (_registerKey.currentState!.validate() && _image != null) {
      _registerKey.currentState!.save();
      bool _result = await _fireBaseServices!.registerUser(
        name: _name!,
        email: _email!,
        pass: _pass!,
        image: _image!,
      );
      if (_result) {
        Navigator.pop(context);
      } else {
        print("register error");
      }
      //print("saved");
    } else {
      //print("error");
    }
  }
}
