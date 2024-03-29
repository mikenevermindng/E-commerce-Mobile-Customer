import 'package:customer_app/abstracts/colors.dart';
import 'package:customer_app/constant.dart';
import 'package:customer_app/screens/shoppingCart/components/delivery_address.dart';
import 'package:customer_app/screens/shoppingCart/components/testMomo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';


class ConfirmOrder extends StatefulWidget {
  static String routeName = '/confirmOrder';
  final Function getData;
  const ConfirmOrder({
    Key key, this.getData,
  }) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  List<dynamic> items = [];
  int totalFee = 0;
  int shipping = 0;
  var dio = new Dio();
  SharedPreferences prefs;
  String currentUserId;
  String username;
  var userInfo;

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      setState(() {
        currentUserId = prefs.getString('customerId');
        username = prefs.getString('username');
      });
      initFunc();
    });
    super.initState();
  }

  void initFunc() async {
    EasyLoading.show(status: 'loading...');
    await Future.wait([getCart(), getUserInfo()]);

    List<Future> listShippingFuture = [];
    var index = 0;
    items.forEach((i) {
      listShippingFuture.add(calShipFee(index));
      index += 1;
    });
    await Future.wait(listShippingFuture);
    EasyLoading.dismiss();
  }

  Future<void> calShipFee(index) async {
    var option = Options(
        headers: {
          "token": token_ghn,
        }
    );
    var res = await dio.post("$ghn_url/shiip/public-api/v2/shipping-order/available-services", data: {
      "from_district": int.parse(items[index]["district"]),
      "to_district": int.parse(userInfo["district"]),
      "shop_id": shopId_ghn
    }, options: option);

    dio.post("$ghn_url/shiip/public-api/v2/shipping-order/fee", data:{
      "from_district_id": int.parse(items[index]["district"]),
      "service_id": res.data["data"][0]["service_id"],
      "service_type_id":null,
      "to_district_id": int.parse(userInfo["district"]),
      "to_ward_code": userInfo["ward"].toString(),
      "height":50,
      "length":20,
      "weight":200,
      "width":20,
      "insurance_fee":0,
      "coupon": null
    }, options: option).then((value) {
      var newTotal = totalFee + value.data["data"]["total"];
      var newItems = items;
      newItems[index]["shipping"] = value.data["data"]["total"];
      setState(() {
        totalFee = newTotal;
        items = newItems;
      });
    });
  }

  Future<void> getCart() {
    return dio.get('$api_url/cart/customer/$currentUserId/getCart').then((value) {
      if (value.data['success']) {
        setState(() {
          items = value.data["data"]['items'].map((item) => {...item, "shipping": 0}).toList();
        });
        items.forEach((item) {
          item["products"].forEach((p) =>
          {
            totalFee += p["checked"] ? p["amount"] * p["product"]["price"] : 0
          });
        });
      }
    });
  }

  Future<void> getUserInfo() {
    return dio.get("$api_url/customer/$currentUserId/getInfo").then((value) {
      if(this.mounted) {
        print(value.data);
        setState(() {
          userInfo = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Xác nhận thanh toán",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 22, color: Colors.white))),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: BoxDecoration(gradient: color_gradient_primary),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: totalFee > 0 ?  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Container>[
                        Container(child: DeliveryAddress(Info: userInfo))
                      ] +
                      items.map((e) {
                        var listProduct = e['products'].where((p) => p["checked"] == true).toList();
                        return listProduct.length > 0 ? Container(
                            decoration: BoxDecoration(
                                gradient: color_gradient_glass,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)
                                ),
                                border: Border.all(color: Colors.white60, width: 1)
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap:(){
                                  print("go to store");
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage: NetworkImage(e["avatar"]),
                                        radius: 25
                                    ),
                                    SizedBox(width: 15,),
                                    Text(e["shopName"], style: Theme.of(context).textTheme.headline6,)
                                  ],
                                ),
                              ),
                            ] + listProduct.map<Widget>((p) => Container(
                              padding: EdgeInsets.only(top: 18),
                              margin: EdgeInsets.only(top: 18),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(color: Colors.black, width: 1)
                                  )
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        // gradient: color_gradient_glass,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: Offset(2, 2)
                                            ),]
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image(
                                            width: 100,
                                            // height: 75,
                                            image: NetworkImage(p["product"]["thumbnail"]),
                                            fit: BoxFit.cover
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                  p["product"]["productName"],
                                                  style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 20)),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false
                                              )
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Giá:  ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(p["product"]["price"])}",
                                                style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 15)),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Số lượng:  ${p["amount"]}",
                                                style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 15)),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Tổng:  ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(p["amount"]*p["product"]["price"])}",
                                                style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )
                            ).toList() + [
                              Container(
                                  padding: EdgeInsets.only(top: 18),
                                  margin: EdgeInsets.only(top: 18),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.black, width: 1)
                                      )
                                  ),
                                child: Row(
                                  children: [
                                    Text("Phí vận chuyển: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(e["shipping"])}", style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 18))),
                                  ],
                                )
                              )
                            ],
                          )
                        ) : Container();
                      }).toList()
                    ),
                  ) : Container()
                )
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: color_gradient_primary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 12,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8) ,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Tổng:  ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(totalFee)}",
                                style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 20))))),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            context: context,
                            builder: (BuildContext context){
                              return Momo(username: username, currentUserId: currentUserId, items: items, totalFee: totalFee,);
                            });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: color_gradient_primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 8,
                                blurRadius: 12,
                                offset: Offset(1, 10), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Xác nhận",
                                style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 20, color: Colors.white))),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
