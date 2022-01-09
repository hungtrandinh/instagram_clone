import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/model/user.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  // đăng ký tài khoản không thành công
  final String messenger;

  const SignUpWithEmailAndPasswordFailure(
      [this.messenger = "đã xảy ra 1 ngoại lệ không xác định"]);

  factory SignUpWithEmailAndPasswordFailure.fromcode(String code) {
    switch (code) {
      case "invalid-email":
        return const SignUpWithEmailAndPasswordFailure(
            "Email không hợp lệ hoặc bị định dạng sai");
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ với bộ phận hỗ trợ để được giúp đỡ.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Một tài khoản đã tồn tại cho email đó.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Hoạt động không được phép. Vui lòng liên hệ với bộ phận hỗ trợ.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Vui lòng nhập mật khẩu mạnh hơn.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  // các lỗi xảy ra khi đanwg nhập không thành công
  final String messenger;

  const LogInWithEmailAndPasswordFailure(
      [this.messenger = 'Xảy ra 1 ngoại lệ không xác đinh']);
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithGoogleFailure implements Exception {
  final String messenger;

  const LogInWithGoogleFailure(
      [this.messenger = " có một lỗi ngoại lệ xuất hiệnh"]);
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }
}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();
  SharedPreferences? prefs;

  AuthenticationRepository(
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  @visibleForTesting // khiểm tra môi trường thực hiện có phải là web hay không?
  bool isWeb = kIsWeb;
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Future<MyUser> updateCurrentUser(MyUser user) async {
    return await firestore
        .collection("users")
        .doc(user.id)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }

  static Future<String?> createNewUser(MyUser user) async => await firestore
      .collection("users")
      .doc(user.id)
      .set(user.toJson())
      .then((value) => null, onError: (e) => e);

  signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      MyUser? user = MyUser(
        email: email,
        name: name,
        id: result.user?.uid ?? '',
      );
      createNewUser(user);

      String? errorMessage = "looi roi";
      if (errorMessage == null) {
        return user;
      } else {
        return 'Couldn\'t sign up for firebase, Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (isWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Stream<MyUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? MyUser.empty : firebaseUser.toUser;
      return user;
    });
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('users').doc(result.user?.uid ?? '').get();

      MyUser? user;

      if (documentSnapshot.exists) {
        user = MyUser.fromJson(documentSnapshot.data() ?? {});
      }
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  String getuid() {
    print(_usersStream.toString());
    return _usersStream.toString();
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  MyUser get currentUser {
    return MyUser.empty;
  }
}

extension on User {
  MyUser get toUser {
    return MyUser(id: uid, email: email, name: displayName);
  }
}

class Uid {
  final String id;

  Uid({required this.id});
  static Uid fromJson(Map<String, dynamic> parsedJson) {
    return Uid(
      id: parsedJson['id'] ?? parsedJson['userID'] ?? '',
    );
  }
}

// FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// String getUser() {
//   User? user;
//   return user!.uid;
// }
