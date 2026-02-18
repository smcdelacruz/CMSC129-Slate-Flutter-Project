import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slate/pages/add_series_form.dart';
import '../models/series_model.dart';

class SeriesDetailsPage extends StatefulWidget {
  final Series series;
 
  final void Function(Series) onUpdate;
  final void Function(String) onDelete;

  const SeriesDetailsPage({
    super.key,
    required this.series,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

  class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
    Stream<Series> getSeriesStream(String id) {
      return FirebaseFirestore.instance
          .collection('series')
          .doc(id)
          .snapshots()
          .map((snapshot) => Series.fromFirestore(snapshot));
    }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Series>(
      stream: getSeriesStream(widget.series.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Failed to load series details.')),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final series = snapshot.data!;

      Color watchedColor = 
        series.isWatched ? const Color.fromRGBO(241, 186, 10, 1) 
                        : const Color.fromRGBO(38, 100, 175, 1);

      Color statusTextColor = 
        series.isWatched ? Colors.black : Colors.white;

      return Scaffold(
        appBar: AppBar(
          title: Text(series.title),

          actions: [
            PopupMenuButton<String>(
              color: const Color(0xFF0F0C0C),
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (option) {
                if (option == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSeriesForm(
                        seriesToEdit: series,
                        onSubmit: (updatedSeries) {
                          widget.onUpdate(updatedSeries);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                } else if (option == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Series'),
                      content: const Text('Are you sure you want to delete this record?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            widget.onDelete(series.id);
                            Navigator.pop(context); // close the dialog
                            Navigator.pop(context);
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit', 
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit, 
                        color: Colors.white, 
                        size: 20), 
                      
                      SizedBox(width: 10), 
                      
                      Text('Edit')])),

                const PopupMenuItem(
                  value: 'delete', 
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded, 
                        color: Colors.red, size: 23), 
                      SizedBox(width: 10), 
                      Text('Delete', 
                        style: TextStyle(
                          color: Colors.red))])),
              ],
            ),
          ],
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisSize: MainAxisSize.min,
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

                const SizedBox(height: 20),

                Text(
                  'Comments: \n',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  
                ),

                Text(
                  series.comment ?? 'No comments added.',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        )
      );
    });
  }
}