import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List news = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController t1 = TextEditingController();
              TextEditingController t2 = TextEditingController();
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: t1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: t2,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addInfo(t1.text, t2.text);
                      },
                      child: Text('add'),
                    )
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: readInfoStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),

              );
            })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }

  addInfo(String title, String image) {
    final db = FirebaseFirestore.instance.collection("news");
    db.add({
      "title": title,
      "image": image,
    });
  }

  readInfo() async {
    List news = [];
    final ref = await FirebaseFirestore.instance.collection("news").get();
    for (var n in ref.docs) {
      print(n.data());
      news.add(n.data());
    }
    return news;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readInfoStream() {
    return FirebaseFirestore.instance.collection("news").snapshots();
  }
}
