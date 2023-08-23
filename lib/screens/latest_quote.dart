// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LatestQuotePage extends StatefulWidget {
  const LatestQuotePage({Key? key}) : super(key: key);

  @override
  State<LatestQuotePage> createState() => _LatestQuotePageState();
}

class _LatestQuotePageState extends State<LatestQuotePage> {
  CollectionReference books = FirebaseFirestore.instance.collection('books');
  CollectionReference quotes = FirebaseFirestore.instance.collection('quotes');
  FirebaseFirestore db = FirebaseFirestore.instance;
  String selectedBookId = "";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController timestampController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController pubtimestampController = TextEditingController();
  String timestamp =
      DateFormat('yyyy-MM-dd E', 'ko_KR').format(DateTime.now()).toString();

  //createQuote 변수
  final TextEditingController pageController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController likeController = TextEditingController();

  Future<void> _createQuote() async {
    timeController.text =
        DateFormat('yyyy-MM-dd HH:MM', 'ko_KR').format(DateTime.now());

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //페이지
                  TextField(
                    controller: pageController,
                    decoration: InputDecoration(
                        labelText: '페이지',
                        suffixIcon: IconButton(
                          onPressed: pageController.clear,
                          icon: Icon(Icons.clear),
                        )),
                  ),
                  SizedBox(height: 5),

                  TextField(
                    controller: authorController,
                    decoration: InputDecoration(
                        labelText: '저자',
                        suffixIcon: IconButton(
                          onPressed: authorController.clear,
                          icon: Icon(Icons.clear),
                        )),
                  ),
                  SizedBox(height: 5),

                  TextField(
                    controller: publisherController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: '출판사',
                        suffixIcon: IconButton(
                          onPressed: publisherController.clear,
                          icon: Icon(Icons.clear),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: pubtimestampController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: '출판연도',
                        suffixIcon: IconButton(
                          onPressed: pubtimestampController.clear,
                          icon: Icon(Icons.clear),
                        )),
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Flexible(
                      child: TextField(
                        controller: timestampController,
                        decoration: InputDecoration(
                            labelText: '생성일',
                            suffixIcon: IconButton(
                              onPressed: timestampController.clear,
                              icon: Icon(Icons.clear),
                            )),
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.calendar_month),
                        label: Text('달력'),
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            // initialEntryMode: DatePickerEntryMode.calendarOnly,
                            locale: const Locale('ko', 'KR'),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              timestamp = DateFormat('yyyy-MM-dd E', 'ko_KR')
                                  .format(selectedDate);
                              timestampController.text = timestamp;
                            });
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final String title = titleController.text;
                        final String author = authorController.text;
                        final String timestamp = timestampController.text;
                        final String publisher = publisherController.text;
                        final String pubdate = pubtimestampController.text;
                        await books.add({
                          'title': title,
                          'author': author,
                          'timestamp': timestamp,
                          'publisher': publisher,
                          'pubdate': pubdate,
                        });

                        titleController.text = "";
                        authorController.text = "";
                        timestampController.text = "";
                        publisherController.text = "";
                        pubtimestampController.text = "";
                        Navigator.of(context).pop(context);
                      },
                      child: Text('저장'),
                    ),
                  ]),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String bookId) async {
    await books.doc(bookId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 40.0, top: 10.0, bottom: 10.0),
            height: MediaQuery.of(context).size.height * 0.30,
            child: StreamBuilder(
              stream: books.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    // padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 0.5,
                      crossAxisSpacing: 0.5,
                    ),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      String bookId = documentSnapshot.id;
                      return GestureDetector(
                        onTap: () {
                          print(bookId);
                          setState(() {
                            selectedBookId = bookId;
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          color: Colors.transparent,
                          child: GridTile(
                            child: Image.network(documentSnapshot['image'],
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              // height: MediaQuery.of(context).size.height * 0.45,
              child: StreamBuilder(
                  stream: Stream<QuerySnapshot>.fromFuture(
                      quotes.where("bookId", isEqualTo: selectedBookId).get()),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (!streamSnapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot quoteDocumentSnapshot =
                              streamSnapshot.data!.docs[index];
                          // String currentBookId = books.snapshots().docs.id;
                          // print(currentBookId);

                          //된다!!! 여기에 Expanded를 해주니까 되는 구만
                          return Expanded(
                            child: Card(
                              margin: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 40, right: 40),

                              //최근 순으로 정렬 후 책 클릭 시 해당 글귀 최신 순 정렬
                              child: Container(
                                // height: MediaQuery.of(context).size.height*30,
                                color: Colors.yellow[50],
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10),
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "p.${quoteDocumentSnapshot["page"].toString()}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          quoteDocumentSnapshot["time"],
                                          style:
                                              TextStyle(color: Colors.black38),
                                        ),
                                        SizedBox(width: 15),
                                        Icon(Icons.edit,
                                            size: 15, color: Colors.black38)
                                      ],
                                    ),
                                    //bottom overflow 문제!! (긴 글이 짤리는 문제)
                                    Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          quoteDocumentSnapshot["content"],
                                          // overflow: TextOverflow.clip,
                                          // maxLines: 10,
                                        )),

                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 15, bottom: 10),
                                    //   child: RichText(
                                    //     text: TextSpan(
                                    //       text: quoteDocumentSnapshot["content"],
                                    //       style: TextStyle(
                                    //         color: Colors.black54,
                                    //         letterSpacing: 1.2,
                                    //       )
                                    //     )
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          // Text(asd);
                          // if (currentBookId == "CDFsIBIuNowpWhspHNot") {
                          // var bookQuotes = quotes.where("bookId", isEqualTo: currentBookId).get().then((querySnapshot) {
                          //   print("Successfully completed");
                          //   print("documentSnapshot: " + documentSnapshot.id);
                          //   // print("quote: ${querySnapshot.docs}");
                          //   for (var docSnapshot in querySnapshot.docs) {
                          //     print('${docSnapshot.id} => ${docSnapshot['content']}');
                          //   }
                          // });
                          // quotes.get().then((value) {
                          //   print("Successfully completed");
                          //   for (var docSnapshot in value.docs) {
                          //     print('${docSnapshot.id} => ${docSnapshot.data()}');
                          //   }
                          // });
                        });
                  }
                  // }
                  ),
            ),
          ),

          //comment 눌렀을때 펼쳐지도록 & 연동
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffB3DAFF),
        foregroundColor: Colors.white,
        tooltip: 'Increment',
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
