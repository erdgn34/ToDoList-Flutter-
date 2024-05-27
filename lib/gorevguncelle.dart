import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GorevGuncelle extends StatefulWidget {
  final QueryDocumentSnapshot gorevVerisi;

  GorevGuncelle({required this.gorevVerisi});

  @override
  _GorevGuncelleState createState() => _GorevGuncelleState();
}


  @override
  State<GorevGuncelle> createState() => _GorevGuncelleState();


class _GorevGuncelleState extends State<GorevGuncelle> {
  late TextEditingController adController;
  late TextEditingController tarihController;

  @override
  void initState() {
    super.initState();
    adController = TextEditingController(text: widget.gorevVerisi['ad']);
    tarihController = TextEditingController(text: widget.gorevVerisi['sonTarih']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Görev Güncelle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: adController,
              decoration: InputDecoration(labelText: "Görev Adı"),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: tarihController,
              decoration: InputDecoration(labelText: "Son Tarih"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Görevi güncelleme işlevini burada çağırabilirsiniz.
                // Örneğin: _goreviGuncelle(adController.text, tarihController.text);
                _goreviGuncelle(widget.gorevVerisi['zaman'], adController.text, tarihController.text);
              },
              child: Text("Görevi Güncelle"),
            ),
          ],
        ),
      ),
    );
  }

  void _goreviGuncelle(String zaman, String yeniAd, String yeniTarih) async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    final User? mevcutKullanici = await yetki.currentUser;

    String uidTutucu = mevcutKullanici!.uid;

    await FirebaseFirestore.instance
        .collection("Gorevler")
        .doc(uidTutucu)
        .collection("Gorevlerim")
        .doc(zaman)
        .update({
      "ad": yeniAd,
      "sonTarih": yeniTarih,
    });

    Navigator.pop(context); // Güncelleme sayfasını kapat
  }
}
