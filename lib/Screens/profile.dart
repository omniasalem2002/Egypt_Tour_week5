import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/booking_model.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/main.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'admin_panel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  BookingModel? bookingModel;
  ProfileModel? guideModel;
  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Bookings")
        .where('user', isEqualTo: getStorage.read('uid'))
        .orderBy('timestamp', descending: true)
        .get();
    List<QueryDocumentSnapshot<Object?>> docList = snapshot.docs;
    if (docList.isNotEmpty) {
      dynamic map = docList.first.data();
      bookingModel = BookingModel.fromMap(map);
      await getGuide(bookingModel?.guide ?? '');
    }
    setState(() => isLoading = false);
  }

  Future<void> getGuide(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    dynamic map = snapshot.data();
    guideModel = ProfileModel.fromMap(map);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Details"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 61, 58),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingModel != null
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(guideModel?.image ??
                                  'https://firebasestorage.googleapis.com/v0/b/egypttourguide.appspot.com/o/user.jpg?alt=media&token=ba5d058a-f600-4df3-9388-d2c4d0d6b17e'),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                        title: const Text('Guide Name'),
                        subtitle: Text(guideModel?.name ?? '')),
                    ListTile(
                        title: const Text('Guide Mail'),
                        subtitle: Text(guideModel?.mail ?? '')),
                    ListTile(
                        title: const Text('Guide Whatsapp number'),
                        subtitle: Text(guideModel!.whatsappNumber)),
                    ListTile(
                        title: const Text('Guide Phone number'),
                        subtitle: Text(guideModel!.phoneNumber)),
                    ListTile(
                        title: const Text('Guide Accept Status'),
                        subtitle: Text(bookingModel?.status ?? '')),
                    ListTile(
                        title: const Text('Booked Date'),
                        subtitle: Text(
                            (bookingModel?.tripDate ?? DateTime.now())
                                .toString()
                                .substring(0, 11))),
                  ],
                )
              : const Center(
                  child: Text('No bookings founds',
                      style: TextStyle(color: Colors.red))),
    );
  }

  void profileUpdateWidget(
      BuildContext context, String title, String key, String hint,
      {String? defaultValue, bool numberValidate = false}) {
    TextEditingController controller = TextEditingController();
    if (defaultValue != null) controller.text = defaultValue;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint, labelText: title),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    showToast('pleaseEnterValue');
                    return;
                  }
                  RegExp re = RegExp(r'^01[0-9]{9}$');
                  if (numberValidate && !re.hasMatch(controller.text)) {
                    showToast('invalidPhoneNumber');
                    return;
                  }
                  EasyLoading.show();
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(getStorage.read('uid'))
                      .update({key: controller.text}).then((value) async {
                    await getData();
                    showToast('Successfully updated details');
                  }).catchError((e) {
                    showToast('Failed to update. $e');
                  });
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
