import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gatewise_app/modules/host/presentation/dialog_notifier.dart';
import 'package:lottie/lottie.dart';

class DialogHost extends ConsumerWidget {
  const DialogHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dialogProvider);
    if (!state.isOpen || state.status == DialogStatus.idle) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.black.withOpacity(0.7),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(dialogProvider.notifier).close();
        },
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: _DialogContent(
                  state: state,
                  onClose: () => ref.read(dialogProvider.notifier).close(),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => ref.read(dialogProvider.notifier).close(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogContent extends StatefulWidget {
  final DialogState state;
  final VoidCallback onClose;
  const _DialogContent({required this.state, required this.onClose});

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  late final AnimationController _dotController;

  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state.status == DialogStatus.loading) {
      _showSuccess = false;
      _lottieController.value = 0;
      _lottieController.stop();
      _dotController.repeat();
    } else if (widget.state.status == DialogStatus.success && !_showSuccess) {
      _dotController.stop();
      _lottieController.forward(from: 0).then((_) async {
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) setState(() => _showSuccess = true);
        }
      });
    } else if (widget.state.status != DialogStatus.loading &&
        widget.state.status != DialogStatus.success) {
      _showSuccess = false;
      _lottieController.reset();
      _lottieController.stop();
      _dotController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget inner;
    if (widget.state.status == DialogStatus.loading ||
        (widget.state.status == DialogStatus.success && !_showSuccess)) {
      inner = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/door.json',
            controller: _lottieController,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.9,
            onLoaded: (composition) {
              _lottieController.duration = composition.duration;
              if (widget.state.status == DialogStatus.loading) {
                _lottieController.value = 0;
                _lottieController.stop();
              } else if (widget.state.status == DialogStatus.success &&
                  !_showSuccess) {
                _lottieController.forward(from: 0).then((_) {
                  if (mounted) setState(() => _showSuccess = true);
                });
              }
            },
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _dotController,
            builder: (_, __) {
              int dotCount = (_dotController.value * 3).floor() + 1;
              String dots = '.' * dotCount;
              return Text(
                'Abrindo laboratório$dots',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101C2B),
                ),
              );
            },
          ),
        ],
      );
    } else if (widget.state.status == DialogStatus.success && _showSuccess) {
      inner = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            repeat: false,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
          ),
          Text(
            widget.state.message ?? "Sucesso!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF101C2B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onClose,
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    } else if (widget.state.status == DialogStatus.error) {
      inner = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/failure.json',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          Text(
            widget.state.message ?? "Erro ao abrir",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onClose,
            child: const Text(
              "Fechar",
              style: TextStyle(color: Color.fromARGB(255, 48, 96, 155)),
            ),
          ),
        ],
      );
    } else if (widget.state.status == DialogStatus.timeout) {
      inner = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_off, color: Colors.orange, size: 60),
          const SizedBox(height: 10),
          const Text(
            "Tempo excedido",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF101C2B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.state.message ??
                "A operação excedeu o tempo limite. Não obtive resposta do GateWise. "
                    "Verifique se a fechadura abriu, ou tente novamente.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF101C2B)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onClose,
            child: const Text(
              "Fechar",
              style: TextStyle(color: Color.fromARGB(255, 48, 96, 155)),
            ),
          ),
        ],
      );
    } else {
      inner = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: inner,
      ),
    );
  }
}
