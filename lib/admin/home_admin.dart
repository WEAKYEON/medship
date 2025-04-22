import 'package:flutter/material.dart';
import 'package:medship/admin/add_hos.dart';
import 'package:medship/admin/add_med.dart';
import 'package:medship/admin/del_hos.dart';
import 'package:medship/admin/del_med.dart';
import 'package:medship/widget/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidget.HeadlineTextFieldStyle(),
              ),
            ),
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMed()),
                );
              },
              child: buildAdminTile(
                imagePath: "images/pill.png",
                label: "Add Medical Items",
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteMed()),
                );
              },
              child: buildAdminTile(
                imagePath: "images/pill.png",
                label: "Delete Medical Items",
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHos()),
                );
              },
              child: buildAdminTile(
                imagePath: "images/hospital.png",
                label: "Add Hospital",
              ),
            ),
            SizedBox(height: 20.0),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteHos()),
                );
              },
              child: buildAdminTile(
                imagePath: "images/hospital.png",
                label: "Delete Hospital",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminTile({required String imagePath, required String label}) {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 30.0),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
