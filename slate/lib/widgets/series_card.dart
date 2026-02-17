import 'package:flutter/material.dart';
import '../models/series_model.dart';

class SeriesCard extends StatelessWidget {
  final Series series;

  const SeriesCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(series.posterUrl, height: 150, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(series.title, 
                     style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold)),
                Text(
                  series.genre, 
                  style: const TextStyle(color: Colors.grey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rating: ${series.rating}'),
                    Icon(series.isWatched ? Icons.check_circle : Icons.radio_button_unchecked, 
                         color: series.isWatched ? Colors.green : Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}