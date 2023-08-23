import 'package:intl/intl.dart';

class Book {
  Book(
      {required this.title,
      required this.link,
      required this.image,
      required this.author,
      required this.discount,
      required this.publisher,
      required this.pubdate,
      required this.isbn,
      required this.description});

  String title;
  String link;
  String image;
  String author;
  String discount;
  String publisher;
  String isbn;
  String pubdate;
  String description;

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        link = json['link'],
        image = json['image'],
        author = json['author'],
        discount = json['discount'],
        publisher = json['publisher'],
        isbn = json['isbn'],
        pubdate = json['pubdate'],
        description = json['description'];

  Map<String, dynamic> bookToJson() => {
        "bookTimeStamp":
            DateFormat('yy-MM-dd E', 'ko_KR').format(DateTime.now()),
        "albumId": "j9Cgl99nqyw1d2U3aSkM",
        "title": title,
        "image": image,
        "author": author,
        "publisher": publisher,
        "isbn": isbn,
        "pubdate": pubdate,
      };
}

//인증키 ttbsehi19921115001
