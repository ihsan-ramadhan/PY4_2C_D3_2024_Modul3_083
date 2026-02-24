import 'package:flutter/material.dart';
import 'log_controller.dart';
import 'models/log_model.dart';
import '../onboarding/onboarding_view.dart';

class LogView extends StatefulWidget {
  final String username;
  const LogView({super.key, required this.username});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  final LogController _controller = LogController();

  // 1. Tambahkan Controller untuk menangkap input di dalam State
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "Pribadi";
  final List<String> _categories = ["Pribadi", "Pekerjaan", "Tugas"];

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Pekerjaan": return Colors.orange;
      case "Tugas": return Colors.red;
      default: return Colors.blue;
    }
  }

  void _showAddLogDialog() {
    _selectedCategory = "Pribadi";
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Tambah Catatan Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Judul Catatan"),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: "Isi Deskripsi"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setDialogState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                _controller.addLog(_titleController.text, _contentController.text, _selectedCategory);
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditLogDialog(int index, LogModel log) {
    _titleController.text = log.title;
    _contentController.text = log.description;
    _selectedCategory = log.category;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Edit Catatan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController),
              TextField(controller: _contentController),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setDialogState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                _controller.updateLog(index, _titleController.text, _contentController.text, _selectedCategory);
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const OnboardingView()),
                        (route) => false
                );
              },
              child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logbook: ${widget.username}"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari berdasarkan judul...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<LogModel>>(
              valueListenable: _controller.logsNotifier,
              builder: (context, currentLogs, child) {
                final filteredLogs = currentLogs.where((log) => log.title.toLowerCase().contains(_searchQuery)).toList();

                if (filteredLogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/catat.png', height: 180, errorBuilder: (c, e, s) => const Icon(Icons.note_add, size: 80)),
                        const SizedBox(height: 16),
                        const Text("Tidak ada catatan.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    final originalIndex = currentLogs.indexOf(log);
                    final color = _getCategoryColor(log.category);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: color.withOpacity(0.5), width: 1),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(log.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: Text(log.category, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        subtitle: Text(log.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _showEditLogDialog(originalIndex, log)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => _controller.removeLog(originalIndex)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLogDialog, // Panggil fungsi dialog yang baru dibuat
        child: const Icon(Icons.add),
      ),
    );
  }
}