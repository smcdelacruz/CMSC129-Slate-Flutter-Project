import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:slate/models/series_model.dart';

/// Firestore database for CRUD operations on series documents

/// Reference to the 'series' collection in Firestore
final seriesCollection = FirebaseFirestore.instance.collection('series');

/// Adds a new series document to Firestore using add()
Future<void> addSeriesToFirestore(Series series) async {
  return seriesCollection
      .add(series.createMap())
      .then((docRef) => debugPrint('Series added with ID: ${docRef.id}'))
      .catchError((error) => debugPrint('Failed to add series: $error'));
}

/// Retrieves a real time stream of new changes of series documents from Firestore.
/// Ordered by creation date (newest first)
Stream<List<Series>> getSeriesToFirestore() {
  return seriesCollection
      .orderBy('createdAt', descending: true) // newest first
      .snapshots()  // listens for real-time updates from Firestore
      .map((snapshot) =>
          snapshot.docs.map((doc) => Series.fromFirestore(doc)).toList());  // Converts Firestore docs to Series objects
}

/// Updates an existing series document in Firestore
Future<void> updateSeriesInFirestore(Series series) async {
  return seriesCollection
      .doc(series.id)
      .update(series.updateMap())
      .then((_) => debugPrint('Series updated with ID: ${series.id}'))
      .catchError((error) => debugPrint('Failed to update series: $error'));
}

/// Deletes a series document permanently from Firestore using its ID
Future<void> deleteSeriesFromFirestore(String id) async {
  return seriesCollection
      .doc(id)
      .delete()
      .then((_) => debugPrint('Series deleted with ID: $id'))
      .catchError((error) => debugPrint('Failed to delete series: $error'));
}