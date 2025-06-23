import 'package:flutter/material.dart';
import 'package:hospitalcrud/api_service.dart';
import 'package:hospitalcrud/view/detail_rumah_sakit.dart';
import 'package:hospitalcrud/view/edit_rumah_sakit.dart';
import 'package:hospitalcrud/view/tambah_rumah_sakit.dart';
import '../model_rumah_sakit.dart';

class ListRumahSakitPage extends StatefulWidget {
  const ListRumahSakitPage({super.key});

  @override
  State<ListRumahSakitPage> createState() => _ListRumahSakitPageState();
}

class _ListRumahSakitPageState extends State<ListRumahSakitPage> {
  late Future<List<RumahSakit>> futureRumahSakit;

  @override
  void initState() {
    super.initState();
    _loadRumahSakit();
  }

  void _loadRumahSakit() {
    setState(() {
      futureRumahSakit = ApiService.getRumahSakit();
    });
  }

  Future<void> _refreshRumahSakit() async {
    _loadRumahSakit();
  }

  Future<void> _deleteRumahSakit(int id) async {
    final success = await ApiService.deleteRumahSakit(id);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data dihapus')),
      );
      _refreshRumahSakit();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus')),
      );
    }
  }

  void _confirmDelete(RumahSakit rs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus "${rs.nama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              _deleteRumahSakit(rs.id!);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 1,
        title: const Text('List Items', style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRumahSakit,
        child: FutureBuilder<List<RumahSakit>>(
          future: futureRumahSakit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
            } else if (snapshot.hasError) {
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Data kosong'));
            }

            final rumahSakitList = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rumahSakitList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rs = rumahSakitList[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F8FF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 28,
                        child: Icon(Icons.local_hospital, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DetailRumahSakitPage(rs: rs)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rs.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rs.type,
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditRumahSakitPage(rumahSakit: rs)),
                          ).then((_) => _refreshRumahSakit());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmDelete(rs),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add),
        label: const Text("Add"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahRumahSakitPage()),
          ).then((_) => _refreshRumahSakit());
        },
      ),
    );
  }
}
