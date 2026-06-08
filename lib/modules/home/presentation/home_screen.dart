import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/gatewise_theme.dart';
import 'home_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(homeNotifierProvider.notifier).fetchAccessGrants(),
    );
  }

  String getStatusText(AccessStatusUi status) {
    switch (status) {
      case AccessStatusUi.pendingRequest:
        return 'Pendente de requisição';
      case AccessStatusUi.pending:
        return 'Pendente';
      case AccessStatusUi.granted:
        return 'Autorizado';
      case AccessStatusUi.rejected:
        return 'Rejeitado';
    }
  }

  Color getStatusColor(AccessStatusUi status) {
    switch (status) {
      case AccessStatusUi.pendingRequest:
        return GateWiseColors.electricBlue;
      case AccessStatusUi.pending:
        return GateWiseColors.amber;
      case AccessStatusUi.granted:
        return GateWiseColors.mint;
      case AccessStatusUi.rejected:
        return GateWiseColors.danger;
    }
  }

  IconData getStatusIcon(AccessStatusUi status) {
    switch (status) {
      case AccessStatusUi.pendingRequest:
        return Icons.lock_clock_rounded;
      case AccessStatusUi.pending:
        return Icons.schedule_rounded;
      case AccessStatusUi.granted:
        return Icons.verified_user_rounded;
      case AccessStatusUi.rejected:
        return Icons.gpp_bad_rounded;
    }
  }

  ({Color color, String text, VoidCallback? onPressed}) resolveButtonConfig(
    AccessStatusUi status,
    HomeNotifier notifier,
    HomeState state,
  ) {
    switch (status) {
      case AccessStatusUi.granted:
        return (
          color: GateWiseColors.mint,
          text: 'Entrar no laboratório',
          onPressed: () => notifier.openLab(),
        );
      case AccessStatusUi.pendingRequest:
        return (
          color: GateWiseColors.electricBlue,
          text: 'Solicitar acesso',
          onPressed: state.requestAccessStatus.isLoading
              ? null
              : () => notifier.requestAccess(),
        );
      case AccessStatusUi.rejected:
        return (
          color: GateWiseColors.danger,
          text: 'Solicitação de Acesso Rejeitada',
          onPressed: null,
        );
      case AccessStatusUi.pending:
        return (
          color: GateWiseColors.amber,
          text: 'Aguardando aprovação',
          onPressed: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    final buttonConfig = resolveButtonConfig(
      state.accessStatus,
      notifier,
      state,
    );
    final statusColor = getStatusColor(state.accessStatus);
    final statusIcon = getStatusIcon(state.accessStatus);

    Widget buildMainButton() {
      final isLoading =
          state.accessStatus == AccessStatusUi.pendingRequest &&
          state.requestAccessStatus.isLoading;
      return NeonGradientButton(
        label: buttonConfig.text,
        icon: state.accessStatus == AccessStatusUi.granted
            ? Icons.lock_open_rounded
            : Icons.lock_outline_rounded,
        isLoading: isLoading,
        onPressed: buttonConfig.onPressed,
        gradient: state.accessStatus == AccessStatusUi.granted
            ? GateWiseColors.successGradient
            : [buttonConfig.color, GateWiseColors.electricBlue],
      );
    }

    Widget buildContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meus acessos',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  color: GateWiseColors.textPrimary,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GlassPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.9),
                            GateWiseColors.electricBlue.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.24),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(statusIcon, color: Colors.white, size: 27),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Laboratório: Automação 66',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: GateWiseColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 7),
                          TechStatusPill(
                            label: getStatusText(
                              state.accessStatus,
                            ).toUpperCase(),
                            icon: statusIcon,
                            color: statusColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Módulo conectado ao controle de acesso. Acione a fechadura apenas quando estiver próximo ao ambiente autorizado.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          state.openLabStatus.when(
            loading: () => Center(
              child: const CircularProgressIndicator(color: Colors.white),
            ),
            error: (err, _) => Column(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: GateWiseColors.danger,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Erro: ${err.toString()}',
                  style: const TextStyle(color: GateWiseColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                buildMainButton(),
              ],
            ),
            data: (_) => buildMainButton(),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RefreshIndicator(
              color: GateWiseColors.electricBlue,
              backgroundColor: GateWiseColors.surface,
              onRefresh: () async => await notifier.fetchAccessGrants(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 122),
                child: buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
