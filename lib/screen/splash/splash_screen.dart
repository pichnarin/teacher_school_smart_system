
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../login/login_screen.dart';
import '../navigator/navigator_menu.dart';

//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//
//   double _opacity = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fadeIn();
//     _checkAuth();
//   }
//
//   void _fadeIn() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       setState(() {
//         _opacity = 1;
//       });
//     });
//   }
//
//   Future<bool> _isTokenValid() async {
//     final token = await _storage.read(key: 'jwt_token');
//
//     if (token == null || token.isEmpty){
//       return false;
//     }
//
//     if (JwtDecoder.isExpired(token)) {
//       return false;
//     }
//
//     return true;
//   }
//
//   void _checkAuth() async {
//     await Future.delayed(const Duration(seconds: 2));
//     final isValid = await _isTokenValid();
//     if (isValid) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const NavigatorMenu()),
//       );
//     } else{
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Session expired. Please log in again.'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Scaffold(
//       backgroundColor: colorScheme.background,
//       body: Center(
//         child: AnimatedOpacity(
//           duration: const Duration(milliseconds: 800),
//           opacity: _opacity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo or app name
//               Icon(Icons.school_rounded, size: 72, color: colorScheme.primary),
//               const SizedBox(height: 24),
//
//               // Loading Indicator
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
//               ),
//               const SizedBox(height: 20),
//
//               // Text
//               Text(
//                 'Checking authentication...',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: colorScheme.onSurface.withOpacity(0.8),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  void _navigate(AuthStatus status) {
    if (status == AuthStatus.authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigatorMenu()),
      );
    } else if (status == AuthStatus.unauthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
      prev.status != curr.status ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) async {
        if (state.status == AuthStatus.unauthenticated) {
          if (state.errorMessage?.contains('Session expired. Please log in again.') == true) {
            // print("Session expired! Showing SnackBar.");
            // print('Token refresh failed, setting unauthenticated with error');
            // print('AuthState changed: ${state.status}, error: ${state.errorMessage}');


            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 2),
              ),
            );

            // Wait for the SnackBar duration before navigating
            await Future.delayed(const Duration(seconds: 2));

            if (mounted) {
              _navigate(state.status);
            }
          } else {
            _navigate(state.status);
          }
        } else if (state.status == AuthStatus.authenticated) {
          _navigate(state.status);
        }
      },

      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Checking authentication...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
