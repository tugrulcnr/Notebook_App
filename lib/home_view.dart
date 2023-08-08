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
  final TextEditingController _searchController = TextEditingController();

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
  }

  Future<void> awaitFunc() async {
    topicTexts = await StoreDate().getStoreData(KeyNames.topics);
    mesagesTexts = await StoreDate().getStoreData(KeyNames.mesaj);
    setState(() {});
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
        appBar: AppBar(
          title: Text(
            "Notlarım",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        body: Column(
          children: [
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (text) {
                  filterList(text);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Kelime veya metin ara.',
                ),
              ),
            ),
            (topicTexts == null || topicTexts!.isEmpty)
                ? const Center(
                    child: Text("Kayıtlı Notunuz Bulunmamaktadır."),
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: topicTexts?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  topicTexts?[index] ?? "Boş Note",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                    mesagesTexts?[index] ?? "Boş Note",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      topicTexts?.removeAt(index);
                                      mesagesTexts?.removeAt(index);

                                      StoreDate().saveData(
                                          KeyNames.topics, topicTexts ?? []);
                                      StoreDate().saveData(
                                          KeyNames.mesaj, mesagesTexts ?? []);
                                    });
                                  },
                                ),
                                onTap: () async {
                                  bool result2 = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsView(index)));

                                  result2 ? awaitFunc() : null;
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        }),
                  ),
          ],
        ));
  }

  void filterList(String searchText) async {
  if (searchText.isEmpty) {
    topicTexts = await StoreDate().getStoreData(KeyNames.topics);
    mesagesTexts = await StoreDate().getStoreData(KeyNames.mesaj);
  } else {
    List<String> filteredTopics = [];
    List<String> filteredMessages = [];

    for (int i = 0; i < topicTexts!.length; i++) {
      if (topicTexts![i].toLowerCase().contains(searchText.toLowerCase())) {
        filteredTopics.add(topicTexts![i]);
        filteredMessages.add(mesagesTexts![i]);
      }
    }

    topicTexts = filteredTopics;
    mesagesTexts = filteredMessages;
  }

  setState(() {});
}

}
