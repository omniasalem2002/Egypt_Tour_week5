import 'package:egypttourguide/Models/guide_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'tourguide_details.dart';

class CustomGuide extends StatelessWidget {
  final GuideDetails guideDetails;

  const CustomGuide(this.guideDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TourGuideDetail(guideDetails);
              },
            ),
          );
        },
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(guideDetails.image), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.black45, borderRadius: BorderRadius.circular(4)),
                      child: Text('\$${guideDetails.price}',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(guideDetails.name,
                      style: const TextStyle(fontSize: 16, color: Colors.black))),
              RatingBarIndicator(
                  rating: guideDetails.rating,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: Color.fromARGB(255, 255, 17, 1)),
                  itemCount: 5,
                  itemSize: 20),
            ],
          ),
        ));
  }
}
