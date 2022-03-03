import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* firestore */
class FirestoreHandler {
  FirestoreHandler({required this.uid});
  final String uid;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  CollectionReference getFsCollectionRefByName(name) => _fs.collection(name);
}

/* firebase auth */
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final firestoreProvider = Provider<FirestoreHandler?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return FirestoreHandler(uid: auth.asData!.value!.uid);
  }
  return null;
});
