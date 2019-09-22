import 'package:boots/common_imports.dart';


Widget circleProfile({String pictureUrl, double radius: 50.0}) {

  ImageProvider image = pictureUrl == null ?
    AssetImage('assets/default_profile.jpg') :
    NetworkImage(pictureUrl);

  return CircleAvatar(
    radius: radius,
    backgroundImage: image,
  );
}

Widget fileCircleProfile({File file, double radius: 50.0}) {
  ImageProvider image = file == null ?
    AssetImage('assets/default_profile.jpg') :
    FileImage(file);

  return CircleAvatar(
    radius: radius,
    backgroundImage: image,
  );
}

