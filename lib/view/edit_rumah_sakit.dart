import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model_rumah_sakit.dart';
import '../api_service.dart';

class EditRumahSakitPage extends StatefulWidget {
  final RumahSakit rumahSakit;

  const EditRumahSakitPage({super.key, required this.rumahSakit});

  @override
  State<EditRumahSakitPage> createState() => _EditRumahSakitPageState();
}

class _EditRumahSakitPageState extends State<EditRumahSakitPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController telponController;
  late TextEditingController typeController;
  late TextEditingController latController;
  late TextEditingController longController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.rumahSakit.nama);
    alamatController = TextEditingController(text: widget.rumahSakit.alamat);
    telponController = TextEditingController(text: widget.rumahSakit.noTelpon);
    typeController = TextEditingController(text: widget.rumahSakit.type);
    latController = TextEditingController(text: widget.rumahSakit.latitude.toString());
    longController = TextEditingController(text: widget.rumahSakit.longitude.toString());
  }

  Future<void> updateData() async {
    final url = Uri.parse('${ApiService.host}/rumahsakit/${widget.rumahSakit.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nama": namaController.text,
        "alamat": alamatController.text,
        "no_telpon": telponController.text,
        "type": typeController.text,
        "latitude": double.tryParse(latController.text) ?? 0.0,
        "longitude": double.tryParse(longController.text) ?? 0.0,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data')),
      );
    }
  }

  InputDecoration minimalInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: AppBar(
        title: const Text(
          'Edit Rumah Sakit',
          style: TextStyle(color: Colors.redAccent),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(controller: namaController, decoration: minimalInput('Nama')),
                      const SizedBox(height: 12),
                      TextFormField(controller: alamatController, decoration: minimalInput('Alamat')),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: telponController,
                        decoration: minimalInput('Telepon'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(controller: typeController, decoration: minimalInput('Tipe')),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: latController,
                        decoration: minimalInput('Latitude'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: longController,
                        decoration: minimalInput('Longitude'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: updateData,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan Perubahan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
