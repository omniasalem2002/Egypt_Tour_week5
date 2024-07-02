import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/guide_model.dart';
import 'package:egypttourguide/utils/constants.dart';

class TourGuide {
  Future<bool> createGuide(GuideModel model) async {
    bool flag = false;
    await FirebaseFirestore.instance
        .collection('Guides')
        .doc(model.uid)
        .set(model.toMap())
        .then((v) async {
      showToast('Sent details for approval');
      flag = true;
    }).catchError((e) {
      showToast('Failed to create guide');
      flag = false;
    });
    return flag;
  }
}
