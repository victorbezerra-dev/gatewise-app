import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../../access_history/presentation/access_history_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../organizations/presentation/organizations_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'dialog_notifier.dart';
import 'host_websocket_provider.dart';
import 'widgets/custom_dialog.dart';

class HostScreen extends ConsumerStatefulWidget {
  const HostScreen({super.key});

  @override
  ConsumerState<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends ConsumerState<HostScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  late HubConnection hubConnection;
  bool _signalrConnected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      hubConnection = ref.read(signalRProvider);

      hubConnection.off('access_result');
      hubConnection.on('access_result', (arguments) async {
        final data = arguments?.first as Map?;
        if (data == null) return;
        if (!mounted) return;

        if (data['status'] == 'opened') {
          ref
              .read(dialogProvider.notifier)
              .showSuccess("Acesso autorizado, Laboratorio Aberto!");
        } else if (data['status'] == 'failed') {
          ref
              .read(dialogProvider.notifier)
              .showError(
                "Ocorreu um erro ao tentar abrir a fechadura, tente novamente ou fale com o suporte!",
              );
        }
      });

      _connectSignalR();
    });
  }

  Future<void> _connectSignalR() async {
    if (_signalrConnected) return;
    try {
      if (hubConnection.state != HubConnectionState.Connected) {
        await hubConnection.start();
        _signalrConnected = true;
        log('SignalR conectado!');
      }
    } catch (e) {
      log('Erro ao conectar SignalR: $e');
      ref
          .read(dialogProvider.notifier)
          .showError("Erro de conexão com o servidor.");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: GateWiseColors.background,
          extendBody: true,
          body: TechBackground(
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Image.asset(
                      'assets/images/gatewise-mini-logo.png',
                      width: 130,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      HomeScreen(),
                      OrganizationsScreen(),
                      AccessHistoryScreen(),
                      ProfileScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            left: false,
            right: false,
            child: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,
            color: GateWiseColors.surface,
            showLabel: true,
            textOverflow: TextOverflow.visible,
            maxLine: 1,
            shadowElevation: 0,
            kBottomRadius: 28.0,
            notchColor: GateWiseColors.electricBlue,
            removeMargins: false,
            bottomBarWidth: 500,
            showShadow: false,
            durationInMilliSeconds: 300,
            itemLabelStyle: const TextStyle(
              fontSize: 10,
              color: GateWiseColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
            elevation: 0,
            kIconSize: 24.0,
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: const Icon(
                  Icons.home_filled,
                  color: GateWiseColors.textMuted,
                ),
                activeItem: const Icon(
                  Icons.home_filled,
                  color: GateWiseColors.background,
                ),
                itemLabel: 'Início',
              ),
              BottomBarItem(
                inActiveItem: const Icon(
                  Icons.business_rounded,
                  color: GateWiseColors.textMuted,
                ),
                activeItem: const Icon(
                  Icons.business_rounded,
                  color: GateWiseColors.background,
                ),
                itemLabel: 'Orgs',
              ),
              BottomBarItem(
                inActiveItem: const Icon(
                  Icons.history,
                  color: GateWiseColors.textMuted,
                ),
                activeItem: const Icon(
                  Icons.history,
                  color: GateWiseColors.background,
                ),
                itemLabel: 'Histórico',
              ),
              BottomBarItem(
                inActiveItem: const Icon(
                  Icons.person,
                  color: GateWiseColors.textMuted,
                ),
                activeItem: const Icon(
                  Icons.person,
                  color: GateWiseColors.background,
                ),
                itemLabel: 'Perfil',
              ),
            ],
          ),
          ),
        ),
        const DialogHost(),
      ],
    );
  }
}
