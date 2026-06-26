import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/software_product.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_card.dart';
import '../widgets/fade_slide_in.dart';
import 'software_detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<SoftwareCategory> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final c = await SupabaseService.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = c;
      _loading = false;
    });
  }

  Future<void> _openForm([SoftwareCategory? category]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _CategoryFormDialog(category: category),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(SoftwareCategory category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF181818),
            title: const Text('Hapus Kategori'),
            content: Text('Hapus kategori "${category.name}"?'),
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
    await SupabaseService.deleteCategory(category.id);
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Kategori'),
        actions: [
          IconButton(
            tooltip: 'Tambah kategori',
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
                  itemCount: _categories.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 210,
                    childAspectRatio: 1.05,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    return FadeSlideIn(
                      delay: Duration(milliseconds: 35 * (i % 8)),
                      child: AnimatedCard(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        SoftwareByCategoryScreen(category: cat),
                              ),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFF1ED760),
                                    child: Icon(
                                      _mapIcon(cat.iconName),
                                      color: const Color(0xFF121212),
                                    ),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    color: const Color(0xFF252525),
                                    icon: const Icon(Icons.more_horiz_rounded),
                                    onSelected: (value) {
                                      if (value == 'edit') _openForm(cat);
                                      if (value == 'delete') _delete(cat);
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
                                cat.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat.description ?? 'Tanpa deskripsi',
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
        label: const Text('KATEGORI'),
      ),
    );
  }

  IconData _mapIcon(String? n) => switch (n) {
    'code' => Icons.code,
    'design_services' => Icons.design_services,
    'dashboard_customize' => Icons.dashboard_customize,
    'chat_bubble_outline' => Icons.chat_bubble_outline,
    'view_kanban' => Icons.view_kanban,
    'smart_toy' => Icons.auto_awesome,
    _ => Icons.folder_rounded,
  };
}

class _CategoryFormDialog extends StatefulWidget {
  const _CategoryFormDialog({this.category});

  final SoftwareCategory? category;

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _icon;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category?.name ?? '');
    _description = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _icon = TextEditingController(text: widget.category?.iconName ?? 'folder');
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _icon.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'name': _name.text.trim(),
      'description':
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      'icon_name': _icon.text.trim().isEmpty ? 'folder' : _icon.text.trim(),
      'color_hex': '#1ED760',
    };
    if (widget.category == null) {
      await SupabaseService.addCategory(data);
    } else {
      await SupabaseService.updateCategory(widget.category!.id, data);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      title: Text(
        widget.category == null ? 'Tambah Kategori' : 'Edit Kategori',
      ),
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
                controller: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _icon,
                decoration: const InputDecoration(labelText: 'Icon name'),
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

class SoftwareByCategoryScreen extends StatefulWidget {
  final SoftwareCategory category;
  const SoftwareByCategoryScreen({super.key, required this.category});

  @override
  State<SoftwareByCategoryScreen> createState() =>
      _SoftwareByCategoryScreenState();
}

class _SoftwareByCategoryScreenState extends State<SoftwareByCategoryScreen> {
  List<SoftwareProduct> _software = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await SupabaseService.getSoftwareByCategory(widget.category.id);
    if (!mounted) return;
    setState(() {
      _software = d;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(widget.category.name)),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1ED760)),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _software.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final sw = _software[i];
                  return ListTile(
                    tileColor: const Color(0xFF181818),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading:
                        sw.mainImageUrl != null && sw.mainImageUrl!.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                sw.mainImageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                            : const Icon(Icons.apps_rounded),
                    title: Text(sw.name),
                    subtitle: Text(sw.shortDescription ?? ''),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SoftwareDetailScreen(softwareId: sw.id),
                          ),
                        ),
                  );
                },
              ),
    );
  }
}
