import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'adresse.dart';

RcUser rcUserFromJson(String str) => RcUser.fromJson(jsonDecode(str));
String rcUserToJson(RcUser rcUser) => jsonEncode(rcUser.toJson());

class RcUser {
  String id;
  String nom;
  String prenom;
  String? password;
  String tel1;
  String? tel2;
  String? email;
  String? photo;
  String? profession;
  Adresse? adresse;
  String? aPropos;
  List<String> quality;
  bool admin;
  bool confirmed;
  bool enable;

  RcUser({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.password,
    required this.tel1,
    required this.tel2,
    required this.email,
    required this.photo,
    required this.profession,
    required this.adresse,
    required this.aPropos,
    required this.quality,
    required this.admin,
    required this.confirmed,
    required this.enable,
  });

  factory RcUser.fromDocumentSnapshot(DocumentSnapshot doc) => RcUser(
        id: doc["id"],
        nom: doc["nom"],
        prenom: doc["prenom"],
        password: doc["password"],
        tel1: doc["tel1"],
        tel2: doc["tel2"],
        email: doc["email"],
        photo: doc["photo"],
        profession: doc["profession"],
        adresse:
            doc["adresse"] == null ? null : Adresse.fromJson(doc["adresse"]),
        aPropos: doc["aPropos"],
        quality: List<String>.from(doc["quality"].map((x) => x)),
        admin: doc["admin"],
        confirmed: doc["confirmed"],
        enable: doc["enable"],
      );

  factory RcUser.fromJson(Map<String, dynamic> json) => RcUser(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        password: json["password"],
        tel1: json["tel1"],
        tel2: json["tel2"],
        email: json["email"],
        photo: json["photo"],
        profession: json["profession"],
        adresse:
            json["adresse"] == null ? null : Adresse.fromJson(json["adresse"]),
        aPropos: json["aPropos"],
        quality: List<String>.from(json["quality"].map((x) => x)),
        admin: json["admin"],
        confirmed: json["confirmed"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "password": password,
        "tel1": tel1,
        "tel2": tel2,
        "email": email,
        "photo": photo,
        "profession": profession,
        "adresse": adresse?.toJson(),
        "aPropos": aPropos,
        "quality": List<dynamic>.from(quality.map((e) => e)),
        "admin": admin,
        "confirmed": confirmed,
        "enable": enable,
      };
}
