import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'widget/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // if (state.user != null) {
            // final user = state.user!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile image
                  // CircleAvatar(
                  //   radius: 60,
                  //   backgroundColor: Colors.grey[300],
                  //   child: user.profileImage != null
                  //       ? null
                  //       : Icon(Icons.person, size: 60, color: Colors.grey[700]),
                  // ),
                  // const SizedBox(height: 24),
                  //
                  // // User name
                  // Text(
                  //   user.name ?? 'User',
                  //   style: Theme.of(context).textTheme.headlineSmall,
                  // ),
                  // const SizedBox(height: 8),

                  // User email
                  // Text(
                  //   user.email ?? 'No email provided',
                  //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  //     color: Colors.grey[600],
                  //   ),
                  // ),

                  const Divider(height: 40),

                  // User information section
                  // _buildInfoSection(context, user),

                  const SizedBox(height: 40),

                  // Using the extracted LogoutButton widget
                  const LogoutButton(),
                ],
              ),
            );
          // } else {
          //   return const Center(child: CircularProgressIndicator());
          // }
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic user) {
    // Existing info section code
    return Column(
      children: [
        _buildInfoItem(context, 'Phone', user.phone ?? 'Not provided', Icons.phone),
        _buildInfoItem(context, 'Role', user.role ?? 'User', Icons.badge),
        _buildInfoItem(context, 'Department', user.department ?? 'Not specified', Icons.business),
        _buildInfoItem(context, 'Employee ID', user.employeeId ?? 'Not provided', Icons.badge),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    // Existing info item code
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}