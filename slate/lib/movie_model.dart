import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String genre;
  final double rating;
  final String imageURL;
  final bool isWatched;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageURL,
    required this.isWatched,
  });

  // Create a Movie from Firestore document
  factory Movie.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      imageURL: data['imageURL'] ?? '',
      isWatched: data['isWatched'] ?? false,
    );
  }

  // Convert Movie to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'genre': genre,
      'rating': rating,
      'imageURL': imageURL,
      'isWatched': isWatched,
    };
  }
}
