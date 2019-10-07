import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:dbcrypt/dbcrypt.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  var _email, _password, _c_password;

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

  _checkData() async {
    var form = _registerFormKey.currentState;
    if (form.validate()) {
      form.save();
      var hashedPassword =
          new DBCrypt().hashpw(_password, new DBCrypt().gensalt());
      if (_password == _c_password) {
        var url = 'http://10.0.2.2/flutter_api/login/register.php';
        var data = {'email': _email, 'pass': hashedPassword};
        var response = await http.post(url, body: data);

//        print('Response status: ${response.statusCode}');
//        print('Response body: ${response.body}');
        showToast('Response : ${response.body}');
        Navigator.pop(context);
      } else {
        form.reset();
        showToast("Password Not Match.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /********************* Button Register ****************************************/
    var registerButton = FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(color: Colors.white)),
      padding: EdgeInsets.only(left: 50, right: 50),
      textColor: Colors.white,
      child: Text('Register'),
      splashColor: Colors.blueGrey,
      onPressed: () => _checkData(),
    );
    /*************************************************/

    return Scaffold(
      body: Form(
        key: _registerFormKey,
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
                      'Google Register',
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
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
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Password'),
                    ),
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
                    onSaved: (value) => _c_password = value,
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
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Confirm Password'),
                  ),
                  Builder(builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25, right: 5),
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 25,
                  ),
                  registerButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
