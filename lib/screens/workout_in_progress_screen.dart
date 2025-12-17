import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import '../models/workout.dart';
import '../models/exercise.dart';

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
  int _restSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRest() {
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
          // Workout finished
        }
      }
    });
  }

  bool get _isWorkoutFinished =>
      _currentExerciseIndex >= widget.workout.exercises.length - 1 &&
      _currentSet >= widget.workout.sets;

  Exercise get _currentExercise =>
      widget.workout.exercises[_currentExerciseIndex];

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
        child: _isResting
            ? _buildRestView()
            : _isWorkoutFinished && !_isResting
                ? _buildFinishedView()
                : _buildExerciseView(),
      ),
    );
  }

  Widget _buildExerciseView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _currentExercise.name,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 20),
        Lottie.asset(
          _currentExercise.animation,
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
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _startRest,
          child: const Text('Complete Set'),
        ),
      ],
    );
  }

  Widget _buildRestView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Rest',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 30),
        Text(
          '$_restSeconds',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 30),
        Text(
          _isWorkoutFinished
              ? 'Workout Complete!'
              : 'Next up: ${widget.workout.exercises[_currentExerciseIndex].name}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildFinishedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Workout Complete!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Lottie.asset(
          'assets/animations/complete.json', // Placeholder for a completion animation
          height: 250,
          width: 250,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => context.go('/'), // Navigate back to the main screen
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}
