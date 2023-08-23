import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuoteScreen extends StatefulWidget {
  QuoteScreen({
    Key? key,
    required this.selectedAlbumId,
    required this.selectedBookId,
    required this.selectedBookCover,
    required this.selectedBookTitle,
    required this.selectedBookAuthor,
  }) : super(key: key);

  String selectedAlbumId;
  String selectedBookId;
  String selectedBookCover;
  String selectedBookTitle;
  String selectedBookAuthor;

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection('quotes');

  CollectionReference albumsCollection =
      FirebaseFirestore.instance.collection('albums');

  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  // TextEditingController quoteSearchController = TextEditingController();
  // GlobalKey _quoteSearchFormKey = GlobalKey();

  bool isInputDeleted = false;
  String searchInput = "";
  String selectedAlbumTitle = '';
  String selectedBookTitle = '';
  String selectedBookCover = '';
  String selectedBookAuthor = '';
  String selectedBookPublisher = '';

  @override
  Widget build(BuildContext context) {
    final albumRef = albumsCollection.doc(widget.selectedAlbumId);
    albumRef.get().then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        selectedAlbumTitle = data['title'];
        print(selectedAlbumTitle);
      },
      onError: (e) => print('Error getting document: $e'),
    );

    final bookRef = booksCollection.doc(widget.selectedBookId);
    bookRef.get().then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        selectedBookTitle = data['title'];
        selectedBookCover = data['image'];
        selectedBookAuthor = data['author'];
        selectedBookPublisher = data['publisher'];

        print(selectedBookTitle);
      },
      onError: (e) => print('Error getting document: $e'),
    );

    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 35),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15.0,
                      ),
                      Container(
                        // height: ,
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 10.0),
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  // color: Colors.blue,
                                  size: 25,
                                  color: Colors.black45,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 11.0, vertical: 1.5),
                                alignment: Alignment.center,
                                //리스트 간격, 사이즈 높이
                                margin: EdgeInsets.only(
                                    bottom: 10.0, left: 15.0, right: 5.0),
                                decoration: BoxDecoration(
                                    //리스트 색깔
                                    color: Color(0xFF5A81AD),
                                    // Color(0xFFECECE9),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFF324053),
                                          spreadRadius: -0.8,
                                          blurRadius: 1,
                                          offset: Offset(0, 4))
                                    ]),
                                child: Text(
                                  selectedAlbumTitle,
                                  style: TextStyle(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFDEE6FB)
                                      // Color(0xFF49463A),
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      Divider(
                        height: 2,
                        color: Color(0xFF49463A).withOpacity(0.6),
                      ),
                      // 책 프로필 섹션
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          top: 5.0,
                          left: 15.0,
                          right: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Image.network(
                                    selectedBookCover,
                                    fit: BoxFit.cover,
                                    height: 60,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedBookTitle,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // SizedBox(
                                    //   height: 0.5,
                                    // ),
                                    Text(
                                      selectedBookAuthor,
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text(
                                      selectedBookPublisher,
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Image.network(
                            //       'https://firebasestorage.googleapis.com/'
                            //       'v0/b/fir-test-cadb2.appspot.com/o/'
                            //       'Icon_quote_4.png?alt=media&token=6979b0c4-43b5-4bb4-bec1-0b7bfb0031d2',
                            //       height: 20,
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.only(left: 15.0),
                            //       child: Text(
                            //         '17',
                            //         style:
                            //             TextStyle(fontWeight: FontWeight.bold),
                            //       ),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ]),
                Divider(
                  height: 1,
                  color: Color(0xFF49463A).withOpacity(0.6),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
                  height: MediaQuery.of(context).size.height * 0.68,
                  width: MediaQuery.of(context).size.width * 0.98,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        // image: NetworkImage(widget.selectedBookCover),
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/'
                            'fir-test-cadb2.appspot.com/o/empty_openbook_slice.png?alt=media&token=b7430789-8d0d-4309-a4fb-867cab9c3be5'),
                        fit: BoxFit.cover),
                    // borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: quotesCollection.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (!streamSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Swiper(
                          itemCount: streamSnapshot.data!.docs.length,
                          loop: true,
                          index: 0,
                          duration: 1000,
                          viewportFraction: 1.0,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            // String quoteId = documentSnapshot.id;
                            print(
                                '=================> ${documentSnapshot['content']}');
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 50.0,
                                  right: 50.0,
                                  top: 35.0,
                                  bottom: 30.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'P. ${documentSnapshot['page'].toString()}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            documentSnapshot['time'].toString(),
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 35.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Image.network(
                                        'https://firebasestorage.googleapis.com/'
                                        'v0/b/fir-test-cadb2.appspot.com/o/'
                                        'Icon_quote_4.png?alt=media&token=6979b0c4-43b5-4bb4-bec1-0b7bfb0031d2',
                                        height: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        documentSnapshot['content'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          letterSpacing: 1.0,
                                          wordSpacing: 2.0,
                                          height: 1.5,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ])

          // Container(
          //   padding: EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       GestureDetector(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.keyboard_arrow_left,
          //             // color: Colors.blue,
          //             size: 25,
          //             color: Colors.black45,
          //           ),
          //         ),
          //         onTap: () {
          //           Navigator.of(context).pop();
          //           setState(() {});
          //         },
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 20.0),
          //         height: MediaQuery.of(context).size.height * 0.08,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Image.network(
          //               widget.selectedBookCover,
          //               fit: BoxFit.cover,
          //               height: 55,
          //             ),
          //             SizedBox(
          //               width: 20.0,
          //             ),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   widget.selectedBookTitle,
          //                   style: TextStyle(
          //                       fontSize: 20.0, fontWeight: FontWeight.bold),
          //                 ),
          //                 // SizedBox(
          //                 //   height: 0.5,
          //                 // ),
          //                 Text(
          //                   widget.selectedBookAuthor,
          //                   style: TextStyle(fontSize: 13.0),
          //                 ),
          //               ],
          //             )
          //           ],
          //         ),
          //       ),

          ),
    );
  }
}
