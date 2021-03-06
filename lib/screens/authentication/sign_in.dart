import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderac/services/auth_service.dart';
import 'package:orderac/shared/snack_bar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void _startLoading() {
    setState(() {
      loading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      loading = false;
    });
  }

  void _setEmail(value) {
    setState(() {
      email = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.comfortaa(
                            fontSize: 50.0,
                          ),
                        ),
                        (loading)
                            ? SpinKitFadingCircle(
                                color: Colors.black,
                                size: 50.0,
                              )
                            : SizedBox()
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: TextFormField(
                        cursorWidth: 1.0,
                        decoration: InputDecoration(
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          counterText: '',
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter an email';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          _setEmail(value);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: TextFormField(
                        cursorWidth: 1.0,
                        decoration: InputDecoration(
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          counterText: '',
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Password must be atleast 6 characters';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      minWidth: double.maxFinite,
                      color: Colors.black,
                      height: 60.0,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          _startLoading();
                          dynamic result = await _auth
                              .signInWithEmailAndPasswordWithFirebase(
                            email,
                            password,
                          );
                          error = result.toString();
                          _stopLoading();
                          if (error == "Instance of 'AboutUser'") {
                            Navigator.of(context).pop();
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              showSnackBar(
                                Icons.error_outline,
                                error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: body,
    );
  }
}
