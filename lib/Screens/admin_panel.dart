import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:flutter/material.dart';
import '../Models/guide_model.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<GuideModel> guides = [];
  List<ProfileModel> profiles = [];
  bool loading = false;

  @override
  void initState() {
    getGuides();
    super.initState();
  }

  Future<void> getGuides() async {
    setState(() => loading = true);
    guides.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Guides')
        .where('approved', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get();
    List<QueryDocumentSnapshot<Object?>> docList = snapshot.docs;
    for (int i = 0; i < docList.length; i++) {
      dynamic map = docList[i].data();
      GuideModel tempGuide = GuideModel.fromMap(map);
      ProfileModel? tempProfile = await getProfile(tempGuide.uid);
      if (tempProfile != null) {
        profiles.add(tempProfile);
        guides.add(tempGuide);
      }
    }
    setState(() => loading = false);
  }

  Future<ProfileModel?> getProfile(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      dynamic map = snapshot.data();
      return ProfileModel.fromMap(map);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> approve(String uid) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({'role': 'GUIDE'}).then((v) async {
      await FirebaseFirestore.instance.collection('Guides').doc(uid).update({'approved': true});
    }).catchError((e) {
      showToast('Failed to update role. Please try again');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Admin Panel'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 1, 61, 58),
            foregroundColor: Colors.white),
        body: !loading
            ? ListView.builder(
                itemCount: guides.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${profiles[index].name}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Phone Number: ${profiles[index].phoneNumber}'),
                          Text('Whatsapp Number: ${profiles[index].whatsappNumber}'),
                          Text('City: ${guides[index].city}'),
                          Text('Rating: ${guides[index].rating}'),
                          Text('Price: ${guides[index].price}'),
                          Text('Experience: ${guides[index].experience}'),
                          Text('Year of Experience: ${guides[index].yearExperience}'),
                          Center(
                            child: ElevatedButton(
                                onPressed: () => approve(guides[index].uid),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 1, 61, 58),
                                    foregroundColor: Colors.white),
                                child: const Text('Approve')),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : const Center(child: CircularProgressIndicator()));
  }
}
