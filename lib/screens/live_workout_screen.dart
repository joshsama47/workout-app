import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:myapp/ai_coach/coach.dart';
import 'package:myapp/models/exercise.dart';
import 'package:myapp/models/personal_record.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/pose_detection/exercise_model.dart';
import 'package:myapp/pose_detection/pose_metrics.dart';
import 'package:myapp/pose_detection/pose_normalizer.dart';
import 'package:myapp/pose_detection/pose_provider.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/screens/workout_summary_screen.dart';
import 'package:myapp/services/workout_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LiveWorkoutScreen extends StatefulWidget {
  final String exerciseName;

  const LiveWorkoutScreen({super.key, required this.exerciseName});

  @override
  State<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends State<LiveWorkoutScreen> {
  late final CameraController _cameraController;
  late final PoseProvider _poseProvider;
  late final PoseNormalizer _poseNormalizer;
  late final ExerciseModel _exerciseModel;
  late final WorkoutService _workoutService;
  late final WorkoutSession _workoutSession;
  late final Coach _coach;
  Pose? _pose;
  StreamSubscription<Pose>? _poseSubscription;

  // Metrics tracking variables
  double _minAngle = 360;
  double _maxAngle = 0;
  DateTime? _repStartTime;
  DateTime? _repMidTime;
  final List<double> _torsoLeanAngles = [];

  @override
  void initState() {
    super.initState();
    _poseProvider = PoseProvider();
    _poseNormalizer = PoseNormalizer(0.7);
    _exerciseModel = ExerciseModel(widget.exerciseName);
    _workoutService = WorkoutService();
    _coach = Coach();

    _workoutSession = WorkoutSession(
      sessionId: const Uuid().v4(),
      workoutName: widget.exerciseName,
      startTime: DateTime.now(),
      status: 'in_progress',
      exercises: [
        Exercise(
            name: widget.exerciseName,
            sets: [],
            recordType: RecordType.reps) //TODO: Fix this
      ],
    );

    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();
    _cameraController.startImageStream((image) async {
      final pose = await _poseProvider.processImage(image, camera);
      if (pose != null) {
        final normalizedPose = _poseNormalizer.smooth(pose);
        if (mounted) {
          setState(() {
            _pose = normalizedPose;
            if (normalizedPose != null) {
              final repCount = _exerciseModel.repetitionCounter.count(
                normalizedPose,
              );
              _updateMetricsAndWorkoutSession(normalizedPose, repCount);
            }
          });
        }
      }
    });
  }

  void _updateMetricsAndWorkoutSession(Pose pose, int repCount) {
    final exercise = _workoutSession.exercises.first;
    if (exercise.sets.isEmpty) {
      exercise.sets.add(ExerciseSet(setNumber: 1, reps: []));
    }
    final currentSet = exercise.sets.last;

    final currentAngle = _exerciseModel.repetitionCounter.getAngle(pose);
    if (currentAngle == null) return;

    final currentTorsoLean = PoseMetrics.getTorsoLean(pose);

    if (repCount > currentSet.reps.length) {
      if (currentSet.reps.isNotEmpty) {
        _finalizeRepMetrics(currentSet.reps.last);
      }

      _repStartTime = DateTime.now();
      currentSet.reps.add(
        Rep(
          repNumber: repCount,
          isCompleted: true,
          startTime: _repStartTime!,
          coachFeedback: [],
        ),
      );

      _minAngle = currentAngle;
      _maxAngle = currentAngle;
      _repMidTime = null;
      _torsoLeanAngles.clear();
      _torsoLeanAngles.add(currentTorsoLean);
    } else {
      _minAngle = min(_minAngle, currentAngle);
      _maxAngle = max(_maxAngle, currentAngle);
      _torsoLeanAngles.add(currentTorsoLean);

      if (_exerciseModel.repetitionCounter.isGoingDown == false &&
          _repMidTime == null) {
        _repMidTime = DateTime.now();
      }
    }
  }

  void _finalizeRepMetrics(Rep rep) {
    final endTime = DateTime.now();
    final rom = _maxAngle - _minAngle;
    final tempoEccentric = _repMidTime
        ?.difference(_repStartTime ?? endTime)
        .inMilliseconds
        .toDouble();
    final tempoConcentric = endTime
        .difference(_repMidTime ?? endTime)
        .inMilliseconds
        .toDouble();
    final maxTorsoLean = _torsoLeanAngles.isNotEmpty
        ? _torsoLeanAngles.reduce(max)
        : null;

    final metrics = RepMetrics(
      rom: rom,
      tempoEccentric: tempoEccentric,
      tempoConcentric: tempoConcentric,
      maxTorsoLean: maxTorsoLean,
    );

    final feedback = _coach.analyzeRep(
      Rep(
        repNumber: rep.repNumber,
        isCompleted: true,
        startTime: rep.startTime,
        metrics: metrics,
        coachFeedback: [],
      ),
      widget.exerciseName,
    );

    if (feedback.isNotEmpty) {
      _showFeedback(feedback.first.message);
    }

    final repIndex = _workoutSession.exercises.first.sets.last.reps.indexWhere(
      (r) => r.repNumber == rep.repNumber,
    );
    if (repIndex != -1) {
      _workoutSession.exercises.first.sets.last.reps[repIndex] = Rep(
        repNumber: rep.repNumber,
        isCompleted: rep.isCompleted,
        startTime: rep.startTime,
        endTime: endTime,
        metrics: metrics,
        coachFeedback: feedback,
      );
    }
  }

  void _showFeedback(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  void _finishWorkout() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      if (_workoutSession.exercises.first.sets.isNotEmpty &&
          _workoutSession.exercises.first.sets.last.reps.isNotEmpty) {
        _finalizeRepMetrics(
          _workoutSession.exercises.first.sets.last.reps.last,
        );
      }

      _workoutSession.exercises.first.sets.removeWhere((s) => s.reps.isEmpty);
      final sessionToSave = WorkoutSession(
        sessionId: _workoutSession.sessionId,
        workoutName: _workoutSession.workoutName,
        startTime: _workoutSession.startTime,
        endTime: DateTime.now(),
        status: 'completed',
        exercises: _workoutSession.exercises,
      );
      await _workoutService.saveWorkoutSession(user.uid, sessionToSave);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WorkoutSummaryScreen(workoutSession: sessionToSave),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _poseProvider.close();
    _poseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _finishWorkout,
            tooltip: 'Finish Workout',
          ),
        ],
      ),
      body: _cameraController.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController),
                if (_pose != null) CustomPaint(painter: PosePainter(_pose!)),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    'Reps: ${_exerciseModel.repetitionCounter.reps}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class PosePainter extends CustomPainter {
  final Pose pose;

  PosePainter(this.pose);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    for (final landmark in pose.landmarks.values) {
      canvas.drawCircle(Offset(landmark.x, landmark.y), 5, paint);
    }

    // Add lines to connect landmarks for better visualization
    final landmarkConnections = {
      PoseLandmarkType.leftShoulder: PoseLandmarkType.leftElbow,
      PoseLandmarkType.leftElbow: PoseLandmarkType.leftWrist,
      PoseLandmarkType.rightShoulder: PoseLandmarkType.rightElbow,
      PoseLandmarkType.rightElbow: PoseLandmarkType.rightWrist,
      PoseLandmarkType.leftHip: PoseLandmarkType.leftKnee,
      PoseLandmarkType.leftKnee: PoseLandmarkType.leftAnkle,
      PoseLandmarkType.rightHip: PoseLandmarkType.rightKnee,
      PoseLandmarkType.rightKnee: PoseLandmarkType.rightAnkle,
      PoseLandmarkType.leftShoulder: PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftHip: PoseLandmarkType.rightHip,
    };

    paint.color = Colors.blue;
    landmarkConnections.forEach((start, end) {
      final startLandmark = pose.landmarks[start];
      final endLandmark = pose.landmarks[end];
      if (startLandmark != null && endLandmark != null) {
        canvas.drawLine(
          Offset(startLandmark.x, startLandmark.y),
          Offset(endLandmark.x, endLandmark.y),
          paint,
        );
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
