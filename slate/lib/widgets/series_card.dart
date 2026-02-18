import 'package:flutter/material.dart';
import '../models/series_model.dart';
import '../pages/series_details.dart';

class SeriesCard extends StatelessWidget {
  final Series series;
  final void Function(Series) onUpdate;
  final void Function(String) onDelete;

  const SeriesCard({
    super.key,
    required this.series,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color watchedColor = 
      series.isWatched ? const Color.fromRGBO(241, 186, 10, 1) 
                       : const Color.fromRGBO(38, 100, 175, 1);

    Text ratingText = 
      series.isWatched ? Text('Rating: ${series.rating}') : Text('Rating: N/A');                       

    Color statusTextColor = 
      series.isWatched ? Colors.black : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesDetailsPage(series: series, onUpdate: onUpdate, onDelete: onDelete),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.network(
                series.posterUrl, 
                height: 200.0,
                width: 197.0, 
                fit: BoxFit.cover
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
  
                  children: [
                    Text(
                      series.title,
                      style: const TextStyle(
                        fontSize: 20.0, 
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      ),
                    ),

                    const SizedBox(height: 3.0),

                    Text(
                      series.genre,
                      style: const TextStyle(
                        fontSize: 15.0, 
                        fontWeight: FontWeight.w400,
                        color: Colors.white
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    Text(
                      ratingText.data ?? 'Rating: N/A',
                      style: const TextStyle(
                        fontSize: 15.0, 
                        fontWeight: FontWeight.w400,
                        color: Colors.white
                      ),
                    ),

                    SizedBox(height: 8.0),

                    Chip(
                      label: Text(
                        series.isWatched ? 'Watched' : 'Not Watched',
                        style: TextStyle(
                          color: statusTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: watchedColor,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              )
            ) 
          ],
          )
      )
    );
  }
}