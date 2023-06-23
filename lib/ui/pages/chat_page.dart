import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/models/message_chat.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/chat_provider.dart';
import 'package:mental_health_app/ui/pages/login_page.dart';
import 'package:mental_health_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final ChatPageArguments arguments;

  const ChatPage({super.key, required this.arguments});

  static const route = '/chat_page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];

  String groupChatId = "";

  File? imageFile;
  File? documentFile;
  bool isLoading = false;
  bool isShowSticker = false;
  bool isShowAddFile = false;
  String fileUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(() {});
    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseId()!;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false);
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatProvider.updateDataFirestore(
        collectionPath: 'user',
        docPath: currentUserId,
        dataNeedUpdate: {'chattingWith': peerId});
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowAddFile = false;
      isShowSticker = !isShowSticker;
    });
  }

  void showAddFile() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = false;
      isShowAddFile = !isShowAddFile;
    });
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: kColorIconGrey);
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") == currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future getImageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  Future getImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  Future getDocumentFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'csv', 'xlsx', 'docx', 'pptx'],
      allowMultiple: false,
    );
    if (pickedFile != null) {
      documentFile = File(pickedFile.files.single.path!);
      if (documentFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadDocumentFile();
      }
    }
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      fileUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(fileUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  // TODO Tampilin di list message, desain tampilanny
  Future uploadDocumentFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(documentFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      fileUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(fileUrl, TypeMessage.document);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else if (isShowAddFile) {
      setState(() {
        isShowAddFile = false;
      });
    } else {
      chatProvider.updateDataFirestore(
          collectionPath: 'user',
          docPath: currentUserId,
          dataNeedUpdate: {'chattingWith': null});
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: CachedNetworkImage(
                imageUrl: widget.arguments.peerAvatar,
                fit: BoxFit.cover,
                width: 35,
                height: 35,
                progressIndicatorBuilder: (context, url, loadingProgress) {
                  return SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.green,
                            value: loadingProgress.progress)),
                  );
                },
                errorWidget: (context, url, error) => const Icon(
                  Icons.account_circle,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.arguments.peerNickname),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                buildListMessage(),
                isShowSticker ? buildSticker() : const SizedBox.shrink(),
                isShowAddFile ? buildAddFile() : const SizedBox.shrink(),
                buildInput()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildListMessage() {
    return Flexible(
        child: groupChatId.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChatStream(groupChatId, 20),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listMessage = snapshot.data!.docs;
                    if (listMessage.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]),
                      );
                    } else {
                      return const Center(
                        child: Text('No message here yet...'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kColorOrange,
                ),
              ));
  }

  Widget buildLoading() {
    return Positioned(
        child: isLoading ? const LoadingView() : const SizedBox.shrink());
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // My message (Right)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageChat.type == TypeMessage.text
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: kColorGrey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(messageChat.content),
                  )
                : messageChat.type == TypeMessage.image
                    ? Container(
                        constraints:
                            const BoxConstraints(maxWidth: 200, maxHeight: 200),
                        margin: const EdgeInsets.only(bottom: 10, left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: messageChat.content,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            right: 10,
                            bottom: isLastMessageRight(index) ? 20 : 10),
                        child: Image.asset(
                          "assets/images/${messageChat.content}.gif",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
          ],
        );
      } else {
        // Peer message (Left)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  messageChat.type == TypeMessage.text
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: 200,
                          decoration: BoxDecoration(
                              color: kColorIconGrey,
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(messageChat.content),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 200, maxHeight: 200),
                              margin:
                                  const EdgeInsets.only(bottom: 10, left: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                      imageUrl: messageChat.content)),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  right: 10,
                                  bottom: isLastMessageRight(index) ? 20 : 10),
                              child: Image.asset(
                                "assets/images/${messageChat.content}.gif",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                ],
              ),
              isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(messageChat.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: kColorSoftGrey,
                            fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: kColorGrey, width: 0.5)),
            color: Colors.white),
        padding: const EdgeInsets.all(5),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 1; i < 4; i++)
                  TextButton(
                      onPressed: () => onSendMessage(
                          'mimi${i.toString()}', TypeMessage.sticker),
                      child: Image.asset(
                        'assets/images/mimi${i.toString()}.gif',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 4; i < 7; i++)
                  TextButton(
                      onPressed: () => onSendMessage(
                          'mimi${i.toString()}', TypeMessage.sticker),
                      child: Image.asset(
                        'assets/images/mimi${i.toString()}.gif',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 7; i < 10; i++)
                  TextButton(
                      onPressed: () => onSendMessage(
                          'mimi${i.toString()}', TypeMessage.sticker),
                      child: Image.asset(
                        'assets/images/mimi${i.toString()}.gif',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddFile() {
    return Expanded(
      flex: 0,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: kColorGrey, width: 0.5)),
            color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 15),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: getImageFromCamera,
                tooltip: 'Camera',
                icon: const Icon(Icons.camera, color: kColorOrange)),
            IconButton(
                onPressed: getImageFromGallery,
                tooltip: 'Gallery',
                icon: const Icon(Icons.image, color: kColorOrange)),
            IconButton(
                onPressed: getDocumentFile,
                tooltip: 'Document',
                icon: const Icon(Icons.document_scanner, color: kColorOrange)),
          ],
        ),
      ),
    );
  }

  Container buildInput() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kColorIconGrey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: showAddFile,
                color: kColorOrange,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.face),
                onPressed: getSticker,
                color: kColorOrange,
              ),
            ),
          ),
          Flexible(
            child: TextField(
              onSubmitted: (value) {},
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: kColorIconGrey)),
              focusNode: focusNode,
              autofocus: true,
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                color: kColorOrange,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(this.peerId, this.peerAvatar, this.peerNickname);
}
