import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_service.dart';

class TambahRumahSakitPage extends StatefulWidget {
  const TambahRumahSakitPage({super.key});

  @override
  State<TambahRumahSakitPage> createState() => _TambahRumahSakitPageState();
}

class _TambahRumahSakitPageState extends State<TambahRumahSakitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController telponController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  Future<void> simpanData() async {
    final url = Uri.parse('${ApiService.host}/rumahsakit');

    final response = await http.post(
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

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        centerTitle: true,
        elevation: 1,
        title: const Text(
          'Tambah Rumah Sakit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                      TextFormField(controller: namaController, decoration: inputStyle('Nama')),
                      const SizedBox(height: 12),
                      TextFormField(controller: alamatController, decoration: inputStyle('Alamat')),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: telponController,
                        decoration: inputStyle('Telepon'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(controller: typeController, decoration: inputStyle('Tipe')),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: latController,
                        decoration: inputStyle('Latitude'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: longController,
                        decoration: inputStyle('Longitude'),
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
                child: ElevatedButton(
                  onPressed: simpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
