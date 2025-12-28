import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/personal_record.dart';

class PersonalRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PersonalRecord>> getPersonalRecords(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('personal_records')
        .get();

    return snapshot.docs
        .map((doc) => PersonalRecord.fromMap(doc.data()))
        .toList();
  }

  Future<void> updatePersonalRecord(
    String userId,
    PersonalRecord record,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('personal_records')
        .doc(record.exerciseName)
        .set(record.toMap());
  }
}
