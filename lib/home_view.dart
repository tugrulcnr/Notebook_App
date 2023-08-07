import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notebook/add_note_view.dart';
import 'package:notebook/details_view.dart';
import 'package:notebook/storeData.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String>? topicTexts = [];
  List<String>? mesagesTexts = [];

  @override
  void initState() {
    super.initState();
/*
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      topicTexts = await StoreDate().getStoreData(KeyNames.topics);
      mesagesTexts = await StoreDate().getStoreData(KeyNames.mesaj);
      setState(() {});
    });
    */

    awaitFunc();

    print(topicTexts);
  }

  Future<void> awaitFunc() async {
    topicTexts = await StoreDate().getStoreData(KeyNames.topics);
    mesagesTexts = await StoreDate().getStoreData(KeyNames.mesaj);
    setState(() {});

    print(topicTexts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteView()),
            );
            result ? awaitFunc() : null;
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(),
        body: (topicTexts == null || topicTexts!.isEmpty)
            ? const Center(
                child: Text("Kayıtlı Notunuz Bulunmamaktadır."),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: topicTexts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(topicTexts?[index] ?? "Boş Note"),
                        subtitle: Text(mesagesTexts?[index] ?? "Boş Note"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              topicTexts?.removeAt(index);
                              mesagesTexts?.removeAt(index);

                              StoreDate().saveData(KeyNames.topics, topicTexts ?? []);
                              StoreDate().saveData(KeyNames.mesaj, mesagesTexts ?? []);


                            });
                          },
                        ),
                        onTap: () async {
                          bool result2 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsView(index)));

                          result2 ? awaitFunc() : null;
                        },
                      ),
                      const Divider(),
                    ],
                  );
                }));
  }
}
