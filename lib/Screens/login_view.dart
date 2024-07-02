import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/Screens/custom_text_form_field.dart';
import 'package:egypttourguide/utils/colors_app.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:egypttourguide/utils/custom_text_button.dart';
import 'package:egypttourguide/utils/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../Backend/tour_guide.dart';
import '../Backend/users.dart';
import '../Models/guide_model.dart';
import '../main.dart';

class LoginView extends StatefulWidget {
  final ProfileModel profileModel;

  const LoginView(this.profileModel, {super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
  final ImagePicker _picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsappNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController yearExperience = TextEditingController();
  String image = '';
  final List<String> _cities = getCities();
  late ProfileModel model;
  XFile? pickedImage;
  String initialCountry1 = 'EG';
  String initialCode1 = '+20';
  String initialCountry2 = 'EG';
  String initialCode2 = '+20';

  @override
  void initState() {
    model = widget.profileModel;
    image = model.image;
    name.text = model.name;
    whatsappNumber.text = getPhoneNUmber(model.whatsappNumber);
    initialCountry1 = getCountryCode(model.whatsappNumber);
    initialCode1 = getDialCode(model.whatsappNumber);

    phone.text = getPhoneNUmber(model.phoneNumber);
    initialCountry2 = getCountryCode(model.phoneNumber);
    initialCode2 = getDialCode(model.phoneNumber);
    super.initState();
  }

  Future<void> pickNUpload() async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      String uid = getStorage.read('uid');
      EasyLoading.show();
      try {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref('Profiles/$uid.png')
            .putFile(File(pickedImage!.path));
        String downloadUrl = await task.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'image': downloadUrl});
        setState(() => image = downloadUrl);
        if (EasyLoading.isShow) EasyLoading.dismiss();
        showToast('Successfully uploaded image');
      } catch (e) {
        if (EasyLoading.isShow) EasyLoading.dismiss();
        showToast('Failed to upload image. Please try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: const Text('Tour Guide Registration'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 1, 61, 58),
            foregroundColor: Colors.white),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  image: const AssetImage("assets/images/logo_remove.png"))),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (image.startsWith('http'))
                        InkWell(
                          onTap: pickNUpload,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image:
                                    DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
                          ),
                        ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: name,
                        hintText: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                              controller: whatsappNumber,
                              hintText: 'Whatsapp Number',
                              keyboardType: const TextInputType.numberWithOptions(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: ColorsApp.primaryColor, width: 1.3),
                                  borderRadius: BorderRadius.circular(16.0)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Invalid phone number';
                                }
                                PhoneNumber phoneNumber = phoneUtil.parse(value, initialCountry1);
                                if (!phoneUtil.isValidNumber(phoneNumber)) {
                                  return 'Invalid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CountryCodePicker(
                              onChanged: (value) {
                                initialCountry2 = value.dialCode ?? initialCountry2;
                                initialCode2 = value.dialCode ?? initialCode2;
                              },
                              initialSelection: initialCountry2,
                              favorite: [initialCountry2, 'IN'],
                              showFlag: false),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CustomTextFormField(
                              controller: phone,
                              hintText: 'Phone Number',
                              keyboardType: const TextInputType.numberWithOptions(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: ColorsApp.primaryColor, width: 1.3),
                                  borderRadius: BorderRadius.circular(16.0)),
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: city,
                        hintText: 'Select City',
                        isEnabled: false,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: ColorsApp.primaryColor, width: 1.3),
                            borderRadius: BorderRadius.circular(16.0)),
                        suffixIcon: const Icon(Icons.arrow_drop_down,
                            size: 20, color: ColorsApp.primaryColor),
                        function: () {
                          showListCityDialog(context, size);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select City';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                          controller: experience,
                          hintText: "Enter Your Work Experience",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your work experience';
                            }
                            return null;
                          },
                          maxLines: 5),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: yearExperience,
                        hintText: 'Year of work experience',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your work experience in years';
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: AppTextButton(
                          buttonText: 'Register',
                          textStyle: Styles.font14LightGreyRegular(context),
                          backgroundColor: ColorsApp.darkPrimary,
                          onPressed: () async {
                            bool valid = formKey.currentState?.validate() ?? false;
                            EasyLoading.show();
                            if (valid) {
                              ProfileModel profileModel = ProfileModel(
                                  uid: getStorage.read('uid'),
                                  name: name.text,
                                  mail: model.mail,
                                  image: image,
                                  whatsappNumber:
                                      '$initialCountry1/$initialCode1/${whatsappNumber.text}',
                                  phoneNumber: '$initialCountry2/$initialCode2/${phone.text}',
                                  token: await getToken(),
                                  role: 'USER',
                                  timestamp: DateTime.now());
                              GuideModel guideModel = GuideModel(
                                  uid: model.uid,
                                  city: city.text,
                                  experience: experience.text,
                                  yearExperience: stringToInt(yearExperience.text),
                                  approved: false,
                                  price: 35,
                                  rating: 5,
                                  timestamp: DateTime.now());
                              bool response = await TourGuide().createGuide(guideModel);
                              await Users().updateUser(profileModel);
                              if (EasyLoading.isShow) EasyLoading.dismiss();
                              if (response) Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 100)
            ],
          ),
        ));
  }

  void showListCityDialog(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Select City',
              style: Styles.font14BlueSemiBold(context).copyWith(color: Colors.pink)),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() => city.text = _cities[index]);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Text(
                        _cities[index],
                        style:
                            Styles.font17GreyRegular(context).copyWith(fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.pink),
              ),
            )
          ],
        );
      },
    );
  }
}
