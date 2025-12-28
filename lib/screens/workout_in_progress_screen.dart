import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/screens/live_workout_screen.dart';
import 'package:myapp/services/workout_service.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/badge_service.dart';
import '../services/music_service.dart';

class WorkoutInProgressScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutInProgressScreen({super.key, required this.workout});

  @override
  State<WorkoutInProgressScreen> createState() =>
      _WorkoutInProgressScreenState();
}

class _WorkoutInProgressScreenState extends State<WorkoutInProgressScreen> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  bool _isResting = false;
  bool _isWorkoutCompleted = false; // New state variable
  int _restSeconds = 0;
  Timer? _timer;
  final BadgeService _badgeService = BadgeService();

  @override
  void initState() {
    super.initState();
    // Auto-play music when workout starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MusicService>(context, listen: false).play();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Pause music when the screen is left
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<MusicService>(context, listen: false).pause();
      }
    });
    super.dispose();
  }

  void _startRest() {
    // Check if it's the very last set of the last exercise
    if (_isWorkoutFinished()) {
      _completeWorkout();
      return;
    }

    setState(() {
      _isResting = true;
      _restSeconds = widget.workout.rest;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSeconds > 0) {
        setState(() {
          _restSeconds--;
        });
      } else {
        _timer?.cancel();
        _moveToNext();
      }
    });
  }

  void _moveToNext() {
    setState(() {
      _isResting = false;
      if (_currentSet < widget.workout.sets) {
        _currentSet++;
      } else {
        if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
          _currentExerciseIndex++;
          _currentSet = 1;
        } else {
          _completeWorkout();
        }
      }
    });
  }

  void _completeWorkout() async {
    final workoutService = Provider.of<WorkoutService>(
      context,
      listen: false,
    );
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;

    final session = WorkoutSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutName: widget.workout.name,
      startTime: DateTime.now(),
      status: 'completed',
      exercises: widget.workout.exercises,
      endTime: DateTime.now(),
    );
    await workoutService.saveWorkoutSession(user.uid, session);
    await _badgeService.checkAndAwardBadges();
    if (mounted) {
      Provider.of<MusicService>(context, listen: false).pause();
      setState(() {
        _isWorkoutCompleted = true; // Set workout as completed
      });
    }
  }

  bool _isWorkoutFinished() =>
      _currentExerciseIndex >= widget.workout.exercises.length - 1 &&
      _currentSet >= widget.workout.sets;

  Exercise? get _currentExercise {
    if (_currentExerciseIndex >= widget.workout.exercises.length) {
      return null;
    }
    return widget.workout.exercises[_currentExerciseIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: _isWorkoutCompleted
            ? _buildFinishedView()
            : _isResting
            ? _buildRestView()
            : _buildExerciseView(),
      ),
      bottomNavigationBar: !_isWorkoutCompleted ? _buildMusicControls() : null,
    );
  }

  Widget _buildMusicControls() {
    return Consumer<MusicService>(
      builder: (context, musicService, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              const Icon(Icons.music_note),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Workout Mix', // Placeholder
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  musicService.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                iconSize: 48,
                onPressed: () {
                  musicService.togglePlayback();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseView() {
    if (_currentExercise == null) {
      return _buildFinishedView();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          Column(
            children: [
              Text(
                _currentExercise!.name,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                _currentExercise!.animation!,
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 30),
              Text(
                'Set $_currentSet of ${widget.workout.sets}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.workout.reps} reps',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                onPressed: _startRest,
                child: Text(
                  _isWorkoutFinished() ? 'Finish Workout' : 'Complete Set',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveWorkoutScreen(
                        exerciseName: _currentExercise!.name,
                      ),
                    ),
                  );
                },
                child: const Text('Start Live Workout'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestView() {
    Exercise? nextExercise;
    if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
      nextExercise = widget.workout.exercises[_currentExerciseIndex + 1];
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Rest', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 30),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _restSeconds / widget.workout.rest,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade300,
                ),
                Center(
                  child: Text(
                    '$_restSeconds',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            nextExercise != null
                ? 'Next up: ${nextExercise.name}'
                : 'Finishing up...',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Workout Complete!',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          Lottie.asset(
            'assets/animations/complete.json',
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              final session = WorkoutSession(
                sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
                workoutName: widget.workout.name,
                startTime: DateTime.now(),
                status: 'completed',
                exercises: widget.workout.exercises,
                endTime: DateTime.now(),
              );
              context.go('/workout-summary', extra: session);
            },
            child: const Text('View Summary'),
          ),
        ],
      ),
    );
  }
}
