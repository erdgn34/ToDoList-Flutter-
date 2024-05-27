import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({super.key});

  @override
  State<KayitFormu> createState() => _KayitFormuState();
}
//Kayıtlı kullanıcı olma durumu global degisken
  bool kayitDurumu=false;

class _KayitFormuState extends State<KayitFormu> {
  //Kayıt parametreleri
   String? kullaniciAdi,email,sifre;
  //Dogrulama anahtari
  var dogrulamaAnahtari=GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Form(
            key: dogrulamaAnahtari,
            child: Container(
              height: 200,
              child: Image.asset("images/todo.jpg")
              ),
            ),
            if(!kayitDurumu)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (alinanAd){
                  kullaniciAdi=alinanAd;
                },
                validator:(alinanAd){
                  
                    return  alinanAd!.isEmpty ?"Bos Bırakılamaz!": null;
                  
                },
                decoration: InputDecoration(
                  labelText: "Kullanıcı Adı Girin",
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
                onChanged: (alinanMail){
                  email=alinanMail;
                },
                keyboardType: TextInputType.emailAddress,
                validator:(alinanMail){
                  return alinanMail!.contains("@")?null:"Geçersiz  email";
                } ,
                decoration: InputDecoration(
                  labelText: "Email Girin",
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber,width: 3),
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
                obscureText: true,
                onChanged: (alinanSifre){
                  sifre=alinanSifre;
                },
                validator: (alinanSifre){
                  return alinanSifre!.length>=6?null:"En az altı karakter..";
                },
                decoration: InputDecoration(
                  labelText: "Sifre Girin",
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber,width: 3),
                 ),
                  enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber,width: 2),
                  ),
                ),
              ),
            ),
             SizedBox(
              height: 10,
            ),
            Padding(
              
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){
                  kayitEkle();
                },
               child:kayitDurumu? Text("Giris Yap",
               style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
               ):Text("Kaydol",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shadowColor: Colors.black,
                
                ),
               ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){
                setState(() {
                  kayitDurumu=!kayitDurumu;
                });
              }, 
              
              child: kayitDurumu?
              Text("Hesabım Yok..",
              style: TextStyle(color: Colors.black),):
              Text("Zaten hesabım var.",
              style: TextStyle(color: Colors.black),)
              ),
            ),
             

        ],
      ),
    );
  }
  
  void kayitEkle() {
    //veriyi dogrulayıp kullanıcı kaydı yapılacak
    if(dogrulamaAnahtari.currentState!.validate()){
      //Firebase e veri ekle
      if(kullaniciAdi != null && email != null && sifre != null){
        formuTeslimEt( kullaniciAdi!,email!,sifre!);
      }
    
    }
  }
  formuTeslimEt(String kullaniciAdi,String email,String sifre) async {
        final yetki=FirebaseAuth.instance;
      
        UserCredential yetkiSonucu;
        //Kayıt durumu true ise giris yapacak
        if(kayitDurumu){
          //giris yapacak
           yetkiSonucu=await yetki.signInWithEmailAndPassword(email: email, password: sifre);

        }
        //Kayıt durumu false ise kaydol
        else{
          //kaydol
          yetkiSonucu=await yetki.createUserWithEmailAndPassword(email: email, password: sifre);
          String uidTutucu=yetkiSonucu.user!.uid;
          await FirebaseFirestore.instance.collection("Kullanicilar").doc(uidTutucu).set({
            "kullaniciAdi":kullaniciAdi,"email":email
          });
        }
      }      
}