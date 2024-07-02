import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/booking_model.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserDetailsPage extends StatefulWidget {
  final BookingModel bookingModel;
  final String userUID;

  const UserDetailsPage(this.bookingModel, this.userUID, {super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  ProfileModel? model;
  late BookingModel bookingModel;

  @override
  void initState() {
    bookingModel = widget.bookingModel;
    getData();
    super.initState();
  }

  Future<void> getData() async {
    EasyLoading.show();
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(widget.userUID).get();
    dynamic map = snapshot.data();
    model = ProfileModel.fromMap(map);
    if (EasyLoading.isShow) EasyLoading.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('User details'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 1, 61, 58),
          foregroundColor: Colors.white),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(model?.image ?? netImgPlaceholder),
                          fit: BoxFit.cover)))),
          ListTile(title: const Text('Name'), subtitle: Text(model?.name ?? '')),
          ListTile(title: const Text('Mail'), subtitle: Text(model?.mail ?? '')),
          ListTile(title: const Text('Phone Number'), subtitle: Text(model?.phoneNumber ?? '')),
          ListTile(title: const Text('Booking ID'), subtitle: Text(bookingModel.id)),
          ListTile(title: const Text('City'), subtitle: Text(bookingModel.city)),
          ListTile(
              title: const Text('Trip Date'),
              subtitle: Text(bookingModel.tripDate.toString().substring(0, 11))),
          ListTile(title: const Text('Trip Status'), subtitle: Text(bookingModel.status)),
          ListTile(
              title: const Text('Booking create on'),
              subtitle: Text(bookingModel.timestamp.toString())),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                  onPressed: () => updateStatus(widget.bookingModel.id, 'Rejected')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => updateStatus(widget.bookingModel.id, 'Accepted'),
                  child: const Text('Accept', style: TextStyle(color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }

  Future<void> updateStatus(String uid, String status) async {
    EasyLoading.show();
    await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(uid)
        .update({'status': status}).then((v) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      showToast('Successfully updated the status');
    }).catchError((e) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      showToast('Failed to update the status');
    });
  }
}
