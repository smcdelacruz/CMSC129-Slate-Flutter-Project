import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/add_series_page.dart';
import 'pages/library_page.dart';
import 'pages/user_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  
  );
  runApp(const SlateApp());
}

class SlateApp extends StatelessWidget {
  const SlateApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slate',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromRGBO(15, 12, 12, 1),   // Body color
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,    // AppBar color
          elevation: 0,
        ),
      ),
      home: const MainScreen(title: 'Slate Home Page',),
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

  static final List<Widget> _pages = <Widget>[
    HomePage(),    // Index 0
    SearchPage(),  // Index 1
    LibraryPage(), // Index 2
    UserPage(),    // Index 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
    void _onAddSeries() {
      // TODO: Implement add series functionality
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddSeriesPage()
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        
        // Leading Icon
        // leading: IconButton(
        //   onPressed: () {}, 
        //   icon: const Icon(Icons.chevron_left_rounded),
        //   iconSize: 35.0,
        //   color: Colors.white,
        // ),

        // Title
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            SizedBox(height: 10),

            Icon(
              FontAwesomeIcons.clapperboard,
              size: 26,
              color: Colors.white,
            ),

            SizedBox(width: 5),

            Text(
              'Slate'.toUpperCase(),
              style: GoogleFonts.wallpoet(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              )
            ),
          ],
        ),

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

      body: SafeArea(child: _pages[_selectedIndex]),

      floatingActionButton: FloatingActionButton(
        onPressed: _onAddSeries,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
        child: 
          const Icon(
            Icons.add, 
                  color: Colors.black),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color.fromARGB(255, 0, 0, 0),
        notchMargin: 6.0,
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () => _onItemTapped(0), 
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                  )
                ),
                
              IconButton(
                onPressed: () => _onItemTapped(1), 
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                )),
              const SizedBox(width: 1),
              
              IconButton(
                onPressed: () => _onItemTapped(2), 
                icon: Icon(
                  Icons.collections_bookmark_rounded,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                )),
              
              IconButton(
                onPressed: () => _onItemTapped(3), 
                icon: Icon(
                  Icons.account_circle,
                  color: _selectedIndex == 3 ? Colors.white : Colors.grey,
                )),
            ],
          )
          // child: BottomNavigationBar(
          //   backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          //   type: BottomNavigationBarType.fixed,
          //   currentIndex: _selectedIndex,
          //   onTap: _onItemTapped,
          //   showSelectedLabels: false,
          //   showUnselectedLabels: false,
          //   items: const [
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark_rounded), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
          //   ],
          // ),
        )
          
      )
    );
  }
}