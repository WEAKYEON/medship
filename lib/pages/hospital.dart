import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medship/service/database.dart';
import 'package:medship/widget/widget_support.dart';

class Hospital extends StatefulWidget {
  const Hospital({super.key});

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  Stream? hospitalStream;

  getHospitalStream() async {
    hospitalStream = await DatabaseMethods().getHospitalList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHospitalStream();
  }

  Widget hospitalListWidget() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: hospitalStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            ds['Image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds['Name'],
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              SizedBox(height: 5),
                              Text(
                                ds['Address'],
                                style: AppWidget.LightTextFieldStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายชื่อโรงพยาบาล",
          style: AppWidget.boldTextFieldStyle().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: hospitalListWidget(),
      ),
    );
  }
}
