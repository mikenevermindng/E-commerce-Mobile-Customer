import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/components/bottom_navbar.dart';
import 'package:customer_app/abstracts/colors.dart';

class Profile extends StatefulWidget {
  static String routeName = '/profile';

  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: color_gradient_primary),
            child: Column(
              children: [
                Container(
                    //Avt
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    decoration: BoxDecoration(
                        gradient: color_gradient_glass,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        border: Border.all(width: 1, color: Colors.white)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      gradient: color_gradient_secondary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.brown.shade800,
                                    child: Text('TH'),
                                    radius: 50,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text("Xin chào,",
                                            style: TextStyle(fontSize: 25)),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              4, 0, 12, 0),
                                          child: Icon(
                                            Icons.menu,
                                            size: 35,
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Vương Thành',
                                            style: TextStyle(fontSize: 25))),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 8),
                                            padding: EdgeInsets.fromLTRB(
                                                15, 4, 4, 4),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                        left: Radius.circular(20))),
                                            child: Container(
                                                width: 138,
                                                child: Row(children: [
                                                  Text("Cửa hàng của tôi",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .button),
                                                  Icon(
                                                      Icons
                                                          .keyboard_arrow_right_sharp,
                                                      size: 30)
                                                ]))))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Icon(Icons.local_grocery_store_outlined,
                                          size: 35, color: Colors.black45),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Giỏ hàng",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Icon(Icons.local_mall_outlined,
                                          size: 35, color: Colors.black),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Đơn hàng",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Text(
                                        "69",
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.black45),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Đang theo dõi",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: ListView(
                    children: [Text('123123')],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavbar());
  }
}