import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notebook/costom/elevation_button_widget.dart';
import 'package:notebook/storeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'costom/textfiel_widget.dart';

class DetailsView extends StatefulWidget {
  DetailsView(this.index, {super.key});
  List<String>? localTopicTexts;
  List<String>? localMesageTexts;
  int index;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> with ProjectString{
  final topicController = TextEditingController();
  final messageController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables

  var storeData = StoreDate();
  List<String>? topicTexts;
  List<String>? mesajTexts;

  @override
  void initState() {
    super.initState();
    inigetValue();

  }

  Future<void> inigetValue() async {
    topicTexts = await storeData.getStoreData(KeyNames.topics);
      widget.localTopicTexts = topicTexts;
      topicController.text = widget.localTopicTexts!.isNotEmpty
          ? widget.localTopicTexts![widget.index]
          : notValue;


      mesajTexts = await storeData.getStoreData(KeyNames.mesaj);
      widget.localMesageTexts = mesajTexts;
      messageController.text = widget.localMesageTexts!.isNotEmpty
          ? widget.localMesageTexts![widget.index]
          : notValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyButtonWidget(
        onPressed: () async {
          //await prefs!.setString('action', topicController.text);

          widget.localTopicTexts?[widget.index] = topicController.text;
          storeData.saveData(KeyNames.topics, widget.localTopicTexts ?? []);
//         inspect(widget.localTopicTexts);

          widget.localMesageTexts?[widget.index] = messageController.text;
          storeData.saveData(KeyNames.mesaj, widget.localMesageTexts ?? []);
          //       inspect(mesajTexts);
        }, bottomText: "Güncelle",
      ),
      appBar: const MyAppBar(),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFieldWidget(
          text: titleHint,
          size: 30,
          maxLineSize: 1,
          textController: topicController,
        ),
        const Divider(),
        TextFieldWidget(
          text: subTitleHint,
          size: 20,
          maxLineSize: 10,
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



class ProjectString {
  String notValue = "Liste boş";
  String titleHint ='Başlık';
  String subTitleHint ='Yazmaya başla';
}