import 'package:boots/common_imports.dart';


var currentUserEmail;


void performSendMessage({CollectionReference messagesCollection, String messageText, File imageFile}) async {

  UserEntry senderEntry = BootsAuth.instance.signedInEntry;

  if (imageFile == null) {
    sendMessage(messagesCollection: messagesCollection, messageText: messageText, imageUrl: null,
    senderEntry: senderEntry);
  } else {
    String imageUrl = await uploadImage(imageFile);
    sendMessage(messagesCollection: messagesCollection, messageText: messageText, imageUrl: imageUrl,
    senderEntry: senderEntry);
  }
}

void sendMessage({CollectionReference messagesCollection, String messageText, String imageUrl,
  UserEntry senderEntry}) {
  messagesCollection.add({
    'text': messageText,
    'email': currentUserEmail,
    'imageUrl': imageUrl,
    'senderName': senderEntry.handle,
    'senderPhotoUrl': senderEntry.dpUrl,
  });
}

