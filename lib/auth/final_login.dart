// ignore_for_file: depend_on_referenced_packages, avoid_print, prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/globals.dart';
import 'package:welcome_mob/dashboard.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/eqWidget/eqTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final LocalAuthentication _auth = LocalAuthentication();
  // bool _isAuthenticated = false;

  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  var db = '';
  var url;
  var data;
  var dbName = '';
  var validateClientId = '';
  var validateUsername = '';
  var validatePwd = '';
  var formValid = false;

  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  List<String> err = [];

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _usernameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: eqPrimaryColor,
        title: const Center(
          child: Text("Login",
              style: TextStyle(
                  fontFamily: 'muli', fontSize: 22, color: Colors.white)),
        ),
      ),
      // floatingActionButton: (validateClientId.isEmpty &&
      //         validateUsername.isEmpty &&
      //         validatePwd.isEmpty)
      //     ? null
      //     : FloatingActionButton(
      //         backgroundColor: eqPrimaryColor,
      //         shape: CircleBorder(eccentricity: 0.2),
      //         onPressed: () async {
      //           if (!_isAuthenticated) {
      //             final bool canAuthenticateWithBiometrics =
      //                 await _auth.canCheckBiometrics;
      //             print(canAuthenticateWithBiometrics);

      //             if (canAuthenticateWithBiometrics) {
      //               try {
      //                 final bool didAuthenticate = await _auth.authenticate(
      //                     localizedReason:
      //                         'Authenticate in Equal with your biometrics !!',
      //                     options: AuthenticationOptions(
      //                         biometricOnly: true,
      //                         useErrorDialogs: true,
      //                         stickyAuth: true));
      //                 setState(() {
      //                   _isAuthenticated = didAuthenticate;
      //                 });
      //                 if (_isAuthenticated) {
      //                   loadCredentials();
      //                   proceedLogin(context);
      //                 }
      //               } catch (e) {
      //                 print(e);
      //                 // Optionally show a snackbar or handle the error here
      //                 showSnakebar(context,
      //                     title: "Authentication error: $e",
      //                     milliseconds: 3000,
      //                     color: Colors.red);
      //               }
      //             } else {
      //               // This part handles the case where biometrics are not available
      //               showSnakebar(context,
      //                   title:
      //                       "Your device does not support biometric authentication",
      //                   milliseconds: 3000,
      //                   color: Colors.grey);
      //             }
      //           } else {
      //             // This block should handle cases when already authenticated
      //             showSnakebar(context,
      //                 title: "Already authenticated",
      //                 milliseconds: 2000,
      //                 color: Colors.blue);
      //             setState(() {
      //               _isAuthenticated = false;
      //             });
      //           }
      //         },
      //         child: Icon(_isAuthenticated ? Icons.verified : Icons.fingerprint,
      //             color: Colors.white),
      //       ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // double screenWidth = constraints.maxWidth;
                  // double svgScaleFactor = screenWidth < 600 ? 150 : 220;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/wm.jpg", height: 188),
                      const SizedBox(height: 20),
                      Text(
                        "Login Here  ..",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      // SvgPicture.asset('assets/svg/login_image.svg',
                      //     height: svgScaleFactor),
                      const SizedBox(height: 50),
                      // buildClientIdField(),
                      // const SizedBox(height: 10),
                      buildUserNameField(),
                      // const SizedBox(height: 10),
                      buildPwdField(),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: EqButton(
                            text: "Continue",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // proceedLogin(context);
                                // login();
                                if (_usernameController.text.trim() ==
                                        "WELCOME MOBILE" &&
                                    _pwdController.text.trim() == "GURUJI") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => dashboard()));
                                } else {
                                  showSnakebar(context,
                                      title: "Invalid Credentials !!",
                                      milliseconds: 1750,
                                      color: Colors.red);
                                }
                              }
                            }),
                      ),
                      SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     InkWell(
                      //         onTap: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       RegScreen(id: 0)));
                      //         },
                      //         child: Text("Don't Have an Account ? "))
                      //   ],
                      // )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  EqTextField buildClientIdField() {
    return EqTextField(
        autofocus: true,
        hintText: "Enter Client Id",
        labelText: "Client Id",
        controller: _clientIdController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _clientIdController.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: _clientIdController.selection);
          checkClientId(value);
        },
        validator: (value) => checkClientId(value),
        prefixIcon: Icon(Icons.person, color: eqPrimaryColor));
  }

  EqTextField buildUserNameField() {
    return EqTextField(
        // autofocus: true,
        hintText: "Enter User Name",
        labelText: "User Name",
        controller: _usernameController,
        onChanged: (value) {
          _usernameController.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: _usernameController.selection);
          checkUserName(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Username is required ...";
          }
          return null;
        },
        prefixIcon: Icon(Icons.person, color: eqPrimaryColor));
  }

  EqTextField buildPwdField() {
    return EqTextField(
        // autofocus: true,
        isObscureText: true,
        hintText: "Enter Password",
        labelText: "Password",
        controller: _pwdController,
        onChanged: (value) {
          _pwdController.value = TextEditingValue(
              text: value.toUpperCase(), selection: _pwdController.selection);
          checkPwd(value);
        },
        suffixIcon: const Icon(Icons.password),
        prefixIcon: Icon(Icons.lock_person_outlined, color: eqPrimaryColor),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password is required ...";
          }
          return null;
        });
  }

  // Error rows
  Row formErrorText({required String err}) {
    return Row(children: [
      const Icon(Icons.error, color: Colors.red),
      const SizedBox(width: 8),
      Text(err, style: const TextStyle(color: Colors.red))
    ]);
  }

  // Check client id ..
  String? checkClientId(String? clientId) {
    String errorText = "Enter client id";
    if (clientId == null || clientId.isEmpty) {
      if (!errors.contains(errorText)) {
        setState(() {
          errors.add(errorText);
          formValid = true;
        });
      }
      return '';
    } else {
      if (errors.contains(errorText)) {
        setState(() {
          errors.remove(errorText);
          formValid = false;
        });
      }
    }
    return null;
  }

  // Check username id ..
  String? checkUserName(String? username) {
    String errorText = "Enter user name";
    if (username == null || username.isEmpty) {
      if (!errors.contains(errorText)) {
        setState(() {
          errors.add(errorText);
          formValid = true;
        });
      }
      return '';
    } else {
      if (errors.contains(errorText)) {
        setState(() {
          errors.remove(errorText);
          formValid = false;
        });
      }
    }
    return null;
  }

  // Check password id ..
  String? checkPwd(String? pwd) {
    String errorText = "Enter password";
    if (pwd == null || pwd.isEmpty) {
      if (!errors.contains(errorText)) {
        setState(() {
          errors.add(errorText);
          formValid = true;
        });
      }
      return '';
    } else {
      if (errors.contains(errorText)) {
        setState(() {
          errors.remove(errorText);
          formValid = false;
        });
      }
    }
    return null;
  }

  Future<void> login() async {
    customProgress(context);
    try {
      var uri = "${Globals.domainUrl}/login";

      var data = {
        'username': _usernameController.text.trim(),
        'password': _pwdController.text.trim(),
      };
      var body = json.encode(data);
      print(uri);
      print(body);

      var response = await http.post(Uri.parse(uri),
          headers: {"Content-Type": "application/json"}, body: body);
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["success"] == true) {
        setSettings("userName", _usernameController.text.trim());
        setSettings("pwd", _pwdController.text.trim());
        hideIndicator(context);
        showSnakebar(context,
            title: "Login Success !!", milliseconds: 1000, color: Colors.green);
        Navigator.push(
            context,
            // MaterialPageRoute(
            //     builder: (context) =>
            //         Dashboard(name: _usernameController.text)));
            MaterialPageRoute(builder: (context) => dashboard()));
      } else {
        hideIndicator(context);
        showSnakebar(context,
            title: resData["message"], milliseconds: 1000, color: Colors.red);
      }
      // showSnakebar(context,
      //     title: "Login Success !!", milliseconds: 1000, color: Colors.green);
      // hideIndicator(context);
    } catch (e) {
      showSnakebar(context, title: e, milliseconds: 1000, color: Colors.red);
    }
  }

  // Load user credentials ..
  void loadCredentials() {
    getSettings('clientId').then((value) {
      setState(() {
        if (value.isEmpty) {
          // isNewUser = true;
        }
        _clientIdController.text = value;
        validateClientId = value;
      });
    });
    getSettings('userName').then((value) {
      _usernameController.text = value;
      validateUsername = value;
    });
    getSettings('pwd').then((value) {
      _pwdController.text = value;
      validatePwd = value;
    });
    getSettings('db').then((value) {
      dbName = value;
    });
  }
}
