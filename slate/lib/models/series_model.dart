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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final String comment;

  Series({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.posterUrl,
    required this.isWatched,
    this.createdAt,
    this.updatedAt,
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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      // comment: data['comment'] ?? '',
    );
  }

  Map<String, dynamic> createMap() {
  return {
    'title': title,
    'genre': genre,
    'rating': rating,
    'posterUrl': posterUrl,
    'isWatched': isWatched,
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

Map<String, dynamic> updateMap() {
  return {
    'title': title,
    'genre': genre,
    'rating': rating,
    'posterUrl': posterUrl,
    'isWatched': isWatched,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}


  

}
