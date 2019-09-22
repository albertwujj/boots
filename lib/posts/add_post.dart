import 'package:boots/common_imports.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:boots/select_photo.dart';


class NewPostPicture {
  static File picture;
}

class CreatePost extends StatefulWidget {
  CreatePost();
  @override
  State<StatefulWidget> createState() {
    return CreatePostState();
  }
}

class CreatePostState extends State<CreatePost> {

  CreatePostState();
  BuildContext context;
  TextEditingController textController = TextEditingController();
  bool _uploading = false;
  String _pictureUrl;
  bool _clickable = true;


  void uponOpenImageSource(BuildContext context, ImageSource imageSource) async {
    setState(() {
      _uploading = true;
    });
    File picture = await ImagePicker.pickImage(
      source: imageSource,
    );
    picture = await ImageCropper.cropImage(sourcePath: picture.path);
    Navigator.pop(context);
    String pictureUrl = await uploadImage(picture);
    setState(() {
      _pictureUrl = pictureUrl;
      _uploading = false;
    });
  }

  void submitPost() async {
    print('submitPost');
    setState((){
      _clickable = false;
    });
    String body = textController.text ?? "";
    PostEntry postEntry = PostEntry(pictureUrl: _pictureUrl, body: body, likes: 0);
    DocumentReference postRef = await Firestore.instance.collection('Posts').add(postEntry.toDict());

    await BootsAuth.instance.signedInRef.updateData({
      UserKeys.postsList: (BootsAuth.instance.signedInSnap)[UserKeys.postsList] + [postRef.documentID],
    });
    BootsAuth.instance.signedInSnap = await BootsAuth.instance.signedInRef.get();
    Navigator.pop(this.context);
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;

    Widget uploadButton = Icon(Icons.file_upload, size: 140,);
    if (_pictureUrl != null) {
      uploadButton = Image.network(_pictureUrl);
    }
    if (_uploading) {
      uploadButton = Icon(Icons.loop, size: 140,);
    }
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(mainAxisAlignment:MainAxisAlignment.start, children: <Widget>[
          SizedBox(height: 100),
          FlatButton(
            color: Colors.transparent,
            textColor: Colors.green,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () => selectPhoto(context: context, uponOpenImageSource: uponOpenImageSource),
            child: uploadButton,
          ),
          SizedBox(height: 60),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Body',),
            maxLines: 5,
            textInputAction: TextInputAction.done,
            onSubmitted: (String _) { FocusScope.of(context).requestFocus(new FocusNode()); },
            controller: this.textController,
          )
        ],
        ),
        Align(alignment: Alignment.bottomCenter,
            child: Padding(padding: EdgeInsets.only(bottom: 20),
                child: FlatButton(
                  color: Colors.lightGreen,
                  child: Text(
                    'Make post',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (_clickable && !_uploading) {
                      submitPost();
                    }
                  },
                )
            )
        ),
      ]
      )
    );
  }
}
