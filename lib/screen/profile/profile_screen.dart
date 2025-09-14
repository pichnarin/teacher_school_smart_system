import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../global_widget/base_screen.dart';
import '../global_widget/section_header.dart';
import 'widget/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header Card
                _buildProfileHeader(),

                const SizedBox(height: 24),

                // Profile Information Section
                _buildProfileInformation(),

                const SizedBox(height: 24),

                // Settings Section
                _buildSettingsSection(),

                const SizedBox(height: 24),

                // About Section
                _buildAboutSection(),

                const SizedBox(height: 32),

                // Logout Button
                const LogoutButton(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage('assets/design_properties/pich_narin_avatar.jpg'),
                    // child: const Icon(
                    //   Icons.person,
                    //   size: 50,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'ណារិន ពេជ្រ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'ព័ត៌មានផ្ទាល់ខ្លួន'),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.email,
                  label: 'អ៊ីម៉ែល',
                  value: 'pichnarin893@gmail.com',
                  color: Colors.blue,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.phone,
                  label: 'លេខទូរស័ព្ទ',
                  value: '+855 179 33 38',
                  color: Colors.green,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.badge,
                  label: 'លេខសម្គាល់',
                  value: 'TCH001',
                  color: Colors.orange,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.business,
                  label: 'តួនាទី',
                  value: 'គណិតវិទ្យា, ភាសាអង់គ្លេស',
                  color: Colors.purple,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'ថ្ងៃខែឆ្នាំចូលធ្វើការ',
                  value: 'មិថុនា 13, 2025',
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'ការកំណត់'),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.edit,
                  title: 'កែប្រែព័ត៌មានផ្ទាល់ខ្លួន',
                  subtitle: '',
                  onTap: () {
                    // Handle edit profile
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.lock,
                  title: 'ផ្លាស់ប្តូរពាក្យសម្ងាត់',
                  subtitle: 'ធ្វើបច្ចុប្បន្នភាពពាក្យសម្ងាត់គណនីរបស់អ្នក។',
                  onTap: () {
                    // Handle change password
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'ការជូនដំណឹង',
                  subtitle: 'គ្រប់គ្រងចំណូលចិត្តការជូនដំណឹង',
                  onTap: () {
                    // Handle notifications
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'ភាសា',
                  subtitle: 'ផ្លាស់ប្តូរភាសាកម្មវិធី',
                  onTap: () {
                    // Handle language change
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'About'),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.info,
                  title: 'កំណែកម្មវិធី',
                  subtitle: '1.0.0',
                  onTap: () {
                    // Handle app version info
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.help,
                  title: 'ជំនួយ',
                  subtitle: 'ទទួលជំនួយ និងទាក់ទងជំនួយ',
                  onTap: () {
                    // Handle help and support
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.privacy_tip,
                  title: 'គោលការណ៍ឯកជនភាព',
                  subtitle: 'សូមអានគោលការណ៍ឯកជនភាពរបស់យើង។',
                  onTap: () {
                    // Handle privacy policy
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey[700], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
