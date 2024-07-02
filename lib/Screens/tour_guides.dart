import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/guide_model.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:flutter/material.dart';
import '../Models/guide_details.dart';
import 'custom_guide.dart';

class TourGuides extends StatefulWidget {
  final String city;

  const TourGuides({super.key, required this.city});

  @override
  State<TourGuides> createState() => _TourGuidesState();
}

class _TourGuidesState extends State<TourGuides> {
  List<GuideDetails> guides = [];
  bool loading = false;

  @override
  void initState() {
    getGuides();
    super.initState();
  }

  Future<void> getGuides() async {
    setState(() => loading = true);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Guides')
        .where('city', isEqualTo: widget.city)
        .where('approved', isEqualTo: true)
        .get();
    List<QueryDocumentSnapshot<Object?>> docList = snapshot.docs;
    for (int i = 0; i < docList.length; i++) {
      dynamic metaData = docList[i].data();
      GuideModel guideModel = GuideModel.fromMap(metaData);
      ProfileModel? profileModel = await getProfileData(guideModel.uid);
      if (profileModel == null) continue;
      GuideDetails guideDetails = GuideDetails(
          uid: profileModel.uid,
          name: profileModel.name,
          mail: profileModel.mail,
          phoneNumber: profileModel.phoneNumber,
          image: profileModel.image,
          city: guideModel.city,
          rating: guideModel.rating,
          experience: guideModel.experience,
          price: guideModel.price,
          token: profileModel.token,
          approved: guideModel.approved);
      guides.add(guideDetails);
    }
    setState(() => loading = false);
  }

  Future<ProfileModel?> getProfileData(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (!snapshot.exists) return null;
    dynamic map = snapshot.data();
    return ProfileModel.fromMap(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.city),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 1, 61, 58),
          foregroundColor: Colors.white,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : guides.isNotEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth ~/ 150).toInt();
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: guides.length,
                          itemBuilder: (context, index) {
                            return CustomGuide(guides[index]);
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                            'No tour guide is available for this city. Please try again later',
                            style: TextStyle(color: Colors.red, fontSize: 16))),
                  ));
  }
}
