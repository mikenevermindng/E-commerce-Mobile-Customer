import 'package:customer_app/abstracts/colors.dart';
import 'package:customer_app/abstracts/variables.dart';
import 'package:customer_app/screens/RegisterScreen/RegisterScreen.dart';
import 'package:customer_app/screens/home/home.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumber = new TextEditingController();
  final _password = new TextEditingController();
  String firebaseToken = "";

  SharedPreferences prefs;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;
    });
    FirebaseMessaging.instance.getToken().then((value) {
      print("Token $value");
      setState(() {
        firebaseToken = value;
      });
    });
    super.initState();
  }

  var dio = new Dio();

  Future<void> loginUser() async {

    if (_phoneNumber.text == '' || _password.text == '') {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Please fulfill the form"),
                // content: Text(""),
              ));
    } else {
      EasyLoading.show(status: 'loading...');
      dio.post('$api_url/customer/login', data: {
        'phone': _phoneNumber.text,
        'password': _password.text,
        'firebaseToken': firebaseToken
      }).then((value) {
        EasyLoading.dismiss();
        if (value.data['success']) {
          prefs.setString('customerId', value.data['_id']);
          prefs.setString('username', value.data['username']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Home.routeName,
                (Route<dynamic> route) => false,
          );
        } else {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text(value.data['msg']),
                  ));
        }
      }).catchError((e) {
        print(e);
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("Error"),
                ));
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: color_gradient_tertiary
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: space_huge * 2, horizontal: space_medium),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 180,
                  ),
                  SizedBox(height: space_big),

                  //Phone number field here~~~~
                  TextFormField(
                      controller: _phoneNumber,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                        labelText: "Số điện thoại",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              border_radius_big),
                          borderSide:
                          BorderSide(color: color_primary_darker, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              border_radius_big),
                          borderSide: BorderSide(
                            color: color_secondary,
                            width: 1.5,
                          ),
                        ),
                      )),

                  SizedBox(height: space_medium),

                  //Password field here~~~~
                  TextFormField(
                      obscureText: true,
                      controller: _password,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        labelText: "Mật khẩu",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              border_radius_big),
                          borderSide:
                          BorderSide(color: color_primary_darker, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              border_radius_big),
                          borderSide: BorderSide(
                            color: color_secondary,
                            width: 1.5,
                          ),
                        ),
                      )),

                  SizedBox(height: space_medium),

                  //Sign in button here~~~~
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: space_small, horizontal: space_big),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                      decoration: BoxDecoration(
                          gradient: color_gradient_dark,
                          borderRadius: BorderRadius.all(
                              Radius.circular(border_radius_big)),
                          boxShadow: [box_shadow_black]),
                      child: TextButton(
                          onPressed: loginUser,
                          child: Text(
                            "Đăng nhập",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: color_white),
                          )),
                    ),
                  ]),

                  SizedBox(height: space_huge),

                  //Sign up link here~~~~
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                        "Bạn mới biết đến EzShopping?",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                            "Đăng ký",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: color_secondary)
                        ))
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//0866770902