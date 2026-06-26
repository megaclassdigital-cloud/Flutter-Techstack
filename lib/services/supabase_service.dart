import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/software_product.dart';
import '../models/category.dart';
import '../models/vendor.dart';
import '../models/review.dart';
import '../models/profile.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static String? get currentUserId => client.auth.currentUser?.id;
  static bool get isLoggedIn => client.auth.currentSession != null;

  static String _requireUserId() {
    final id = currentUserId;
    if (id == null) throw Exception('User not authenticated');
    return id;
  }

  // --------------------- Dashboard Stats ---------------------
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final data = await client.rpc(
      'get_dashboard_stats',
      params: {'user_uuid': currentUserId},
    );
    return data as Map<String, dynamic>;
  }

  // --------------------- Software Products (JOIN) ---------------------
  static Future<List<SoftwareProduct>> getAllSoftware() async {
    try {
      final response = await client.from('software_products').select('''
        *,
        software_categories:category_id(*),
        vendors:vendor_id(*),
        profiles:created_by(*)
      ''');
      return response
          .map<SoftwareProduct>((e) => SoftwareProduct.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data software: $e');
    }
  }

  static Future<List<SoftwareProduct>> getSoftwareByCategory(
    String categoryId,
  ) async {
    final response = await client
        .from('software_products')
        .select('''
          *,
          software_categories:category_id(*),
          vendors:vendor_id(*),
          profiles:created_by(*)
        ''')
        .eq('category_id', categoryId);
    return response
        .map<SoftwareProduct>((e) => SoftwareProduct.fromJson(e))
        .toList();
  }

  static Future<SoftwareProduct?> getSoftwareById(String id) async {
    final response =
        await client
            .from('software_products')
            .select('''
          *,
          software_categories:category_id(*),
          vendors:vendor_id(*),
          profiles:created_by(*)
        ''')
            .eq('id', id)
            .single();
    return SoftwareProduct.fromJson(response);
  }

  static Future<void> addSoftware(Map<String, dynamic> data) async {
    data['created_by'] = _requireUserId();
    await client.from('software_products').insert(data);
  }

  static Future<void> updateSoftware(
    String id,
    Map<String, dynamic> data,
  ) async {
    await client.from('software_products').update(data).eq('id', id);
  }

  static Future<void> deleteSoftware(String id) async {
    await client.from('software_products').delete().eq('id', id);
  }

  // --------------------- Categories & Vendors ---------------------
  static Future<List<SoftwareCategory>> getCategories() async {
    final response = await client
        .from('software_categories')
        .select()
        .order('name');
    return response
        .map<SoftwareCategory>((e) => SoftwareCategory.fromJson(e))
        .toList();
  }

  static Future<List<Vendor>> getVendors() async {
    final response = await client.from('vendors').select().order('name');
    return response.map<Vendor>((e) => Vendor.fromJson(e)).toList();
  }

  static Future<void> addCategory(Map<String, dynamic> data) async {
    await client.from('software_categories').insert(data);
  }

  static Future<void> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) async {
    await client.from('software_categories').update(data).eq('id', id);
  }

  static Future<void> deleteCategory(String id) async {
    await client.from('software_categories').delete().eq('id', id);
  }

  static Future<void> addVendor(Map<String, dynamic> data) async {
    await client.from('vendors').insert(data);
  }

  static Future<void> updateVendor(String id, Map<String, dynamic> data) async {
    await client.from('vendors').update(data).eq('id', id);
  }

  static Future<void> deleteVendor(String id) async {
    await client.from('vendors').delete().eq('id', id);
  }

  // --------------------- Reviews ---------------------
  static Future<List<Review>> getReviews(String softwareId) async {
    final response = await client
        .from('software_reviews')
        .select()
        .eq('software_id', softwareId);
    return response.map<Review>((e) => Review.fromJson(e)).toList();
  }

  static Future<void> addReview(
    String softwareId,
    int rating,
    String? comment,
  ) async {
    final userId = _requireUserId();
    await client.from('software_reviews').insert({
      'software_id': softwareId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    });
  }

  // --------------------- Favorites ---------------------
  static Future<List<Map<String, dynamic>>> getUserFavorites() async {
    final userId = _requireUserId();
    final data = await client
        .from('favorites')
        .select('*, software_products(*)')
        .eq('user_id', userId);
    return data;
  }

  static Future<bool> isFavorite(String softwareId) async {
    final userId = currentUserId;
    if (userId == null) return false;
    final response = await client
        .from('favorites')
        .select('id')
        .eq('software_id', softwareId)
        .eq('user_id', userId);
    return response.isNotEmpty;
  }

  static Future<void> addFavorite(String softwareId) async {
    final userId = _requireUserId();
    await client.from('favorites').insert({
      'software_id': softwareId,
      'user_id': userId,
    });
  }

  static Future<void> removeFavorite(String softwareId) async {
    final userId = _requireUserId();
    await client
        .from('favorites')
        .delete()
        .eq('software_id', softwareId)
        .eq('user_id', userId);
  }

  // --------------------- Profile ---------------------
  static Future<UserProfile?> getProfile(String userId) async {
    final data = await client.from('profiles').select().eq('id', userId);
    if (data.isEmpty) return null;
    return UserProfile.fromJson(data.first);
  }

  static Future<void> updateProfile(String fullName, String? avatarUrl) async {
    final userId = _requireUserId();
    await client
        .from('profiles')
        .update({'full_name': fullName, 'avatar_url': avatarUrl})
        .eq('id', userId);
  }

  // --------------------- Storage ---------------------
  static Future<String> uploadImage(
    String path,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final userId = _requireUserId();
    final filePath =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await client.storage
        .from('software-images')
        .uploadBinary(filePath, fileBytes);
    return client.storage.from('software-images').getPublicUrl(filePath);
  }
}
