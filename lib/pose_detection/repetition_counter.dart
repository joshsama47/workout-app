import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:myapp/pose_detection/pose_metrics.dart';

abstract class RepetitionCounter {
  int reps = 0;
  String stage = 'idle';
  bool isGoingDown = false;

  int count(Pose pose);
  double? getAngle(Pose pose);
}

class SquatRepetitionCounter extends RepetitionCounter {
  @override
  int count(Pose pose) {
    final hip = pose.landmarks[PoseLandmarkType.leftHip]!;
    final knee = pose.landmarks[PoseLandmarkType.leftKnee]!;
    final ankle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    final angle = PoseMetrics.getAngle(hip, knee, ankle);

    if (angle < 100) {
      if (stage == 'idle') {
        stage = 'down';
        isGoingDown = true;
      }
    } else if (angle > 160) {
      if (stage == 'down') {
        stage = 'up';
        isGoingDown = false;
        reps++;
      }
      stage = 'idle';
    }
    return reps;
  }

  @override
  double? getAngle(Pose pose) {
    final hip = pose.landmarks[PoseLandmarkType.leftHip]!;
    final knee = pose.landmarks[PoseLandmarkType.leftKnee]!;
    final ankle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    return PoseMetrics.getAngle(hip, knee, ankle);
  }
}

class PushUpRepetitionCounter extends RepetitionCounter {
  @override
  int count(Pose pose) {
    final shoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final elbow = pose.landmarks[PoseLandmarkType.leftElbow]!;
    final wrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    final angle = PoseMetrics.getAngle(shoulder, elbow, wrist);

    if (angle < 90) {
      if (stage == 'idle') {
        stage = 'down';
        isGoingDown = true;
      }
    } else if (angle > 160) {
      if (stage == 'down') {
        stage = 'up';
        isGoingDown = false;
        reps++;
      }
      stage = 'idle';
    }
    return reps;
  }

  @override
  double? getAngle(Pose pose) {
    final shoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final elbow = pose.landmarks[PoseLandmarkType.leftElbow]!;
    final wrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    return PoseMetrics.getAngle(shoulder, elbow, wrist);
  }
}

class JumpingJackRepetitionCounter extends RepetitionCounter {
  @override
  int count(Pose pose) {
    final leftHand = pose.landmarks[PoseLandmarkType.leftWrist]!;
    final rightHand = pose.landmarks[PoseLandmarkType.rightWrist]!;
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder]!;

    final handDist = (leftHand.x - rightHand.x).abs();
    final shoulderDist = (leftShoulder.x - rightShoulder.x).abs();

    if (handDist > shoulderDist * 1.5) {
      if (stage == 'idle') {
        stage = 'up';
        isGoingDown = false;
      }
    } else if (stage == 'up' && handDist < shoulderDist) {
      stage = 'down';
      isGoingDown = true;
      reps++;
      stage = 'idle';
    }
    return reps;
  }

  @override
  double? getAngle(Pose pose) {
    return null; // Not applicable for jumping jacks
  }
}
