// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

// Series model that holds the data
class Series {
  final String id;
  final String title;
  final String genre;
  final double rating;
  final String posterUrl;
  final bool isWatched;
  // final String comment;

  Series({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.posterUrl,
    required this.isWatched,
    // required this.comment,

  });

  // Convert Firestore to Series object
  factory Series.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Series(
      id: doc.id,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      posterUrl: data['posterUrl'] ?? '',
      isWatched: data['isWatched'] ?? false,
      // comment: data['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'genre': genre,
      'rating': rating,
      'posterUrl': posterUrl,
      'isWatched': isWatched,
      // 'comment': comment,
    };
  }

}
