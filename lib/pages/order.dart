import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medship/service/constant.dart';
import 'package:medship/service/database.dart';
import 'package:medship/service/shared_pref.dart';
import 'package:medship/widget/widget_support.dart';
import 'package:http/http.dart' as http;

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  int total = 0, amount2 = 0;
  Map<String, dynamic>? paymentIntent = {
    "amount": 0,
    "currency": "THB",
    "payment_method_types": ["card"],
  };
  void startTimer() {
    Timer(Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    total = 0;
    medStream = await DatabaseMethods().getMedCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? medStream;

  Widget medCart() {
    return StreamBuilder(
      stream: medStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                total = total + int.parse(ds["Total"]);
                int quantity = int.parse(ds["Quantity"]);
                int pricePerItem = int.parse(ds["Total"]) ~/ quantity;
                total = 0;
                total += int.parse(ds["Total"]);

                return Container(
                  margin: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // จำนวน
                          Container(
                            height: 90,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(ds["Quantity"])),
                          ),
                          SizedBox(width: 20.0),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              ds["Image"],
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20.0),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "\$${ds["Total"]}",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () async {
                                        if (quantity > 1) {
                                          await DatabaseMethods()
                                              .updateCartQuantity(
                                                id!,
                                                ds.id,
                                                quantity - 1,
                                                pricePerItem,
                                              );
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    Text(ds["Quantity"]),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        await DatabaseMethods()
                                            .updateCartQuantity(
                                              id!,
                                              ds.id,
                                              quantity + 1,
                                              pricePerItem,
                                            );
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () async {
                                        await DatabaseMethods().deleteCartItem(
                                          id!,
                                          ds.id,
                                        );
                                        setState(() {});
                                        total = 0;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MedCart", style: AppWidget.boldTextFieldStyle()),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: medCart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFieldStyle()),
                  Text(
                    "\฿" + total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                makePayment(total.toString());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'THB');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'MedShip',
            ),
          )
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      print("exception:$e$s");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
            await clearMedCart();
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Payment Successful",
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
            paymentIntent = null;
          })
          .onError((error, stackTrace) {
            print("Error is: --->$error $stackTrace");
          });
    } on StripeException catch (e) {
      print("Error is:--->$e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print("err charging user: ${err.toString()}");
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount) * 100);
    return calculateAmount.toString();
  }

  Future<void> clearMedCart() async {
    final cartCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("cart");

    final cartItems = await cartCollection.get();

    for (DocumentSnapshot doc in cartItems.docs) {
      await doc.reference.delete();
    }

    total = 0;
    amount2 = 0;
    setState(() {});
  }
}
