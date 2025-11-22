import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User deleted successfully from Firebase");
      }
      await SharedPref().clearAll();
      await auth.signOut();
      print("Signed out and cleared local data");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        await auth.signOut();
      } else {
        print("$e.code");
      }
    } catch (e) {
      print("$e");
    }
  }
}
