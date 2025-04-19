import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medship/pages/details.dart';
import 'package:medship/service/database.dart';
import 'package:medship/service/shared_pref.dart';
import 'package:medship/widget/widget_support.dart';
import 'package:medship/pages/order.dart' as mypage;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool lodkai = true, kaepud = false, khachuea = false, sleep = false;
  String? name;
  Stream? medItemStream;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    medItemStream = await DatabaseMethods().getMedItem("lodkai");
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: medItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Details(
                              name: ds['Name'],
                              image: ds['Image'],
                              price: ds['Price'],
                              detail: ds['Detail'],
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              ds['Image'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                      ds['Name'],
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "บรรเทาหวัด และเป็นไข้",
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "\฿" + ds['Price'],
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget allItems() {
    return StreamBuilder(
      stream: medItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Details(
                              name: ds['Name'],
                              image: ds['Image'],
                              price: ds['Price'],
                              detail: ds['Detail'],
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                ds['Image'],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              ds['Name'],
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "บรรเทาหวัด และเป็นไข้",
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\฿" + ds['Price'],
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                          ],
                        ),
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppWidget.boldTextFieldStyle(),
                      children: [
                        TextSpan(text: 'สวัสดี! คุณ '),
                        TextSpan(
                          text: name ?? '',
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mypage.Order()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "วันนี้คุณเป็นอย่างไรบ้าง?",
                style: AppWidget.HeadlineTextFieldStyle(),
              ),
              Text(
                "อย่าลืมดูแลตัวเองด้วยนะครับ",
                style: AppWidget.LightTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: showItem(),
              ),
              SizedBox(height: 30.0),
              Container(height: 270, child: allItems()),
              SizedBox(height: 20.0),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            lodkai = true;
            kaepud = false;
            khachuea = false;
            sleep = false;
            medItemStream = await DatabaseMethods().getMedItem("lodkai");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: lodkai ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/lodkai.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: lodkai ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            lodkai = false;
            kaepud = true;
            khachuea = false;
            sleep = false;
            medItemStream = await DatabaseMethods().getMedItem("kaepud");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: kaepud ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/kaepud.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: kaepud ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            lodkai = false;
            kaepud = false;
            khachuea = true;
            sleep = false;
            medItemStream = await DatabaseMethods().getMedItem("khachuea");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: khachuea ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/khachuea.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: khachuea ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            lodkai = false;
            kaepud = false;
            khachuea = false;
            sleep = true;
            medItemStream = await DatabaseMethods().getMedItem("sleep");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: sleep ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/sleep.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: sleep ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
