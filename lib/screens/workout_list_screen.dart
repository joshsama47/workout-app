import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/workout_plans.dart';
import '../main.dart';
import '../providers/workout_manager.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Workout Plans'),
            Tab(text: 'Generated Workouts'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [WorkoutPlansTab(), GeneratedWorkoutsTab()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/generate-workout');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WorkoutPlansTab extends StatelessWidget {
  const WorkoutPlansTab({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = workoutPlans;

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onTap: () => context.go('/plan/${plan.id}'),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Image.network(
                  'https://picsum.photos/seed/${plan.id}/600/200',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha((255 * 0.6).round()),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${plan.workouts.length} workouts',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GeneratedWorkoutsTab extends StatelessWidget {
  const GeneratedWorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutManager = Provider.of<WorkoutManager>(context);

    return FutureBuilder(
      future: Future.value(workoutManager.workouts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final workouts = snapshot.data ?? [];
          if (workouts.isEmpty) {
            return const Center(child: Text('No generated workouts yet.'));
          }
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return ListTile(
                title: Text(workout.name),
                onTap: () => context.go('/workout/${workout.id}'),
              );
            },
          );
        }
      },
    );
  }
}
