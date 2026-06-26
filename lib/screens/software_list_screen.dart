import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/software_product.dart';
import '../widgets/animated_card.dart';
import '../widgets/fade_slide_in.dart';
import 'software_detail_screen.dart';
import 'add_edit_software_screen.dart';

class SoftwareListScreen extends StatefulWidget {
  const SoftwareListScreen({super.key});

  @override
  State<SoftwareListScreen> createState() => _SoftwareListScreenState();
}

class _SoftwareListScreenState extends State<SoftwareListScreen> {
  List<SoftwareProduct> _software = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await SupabaseService.getAllSoftware();
      if (!mounted) return;
      setState(() {
        _software = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Daftar Software'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Bisa tambah filter nanti
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditSoftwareScreen()),
          );
          _loadData();
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _software.isEmpty
                ? const Center(
                  child: Text(
                    'Belum ada software',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        constraints.maxWidth > 900
                            ? 4
                            : constraints.maxWidth > 600
                            ? 3
                            : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _software.length,
                      itemBuilder: (_, i) {
                        final sw = _software[i];
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 35 * (i % 8)),
                          child: _buildSoftwareCard(sw),
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildSoftwareCard(SoftwareProduct sw) {
    return AnimatedCard(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SoftwareDetailScreen(softwareId: sw.id),
            ),
          ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child:
                sw.mainImageUrl != null && sw.mainImageUrl!.isNotEmpty
                    ? Image.network(
                      sw.mainImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            color: const Color(0xFF1F1F1F),
                            child: const Icon(
                              Icons.apps_rounded,
                              color: Colors.white54,
                              size: 42,
                            ),
                          ),
                    )
                    : Container(
                      color: const Color(0xFF1F1F1F),
                      child: const Icon(
                        Icons.apps_rounded,
                        size: 42,
                        color: Colors.white54,
                      ),
                    ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sw.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sw.shortDescription ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB3B3B3),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
