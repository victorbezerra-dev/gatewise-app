import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../../access_history/presentation/access_history_screen.dart';
import '../../home/presentation/home_screen.dart';
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
          backgroundColor: const Color(0xFF101C2B),
          extendBody: true,
          body: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomeScreen(),
                    AccessHistoryScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,
            color: Colors.white,
            showLabel: true,
            textOverflow: TextOverflow.visible,
            maxLine: 1,
            shadowElevation: 5,
            kBottomRadius: 28.0,
            notchColor: Colors.white,
            removeMargins: false,
            bottomBarWidth: 500,
            showShadow: false,
            durationInMilliSeconds: 300,
            itemLabelStyle: const TextStyle(fontSize: 10),
            elevation: 1,
            kIconSize: 24.0,
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: const Icon(
                  Icons.home_filled,
                  color: Colors.blueGrey,
                ),
                activeItem: const Icon(
                  Icons.home_filled,
                  color: Color(0xFF101C2B),
                ),
                itemLabel: 'Início',
              ),
              BottomBarItem(
                inActiveItem: const Icon(Icons.history, color: Colors.blueGrey),
                activeItem: const Icon(Icons.history, color: Color(0xFF101C2B)),
                itemLabel: 'Histórico',
              ),
              BottomBarItem(
                inActiveItem: const Icon(Icons.person, color: Colors.blueGrey),
                activeItem: const Icon(Icons.person, color: Color(0xFF101C2B)),
                itemLabel: 'Perfil',
              ),
            ],
          ),
        ),
        const DialogHost(),
      ],
    );
  }
}
