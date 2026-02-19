import 'package:cloud_firestore/cloud_firestore.dart';

// Series model that holds the data
class Series {
  final String id;
  final String title;
  final String genre;
  final double rating;
  final String posterUrl;
  final bool isWatched;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Constructor for Series model
  /// the blueprint for the data structure of a series document in Firestore
  Series({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.posterUrl,
    required this.isWatched,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Firestore data to Series object
  factory Series.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Series(
      id: doc.id,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      posterUrl: data['posterUrl'] ?? '',
      isWatched: data['isWatched'] ?? false,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

    /// Convert Series object to Map to store in Firestore database
   /// Used to add a series document in Firestore
    Map<String, dynamic> createMap() {
    return {
      'title': title,
      'genre': genre,
      'rating': rating,
      'posterUrl': posterUrl,
      'isWatched': isWatched,
      'comment': comment ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert Series object to Map for Firestore update (without createdAt.
  /// Used to update a series document in Firestore to avoid overwriting createdAt.
  Map<String, dynamic> updateMap() {
    return {
      'title': title,
      'genre': genre,
      'rating': rating,
      'posterUrl': posterUrl,
      'isWatched': isWatched,
      'comment': comment ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}