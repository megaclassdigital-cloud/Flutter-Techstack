import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/supabase_service.dart';
import '../widgets/fade_slide_in.dart';
import 'software_list_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import 'category_list_screen.dart';
import 'vendor_list_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String _displayName = 'User';
  final _bannerController = PageController(viewportFraction: 0.92);
  Timer? _bannerTimer;

  static const _banners = [
    'https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&w=1200&q=70',
    'https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&w=1200&q=70',
    'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=70',
  ];

  @override
  void initState() {
    super.initState();
    _loadStats();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_bannerController.hasClients) return;
      final next =
          ((_bannerController.page ?? 0).round() + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await SupabaseService.getDashboardStats();
      final user = SupabaseService.client.auth.currentUser;
      var displayName =
          user?.userMetadata?['full_name']?.toString().trim() ?? '';
      if (displayName.isEmpty && SupabaseService.currentUserId != null) {
        final profile = await SupabaseService.getProfile(
          SupabaseService.currentUserId!,
        );
        displayName = profile?.fullName.trim() ?? '';
      }
      if (displayName.isEmpty) {
        displayName = user?.email?.split('@').first ?? 'User';
      }
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _displayName = displayName;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'Overview koleksi software Anda',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseService.client.auth.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1ED760),
        onRefresh: _loadStats,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 120),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
              )
            else ...[
              FadeSlideIn(child: _buildGreeting()),
              const SizedBox(height: 18),
              FadeSlideIn(
                delay: const Duration(milliseconds: 90),
                child: _buildBannerCarousel(),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 150),
                child: _buildStatsRow(),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(
                delay: const Duration(milliseconds: 220),
                child: _buildQuickActions(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo $_displayName,',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Selamat datang di Tech Stack Hub.',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFCBCBCB),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 178,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final titles = [
            'Aplikasi favorit, siap dipakai',
            'Stack modern untuk kerja cepat',
            'Katalog rapi untuk keputusan teknis',
          ];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _banners[index],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            Container(color: const Color(0xFF181818)),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          const Color(0xFF121212).withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Text(
                      titles[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F).withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'AUTO SCROLL',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = _stats ?? {};
    final items = [
      {
        'icon': Icons.apps_rounded,
        'value': '${stats['total_software'] ?? 0}',
        'label': 'Software',
        'desc': 'Total aplikasi',
      },
      {
        'icon': Icons.category_rounded,
        'value': '${stats['total_categories'] ?? 0}',
        'label': 'Kategori',
        'desc': 'Jenis software',
      },
      {
        'icon': Icons.business_rounded,
        'value': '${stats['total_vendors'] ?? 0}',
        'label': 'Vendor',
        'desc': 'Pembuat',
      },
      {
        'icon': Icons.favorite_rounded,
        'value': '${stats['total_favorites'] ?? 0}',
        'label': 'Favorit',
        'desc': 'Disimpan',
      },
      {
        'icon': Icons.star_rounded,
        'value': '${stats['average_rating'] ?? 0}',
        'label': 'Rata Rating',
        'desc': 'Dari semua',
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width > 720) ? 5 : 2,
        childAspectRatio: 1.24,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder:
          (_, i) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    size: 28,
                    color: const Color(0xFF1ED760),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    items[i]['value'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    items[i]['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFCBCBCB),
                    ),
                  ),
                  Text(
                    items[i]['desc'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFFB3B3B3),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Jelajahi Software',
        'desc': 'Lihat dan kelola semua software',
        'icon': Icons.apps_rounded,
        'screen': const SoftwareListScreen(),
      },
      {
        'title': 'Favorit Saya',
        'desc': 'Akses cepat software favorit',
        'icon': Icons.favorite_rounded,
        'screen': const FavoritesScreen(),
      },
      {
        'title': 'Kategori',
        'desc': 'Kelola kategori software',
        'icon': Icons.grid_view_rounded,
        'screen': const CategoryListScreen(),
      },
      {
        'title': 'Vendor',
        'desc': 'Lihat dan kelola daftar vendor',
        'icon': Icons.business_rounded,
        'screen': const VendorListScreen(),
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Akses Cepat',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        ...actions.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => a['screen'] as Widget),
                    ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Icon(
                          a['icon'] as IconData,
                          color: const Color(0xFF1ED760),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a['title'] as String,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              a['desc'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFFB3B3B3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFFB3B3B3)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
