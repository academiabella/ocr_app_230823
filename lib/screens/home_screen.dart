import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocr_app/screens/quote_screen.dart';
import 'package:ocr_app/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CollectionReference albumCollection =
      FirebaseFirestore.instance.collection('albums');
  CollectionReference bookCollection =
      FirebaseFirestore.instance.collection('books');
  String selectedAlbumId = "";
  String selectedBookId = "";
  String selectedBookImage = "";

  bool isaddButtonPushed = false;
  bool isLongPushed = false;
  bool isOnTapPushed = false;
  bool isAlbumSelected = false;
  String previousSelectedAlbumId = '';

  Future<void> _addNewAlbum() async {
    TextEditingController albumController = TextEditingController();

    String title = "";
    int count_books = 0;
    int count_quotes = 0;
    String timestamp =
        DateFormat('yyyy-MM-dd E', 'ko_KR').format(DateTime.now());

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('새 앨범 추가'),
            content: TextField(
              keyboardType: TextInputType.text,
              controller: albumController,
              decoration: InputDecoration(hintText: "앨범명을 입력하세요"),
              onSubmitted: (e) {
                albumController.text = e;
              },
            ),
            actions: [
              TextButton(
                child: Text('생성'),
                onPressed: () async {
                  title = albumController.text;
                  albumController.clear();
                  await albumCollection.add({
                    "title": title,
                    "count_quotes": count_quotes,
                    "count_books": count_books,
                    "createdAt": timestamp
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _deleteAlbum(String albumId) async {
    await albumCollection.doc(albumId).delete();
  }

  Future<void> _deleteBook(String bookId) async {
    await bookCollection.doc(bookId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: albumCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60.0,
                        ),
                        // 프로필 섹션
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(
                              top: 10.0, left: 8.0, right: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: CircleAvatar(
                                      foregroundImage: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/fir-test-cadb2.appspot.com/o/sushi.png?alt=media&token=60475d1c-fb79-4147-b650-c7fbb04dba93'),
                                      radius: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, right: 10.0),
                                    child: Text(
                                      //나중에 총 book개수, quote의 갯수, comment 갯수 띄우기
                                      'Hello, Bella!',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 2,
                                color: Color(0xFF49463A).withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),

                        //앨범 리스트 & 앨범 추가
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.12,
                          padding: EdgeInsets.only(
                              left: 5.0, top: 30.0, right: 0.0, bottom: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.only(left: 20.0, bottom: 17.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '앨범 목록',
                                      style: TextStyle(
                                          fontSize: 15, color: Color(0xFF2B2B2B)
                                          // fontWeight: FontWeight.bold
                                          ),
                                    ),
                                    GestureDetector(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 4.0),
                                          child: Icon(
                                            Icons.add_to_photos,
                                            size: 22,
                                            color: Color(0xFF98AEA9),
                                          )),
                                      onTap: () {
                                        _addNewAlbum();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: EdgeInsets.only(left: 10.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[index];
                                      return GestureDetector(
                                        child: Container(
                                          //리스트 사이즈 너비
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2.0),
                                          alignment: Alignment.center,
                                          //리스트 간격, 사이즈 높이
                                          margin: EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 10.0,
                                              left: 10.0,
                                              right: 5.0),
                                          decoration: BoxDecoration(
                                              //리스트 색깔
                                              color: isAlbumSelected
                                                  ? documentSnapshot.id ==
                                                          selectedAlbumId
                                                      ? Color(0xFF5A81AD)
                                                      : Color(0xFFECECE9)
                                                  : isAlbumSelected
                                                      ? Color(0xFF5A81AD)
                                                      : Color(0xFFECECE9),
                                              // boxShadow: <BoxShadow>[
                                              //   BoxShadow(
                                              //       color: Color(0xFFD0E6E8),
                                              //       spreadRadius: -5,
                                              //       blurRadius: 20,
                                              //       offset: Offset(1, 3)),
                                              // ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xFF324053),
                                                    spreadRadius:
                                                        isAlbumSelected
                                                            ? documentSnapshot
                                                                        .id !=
                                                                    selectedAlbumId
                                                                ? -15.0
                                                                : -0.2
                                                            : -0.2,
                                                    blurRadius: isAlbumSelected
                                                        ? documentSnapshot.id !=
                                                                selectedAlbumId
                                                            ? 0.0
                                                            : 2.0
                                                        : 2.0,
                                                    offset: Offset(0, 3))
                                              ]),
                                          child: Text(
                                            documentSnapshot['title'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              // fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w500,
                                              color: isAlbumSelected
                                                  ? documentSnapshot.id ==
                                                          selectedAlbumId
                                                      ? Color(0xFFDEE6FB)
                                                      : Color(0xFF49463A)
                                                  : isAlbumSelected
                                                      ? Color(0xFFDEE6FB)
                                                      : Color(0xFF49463A),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            // 앨범리스트 선택 시 hovercolor 와 id 변경 설정
                                            if (selectedAlbumId ==
                                                documentSnapshot.id) {
                                              if (isAlbumSelected) {
                                                isAlbumSelected = false;
                                                selectedAlbumId = "";
                                                print("No Album is selected!");
                                              } else {
                                                isAlbumSelected = true;
                                                selectedAlbumId =
                                                    documentSnapshot.id;
                                                print(
                                                    "Selected albumID ==> $selectedAlbumId");
                                              }
                                            } else {
                                              if (isAlbumSelected) {
                                                isAlbumSelected = false;
                                                selectedAlbumId =
                                                    documentSnapshot.id;
                                                isAlbumSelected = true;
                                                print(
                                                    "Selected albumID ==> $selectedAlbumId");
                                              } else {
                                                selectedAlbumId =
                                                    documentSnapshot.id;
                                                isAlbumSelected = true;
                                                print(
                                                    "Selected albumID ==> $selectedAlbumId");
                                              }
                                            }
                                          });
                                        },
                                        onLongPress: () {
                                          if (documentSnapshot['title'] !=
                                              "Default") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Are you sure to delete the album?"),
                                                    duration:
                                                        Duration(seconds: 4),
                                                    elevation: 2.0,
                                                    backgroundColor:
                                                        Colors.black45,
                                                    action: SnackBarAction(
                                                      label: 'delete',
                                                      onPressed: () {
                                                        _deleteAlbum(
                                                            documentSnapshot
                                                                .id);
                                                      },
                                                    )));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Default album cannot be deleted!"),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.black45,
                                              elevation: 2.0,
                                            ));
                                          }
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),

                        //책 리스트
                        Container(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 0.0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: StreamBuilder(
                            stream: Stream<QuerySnapshot>.fromFuture(
                                bookCollection
                                    .where("albumId",
                                        isEqualTo: selectedAlbumId)
                                    .get()),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (!streamSnapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  //책 커버이미지 사이즈 비율 조정
                                  childAspectRatio: 100 / 65,
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 20,
                                  // crossAxisSpacing: 2,
                                ),
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  String bookId = documentSnapshot.id;

                                  // book 클릭했을 때 quote 페이지로 넘어가기
                                  return GestureDetector(
                                    onTap: () {
                                      isLongPushed = false;
                                      isOnTapPushed = true;
                                      if (selectedAlbumId != "") {
                                        print(
                                            "Selected albumID =====> $selectedAlbumId");
                                      } else {
                                        selectedAlbumId =
                                            "j9Cgl99nqyw1d2U3aSkM";
                                        print(
                                            'No album is selected! Default : $selectedAlbumId');
                                      }
                                      setState(() {
                                        selectedBookId = bookId;
                                        print(
                                            "Selected bookId =====> $selectedBookId");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QuoteScreen(
                                                      selectedAlbumId:
                                                          selectedAlbumId,
                                                      selectedBookId:
                                                          selectedBookId,
                                                      selectedBookCover:
                                                          documentSnapshot[
                                                              'image'],
                                                      selectedBookAuthor:
                                                          documentSnapshot[
                                                              'author'],
                                                      selectedBookTitle:
                                                          documentSnapshot[
                                                              'title'],
                                                    )));
                                      });
                                    },
                                    onLongPress: () {
                                      selectedBookId = documentSnapshot.id;
                                      setState(() {
                                        isOnTapPushed = false;
                                        isLongPushed = true;
                                        // selectedBookId = documentSnapshot.id;
                                        print(
                                            "Long pressed selected bookId =====> $selectedBookId");
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 10.0,
                                          bottom: 25.0),
                                      //책 커버 이미지 모서리 둥글게
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 8.0,
                                              spreadRadius: -1.0,
                                              offset: Offset(0, 4))
                                        ],
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(
                                                    // 선택한 bookcover만 블러처리
                                                    isLongPushed
                                                        ? documentSnapshot.id ==
                                                                selectedBookId
                                                            ? 0.6
                                                            : 0.0
                                                        : 0.0),
                                                BlendMode.darken),
                                            image: NetworkImage(
                                                documentSnapshot['image']),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Visibility(
                                        visible: isLongPushed
                                            ? documentSnapshot.id ==
                                                    selectedBookId
                                                ? true
                                                : false
                                            : false,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.filter_tilt_shift_rounded,
                                                color: Color(0xFFB1BED7),
                                                size: 32,
                                              ),
                                              SizedBox(width: 10),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Color(0xFFF65151),
                                                onPressed: () {
                                                  setState(() {
                                                    _deleteBook(selectedBookId);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // child: Card(
                                    //   color: Colors.transparent,
                                    //   child: GridTile(
                                    //     child: Image.network(
                                    //         documentSnapshot['image'],
                                    //         fit: BoxFit.cover),
                                    //   ),
                                    // ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Text("Failed to get Album list.");
                }),
          ],
        ),
      ),

      // 새 book 검색, 새 comment추가
      floatingActionButton: Stack(children: <Widget>[
        // 전체 책 목록
        AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            bottom: 20,
            left: isaddButtonPushed
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width * 0.5,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFE5D7CE),
              child: IconButton(
                highlightColor: Colors.white.withOpacity(0.2),
                icon: Icon(
                  size: 22,
                  Icons.format_list_bulleted,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => QuoteScreen()),
                  // );
                },
              ),
            )),

        //카메라 ocr
        AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            bottom: 20,
            left: isaddButtonPushed
                ? MediaQuery.of(context).size.width * 0.75
                : MediaQuery.of(context).size.width * 0.5,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFE5D7CE),
              child: IconButton(
                highlightColor: Colors.white.withOpacity(0.2),
                icon: Icon(
                  Icons.fullscreen,
                  size: 25,
                  color: Color(0xFFFAFAFA),
                ),
                onPressed: () {
                  setState(() {});
                },
              ),
            )),

        // 새 책 검색 페이지
        Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5,
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  isaddButtonPushed = !isaddButtonPushed;
                });
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFE5D7CE),
                child: IconButton(
                  highlightColor: Colors.white.withOpacity(0.2),
                  icon: Icon(
                    Icons.search,
                    size: 22,
                    color: Color(0xFFFAFAFA),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen(selectedAlbumId: selectedAlbumId)),
                    );
                  },
                ),
              ),
            )),
      ]),
    );
  }
}
