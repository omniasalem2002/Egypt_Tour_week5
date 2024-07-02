import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/booking_model.dart';
import 'package:egypttourguide/Screens/user_details_page.dart';
import 'package:egypttourguide/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class FindBookings extends StatefulWidget {
  const FindBookings({super.key});

  @override
  State<FindBookings> createState() => _FindBookingsState();
}

class _FindBookingsState extends State<FindBookings> {
  List<BookingModel> bookings = [];

  @override
  void initState() {
    getBookings();
    super.initState();
  }

  Future<void> getBookings() async {
    EasyLoading.show();
    bookings.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('guide', isEqualTo: getStorage.read('uid'))
        .orderBy('timestamp', descending: true)
        .get();
    if (EasyLoading.isShow) EasyLoading.dismiss();
    List<QueryDocumentSnapshot<Object?>> docList = snapshot.docs;
    for (int i = 0; i < docList.length; i++) {
      dynamic metaData = docList[i].data();
      bookings.add(BookingModel.fromMap(metaData));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Find Bookings'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 1, 61, 58),
            foregroundColor: Colors.white,
            actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: getBookings)]),
        body: ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (BuildContext context, index) {
              BookingModel model = bookings[index];
              return InkWell(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking ID: ${model.id}'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('City: ${model.city}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Status: ${model.status}',
                                  style: const TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Trip Date: ${model.tripDate.toString().substring(0, 11)}'),
                            const Text('View User Details', style: TextStyle(color: Colors.blue)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () => Get.to(UserDetailsPage(model, model.user)),
              );
            }));
  }
}
