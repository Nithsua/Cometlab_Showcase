import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getFirestoreCollection(
      {required String collectionName}) {
    return _firestore.collection(collectionName).get();
  }

  Future<DocumentReference<Map<String, dynamic>>> writeToFirestoreCollection(
      {required String collectionName, required Map<String, dynamic> data}) {
    return _firestore.collection(collectionName).add(data);
  }
}

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleUser = GoogleSignIn();

  Stream<User?> isSignedIn() {
    return _firebaseAuth.userChanges();
  }

  Future<void> signInWithGoogle() async {
    try {
      final _googleUserAccount = await _googleUser.signIn();
      final GoogleSignInAuthentication googleAuth =
          await _googleUserAccount!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);

      // await firestoreServices.writeToFirestoreCollection(collectionName: "User", data: );
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleUser.signOut();
    await _firebaseAuth.signOut();
  }
}

FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
FirestoreServices firestoreServices = FirestoreServices();
