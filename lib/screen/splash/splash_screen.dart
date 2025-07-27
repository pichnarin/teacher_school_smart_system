
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../login/login_screen.dart';
import '../navigator/navigator_menu.dart';


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
          if (state.errorMessage?.contains('ពេលវេលាសម័យបានផុតកំណត់។ សូមចូលគណនីម្ដងទៀត។') == true) {

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
                'កំពុងពិនិត្យការផ្ទៀងផ្ទាត់ភាពត្រឹមត្រូវ...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
