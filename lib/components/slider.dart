import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class SliderCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Container(
       height: height/3,
       child: Carousel(
         boxFit: BoxFit.cover,
         images: [
             AssetImage('assets/images/s3.jpeg'),
             AssetImage('assets/images/s1.jpeg'),
             AssetImage('assets/images/s2.jpeg'),
             AssetImage('assets/images/s4.jpg'),
         ],
         autoplay: false,
         animationCurve: Curves.fastOutSlowIn,
         animationDuration: Duration(milliseconds: 1000),
       ),
    );
  }
}


  