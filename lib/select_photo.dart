import 'package:boots/common_imports.dart';

import 'package:image_picker/image_picker.dart';


Future<void> selectPhoto({BuildContext context, var uponOpenImageSource}) async {
  await showDialog(context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              GestureDetector(
                child: new Text('Take a picture'),
                onTap: () => uponOpenImageSource(context, ImageSource.camera),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              GestureDetector(
                child: new Text('Select from gallery'),
                onTap: () => uponOpenImageSource(context, ImageSource.gallery),
              ),
              ],
            ),
          ),
      );
    }
  );
}
