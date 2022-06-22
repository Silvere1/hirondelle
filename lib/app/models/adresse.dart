class Adresse {
  String? pays;
  String? ville;
  String? quartier;
  String? description;

  Adresse({
    required this.pays,
    required this.ville,
    required this.quartier,
    required this.description,
  });

  factory Adresse.fromJson(Map<String, dynamic> json) => Adresse(
      pays: json["pays"],
      ville: json["ville"],
      quartier: json["quartier"],
      description: json["description"]);

  Map<String, dynamic> toJson() => {
        "pays": pays,
        "ville": ville,
        "quartier": quartier,
        "description": description,
      };
}
