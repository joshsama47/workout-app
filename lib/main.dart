import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'data/workout_plans.dart';
import 'data/workouts.dart';
import 'screens/workout_list_screen.dart';
import 'screens/workout_plan_detail_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'screens/workout_in_progress_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'plan/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final plan = workoutPlans.firstWhere((p) => p.id == id);
              return WorkoutPlanDetailScreen(plan: plan);
            },
          ),
          GoRoute(
            path: 'workout/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final workout = workouts.firstWhere((w) => w.id == id);
              return WorkoutDetailScreen(workout: workout);
            },
            routes: [
              GoRoute(
                path: 'in-progress',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final workout = workouts.firstWhere((w) => w.id == id);
                  return WorkoutInProgressScreen(workout: workout);
                },
              ),
            ],
          ),
        ]),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Colors.deepPurple;

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
    );

    return MaterialApp.router(
      title: 'Workout Planner',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: _router,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    WorkoutListScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
