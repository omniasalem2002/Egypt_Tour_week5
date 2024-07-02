import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/booking_model.dart';
import 'package:egypttourguide/Models/guide_details.dart';
import 'package:egypttourguide/Screens/notifications.dart';
import 'package:egypttourguide/main.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:linkable/linkable.dart';
import 'bottom_navigation.dart';

class TourGuideDetail extends StatefulWidget {
  final GuideDetails guideDetails;

  const TourGuideDetail(this.guideDetails, {super.key});

  @override
  State<TourGuideDetail> createState() => _TourGuideDetailState();
}

class _TourGuideDetailState extends State<TourGuideDetail> {
  late GuideDetails guideDetails;
  DateTime? picked;

  @override
  void initState() {
    guideDetails = widget.guideDetails;
    getLastDay();
    super.initState();
  }

  int getLastDay() {
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDay = firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDay.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guideDetails.name),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 61, 58),
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: NetworkImage(guideDetails.image), fit: BoxFit.cover)),
          ),
          const Spacer(flex: 1),
          const Text("Experience", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Linkable(text: guideDetails.experience, maxLines: getMaxLines(guideDetails.experience))),
          const Spacer(flex: 1),
          const Text("Rating", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          RatingBarIndicator(
              rating: guideDetails.rating,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Color.fromARGB(255, 255, 17, 1)),
              itemCount: 5,
              itemSize: 26),
          const Spacer(flex: 4),
          InkWell(
            child: Container(
              height: 50,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration:
                  BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Spacer(flex: 1),
                  const Icon(Icons.calendar_month, color: Colors.white),
                  const Spacer(flex: 1),
                  Text(
                    picked == null ? 'Choose a date' : picked.toString().substring(0, 11),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(flex: 8),
                ],
              ),
            ),
            onTap: () async {
              picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 0)),
                lastDate: DateTime(2100),
              );
              setState(() {});
            },
          ),
          const Spacer(flex: 2),
          ElevatedButton(
              onPressed: picked != null ? bookGuide : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 61, 58),
              ),
              child: Text("Book Now",
                  style: TextStyle(color: picked == null ? Colors.black45 : Colors.white))),
          const Spacer(flex: 4),
        ],
      ),
    );
  }

  Future<void> bookGuide() async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('Bookings').doc();
    EasyLoading.show();
    BookingModel model = BookingModel(
        id: docRef.id,
        user: getStorage.read('uid'),
        guide: guideDetails.uid,
        city: guideDetails.city,
        status: 'Pending',
        tripDate: picked ?? DateTime.now(),
        timestamp: DateTime.now());
    await docRef.set(model.toMap()).then((v) async {
      await NotifyService().sendNotification(guideDetails.token);
      if (EasyLoading.isShow) EasyLoading.dismiss();
      showToast('Successfully booked.');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => const BottomNavBar());
      });
    }).catchError((e) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      showToast('Failed to book. Please try again.');
    });
  }

  int getMaxLines(String value){
    int maxLines = value.length ~/ 50;
    int temp = maxLines < 1 ? 1 : maxLines > 6 ? 6 : maxLines;
    return temp;
  }
}
