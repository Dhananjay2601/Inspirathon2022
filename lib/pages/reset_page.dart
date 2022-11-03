// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, unnecessary_new
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:inspirathon/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPage extends StatefulWidget {
  static String id = 'auth page';
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  bool _isLoading = false;
  bool _isObscure = true;

  TextEditingController otp1controller = TextEditingController();
  TextEditingController otp2controller = TextEditingController();
  TextEditingController otp3controller = TextEditingController();
  TextEditingController otp4controller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

//function to store user token locally
  static Future<bool> storeToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  //POST req, resetting password
  void resetPass(String password, String otp) async {
    try {
      Response response = await post(
        Uri.parse('http://10.10.25.23:8000/api/reset/'),
        body: {
          'otp': otp,
          'pw': password,
        },
      );
      if (response.statusCode == 202) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, '/');
      } else if (response.statusCode == 408) {
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
      } else {
        print('Failed');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Reset Failed! Please Enter Valid Details'),
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

//function to validate email
  // static validateEmail(String? value) {
  //   String pattern =
  //       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
  //       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
  //       r"{0,253}[a-zA-Z0-9])?)*$";
  //   RegExp regex = RegExp(pattern);
  //   if (value == null || value.isEmpty || !regex.hasMatch(value)) {
  //     return 'Enter a valid email address';
  //   } else {
  //     return null;
  //   }
  // }

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
        title: Text('Auth page'),
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
                //welcome resller
                Text(
                  'Get OTP for resetting password!',
                ),
                SizedBox(height: 20),
                ReqOtp(),
                SizedBox(height: 50),
                Text('Enter OTP here'),
                SizedBox(height: 15),

//OTP textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 50,
                        child: TextFormField(
                          controller: otp1controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          decoration: InputDecoration(hintText: '0'),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 50,
                        child: TextFormField(
                          controller: otp2controller,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: '0'),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 50,
                        child: TextFormField(
                          controller: otp3controller,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: '0'),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 50,
                        child: TextFormField(
                          controller: otp4controller,
                          decoration: InputDecoration(hintText: '0'),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text('Enter New Password here'),
                SizedBox(height: 30),
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
                            hintText: ('Enter New Password'),
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
//Submit OTP button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text(
                              'Submitting OTP...',
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
                      resetPass(
                        passwordcontroller.text.toString(),
                        otp1controller.text.toString() +
                            otp2controller.text.toString() +
                            otp3controller.text.toString() +
                            otp4controller.text.toString(),
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
                          'Submit OTP',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
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

class ReqOtp extends StatefulWidget {
  const ReqOtp({super.key});

  @override
  State<ReqOtp> createState() => _ReqOtpState();
}

class _ReqOtpState extends State<ReqOtp> {
  TextEditingController emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //POST req, sending email
  void reqOtp(String email) async {
    try {
      Response response = await post(
        Uri.parse('http://10.10.25.23:8000/api/forgot/'),
        body: {
          'email': email,
        },
      );
      if (response.statusCode == 200) {
        print('Email recieved Successfull');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //Email textfield
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
                      hintText: ('Enter your Email'),
                      prefixIcon: Visibility(
                        child: Icon(
                          Icons.mail,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
//Request OTP button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       backgroundColor: Colors.orange,
                //       content: Text(
                //         'Sending OTP to your phone...',
                //         style: TextStyle(color: Colors.black),
                //       ),
                //     ),
                //   );
                // }
                // _isLoading
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     :

                reqOtp(
                  emailcontroller.text.toString(),
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
                    'Request OTP',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
