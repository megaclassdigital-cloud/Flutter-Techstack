import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/supabase_service.dart';
import '../models/software_product.dart';
import '../models/review.dart';
import 'add_edit_software_screen.dart';

class SoftwareDetailScreen extends StatefulWidget {
  final String softwareId;
  const SoftwareDetailScreen({super.key, required this.softwareId});

  @override
  State<SoftwareDetailScreen> createState() => _SoftwareDetailScreenState();
}

class _SoftwareDetailScreenState extends State<SoftwareDetailScreen> {
  SoftwareProduct? _software;
  List<Review> _reviews = [];
  bool _isFavorite = false;
  bool _loading = true;
  final _commentCtl = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final sw = await SupabaseService.getSoftwareById(widget.softwareId);
      final reviews = await SupabaseService.getReviews(widget.softwareId);
      final fav = await SupabaseService.isFavorite(widget.softwareId);
      if (!mounted) return;
      setState(() {
        _software = sw;
        _reviews = reviews;
        _isFavorite = fav;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openWebsite(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    final normalized = url.startsWith('http') ? url : 'https://$url';
    await launchUrl(Uri.parse(normalized), webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1ED760)),
        ),
      );
    }
    if (_software == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Text(
            'Data tidak ditemukan',
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    final sw = _software!;
    final isOwner = sw.createdBy == SupabaseService.currentUserId;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gambar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background:
                  sw.mainImageUrl != null && sw.mainImageUrl!.isNotEmpty
                      ? Image.network(sw.mainImageUrl!, fit: BoxFit.cover)
                      : Container(
                        color: Colors.white12,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.white30,
                          ),
                        ),
                      ),
            ),
            actions: [
              // Favorite button
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (_isFavorite) {
                    await SupabaseService.removeFavorite(widget.softwareId);
                  } else {
                    await SupabaseService.addFavorite(widget.softwareId);
                  }
                  setState(() => _isFavorite = !_isFavorite);
                },
              ),
              // Edit/Delete jika pemilik
              if (isOwner)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (v) async {
                    if (v == 'edit') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditSoftwareScreen(software: sw),
                        ),
                      );
                      if (!mounted) return;
                      _loadAll();
                    } else if (v == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF181818),
                              title: Text(
                                'Hapus Software',
                                style: GoogleFonts.inter(color: Colors.white),
                              ),
                              content: Text(
                                'Yakin ingin menghapus?',
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(
                                    'Batal',
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(
                                    'Hapus',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFF3727F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                      if (confirm == true) {
                        await SupabaseService.deleteSoftware(sw.id);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    }
                  },
                  itemBuilder:
                      (ctx) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            'Edit',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Hapus',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFF3727F),
                            ),
                          ),
                        ),
                      ],
                ),
            ],
          ),

          // Konten detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama software
                  Text(
                    sw.name,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Short description
                  Text(
                    sw.shortDescription ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating & Pricing
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${sw.rating}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1ED760,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          sw.pricingType ?? 'Free',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1ED760),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Deskripsi
                  Text(
                    'Tentang Software',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sw.description ?? 'Tidak ada deskripsi.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Kartu info detail
                  _buildInfoCard(context, [
                    {'label': 'Kategori', 'value': sw.categoryName ?? '-'},
                    {'label': 'Vendor', 'value': sw.vendorName ?? '-'},
                    {'label': 'Platform', 'value': sw.platform ?? '-'},
                    {'label': 'Versi', 'value': sw.version ?? '-'},
                  ]),
                  if ((sw.websiteUrl ?? sw.vendorWebsite ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            () =>
                                _openWebsite(sw.websiteUrl ?? sw.vendorWebsite),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('BUKA WEBSITE'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF7C7C7C)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Bagian Ulasan
                  Text(
                    'Ulasan',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_reviews.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Belum ada ulasan. Jadilah yang pertama!',
                        style: GoogleFonts.inter(color: Colors.white38),
                      ),
                    )
                  else
                    ..._reviews.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < r.rating ? Icons.star : Icons.star_border,
                                size: 18,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.comment ?? '',
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Form tambah ulasan
                  Text(
                    'Tambah Ulasan',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (i) => IconButton(
                        icon: Icon(
                          i < _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFF59E0B),
                        ),
                        onPressed: () => setState(() => _rating = i + 1),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _commentCtl,
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      hintStyle: TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_commentCtl.text.trim().isEmpty) return;
                        await SupabaseService.addReview(
                          widget.softwareId,
                          _rating,
                          _commentCtl.text.trim(),
                        );
                        _commentCtl.clear();
                        _loadAll();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1ED760),
                        foregroundColor: const Color(0xFF121212),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kirim Ulasan',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // ruang bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Komponen kartu info (kategori, vendor, dll.)
  Widget _buildInfoCard(BuildContext context, List<Map<String, String>> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children:
            items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item['label']!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item['value']!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
