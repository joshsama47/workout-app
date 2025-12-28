import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseMetrics {
  static double getAngle(
    PoseLandmark first,
    PoseLandmark mid,
    PoseLandmark last,
  ) {
    final double angle =
        atan2(last.y - mid.y, last.x - mid.x) -
        atan2(first.y - mid.y, first.x - mid.x);
    double degrees = angle * 180 / pi;
    if (degrees.isNegative) {
      degrees += 360;
    }
    return degrees;
  }

  static double getDistance(PoseLandmark a, PoseLandmark b) {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
  }

  static double getSymmetryDifference(
    Pose pose,
    PoseLandmarkType left,
    PoseLandmarkType mid,
    PoseLandmarkType right,
  ) {
    final leftAngle = getAngle(
      pose.landmarks[left]!,
      pose.landmarks[mid]!,
      pose.landmarks[right]!,
    );
    final rightAngle = getAngle(
      pose.landmarks[right]!,
      pose.landmarks[mid]!,
      pose.landmarks[left]!,
    );
    return (leftAngle - rightAngle).abs();
  }

  static double getTorsoLean(Pose pose) {
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder]!;

    final midHip = PoseLandmark(
      type: PoseLandmarkType.nose,
      x: (leftHip.x + rightHip.x) / 2,
      y: (leftHip.y + rightHip.y) / 2,
      z: (leftHip.z + rightHip.z) / 2,
      likelihood: min(leftHip.likelihood, rightHip.likelihood),
    );
    final midShoulder = PoseLandmark(
      type: PoseLandmarkType.nose,
      x: (leftShoulder.x + rightShoulder.x) / 2,
      y: (leftShoulder.y + rightShoulder.y) / 2,
      z: (leftShoulder.z + rightShoulder.z) / 2,
      likelihood: min(leftShoulder.likelihood, rightShoulder.likelihood),
    );

    final verticalReference = PoseLandmark(
      type: PoseLandmarkType.nose,
      x: midShoulder.x,
      y: midShoulder.y - 100, // Artificial point for vertical line
      z: midShoulder.z,
      likelihood: 1.0,
    );

    return getAngle(midHip, midShoulder, verticalReference);
  }
}
