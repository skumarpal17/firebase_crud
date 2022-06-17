import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Crude',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Crud();
  }
}

class Crud extends StatefulWidget {
  const Crud({Key? key}) : super(key: key);

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  CollectionReference firebase =
      FirebaseFirestore.instance.collection('mycrud');
  // final snapShot = FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(varuId) // varuId in your case
  //     .get();

  TextEditingController mytext = TextEditingController();
  // final QuerySnapshot snap ;
  String text2 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crud")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextField(
                controller: mytext,
                onChanged: (value) {
                  text2 = value;
                },
                decoration: InputDecoration(
                    hintText: 'Write your data', border: OutlineInputBorder()),
              ),
            ),
            ////////////////////////////////////////////////////////////////////// sending data into firebase
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    mytext.text = "";
                  });
                  await firebase.add({'input': text2});
                },
                child: Text("Submit")),
            //////////////////////////////////////////////////////////////////////
            StreamBuilder(
                stream: firebase.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data"),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['input']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              highlightColor: Colors.red,
                              onPressed: () {
                                // snapshot.data!.docs([doc.documentID]).delete();
                                // FirebaseFirestore.instance.collection('mycrud').docs().delete();
                                print(index);
                                var a = snapshot.data!.docs[index].id;
                                FirebaseFirestore.instance
                                    .collection('mycrud')
                                    .doc(a)
                                    .delete();
                                print(a);
                              },
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
