import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


Widget circleProfile({String pictureUrl}) {
  return CircleAvatar(backgroundImage:
    pictureUrl == null ? AssetImage('assets/default_profile.jpg') : NetworkImage(pictureUrl),
  );
}


Widget containerImage({String pictureUrl, double height: 300.0, double width: 300.0}){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        image: DecorationImage(
          image: pictureUrl == null ?
          AssetImage('assets/default_profile.jpg')
              : NetworkImage(pictureUrl),
          fit: BoxFit.fill,
        )
    ),
  );
}

