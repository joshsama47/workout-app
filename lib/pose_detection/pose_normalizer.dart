import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseNormalizer {
  final double alpha;
  Pose? _previousPose;

  PoseNormalizer(this.alpha);

  Pose? smooth(Pose? newPose) {
    if (newPose == null) return null;
    if (_previousPose == null) {
      _previousPose = newPose;
      return newPose;
    }

    final smoothedLandmarks = <PoseLandmarkType, PoseLandmark>{};
    for (final landmarkType in newPose.landmarks.keys) {
      final newLandmark = newPose.landmarks[landmarkType]!;
      final oldLandmark = _previousPose!.landmarks[landmarkType]!;

      smoothedLandmarks[landmarkType] = PoseLandmark(
        type: landmarkType,
        x: alpha * newLandmark.x + (1 - alpha) * oldLandmark.x,
        y: alpha * newLandmark.y + (1 - alpha) * oldLandmark.y,
        z: alpha * newLandmark.z + (1 - alpha) * oldLandmark.z,
        likelihood: newLandmark.likelihood,
      );
    }

    _previousPose = Pose(landmarks: smoothedLandmarks);
    return _previousPose;
  }
}
