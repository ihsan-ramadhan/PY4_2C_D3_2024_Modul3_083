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
  String _selectedCategory = "Pribadi";
  final List<String> _categories = ["Pribadi", "Pekerjaan", "Tugas"];

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Pekerjaan": return Colors.orange;
      case "Tugas": return Colors.red;
      default: return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Pekerjaan":
        return Icons.work_outline_rounded;
      case "Tugas":
        return Icons.assignment_outlined;
      default:
        return Icons.person_outline_rounded;
    }
  }

  InputDecoration _fieldDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  void _showAddLogDialog() {
    _selectedCategory = "Pribadi";
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1565C0)),
              SizedBox(width: 8),
              Text(
                "Catatan Baru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
            children: [
              TextField(
                controller: _titleController,
                decoration: _fieldDecoration(
                  "Judul catatan",
                  icon: Icons.title_rounded,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                decoration: _fieldDecoration("Isi deskripsi"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _fieldDecoration(
                  "Kategori",
                  icon: Icons.label_outline_rounded,
                ),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) =>
                    setDialogState(() => _selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _controller.addLog(
                  _titleController.text,
                  _contentController.text,
                  _selectedCategory,
                );
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
                setState(() {});
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.edit_outlined, color: Color(0xFF1565C0)),
              SizedBox(width: 8),
              Text(
                "Edit Catatan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: _fieldDecoration(
                  "Judul catatan",
                  icon: Icons.title_rounded,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                decoration: _fieldDecoration("Isi deskripsi"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _fieldDecoration(
                  "Kategori",
                  icon: Icons.label_outline_rounded,
                ),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) =>
                    setDialogState(() => _selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _controller.updateLog(
                  index,
                  _titleController.text,
                  _contentController.text,
                  _selectedCategory,
                );
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
                setState(() {});
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingView()),
                (route) => false,
              );
            },
            child: const Text("Ya, Keluar"),
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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Logbook",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              "Halo, ${widget.username}!",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari catatan...",
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.blueGrey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1565C0),
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              onChanged: (value) => _controller.searchLog(value),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<LogModel>>(
              valueListenable: _controller.filteredLogs,
              builder: (context, filteredLogs, child) {
                final currentLogs = _controller.logsNotifier.value;

                if (filteredLogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/notfound.png',
                            height: 100,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.note_alt_outlined,
                              size: 60,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum ada catatan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tekan + untuk menambah catatan baru",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 80),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    final originalIndex = currentLogs.indexOf(log);
                    final color = _getCategoryColor(log.category);
                    final catIcon = _getCategoryIcon(log.category);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      child: Dismissible(
                        key: Key('${log.title}_$originalIndex'),
                        direction: DismissDirection.endToStart,
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                          ),
                        ),
                        background: const SizedBox.shrink(),
                        onDismissed: (_) =>
                            _controller.removeLog(originalIndex),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          shadowColor: color.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Container(
                                    width: 5,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomLeft: Radius.circular(14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  log.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Color(0xFF1A237E),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      catIcon,
                                                      size: 11,
                                                      color: color,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      log.category,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            log.description,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.blueGrey[600],
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _formatDate(log.date),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.blueGrey[300],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.blue[700],
                                          size: 18,
                                        ),
                                        onPressed: () => _showEditLogDialog(
                                          originalIndex,
                                          log,
                                        ),
                                        tooltip: "Edit",
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red[400],
                                          size: 18,
                                        ),
                                        onPressed: () => _controller.removeLog(
                                          originalIndex,
                                        ),
                                        tooltip: "Hapus",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ),
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
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);
      final months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return "${dt.day} ${months[dt.month]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return rawDate;
    }
  }
}
