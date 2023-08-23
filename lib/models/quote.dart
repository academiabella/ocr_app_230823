

class Quote {
  Quote({
    required this.bookId,
    required this.pageNo,
    required this.content,
    required this.time,
    required this.discount,
  });

  String bookId;
  String pageNo;
  String content;
  String time;
  String discount;
}

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // 위에서 작성한 getDocument 함수를 여기에 포함시켜주세요.
//   Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
//       String collectionName, String documentId) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//           await _firestore.collection(collectionName).doc(documentId).get();
//       return documentSnapshot;
//     } catch (e) {
//       print("Error getting document: $e");
//       throw Exception("Error getting document: $e");
//     }
//   }
//
//   // 검색어에 따라 documents를 Stream으로 가져오는 함수
//   Stream<QuerySnapshot<Map<String, dynamic>>> searchDocuments(
//       String collectionName, String keyword) {
//     return _firestore
//         .collection(collectionName)
//         .where('content', arrayContains: keyword)
//         .orderBy('time', descending: true)
//         .snapshots();
//   }
// }
