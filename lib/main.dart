import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/nutrition/food_item.dart';
import 'package:myapp/models/nutrition/meal.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/providers/challenge_provider.dart';
import 'package:myapp/providers/nutrition_provider.dart';
import 'package:myapp/providers/social_event_provider.dart';
import 'package:myapp/screens/add_food_screen.dart';
import 'package:myapp/screens/challenges_screen.dart';
import 'package:myapp/screens/edit_food_screen.dart';
import 'package:myapp/screens/social_events_screen.dart';
import 'package:myapp/screens/workout_summary_screen.dart';
import 'package:provider/provider.dart';

import 'data/workout_plans.dart';
import 'firebase_options.dart';
import 'generate_workout_screen.dart';
import 'models/class_model.dart';
import 'models/custom_workout_model.dart';
import 'providers/body_composition_provider.dart';
import 'providers/custom_workout_provider.dart';
import 'providers/user_provider.dart';
import 'providers/workout_manager.dart';
import 'screens/add_body_composition_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/body_composition_screen.dart';
import 'screens/class_detail_screen.dart';
import 'screens/custom_workout_builder_screen.dart';
import 'screens/custom_workout_detail_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/main_wrapper.dart';
import 'screens/nutrition_screen.dart';
import 'screens/on_demand_classes_screen.dart';
import 'screens/outdoor_workout_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'screens/workout_history_screen.dart';
import 'screens/workout_in_progress_screen.dart';
import 'screens/workout_plan_detail_screen.dart';
import 'services/auth_service.dart';
import 'services/friends_service.dart';
import 'services/leaderboard_service.dart';
import 'services/music_service.dart';
import 'services/notification_service.dart';
import 'services/progress_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FriendsService>(create: (_) => FriendsService()),
        Provider<LeaderboardService>(create: (_) => LeaderboardService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutManager()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BodyCompositionProvider()),
        ChangeNotifierProvider(create: (context) => NutritionProvider()),
        ChangeNotifierProxyProvider<UserProvider, ProgressService>(
          create: (context) => ProgressService(),
          update: (context, userProvider, progressService) {
            final userId = userProvider.user?.uid;
            if (userId != null) {
              progressService!.fetchCompletedWorkouts(userId);
            }
            return progressService!;
          },
        ),
        ChangeNotifierProvider(create: (context) => MusicService()),
        ChangeNotifierProvider(create: (context) => CustomWorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ChallengeProvider()),
        ChangeNotifierProvider(create: (context) => SocialEventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthWrapper();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const UserProfileScreen();
          },
        ),
        GoRoute(
          path: 'edit-profile',
          builder: (BuildContext context, GoRouterState state) {
            return const EditProfileScreen();
          },
        ),
        GoRoute(
          path: 'friends',
          builder: (BuildContext context, GoRouterState state) {
            return const FriendsScreen();
          },
        ),
        GoRoute(
          path: 'leaderboard',
          builder: (BuildContext context, GoRouterState state) {
            return const LeaderboardScreen();
          },
        ),
        GoRoute(
          path: 'outdoor-workout',
          builder: (BuildContext context, GoRouterState state) {
            return const OutdoorWorkoutScreen();
          },
        ),
        GoRoute(
          path: 'workout-history',
          builder: (BuildContext context, GoRouterState state) {
            return const WorkoutHistoryScreen();
          },
        ),
        GoRoute(
          path: 'plan/:planId',
          builder: (BuildContext context, GoRouterState state) {
            final planId = state.pathParameters['planId']!;
            final plan = workoutPlans.firstWhere((p) => p.id == planId);
            return WorkoutPlanDetailScreen(plan: plan);
          },
        ),
        GoRoute(
          path: 'workout',
          builder: (BuildContext context, GoRouterState state) {
            final workoutJson = state.extra as String?;
            if (workoutJson != null) {
              final workoutManager = Provider.of<WorkoutManager>(
                context,
                listen: false,
              );
              workoutManager.addWorkout(workoutJson);
              final workout = workoutManager.workouts.last;
              return WorkoutDetailScreen(workout: workout);
            }
            return const MainWrapper();
          },
        ),
        GoRoute(
          path: 'workout/:workoutId',
          builder: (BuildContext context, GoRouterState state) {
            final workoutId = state.pathParameters['workoutId']!;
            final workout = workoutPlans
                .expand((p) => p.workouts.values)
                .firstWhere((w) => w.id == workoutId);
            return WorkoutDetailScreen(workout: workout);
          },
        ),
        GoRoute(
          path: 'workout/:workoutId/in-progress',
          builder: (BuildContext context, GoRouterState state) {
            final workoutId = state.pathParameters['workoutId']!;
            final workout = workoutPlans
                .expand((p) => p.workouts.values)
                .firstWhere((w) => w.id == workoutId);
            return WorkoutInProgressScreen(workout: workout);
          },
        ),
        GoRoute(
          path: 'workout-summary',
          builder: (BuildContext context, GoRouterState state) {
            final workoutSession = state.extra as WorkoutSession;
            return WorkoutSummaryScreen(workoutSession: workoutSession);
          },
        ),
        GoRoute(
          path: 'generate-workout',
          builder: (BuildContext context, GoRouterState state) {
            return const GenerateWorkoutScreen();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: 'body-composition',
          builder: (BuildContext context, GoRouterState state) {
            return const BodyCompositionScreen();
          },
        ),
        GoRoute(
          path: 'add-body-composition',
          builder: (BuildContext acontext, GoRouterState state) {
            return const AddBodyCompositionScreen();
          },
        ),
        GoRoute(
          path: 'explore',
          builder: (BuildContext context, GoRouterState state) {
            return const ExploreScreen();
          },
        ),
        GoRoute(
          path: 'custom-workout-builder',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomWorkoutBuilderScreen();
          },
        ),
        GoRoute(
          path: 'custom-workout-detail',
          builder: (BuildContext context, GoRouterState state) {
            final workout = state.extra as CustomWorkout;
            return CustomWorkoutDetailScreen(workout: workout);
          },
        ),
        GoRoute(
          path: 'on-demand-classes',
          builder: (BuildContext context, GoRouterState state) {
            return const OnDemandClassesScreen();
          },
        ),
        GoRoute(
          path: 'class-detail',
          builder: (BuildContext context, GoRouterState state) {
            final fitnessClass = state.extra as FitnessClass;
            return ClassDetailScreen(fitnessClass: fitnessClass);
          },
        ),
        GoRoute(
          path: 'nutrition',
          builder: (BuildContext context, GoRouterState state) {
            return const NutritionScreen();
          },
        ),
        GoRoute(
          path: 'add-food',
          builder: (BuildContext context, GoRouterState state) {
            final meal = state.extra as Meal;
            return AddFoodScreen(meal: meal);
          },
        ),
        GoRoute(
          path: 'edit-food',
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>;
            final meal = data['meal'] as Meal;
            final foodItem = data['foodItem'] as FoodItem;
            return EditFoodScreen(meal: meal, foodItem: foodItem);
          },
        ),
        GoRoute(
          path: 'challenges',
          builder: (BuildContext context, GoRouterState state) {
            return const ChallengesScreen();
          },
        ),
        GoRoute(
          path: 'social-events',
          builder: (BuildContext context, GoRouterState state) {
            return const SocialEventsScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Fitness App',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepPurple,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).primaryTextTheme,
            ),
            useMaterial3: true,
          ),
          themeMode: themeProvider.themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final user = snapshot.data!;
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          return const MainWrapper();
        }
        return const AuthScreen();
      },
    );
  }
}
