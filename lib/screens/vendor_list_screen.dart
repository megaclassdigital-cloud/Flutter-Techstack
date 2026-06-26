import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/vendor.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_card.dart';
import '../widgets/fade_slide_in.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<Vendor> _vendors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final vendors = await SupabaseService.getVendors();
    if (!mounted) return;
    setState(() {
      _vendors = vendors;
      _loading = false;
    });
  }

  Future<void> _openForm([Vendor? vendor]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _VendorFormDialog(vendor: vendor),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Vendor vendor) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF181818),
            title: const Text('Hapus Vendor'),
            content: Text('Hapus vendor "${vendor.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Color(0xFFF3727F)),
                ),
              ),
            ],
          ),
    );
    if (confirm != true) return;
    await SupabaseService.deleteVendor(vendor.id);
    if (mounted) _load();
  }

  Future<void> _openWebsite(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    final normalized = url.startsWith('http') ? url : 'https://$url';
    await launchUrl(Uri.parse(normalized), webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Vendor'),
        actions: [
          IconButton(
            tooltip: 'Tambah vendor',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _openForm(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1ED760),
        onRefresh: _load,
        child:
            _loading
                ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                )
                : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _vendors.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, i) {
                    final vendor = _vendors[i];
                    return FadeSlideIn(
                      delay: Duration(milliseconds: 35 * (i % 8)),
                      child: AnimatedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Color(0xFF1ED760),
                                    child: Icon(
                                      Icons.business_rounded,
                                      color: Color(0xFF121212),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    tooltip: 'Buka website',
                                    onPressed:
                                        vendor.websiteUrl == null
                                            ? null
                                            : () =>
                                                _openWebsite(vendor.websiteUrl),
                                    icon: const Icon(Icons.open_in_new_rounded),
                                  ),
                                  PopupMenuButton<String>(
                                    color: const Color(0xFF252525),
                                    icon: const Icon(Icons.more_horiz_rounded),
                                    onSelected: (value) {
                                      if (value == 'edit') _openForm(vendor);
                                      if (value == 'delete') _delete(vendor);
                                    },
                                    itemBuilder:
                                        (_) => const [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(
                                                color: Color(0xFFF3727F),
                                              ),
                                            ),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                vendor.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vendor.country ?? 'Global',
                                style: const TextStyle(
                                  color: Color(0xFFCBCBCB),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vendor.description ?? 'Tanpa deskripsi',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFB3B3B3),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('VENDOR'),
      ),
    );
  }
}

class _VendorFormDialog extends StatefulWidget {
  const _VendorFormDialog({this.vendor});

  final Vendor? vendor;

  @override
  State<_VendorFormDialog> createState() => _VendorFormDialogState();
}

class _VendorFormDialogState extends State<_VendorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _website;
  late final TextEditingController _country;
  late final TextEditingController _description;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.vendor?.name ?? '');
    _website = TextEditingController(text: widget.vendor?.websiteUrl ?? '');
    _country = TextEditingController(text: widget.vendor?.country ?? '');
    _description = TextEditingController(
      text: widget.vendor?.description ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _website.dispose();
    _country.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'name': _name.text.trim(),
      'website_url': _website.text.trim().isEmpty ? null : _website.text.trim(),
      'country': _country.text.trim().isEmpty ? null : _country.text.trim(),
      'description':
          _description.text.trim().isEmpty ? null : _description.text.trim(),
    };
    if (widget.vendor == null) {
      await SupabaseService.addVendor(data);
    } else {
      await SupabaseService.updateVendor(widget.vendor!.id, data);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      title: Text(widget.vendor == null ? 'Tambah Vendor' : 'Edit Vendor'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Wajib' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _website,
                decoration: const InputDecoration(labelText: 'Website URL'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _country,
                decoration: const InputDecoration(labelText: 'Negara'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'MENYIMPAN' : 'SIMPAN'),
        ),
      ],
    );
  }
}
