import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medship/service/database.dart';
import 'package:medship/widget/widget_support.dart';

class DeleteMed extends StatefulWidget {
  const DeleteMed({super.key});

  @override
  State<DeleteMed> createState() => _DeleteMedState();
}

class _DeleteMedState extends State<DeleteMed> {
  bool lodkai = true,
      lodmuk = false,
      kaepud = false,
      kaeai = false,
      kaepae = false,
      lodklod = false,
      birth = false,
      medkit = false,
      supfood = false;
  String collectionName = "lodkai";
  Stream? medItemStream;

  @override
  void initState() {
    super.initState();
    getMedItems();
  }

  getMedItems() async {
    medItemStream = await DatabaseMethods().getMedItem(collectionName);
    setState(() {});
  }

  void resetCategories() {
    lodkai =
        lodmuk =
            kaepud =
                kaeai = kaepae = lodklod = birth = medkit = supfood = false;
  }

  Widget showCategoryButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          categoryButton("lodkai", "images/lodkai.png", lodkai, () {
            setState(() {
              collectionName = "lodkai";
              resetCategories();
              lodkai = true;
            });
            getMedItems();
          }),
          categoryButton("lodmuk", "images/lodmuk.png", lodmuk, () {
            setState(() {
              collectionName = "lodmuk";
              resetCategories();
              lodmuk = true;
            });
            getMedItems();
          }),
          categoryButton("kaepud", "images/kaepud.png", kaepud, () {
            setState(() {
              collectionName = "kaepud";
              resetCategories();
              kaepud = true;
            });
            getMedItems();
          }),
          categoryButton("kaeai", "images/kaeai.png", kaeai, () {
            setState(() {
              collectionName = "kaeai";
              resetCategories();
              kaeai = true;
            });
            getMedItems();
          }),
          categoryButton("kaepae", "images/kaepae.png", kaepae, () {
            setState(() {
              collectionName = "kaepae";
              resetCategories();
              kaepae = true;
            });
            getMedItems();
          }),
          categoryButton("lodklod", "images/lodklod.png", lodklod, () {
            setState(() {
              collectionName = "lodklod";
              resetCategories();
              lodklod = true;
            });
            getMedItems();
          }),
          categoryButton("birth", "images/birth.png", birth, () {
            setState(() {
              collectionName = "birth";
              resetCategories();
              birth = true;
            });
            getMedItems();
          }),
          categoryButton("medkit", "images/medkit.png", medkit, () {
            setState(() {
              collectionName = "medkit";
              resetCategories();
              medkit = true;
            });
            getMedItems();
          }),
          categoryButton("supfood", "images/supfood.png", supfood, () {
            setState(() {
              collectionName = "supfood";
              resetCategories();
              supfood = true;
            });
            getMedItems();
          }),
        ],
      ),
    );
  }

  Widget categoryButton(
    String name,
    String imagePath,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8),
          child: Image.asset(
            imagePath,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget showMedList() {
    return StreamBuilder<QuerySnapshot>(
      stream: medItemStream as Stream<QuerySnapshot>,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListTile(
                leading: Image.network(
                  doc["Image"],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(doc["Name"]),
                subtitle: Text("Price: ${doc["Price"]}\n${doc["Detail"]}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("ยืนยันการลบ"),
                            content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบยานี้?"),
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
                      await FirebaseFirestore.instance
                          .collection(collectionName)
                          .doc(doc.id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            "ลบยาสำเร็จแล้ว",
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
          "รายการยาในระบบ",
          style: AppWidget.boldTextFieldStyle().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            showCategoryButtons(),
            SizedBox(height: 20),
            Expanded(child: showMedList()),
          ],
        ),
      ),
    );
  }
}
