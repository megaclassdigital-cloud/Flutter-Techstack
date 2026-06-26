import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SupabaseService.getProfile(SupabaseService.currentUserId!);
    if (!mounted) return;
    setState(() {
      _profile = p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Profil')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: AnimatedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: 'avatar',
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                _profile?.avatarUrl != null
                                    ? NetworkImage(_profile!.avatarUrl!)
                                    : null,
                            child:
                                _profile?.avatarUrl == null
                                    ? const Icon(Icons.person, size: 64)
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _profile?.fullName ?? '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text('Role: ${_profile?.role ?? 'user'}'),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
