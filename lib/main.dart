import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/solid_background.dart';
import 'services/opening_sound_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const TechstackHubApp());
}

class TechstackHubApp extends StatelessWidget {
  const TechstackHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFFFFFFF),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFCBCBCB),
      ),
    );

    return MaterialApp(
      title: 'Techstack Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1ED760),
          brightness: Brightness.dark,
          primary: const Color(0xFF1ED760),
          onPrimary: const Color(0xFF121212),
          secondary: const Color(0xFF539DF5),
          surface: const Color(0xFF181818),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1ED760),
          foregroundColor: Color(0xFF121212),
          shape: StadiumBorder(),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF181818),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
          labelStyle: const TextStyle(color: Color(0xFFCBCBCB)),
          hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
          prefixIconColor: const Color(0xFFB3B3B3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: const BorderSide(color: Color(0xFF7C7C7C)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: const BorderSide(color: Color(0xFFF3727F)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: const BorderSide(color: Color(0xFFF3727F), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1ED760),
            foregroundColor: const Color(0xFF121212),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: const StadiumBorder(),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1ED760),
            foregroundColor: const Color(0xFF121212),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
            shape: const StadiumBorder(),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1ED760),
            shape: const StadiumBorder(),
          ),
        ),
        textTheme: textTheme,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) {
        return SolidBackground(child: child!);
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconFade;
  late Animation<double> _techStackFade;
  late Animation<double> _welcomeFade;
  late Animation<double> _catalogFade;
  late Animation<double> _softwareFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _iconFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.16, curve: Curves.easeOutCubic),
    );
    _techStackFade = _intervalFade(0.06, 0.22, 0.36, 0.48);
    _welcomeFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.46, 0.64, curve: Curves.easeOutCubic),
    );
    _catalogFade = _intervalFade(0.18, 0.34, 0.48, 0.58);
    _softwareFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.60, 0.80, curve: Curves.easeOutCubic),
    );
    OpeningSoundPlayer.playOnFirstOpen();
    _controller.forward().then((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (_, __, ___) =>
                  Supabase.instance.client.auth.currentSession == null
                      ? const LoginScreen()
                      : const DashboardScreen(),
          transitionsBuilder:
              (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  Animation<double> _intervalFade(
    double fadeInStart,
    double fadeInEnd,
    double fadeOutStart,
    double fadeOutEnd,
  ) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: fadeInStart),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: fadeInEnd - fadeInStart,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1),
        weight: fadeOutStart - fadeInEnd,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: fadeOutEnd - fadeOutStart,
      ),
      TweenSequenceItem(tween: ConstantTween(0), weight: 1 - fadeOutEnd),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _iconFade,
                  child: const Icon(
                    Icons.apps_rounded,
                    size: 76,
                    color: Color(0xFF1ED760),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 46,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FadeTransition(
                        opacity: _techStackFade,
                        child: _OpeningTitle(text: 'TechStack'),
                      ),
                      FadeTransition(
                        opacity: _welcomeFade,
                        child: _OpeningTitle(text: 'Welcome'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 26,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FadeTransition(
                        opacity: _catalogFade,
                        child: _OpeningSubtitle(
                          text: 'Software Catalog & Elevated',
                        ),
                      ),
                      FadeTransition(
                        opacity: _softwareFade,
                        child: _OpeningSubtitle(text: 'To My Software'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: _controller.value,
                      minHeight: 3,
                      backgroundColor: const Color(0xFF252525),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF1ED760),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OpeningTitle extends StatelessWidget {
  const _OpeningTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }
}

class _OpeningSubtitle extends StatelessWidget {
  const _OpeningSubtitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }
}
