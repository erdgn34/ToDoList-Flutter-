import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEkle extends StatefulWidget {
  const GorevEkle({super.key});

  @override
  State<GorevEkle> createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  //verileir kontrollerden alıcı
  TextEditingController adAlici=TextEditingController();
  TextEditingController tarihAlici=TextEditingController();

  //Verileri ekleme
  verileriEkle()async{
    FirebaseAuth yetki =FirebaseAuth.instance;
    final User? mevcutKullanici =await yetki.currentUser;

    String uidTutucu=mevcutKullanici!.uid;
    var zamanTutucu =DateTime.now();
    await FirebaseFirestore.instance.collection("Gorevler").doc(uidTutucu).collection("Gorevlerim").doc(zamanTutucu.toString()).set({
      "ad":adAlici.text,"sonTarih":tarihAlici.text,"zaman":zamanTutucu.toString(),"tamZaman":zamanTutucu,
    });
    Fluttertoast.showToast(msg: "Gorev Eklendi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gorev Ekle",
      style: TextStyle(fontStyle: FontStyle.italic,),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: adAlici,
            decoration: InputDecoration(
                    labelText: "Gorev Adı",
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber,width: 3,),
                   ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber,width: 2),
                    ),
                  ),
          ),
        ),
           Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: tarihAlici,
            decoration: InputDecoration(
                    labelText: "Son Tarihi",
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber,width: 3,),
                   ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber,width: 2),
                    ),
                  ),
          ),
        ),

        Container(
          width: 380,
          
          padding: EdgeInsets.only(top: 10),
          child: ElevatedButton(onPressed: (){
            //gorevi firebase e ekleyecek
            verileriEkle();
          }, 
           style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shadowColor: Colors.black,
                
                ),
          child: Text("Gorevi Ekle",
          style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
          )
          ),
        )
      ],
      ),
    ),
      
    );
  }
}