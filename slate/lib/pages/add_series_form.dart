import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/models/series_model.dart';
import 'package:slate/services/firestore_service.dart';

class AddSeriesForm extends StatefulWidget {

  // Optional callback functions to be called after adding or updating a series, passed from the Home page
  final Function(Series)? onSubmit;
  final Series? seriesToEdit;

  const AddSeriesForm({super.key, this.onSubmit, this.seriesToEdit});

  @override
  State<AddSeriesForm> createState() => _AddSeriesFormState();
}

class _AddSeriesFormState extends State<AddSeriesForm> {
  final _formKey = GlobalKey<FormState>();    // Global key to identify the form and validate it

  // Text editing controllers to store user inputs from text fields
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    if (widget.seriesToEdit != null) {
      _titleController.text = widget.seriesToEdit!.title;
      _genreController.text = widget.seriesToEdit!.genre;
      _ratingController.text = widget.seriesToEdit!.rating.toString();
      _posterUrlController.text = widget.seriesToEdit!.posterUrl;
      _commentController.text = widget.seriesToEdit!.comment ?? '';
      _isWatched = widget.seriesToEdit!.isWatched;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.seriesToEdit != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        
        // Leading Icon
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.chevron_left_rounded),
          iconSize: 35.0,
          color: Colors.white,
        ),

        title: Text(
          isEditing ? 'Edit Series Details' : 'Add New Series',
          style: GoogleFonts.roboto(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                color: Colors.white,
          )
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Series Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a genre' : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: 'Rating (0 to 5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _posterUrlController,
                decoration: const InputDecoration(
                  labelText: 'Poster Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                  value == null || value.isEmpty ? null : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comments (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),

              Row(
                children: [
                  const Text('Watched?'),
                  Switch(
                    value: _isWatched, 
                    onChanged: (value) {
                      setState(() {
                        _isWatched = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                   const SizedBox(width: 12),

                  Expanded(
                    child:
                      ElevatedButton(
                        onPressed: () async {
                          // Runs the validator functions of all form fields, 
                          // returns true if all are valid and adds the series to the database
                          if (!_formKey.currentState!.validate()) return;  

                        final newSeries = Series(
                          id: widget.seriesToEdit?.id ?? DateTime.now().toString(),
                          title: _titleController.text,
                          genre: _genreController.text,
                          rating: double.parse(_ratingController.text),
                          posterUrl: _posterUrlController.text.isEmpty
                              ? "assets/images/default.png"
                              : _posterUrlController.text,
                          isWatched: _isWatched,
                          comment: _commentController.text.isEmpty ? null: _commentController.text,
                        );

                        final navigator = Navigator.of(context);

                        if (isEditing) {
                          await updateSeriesInFirestore(newSeries);
                        } else {
                          await addSeriesToFirestore(newSeries);
                        }

                        if (!mounted) return;

                        widget.onSubmit?.call(newSeries);
                        navigator.pop();
                      },

                      child: Text(widget.seriesToEdit == null ? 'Add Series' : 'Update'),
                    ),
                  )
                ],
              )
            ]
          )
        ),
      )
    ); 
  }
}