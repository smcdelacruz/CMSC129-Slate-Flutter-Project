import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/add_series_form.dart';

/// Entry point of the application.
void main() async {

  // To make sure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Intializes Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SlateApp());   // Runs the Flutter app
}

/// SlateApp is the root app widget.
class SlateApp extends StatelessWidget {
  const SlateApp({super.key});    // Constructor with optional key parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slate',

      // defines the global theme for the app
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromRGBO(15, 12, 12, 1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MainScreen(title: 'Slate Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// MainScreen is the main page of the Slate app.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;   

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// MainScreenState manages the state of MainScreen, including navigation and page management.
class _MainScreenState extends State<MainScreen> {
  // int _selectedIndex = 0;   // Tracks the currently selected page index

  late final List<Widget> _pages;   

  // HomePage key to access its state - home_page.dart
  // purpose: to call state methods like addSeries() from AddSeriesForm after adding a new series
  final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      HomePage(key: homePageKey), // pass the key to HomePage
    ];
  }

  /// Opens the AddSeriesForm page when the floating action button is pressed.
  void _openAddSeriesForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSeriesForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// ========== AppBar ==========
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.clapperboard, size: 26, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              'Slate'.toUpperCase(),
              style: GoogleFonts.wallpoet(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),

      /// ========== BODY ==========
      body: 
        SafeArea(child: _pages[0]), // Always display HomePage for now

        /// ========== Floating Action Button ==========
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            /// When pressed, opens the AddSeriesForm page
            onPressed: _openAddSeriesForm,
            backgroundColor: const Color.fromARGB(255, 49, 107, 231),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 35,),
          ),
        ),
        
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   color: Colors.black,
      //   notchMargin: 6.0,
      //   child: SizedBox(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: <Widget>[
      //         IconButton(
      //           onPressed: () => _onItemTapped(0),
      //           icon: Icon(Icons.home,
      //               color: _selectedIndex == 0 ? Colors.white : Colors.grey),
      //         ),
      //         IconButton(
      //           onPressed: () => _onItemTapped(1),
      //           icon: Icon(Icons.search,
      //               color: _selectedIndex == 1 ? Colors.white : Colors.grey),
      //         ),
      //         const SizedBox(width: 1),
      //         IconButton(
      //           onPressed: () => _onItemTapped(2),
      //           icon: Icon(Icons.collections_bookmark_rounded,
      //               color: _selectedIndex == 2 ? Colors.white : Colors.grey),
      //         ),
      //         IconButton(
      //           onPressed: () => _onItemTapped(3),
      //           icon: Icon(Icons.account_circle,
      //               color: _selectedIndex == 3 ? Colors.white : Colors.grey),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
