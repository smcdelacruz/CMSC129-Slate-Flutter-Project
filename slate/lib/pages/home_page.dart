import 'package:flutter/material.dart';
import '../models/series_model.dart';
import '../widgets/series_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
            child: ListView.builder(
              itemCount: seriesList.length,
              itemBuilder: (context, index) {
                return SeriesCard(series: seriesList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }


  final List<Series> seriesList = [
    Series(
      id: '1',
      title: 'Stranger Things',
      genre: 'Sci-Fi',
      rating: 4.5,
      posterUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d4/Stranger_Things_season_3.png/250px-Stranger_Things_season_3.png',
      isWatched: true,
    ),
    Series(
      id: '2',
      title: 'The Crown',
      genre: 'Drama',
      rating: 4.7,
      posterUrl: 'https://upload.wikimedia.org/wikipedia/en/b/ba/The_Crown_season_2.jpeg',
      isWatched: false,
    ),
  ];
}