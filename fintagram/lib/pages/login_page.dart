// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, use_build_context_synchronously, avoid_print

import 'package:fintagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;
  FireBaseServices? _fireBaseServices;
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  String? _email, _pass;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _titleApp(),
                _loginForm(),
                _loginButton(),
                _registerPageLink()
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

  Widget _loginForm() {
    return Container(
      height: _deviceHeight! * 0.2,
      child: Form(
        key: _loginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _emailTextField(),
            _passTextField(),
          ],
        ),
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

  Widget _loginButton() {
    return MaterialButton(
      onPressed: () {
        _loginUser();
      },
      minWidth: _deviceWidth! * 0.7,
      height: _deviceHeight! * 0.06,
      color: Colors.red,
      child: Text(
        "Login",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: Text(
        "don't have an account?",
        style: TextStyle(
            color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _loginUser() async {
    if (_loginKey.currentState!.validate()) {
      _loginKey.currentState!.save();
      bool _result =
          await _fireBaseServices!.userLogin(email: _email!, pass: _pass!);
      if (_result) {
        Navigator.popAndPushNamed(context, 'home');
      } else {
        print("login error");
      }
    }
  }
}
