import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/utils/constants.dart';

import '../main.dart';

class Users {
  Future<bool> createUser(ProfileModel model) async {
    bool flag = false;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(model.uid)
        .set(model.toMap())
        .then((v) {
      flag = true;
    }).catchError((e) {
      showToast('Failed to create user. $e');
      flag = false;
    });
    return flag;
  }

  Future<bool> checkUser(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return snapshot.exists;
  }

  Future<ProfileModel?> getProfileData() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(getStorage.read('uid')).get();
    if (!snapshot.exists) return null;
    dynamic map = snapshot.data();
    return ProfileModel.fromMap(map);
  }

  Future<void> updateUser(ProfileModel model) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(getStorage.read('uid'))
        .update(model.toMap());
  }
}
