import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapilacaklarlistesi/gorevekle.dart';
import 'package:yapilacaklarlistesi/gorevguncelle.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  String? mevcutKullaniciUidTutucu;

  @override
  void initState() {
    super.initState();
    mevcutKullaniciUidsiAl();
  }

  mevcutKullaniciUidsiAl() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    final User mevcutKullanici = await yetki.currentUser!;

    setState(() {
      mevcutKullaniciUidTutucu = mevcutKullanici.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yapılacaklar",
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Gorevler").doc(mevcutKullaniciUidTutucu).collection("Gorevlerim").snapshots(),
          builder: (context, veriTabaniVerilerim) {
            if (veriTabaniVerilerim.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final alinanVeri = veriTabaniVerilerim.data!.docs;
              return ListView.builder(
                itemCount: alinanVeri.length,
                itemBuilder: (context, index) {
                  var eklenmeZamani = (alinanVeri[index]["tamZaman"] as Timestamp).toDate();

                  return Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 3),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alinanVeri[index]["ad"],
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.yMd().add_jm().format(eklenmeZamani).toString(),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                alinanVeri[index]["sonTarih"],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("Gorevler")
                                  .doc(mevcutKullaniciUidTutucu)
                                  .collection("Gorevlerim")
                                  .doc(alinanVeri[index]["zaman"])
                                  .delete();
                            },
                            icon: Icon(Icons.delete),
                          ),
                          ElevatedButton(
                         onPressed: () {
            Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => GorevGuncelle(gorevVerisi: alinanVeri[index] as QueryDocumentSnapshot),
    ),
  );
},
                         style: ElevatedButton.styleFrom(
                       primary: Colors.green, // Renk değişebilir
                       ),
                        child: Text("Güncelle"),
                              ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => GorevEkle()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}