import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notebook/storeData.dart';

import 'costom/elevation_button_widget.dart';
import 'costom/textfiel_widget.dart';

// ignore: must_be_immutable
class AddNoteView extends StatefulWidget {
  AddNoteView({super.key});
  List<String>? localTopicTexts;
  List<String>? localMesageTexts;

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final topicController = TextEditingController();
  final messageController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables

  var storeData = StoreDate();
  List<String>? topicTexts;
  List<String>? mesajTexts;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      topicTexts = await storeData.getStoreData(KeyNames.topics);
      widget.localTopicTexts = topicTexts;

      mesajTexts = await storeData.getStoreData(KeyNames.mesaj);
      widget.localMesageTexts = mesajTexts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      floatingActionButton: MyButtonWidget(
        onPressed: () async {
          widget.localTopicTexts?.add(topicController.text);
          storeData.saveData(KeyNames.topics, widget.localTopicTexts ?? []);
          widget.localMesageTexts?.add(messageController.text);
          storeData.saveData(KeyNames.mesaj, widget.localMesageTexts ?? []);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Yeni Not eklendi"),
          ));
        },
        bottomText: "Kaydet",
      ),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFieldWidget(
          text: 'Başlık',
          size: 30,
          maxLineSize: 1,
          textController: topicController,
        ),
        const Divider(),
        TextFieldWidget(
          text: 'Yazmaya başla',
          size: 20,
          maxLineSize: 25,
          textController: messageController,
        ),
      ]),
    );
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Yeni Not Ekle",
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
