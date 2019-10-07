import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  var _email, _password;

  showSnackbar(context, message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepOrange,
    ));
  }

  showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getLogin() async {
    var form = _loginFormKey.currentState;
    if (form.validate()) {
      form.save();

      var url = 'http://10.0.2.2/flutter_api/login/login.php';
      var data = {'email': _email};

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
      var response = await http.post(url, body: data);

      var parsedJson = json.decode(response.body);
      var email = parsedJson['result'][0]['email'];
      var hashedPassword = parsedJson['result'][0]['pass'];
      var isCorrect = new DBCrypt().checkpw(_password, hashedPassword);

      Navigator.pop(context);
      if (isCorrect)
        Navigator.pushNamed(context, '/home');
      else
        showToast("Invalid Credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    /********************* Button Login ****************************************/
    var loginButton = FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(color: Colors.white)),
      padding: EdgeInsets.only(left: 50, right: 50),
      textColor: Colors.white,
      child: Text('Login'),
      splashColor: Colors.blueGrey,
      onPressed: () => _getLogin(),
    );
    /*************************************************/

    return Scaffold(
      body: Form(
        key: _loginFormKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage('assets/img/login-background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
            ),
          ),
          padding: EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/img/login-logo.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Text(
                      'Google Login',
                      style: TextStyle(fontSize: 34, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text.';
                        } else if (!EmailValidator.validate(value, true)) {
                          return 'Not a valid email.';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value,
                      style: TextStyle(color: Colors.blue),
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Email Address'),
                      onChanged: (String value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text.';
                      } else if (value.length < 4) {
                        return 'Password too short..';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // hintText: 'Enter your product description',
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Password'),
                    onChanged: (String value) {
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            showSnackbar(context, 'Forgot Password ?');
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 25, right: 5),
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                      Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 25, right: 5),
                            child: Text(
                              'Create An Account?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  loginButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
