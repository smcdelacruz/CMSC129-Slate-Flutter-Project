import 'package:flutter/material.dart';
import 'package:slate/services/firestore_service.dart';
import '../models/series_model.dart';
import '../widgets/series_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // final Function(Series) onAddSeries;   // callback to add series to the list

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  // void addSeries(Series series) {
  //   setState(() {
  //     seriesList.add(series);
  //   });
  // }

  // void updateSeries(Series updatedSeries) {
  //   setState(() {
  //     final index = seriesList.indexWhere((s) => s.id == updatedSeries.id);
  //     if (index != -1) {
  //       seriesList[index] = updatedSeries;
  //     }
  //   });
  // }

  // void removeSeries(String id) {
  //   setState(() {
  //     seriesList.removeWhere((s) => s.id == id);
  //   });
  // }
  
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

          Expanded(
            child: StreamBuilder<List<Series>>(
              stream: getSeriesToFirestore(), // from your service file
              builder: (context, snapshot) {

                // if (!snapshot.hasData) {
                //   return const Center(child: CircularProgressIndicator());
                // }

                // final seriesList = snapshot.data!;

                 // ERROR STATE
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                // LOADING STATE
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // DATA STATE
                final seriesList = snapshot.data ?? [];

                if (seriesList.isEmpty) {
                  return const Center(child: Text("No series yet"));
                }

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
                      
            // child: ListView.builder(
            //   itemCount: seriesList.length,
            //   itemBuilder: (context, index) {
            //     final series = seriesList[index];
            //     return SeriesCard(series: series, 
            //     onUpdate: updateSeries,
            //     onDelete: removeSeries,);
            //   },
            // ),
          ),
        ],
      ),
    );
  }

  // final List<Series> seriesList = [
  //   Series(
  //     id: '1',
  //     title: 'Stranger Things',
  //     genre: 'Sci-Fi',
  //     rating: 4.5,
  //     posterUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d4/Stranger_Things_season_3.png/250px-Stranger_Things_season_3.png',
  //     isWatched: true,
  //   ),
  //   Series(
  //     id: '2',
  //     title: 'The Crown',
  //     genre: 'Drama',
  //     rating: 4.7,
  //     posterUrl: 'https://upload.wikimedia.org/wikipedia/en/b/ba/The_Crown_season_2.jpeg',
  //     isWatched: false,
  //   ),
  // ];
}