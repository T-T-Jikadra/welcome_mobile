// ignore_for_file: depend_on_referenced_packages, avoid_print, prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqButton.dart';
import 'package:welcome_mob/common/eqWidget/eqTextField.dart';
import 'package:welcome_mob/common/constant.dart';
import 'package:welcome_mob/common/function.dart';
import 'package:http/http.dart' as http;
import 'package:welcome_mob/auth/final_login.dart';
import 'package:welcome_mob/globals.dart';
import 'package:welcome_mob/auth/user_List.dart';

class RegScreen extends StatefulWidget {
  final int? id;

  const RegScreen({super.key, this.id});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
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
    print("idddd1");
    print(widget.id);
    if (widget.id != 0) {
      loadUserData();
    }
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
      appBar: AppBar(
        backgroundColor: eqPrimaryColor,
        title: Center(
          child: Text(widget.id! == 0 ? "Register" : "Update User",
              style: TextStyle(
                  fontFamily: 'muli', fontSize: 22, color: Colors.white)),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // double screenWidth = constraints.maxWidth;
                  // double svgScaleFactor = screenWidth < 600 ? 150 : 220;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/t_2.png", height: 188),
                      Text(
                        widget.id! == 0
                            ? "Create An Account .."
                            : "Update user Data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      // SvgPicture.asset('assets/svg/login_image.svg',
                      //     height: svgScaleFactor),
                      const SizedBox(height: 51),
                      // buildClientIdField(),
                      // const SizedBox(height: 10),
                      buildUserNameField(),
                      // const SizedBox(height: 10),
                      buildPwdField(),
                      Column(
                          children: errors
                              .map((error) => formErrorText(err: error))
                              .toList()),
                      errors.isNotEmpty
                          ? const SizedBox(height: 10)
                          : const SizedBox(height: 30),
                      EqButton(
                          text: widget.id! == 0 ? "Register" : "Update",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // proceedLogin(context);
                              reg();
                            }
                          }),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserList()));
                              },
                              child: Text("User List")),
                          if (widget.id! == 0)
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text("Have an Account ? "))
                        ],
                      ),
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
        autofocus: true,
        hintText: "Enter User Name",
        labelText: "User Name",
        controller: _usernameController,
        onChanged: (value) {
          _usernameController.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: _usernameController.selection);
          checkUserName(value);
        },
        validator: (value) => checkUserName(value),
        prefixIcon: Icon(Icons.person, color: eqPrimaryColor));
  }

  EqTextField buildPwdField() {
    return EqTextField(
        autofocus: true,
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
        validator: (value) => checkPwd(value));
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

  Future<void> reg() async {
    customProgress(context);
    try {
      var id;
      var uri = "${Globals.domainUrl}/addUser";
      if (widget.id! > 0) {
        id = widget.id!.toString();
      } else {
        id = 0;
      }

      var data = {
        'id': id,
        'username': _usernameController.text.trim(),
        'password': _pwdController.text.trim(),
      };
      var body = json.encode(data);
      print(uri);
      print(body);

      var response = await http.post(Uri.parse(uri),
          headers: {"Content-Type": "application/json"}, body: body);
      print(response.statusCode);

      // if (response.statusCode == 200) {
      var resData = jsonDecode(response.body);
      print(resData);
      if (resData["success"] == true) {
        hideIndicator(context);
        showSnakebar(context,
            title: resData["message"], milliseconds: 1000, color: Colors.green);
        if (widget.id! == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          Navigator.pop(context, true);
        }
      } else {
        hideIndicator(context);
        showSnakebar(context,
            title: resData["message"], milliseconds: 1000, color: Colors.red);
      }
      // } else {
      //   var errorBody = jsonDecode(response.body);
      //   print('Error: ${errorBody['error']}');
      //   print('Message: ${errorBody['message']}');
      //   hideIndicator(context);
      //   showSnakebar(context,
      //       title: errorBody['message'], milliseconds: 1000, color: Colors.red);
      // }
    } catch (e) {
      hideIndicator(context);
      showSnakebar(context,
          title: e.toString(), milliseconds: 1000, color: Colors.red);
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

  Future<void> loadUserData() async {
    var id = widget.id;
    var url = "${Globals.domainUrl}/getUser?id=$id";

    var jsonData = await getDio(Url: url);
    setState(() {
      _usernameController.text = jsonData["data"]["username"];
    });
  }
}
