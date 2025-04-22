import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addMedItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getMedItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future<Stream<QuerySnapshot>> getHospitalList() async {
    return FirebaseFirestore.instance.collection("Hospitals").snapshots();
  }

  Future addHospital(Map<String, dynamic> hospitalInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Hospitals")
        .add(hospitalInfoMap);
  }

  Future<void> deleteHospital(String docId) async {
    await FirebaseFirestore.instance
        .collection("Hospitals")
        .doc(docId)
        .delete();
  }

  Future addMedtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getMedCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("cart")
        .snapshots();
  }

  Future<void> deleteCartItem(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(docId)
        .delete();
  }

  Future<void> updateCartQuantity(
    String userId,
    String docId,
    int newQuantity,
    int pricePerItem,
  ) async {
    int newTotal = newQuantity * pricePerItem;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(docId)
        .update({
          'Quantity': newQuantity.toString(),
          'Total': newTotal.toString(),
        });
  }

  Future<void> clearCart(String userId) async {
    var cartItems =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("cart")
            .get();

    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfoMap,
  ) async {
    final chatRoomDoc = _firestore.collection("chatrooms").doc(chatRoomId);
    final snapshot = await chatRoomDoc.get();
    if (!snapshot.exists) {
      await chatRoomDoc.set(chatRoomInfoMap);
    }
  }

  Future<void> addMessage(
    String chatRoomId,
    Map<String, dynamic> messageInfoMap,
  ) async {
    await _firestore
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(messageInfoMap);
  }

  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    return _firestore
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChatRooms(String userName) {
    return _firestore
        .collection("chatrooms")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
