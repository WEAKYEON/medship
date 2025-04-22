import 'package:flutter/material.dart';
import 'package:medship/service/database.dart';
import 'package:medship/widget/widget_support.dart';

class DeleteHos extends StatefulWidget {
  const DeleteHos({super.key});

  @override
  State<DeleteHos> createState() => _DeleteHosState();
}

class _DeleteHosState extends State<DeleteHos> {
  Stream? hospitalStream;

  @override
  void initState() {
    getHospitalList();
    super.initState();
  }

  getHospitalList() async {
    hospitalStream = await DatabaseMethods().getHospitalList();
    setState(() {});
  }

  Widget hospitalListWidget() {
    return StreamBuilder(
      stream: hospitalStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0) {
          return Center(child: Text("ไม่มีข้อมูลโรงพยาบาล"));
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var hospital = snapshot.data.docs[index];
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(hospital["Image"]),
                  radius: 25,
                ),
                title: Text(
                  hospital["Name"],
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                subtitle: Text(hospital["Address"]),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("ยืนยันการลบ"),
                            content: Text(
                              "คุณแน่ใจหรือไม่ว่าต้องการลบโรงพยาบาลนี้?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "ลบ",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );

                    if (confirmDelete) {
                      await DatabaseMethods().deleteHospital(hospital.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            "ลบโรงพยาบาลเรียบร้อยแล้ว",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: hospitalListWidget(),
      ),
    );
  }
}
