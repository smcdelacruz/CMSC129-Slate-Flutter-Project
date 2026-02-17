import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/models/series_model.dart';

class AddSeriesForm extends StatefulWidget {
  // final Function(dynamic) onAddSeries;
  final Function(Series) onSubmit;
  final Series? seriesToEdit;
  

  const AddSeriesForm({super.key, required this.onSubmit, this.seriesToEdit});

  @override
  State<AddSeriesForm> createState() => _AddSeriesFormState();
}

class _AddSeriesFormState extends State<AddSeriesForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();
  final _posterUrlController = TextEditingController();
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    if (widget.seriesToEdit != null) {
      _titleController.text = widget.seriesToEdit!.title;
      _genreController.text = widget.seriesToEdit!.genre;
      _ratingController.text = widget.seriesToEdit!.rating.toString();
      _posterUrlController.text = widget.seriesToEdit!.posterUrl;
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

        // Title
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       'Edit Series Details',
        //       style: GoogleFonts.roboto(
        //         fontSize: 27,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white,
        //       )
        //     ),
        //   ]
        // ),

        // actions: [
        //   PopupMenuButton<String>(
        //     color: const Color(0xFF0F0C0C),
        //     icon: const Icon(Icons.more_vert, color: Colors.white),

        //     onSelected: (String option) {
        //       if (option == 'edit') {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => const MainScreen(title: 'Edit Series')),
        //         );

        //       } else if (option == 'delete') {
        //         showDialog(context: context, 
        //         builder: (context) => AlertDialog(
        //           title: const Text('Delete Series'),
        //           content: const Text('Are you sure you want to delete this record?'),
        //           actions: [
        //             TextButton(
        //               onPressed: () => Navigator.pop(context), 
        //               child: const Text('Cancel')
        //             ),
        //             TextButton(
        //               onPressed: () {
        //                 // TODO: Implement delete series functionality
        //                 Navigator.pop(context);
        //               },
        //               child: const Text('Delete', style: TextStyle(color: Colors.red)),
        //             ),
        //           ],
        //         ), 
        //         );
        //       }
        //     }, 
            
        //     // build menu items
        //     itemBuilder: (BuildContext context) { 
        //       return [
        //         const PopupMenuItem<String>(
        //           value: 'edit',
        //           child: Row(
        //             children: [
        //               Icon(Icons.edit, 
        //                    color: Colors.white,
        //                    size: 20,
        //               ),
        //               SizedBox(width: 10),
        //               Text('Edit'),
        //             ],
        //           ),
        //         ),
        //         const PopupMenuItem<String>(
        //           value: 'delete',
        //           child: Row(
        //             children: [
        //               Icon(Icons.delete_outline_rounded, 
        //                    color: Colors.red,
        //                    size: 23,
        //               ),
        //               SizedBox(width: 10),
        //               Text('Delete', 
        //                     style: TextStyle(color: Colors.red)),
        //             ],
        //           ),
        //         ),
        //       ];
        //     },
        //   )
        // ],
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
                  value == null || value.isEmpty ? 'Please enter a poster URL' : null,
              ),

              const SizedBox(height: 20),

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

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newSeries = Series(
                      // id: DateTime.now().toString(),
                      id: widget.seriesToEdit?.id ?? DateTime.now().toString(),
                      title: _titleController.text,
                      genre: _genreController.text,
                      rating: double.parse(_ratingController.text),
                      posterUrl: _posterUrlController.text.isEmpty
                          ? 'https://via.placeholder.com/150'
                          : _posterUrlController.text,
                      isWatched: _isWatched,
                    );

                    widget.onSubmit(newSeries);
                    Navigator.pop(context);
                  }
                }, 
                child: Text(widget.seriesToEdit == null ? 'Add Series' : 'Update Series'),
              )

            ],
          )
        )
      ),
    );
    // Form(
    //   key: _formKey,
    //   child: const Column(
    //     children: <Widget>[
    //       // TextFormField for series title
    //       // TextFormField for genre
    //     ],
    //   )
    // );}
  
  }

}