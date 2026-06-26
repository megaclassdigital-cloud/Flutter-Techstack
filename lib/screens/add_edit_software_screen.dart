import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/supabase_service.dart';
import '../models/software_product.dart';
import '../models/category.dart';
import '../models/vendor.dart';

class AddEditSoftwareScreen extends StatefulWidget {
  final SoftwareProduct? software;
  const AddEditSoftwareScreen({super.key, this.software});

  @override
  State<AddEditSoftwareScreen> createState() => _AddEditSoftwareScreenState();
}

class _AddEditSoftwareScreenState extends State<AddEditSoftwareScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _short, _desc, _plat, _ver, _web;
  String? _catId, _venId, _price = 'Free';
  String? _imgUrl;
  Uint8List? _imgBytes;
  String? _imgName;
  List<SoftwareCategory> _cats = [];
  List<Vendor> _vens = [];
  bool _loading = false;
  static const _place =
      'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1000&q=70';

  @override
  void initState() {
    super.initState();
    final s = widget.software;
    _name = TextEditingController(text: s?.name ?? '');
    _short = TextEditingController(text: s?.shortDescription ?? '');
    _desc = TextEditingController(text: s?.description ?? '');
    _plat = TextEditingController(text: s?.platform ?? '');
    _ver = TextEditingController(text: s?.version ?? '');
    _web = TextEditingController(text: s?.websiteUrl ?? '');
    _catId = s?.categoryId;
    _venId = s?.vendorId;
    _price = s?.pricingType ?? 'Free';
    _imgUrl =
        (s?.mainImageUrl != null && s!.mainImageUrl!.isNotEmpty)
            ? s.mainImageUrl
            : _place;
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    final c = await SupabaseService.getCategories();
    final v = await SupabaseService.getVendors();
    if (!mounted) return;
    setState(() {
      _cats = c;
      _vens = v;
    });
  }

  Future<void> _pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (p != null) {
      final bytes = await p.readAsBytes();
      setState(() {
        _imgBytes = bytes;
        _imgName = p.name;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    String? url = _imgUrl;
    if (_imgBytes != null) {
      try {
        url = await SupabaseService.uploadImage(
          '',
          _imgBytes!,
          _imgName ?? 'img.jpg',
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
        setState(() => _loading = false);
        return;
      }
    }
    url ??= _place;

    final data = {
      'name': _name.text.trim(),
      'short_description': _short.text.trim(),
      'description': _desc.text.trim(),
      'platform': _plat.text.trim(),
      'version': _ver.text.trim(),
      'pricing_type': _price,
      'website_url': _web.text.trim(),
      'main_image_url': url,
      'category_id': _catId,
      'vendor_id': _venId,
      'is_featured': false,
    };
    try {
      if (widget.software == null) {
        await SupabaseService.addSoftware(data);
      } else {
        await SupabaseService.updateSoftware(widget.software!.id, data);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          widget.software == null ? 'Tambah Software' : 'Edit Software',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _input('Nama', _name, Icons.title, required: true),
            _input('Deskripsi Singkat', _short, Icons.short_text),
            _input('Deskripsi', _desc, Icons.description, maxLines: 3),
            _input('Platform', _plat, Icons.devices, required: true),
            _input('Versi', _ver, Icons.info_outline),
            DropdownButtonFormField<String>(
              initialValue: _price,
              items:
                  ['Free', 'Freemium', 'Paid', 'Subscription']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (v) => setState(() => _price = v!),
              decoration: const InputDecoration(labelText: 'Tipe Harga'),
            ),
            _input('Website URL', _web, Icons.link),
            _dropdown('Kategori', _cats, _catId, (v) => _catId = v),
            _dropdown('Vendor', _vens, _venId, (v) => _venId = v),
            const SizedBox(height: 12),
            _imgPreview(),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_rounded),
              label: const Text('PILIH GAMBAR'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _loading
                      ? const CircularProgressIndicator()
                      : const Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController ctl,
    IconData icon, {
    int maxLines = 1,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: required ? (v) => v!.isEmpty ? 'Wajib' : null : null,
      ),
    );
  }

  Widget _dropdown<T>(
    String label,
    List<T> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items:
            items.map((e) {
              if (e is SoftwareCategory) {
                return DropdownMenuItem(value: e.id, child: Text(e.name));
              }
              if (e is Vendor) {
                return DropdownMenuItem(value: e.id, child: Text(e.name));
              }
              return const DropdownMenuItem(value: '', child: Text(''));
            }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _imgPreview() {
    if (_imgBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(_imgBytes!, height: 150, fit: BoxFit.cover),
      );
    }
    if (_imgUrl != null && _imgUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(_imgUrl!, height: 150, fit: BoxFit.cover),
      );
    }
    return const SizedBox.shrink();
  }
}
