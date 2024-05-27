import 'package:flutter/material.dart';
import 'package:yapilacaklarlistesi/kayitformu.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ekranı"),
        
      ),
      body: KayitFormu()
    );

  }
}