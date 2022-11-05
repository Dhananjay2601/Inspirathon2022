// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, unnecessary_new
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/reset_page.dart';
import 'package:inspirathon/pages/signUp_page.dart';
import 'package:inspirathon/uri_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isObscure = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

//function to store user token locally
  static Future<bool> storeToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

//POST req, Login function
  void login(String email, password) async {
    try {
      Response response = await post(
        Uri.parse('$config/api/login/'),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 202) {
        setState(() {
          _isLoading = false;
        });

        print('Login Successfull');
        Navigator.pushNamed(context, HomePage.id);
        //take user token from API and store it locally for auth
        var data = jsonDecode(response.body.toString());
        storeToken(data['token']);
      } else if (response.statusCode == 404) {
        var message = jsonDecode(response.body.toString());
        message['message'];
        print(message);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('$message'),
          ),
          barrierDismissible: true,
        );
      } else if (response.statusCode == 406) {
        var message = jsonDecode(response.body.toString());
        message['message'];
        print(message);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('$message'),
          ),
          barrierDismissible: true,
        );
      } else {
        print('Login Failed');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Login Failed! Please Enter Valid User Details'),
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Image appLogo = new Image(
  //   image: ExactAssetImage("assets/goa-app-bar.png"),
  //   height: 50.0,
  //   width: 50.0,
  //   alignment: FractionalOffset.center,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          // child: appLogo,
        ),
        title: Text(
          'Login page',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[600],
      ),
      backgroundColor: Colors.orange[100],
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello User!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(height: 20),
//email testfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ('Email'),
                            prefixIcon: Visibility(
                              child: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
//password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: passwordcontroller,
                        obscureText: _isObscure,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ('Password'),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            prefixIcon: Visibility(
                              child: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
//login button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text(
                              'Processing Data...',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      // _isLoading
                      //     ? Center(
                      //         child: CircularProgressIndicator(),
                      //       )
                      //     :
                      setState(() {
                        _isLoading = true;
                      });
                      login(
                        emailcontroller.text.toString(),
                        passwordcontroller.text.toString(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
//not a resller? Join Us Now!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    TextButton(
                      child: Text(
                        ' Reset NOW!',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ResetPage.id);
                      },
                    )
                  ],
                ),
//not a member? Sign Up Now!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    TextButton(
                      child: Text(
                        ' Sign Up NOW!',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.id);
                      },
                    )
                  ],
                ),
                // Container(
                //   height: 60,
                //   width: 60,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('assets/goa-logo-app.png'),
                //     ),
                //     shape: BoxShape.circle,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
