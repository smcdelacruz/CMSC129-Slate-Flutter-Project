import 'package:flutter/material.dart';
import '../models/series_model.dart';

class SeriesDetailsPage extends StatelessWidget {
  final Series series;

  const SeriesDetailsPage({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    Color watchedColor = 
      series.isWatched ? const Color.fromRGBO(241, 186, 10, 1) 
                       : const Color.fromRGBO(38, 100, 175, 1);

    Color statusTextColor = 
      series.isWatched ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(series.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(series.posterUrl, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(series.title, 
                 style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Genre: ${series.genre}', 
                 style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Rating: ${series.rating}', 
                 style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Status: ', 
                     style: const TextStyle(fontSize: 18)),
                Chip(
                      label: Text(
                        series.isWatched ? 'Watched' : 'Not Watched',
                        style: TextStyle(
                          color: statusTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: watchedColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )


              ],
            ),
          ],
        ),
      ),
    );
  }
}