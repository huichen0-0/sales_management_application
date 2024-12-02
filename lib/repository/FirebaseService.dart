import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  FirebaseService();

  /// Inserts data into a specific path in Firebase Realtime Database.
  Future<void> insertData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).push().set(data);
      print('Data inserted successfully at $path');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  Future<Map<String, Object>> readData(String path) async {
    Map<String, Map<Object, Object>> mapResults = new HashMap();
    try {
      await _database.child(path).once().then((DatabaseEvent event) {
        final snapshot = event.snapshot;
        if (snapshot.exists) {
          final values = Map<Object, Object>.from(snapshot.value as Map);
          values.forEach((k, v) {
            String key = k as String;
            final mapValue = Map<Object, Object>.from(v as Map);
            mapResults[key] = mapValue;
          });
          return mapResults;
        } else {
          print('No data found');
          return [];
        }
      });
    } catch (error) {
      print('Error reading data: $error');
    }
    return mapResults;
  }

  Future<void> updateDate(String path, String id, Map<String, dynamic> data) async {
    try {
      await _database.child(path).child(id).update(data);
      print('Data updated successfully at $path');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

}
