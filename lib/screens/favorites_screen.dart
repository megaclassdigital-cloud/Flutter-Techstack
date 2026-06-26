import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_card.dart';
import 'software_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await SupabaseService.getUserFavorites();
    if (!mounted) return;
    setState(() {
      _favs = d;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Favorit Saya')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _favs.isEmpty
              ? const Center(child: Text('Belum ada favorit'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _favs.length,
                itemBuilder: (_, i) {
                  final fav = _favs[i];
                  final sw = fav['software_products'];
                  return AnimatedCard(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    SoftwareDetailScreen(softwareId: sw['id']),
                          ),
                        ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            sw['main_image_url'] != null &&
                                    sw['main_image_url']!.toString().isNotEmpty
                                ? Image.network(
                                  sw['main_image_url'],
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                )
                                : const Icon(Icons.folder, size: 48),
                      ),
                      title: Text(sw['name'] ?? ''),
                      subtitle: Text(sw['short_description'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFF3727F),
                        ),
                        onPressed: () async {
                          await SupabaseService.removeFavorite(sw['id']);
                          _load();
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
