import 'package:flutter/material.dart';
import 'package:slate/services/firestore_service.dart';
import '../models/series_model.dart';
import '../widgets/series_card.dart';

/// Home page that displays the list of series records from Firestore.
/// Uses StreamBuilder to listen to real-time updates of series documents 
/// from Firestore and builds the list of series cards.
/// Automatically updates UI when series is added, updated, or deleted in the database.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Records',
            style: TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          // ===== StreamBuilder =====
          Expanded(
            child: StreamBuilder<List<Series>>(
              stream: getSeriesToFirestore(), // from your service file
              builder: (context, snapshot) {

                 // Error state
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Data state
                final seriesList = snapshot.data ?? [];

                if (seriesList.isEmpty) {
                  return const Center(child: Text("No series yet"));
                }

                // Displays list of series cards using SeriesCard widget
                return ListView.builder(
                  itemCount: seriesList.length,
                  itemBuilder: (context, index) {
                    return SeriesCard(
                      series: seriesList[index],
                      onUpdate: updateSeriesInFirestore,
                      onDelete: deleteSeriesFromFirestore,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}