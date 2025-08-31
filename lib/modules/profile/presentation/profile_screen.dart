import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/domain/entities/user_entity.dart';
import '../../../core/domain/value_objects/user_type_vo.dart';
import '../../../core/providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Container(
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar perfil: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Usuário não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Perfil', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 24),
                _AvatarSection(user: user),
                const SizedBox(height: 10),
                _InfoTile(label: 'Nome', value: user.name),
                _InfoTile(label: 'E-mail', value: user.email),
                _InfoTile(label: 'Matrícula', value: user.registrationNumber),
                _InfoTile(
                  label: 'Tipo de usuário',
                  value: UserType.fromInt(user.userType).label,
                ),
                const SizedBox(height: 5),
                const Divider(),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3C87CF),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/auth-login');
                    }
                  },
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Sair',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final User user;
  const _AvatarSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.userAvatarUrl.isNotEmpty ? user.userAvatarUrl : null;
    return Column(
      children: [
        CircleAvatar(
          radius: 54,
          backgroundColor: Color.fromARGB(255, 96, 111, 129),
          backgroundImage: avatarUrl != null
              ? NetworkImage('https://suap.ifro.edu.br/media/$avatarUrl')
              : null,
          child: avatarUrl == null
              ? Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 48,
                    color: Color(0xFF1F2D37),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF3C87CF),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : '-',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
