import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:slate/models/series_model.dart';

final seriesCollection = FirebaseFirestore.instance.collection('series');

/* Adds series to Firestore */
Future<void> addSeriesToFirestore(Series series) async {
  return seriesCollection
      .add(series.createMap())
      .then((docRef) => debugPrint('Series added with ID: ${docRef.id}'))
      .catchError((error) => debugPrint('Failed to add series: $error'));
}

/* Reads series in Firestore */
Stream<List<Series>> getSeriesToFirestore() {
  return seriesCollection
      .orderBy('createdAt', descending: true) // newest first
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Series.fromFirestore(doc)).toList());
}

/* Updates series in Firestore */
Future<void> updateSeriesInFirestore(Series series) async {
  return seriesCollection
      .doc(series.id)
      .update(series.updateMap())
      .then((_) => debugPrint('Series updated with ID: ${series.id}'))
      .catchError((error) => debugPrint('Failed to update series: $error'));
}

/* Deletes series in Firestore */
Future<void> deleteSeriesFromFirestore(String id) async {
  return seriesCollection
      .doc(id)
      .delete()
      .then((_) => debugPrint('Series deleted with ID: $id'))
      .catchError((error) => debugPrint('Failed to delete series: $error'));
}