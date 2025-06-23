// To parse this JSON data, do
//
//     final rumahSakit = rumahSakitFromJson(jsonString);

import 'dart:convert';

List<RumahSakit> rumahSakitFromJson(String str) => List<RumahSakit>.from(
    json.decode(str).map((x) => RumahSakit.fromJson(x)));

String rumahSakitToJson(List<RumahSakit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RumahSakit {
  int? id;
  String nama;
  String alamat;
  String noTelpon;
  String type;
  double latitude;
  double longitude;

  RumahSakit({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory RumahSakit.fromJson(Map<String, dynamic> json) => RumahSakit(
    id: json["id"],
    nama: json["nama"],
    alamat: json["alamat"],
    noTelpon: json["no_telpon"],
    type: json["type"],
    latitude: (json["latitude"] as num).toDouble(),
    longitude: (json["longitude"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "alamat": alamat,
    "no_telpon": noTelpon,
    "type": type,
    "latitude": latitude,
    "longitude": longitude,
  };
}
