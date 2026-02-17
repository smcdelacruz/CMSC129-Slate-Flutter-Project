import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movie_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  
  );
  
  runApp(const Slate());
}

class Slate extends StatelessWidget {
  const Slate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Watchlist',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const WatchlistScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}
// The main screen of the app that displays the user's movie watchlist and allows them to add, edit, and delete movies.
class _WatchlistScreenState extends State<WatchlistScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filterStatus = 'all'; // all, watched, unwatched

  Stream<List<Movie>> _getMoviesStream() {
    Query query = _firestore.collection('movies').orderBy('title');
    
    if (_filterStatus == 'watched') {
      query = query.where('isWatched', isEqualTo: true);
    } else if (_filterStatus == 'unwatched') {
      query = query.where('isWatched', isEqualTo: false);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromFirestore(doc);
      }).toList();
    });
  }

  void _showAddEditDialog({Movie? movie}) { // If movie is null, it's an add operation. Otherwise, it's an edit.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditMovieDialog(movie: movie),
    );
  }

  void _toggleWatchedStatus(Movie movie) {
    _firestore.collection('movies').doc(movie.id).update({
      'isWatched': !movie.isWatched,
    });
  }

  void _deleteMovie(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie'),
        content: const Text('Are you sure you want to delete this movie?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('movies').doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'unwatched', child: Text('To Watch')),
              const PopupMenuItem(value: 'watched', child: Text('Watched')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Movie>>(
        stream: _getMoviesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No movies yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first movie',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onEdit: () => _showAddEditDialog(movie: movie),
                onDelete: () => _deleteMovie(movie.id),
                onToggleWatched: () => _toggleWatchedStatus(movie),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleWatched;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleWatched,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onToggleWatched,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.imageURL.isNotEmpty
                    ? Image.network(
                        movie.imageURL,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[800],
                            child: const Icon(Icons.movie, size: 40),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, size: 40),
                      ),
              ),
              const SizedBox(width: 12),
              // Movie Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            movie.isWatched ? Icons.check_circle : Icons.circle_outlined,
                            color: movie.isWatched ? Colors.green : Colors.grey,
                          ),
                          onPressed: onToggleWatched,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        movie.genre,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     TextButton.icon(
                    //       onPressed: onEdit,
                    //       icon: const Icon(Icons.edit, size: 16),
                    //       label: const Text('Edit'),
                    //       style: TextButton.styleFrom(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8),
                    //       ),
                    //     ),
                    //     TextButton.icon(
                    //       onPressed: onDelete,
                    //       icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    //       label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    //       style: TextButton.styleFrom(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        ),
                        TextButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                          label: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddEditMovieDialog extends StatefulWidget {
  final Movie? movie;

  const AddEditMovieDialog({super.key, this.movie});

  @override
  State<AddEditMovieDialog> createState() => _AddEditMovieDialogState();
}

class _AddEditMovieDialogState extends State<AddEditMovieDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imageURLController = TextEditingController();
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _genreController.text = widget.movie!.genre;
      _ratingController.text = widget.movie!.rating.toString();
      _imageURLController.text = widget.movie!.imageURL;
      _isWatched = widget.movie!.isWatched;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _ratingController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      final movieData = {
        'title': _titleController.text.trim(),
        'genre': _genreController.text.trim(),
        'rating': double.parse(_ratingController.text),
        'imageURL': _imageURLController.text.trim(),
        'isWatched': _isWatched,
      };

      if (widget.movie != null) {
        // Update existing movie
        await FirebaseFirestore.instance
            .collection('movies')
            .doc(widget.movie!.id)
            .update(movieData);
      } else {
        // Add new movie
        await FirebaseFirestore.instance.collection('movies').add(movieData);
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.movie != null ? 'Edit Movie' : 'Add Movie',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.movie),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a genre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: 'Rating (0-10)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 10) {
                    return 'Please enter a valid rating between 0 and 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageURLController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  helperText: 'Paste poster image URL from Chrome',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Watched'),
                value: _isWatched,
                onChanged: (value) {
                  setState(() {
                    _isWatched = value;
                  });
                },
                activeThumbColor: Colors.green,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMovie,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    widget.movie != null ? 'Update Movie' : 'Add Movie',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
