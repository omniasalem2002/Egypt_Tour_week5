import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:egypttourguide/Backend/users.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/Screens/admin_panel.dart';
import 'package:egypttourguide/Screens/country_city_selection.dart';
import 'package:egypttourguide/Screens/find_bookings.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../utils/colors_app.dart';
import 'custom_text_form_field.dart';
import 'login_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List imageList = [
    {"id": 1, "image_path": 'assets/images/1.png'},
    {"id": 2, "image_path": 'assets/images/1.jpg'},
    {"id": 3, "image_path": 'assets/images/2.jpg'},
    {"id": 4, "image_path": 'assets/images/3.jpg'},
    {"id": 5, "image_path": 'assets/images/4.jpg'},
    {"id": 6, "image_path": 'assets/images/5.jpg'},
    {"id": 7, "image_path": 'assets/images/6.jpg'},
    {"id": 8, "image_path": 'assets/images/7.jpg'}
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  ProfileModel? model;
  String initialCountry1 = 'EG';
  String initialCode1 = '+20';
  String initialCountry2 = 'EG';
  String initialCode2 = '+20';
  final PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;

  @override
  void initState() {
    getProfileData();
    Permission.notification.request();
    super.initState();
  }

  Future<void> getProfileData() async {
    model = await Users().getProfileData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home Screen"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 1, 61, 58),
          foregroundColor: Colors.white,
          actions: [
            if (getStorage.read('uid') == 'xjHersHhIPPiFq48C43ZSXxZEUK2')
              IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () => Get.to(() => const AdminPanel()))
          ]),
      body: model != null
          ? ListView(children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: CarouselSlider(
                          items: imageList
                              .map(
                                (item) => Image.asset(
                                  item['image_path'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                              .toList(),
                          carouselController: carouselController,
                          options: CarouselOptions(
                            scrollPhysics: const BouncingScrollPhysics(),
                            autoPlay: true,
                            aspectRatio: 0.8,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: currentIndex == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentIndex == entry.key
                                    ? Colors.red
                                    : Colors.teal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Guru app connects ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Tourists ",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 1, 61, 58),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "with ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Tour Guides ",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 1, 61, 58),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (model!.role != 'GUIDE')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 61, 58),
                        minimumSize: const Size(225, 40),
                      ),
                      onPressed: () async {
                        if (model == null) {
                          showToast('Failed to get User details');
                          return;
                        } else if (model!.whatsappNumber.isEmpty) {
                          profileUpdateWidget(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const CountryCitySelection();
                              },
                            ),
                          );
                        }
                      },
                      label: const Text("Search Tour Guides",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              model!.role == 'GUIDE'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 61, 58),
                            minimumSize: const Size(200, 40),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const FindBookings();
                                },
                              ),
                            );
                          },
                          label: const Text("Find Bookings",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 61, 58),
                            minimumSize: const Size(200, 40),
                          ),
                          onPressed: () async {
                            EasyLoading.show();
                            if (EasyLoading.isShow) EasyLoading.dismiss();
                            if (model == null) {
                              showToast('Failed to get User details');
                              return;
                            } else if (model!.whatsappNumber.isEmpty) {
                              profileUpdateWidget(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginView(model!);
                                  },
                                ),
                              );
                            }
                          },
                          label: const Text("Tour Guide Registration",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
            ])
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void profileUpdateWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController controller = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 260,
              width: size.width * 0.8,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Update phone numbers',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        CountryCodePicker(
                            onChanged: (value) {
                              initialCountry1 = value.code ?? initialCountry1;
                              initialCode1 = value.dialCode ?? initialCode1;
                            },
                            initialSelection: initialCountry1,
                            favorite: [initialCountry1, 'IN'],
                            showFlag: false),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: CustomTextFormField(
                            controller: controller,
                            hintText: 'Whatsapp Number',
                            isEnabled: true,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorsApp.primaryColor, width: 1.3),
                                borderRadius: BorderRadius.circular(16.0)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid phone number';
                              }
                              PhoneNumber phoneNumber =
                                  phoneUtil.parse(value, initialCountry1);
                              if (!phoneUtil.isValidNumber(phoneNumber)) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CountryCodePicker(
                            onChanged: (value) {
                              initialCountry2 =
                                  value.dialCode ?? initialCountry2;
                              initialCode2 = value.dialCode ?? initialCode2;
                            },
                            initialSelection: initialCountry2,
                            favorite: [initialCountry2, 'IN'],
                            showFlag: false),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: CustomTextFormField(
                            controller: controller2,
                            hintText: 'Phone Number',
                            isEnabled: true,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorsApp.primaryColor, width: 1.3),
                                borderRadius: BorderRadius.circular(16.0)),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (!(formKey.currentState?.validate() ?? true))
                              return;
                            EasyLoading.show();
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(getStorage.read('uid'))
                                .update({
                              'whatsappNumber':
                                  '$initialCountry1/$initialCode1/${controller.text}',
                              'phoneNumber':
                                  '$initialCountry2/$initialCode2/${controller2.text}'
                            }).then((value) async {
                              await getProfileData();
                              showToast('Successfully updated details');
                            }).catchError((e) {
                              showToast('Failed to update. $e');
                            });
                            if (EasyLoading.isShow) EasyLoading.dismiss();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
