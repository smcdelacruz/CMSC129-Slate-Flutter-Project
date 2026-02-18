import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/add_series_form.dart';
import 'pages/library_page.dart';
import 'pages/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SlateApp());
}

class SlateApp extends StatelessWidget {
  const SlateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slate',
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  // HomePage key to access its state
  final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      HomePage(key: homePageKey), // pass the key
      SearchPage(),
      LibraryPage(),
      UserPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAddSeriesForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSeriesForm(),
        // builder: (context) => AddSeriesForm(
        //   onSubmit: (series) {
        //     // Call HomePage's state method to add series
        //     homePageKey.currentState?.addSeries(series);
        //   },
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(child: _pages[_selectedIndex]),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddSeriesForm,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.black,
        notchMargin: 6.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: Icon(Icons.home,
                    color: _selectedIndex == 0 ? Colors.white : Colors.grey),
              ),
              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: Icon(Icons.search,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey),
              ),
              const SizedBox(width: 1),
              IconButton(
                onPressed: () => _onItemTapped(2),
                icon: Icon(Icons.collections_bookmark_rounded,
                    color: _selectedIndex == 2 ? Colors.white : Colors.grey),
              ),
              IconButton(
                onPressed: () => _onItemTapped(3),
                icon: Icon(Icons.account_circle,
                    color: _selectedIndex == 3 ? Colors.white : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
