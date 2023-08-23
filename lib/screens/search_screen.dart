import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
import 'package:ocr_app/network/connect_user.dart';

import '../models/book.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required this.selectedAlbumId});

  final String selectedAlbumId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

Future<List<Book>> _jsonData(String query) async {
// Future<void> _jsonData() async {
  String clientId = "NbzjRfinNefY4ce0WL4P";
  String clientSecret = "1VLJaoivYz";

  ApiExamSearchBook apiSearch = ApiExamSearchBook(clientId, clientSecret);
  String? responseBodyString = await apiSearch.searchBook(query);
  // print('responseBody> $responseBody');

  Map<String, dynamic> responseBody = jsonDecode(responseBodyString);
  // print("bookItem Length? ${responseBody["items"].length}");

  // NaverResponseBody
  List<Book> books =
      responseBody["items"].map<Book>((item) => Book.fromJson(item)).toList();

  return books;
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey();
  final _searchKey = GlobalKey();
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  String searchButtonText = "도서추가";
  List<Book> newBooks = <Book>[];

  FocusNode focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  bool isInputDeleted = false;
  String query = "";

  @override
  build(BuildContext context) {
    Future<void> newBookAdd(Book selectedNewBook) async {
      //기본앨범

      String albumId = '';
      if (albumId != "j9Cgl99nqyw1d2U3aSkM") {
        albumId = widget.selectedAlbumId;
      } else {
        albumId = "j9Cgl99nqyw1d2U3aSkM";
      }
      String title = selectedNewBook.title;
      String image = selectedNewBook.image;
      String author = selectedNewBook.author;
      String publisher = selectedNewBook.publisher;
      String pubdate = selectedNewBook.pubdate.substring(0, 4);
      String isbn = selectedNewBook.isbn;
      String timestamp =
          DateFormat('yyyy-MM-dd E', 'ko_KR').format(DateTime.now());

      await booksCollection.add({
        "title": title,
        "image": image,
        "author": author,
        "publisher": publisher,
        "pubdate": pubdate,
        "isbn": isbn,
        "albumId": albumId,
        "timestamp": timestamp
      });
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Container(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          // color: Colors.blue,
                          size: 25,
                          color: Colors.black45,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextField(
                      key: _formKey,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "검색",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        focusColor: Colors.black,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () async {
                            searchController.text = '';
                            isInputDeleted = true;
                            setState(() {
                              newBooks = <Book>[];
                            });
                          },
                        ),
                      ),
                      onSubmitted: (input) async {
                        isInputDeleted = false;
                        query = input;
                        var searchedBooks = await _jsonData(query);
                        setState(() {
                          print(newBooks);
                          newBooks = [...newBooks, ...searchedBooks];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  key: _searchKey,
                  itemCount: newBooks.length,
                  itemBuilder: (BuildContext context, index) {
                    Book book = newBooks[index];
                    // print("bookIndex $index");
                    return Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            newBookAdd(book);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Selected Book is added. Exit?'),
                                duration: Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.greenAccent,
                                action: SnackBarAction(
                                  label: 'Yes',
                                  textColor: Colors.black54,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )));
                          });
                        },
                        leading: Image.network(book.image),
                        title: Text(
                          book.title,
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.author,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '${book.publisher}(${book.pubdate.substring(0, 4)})',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
