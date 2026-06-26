import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';

class HumToSearchButton extends ConsumerStatefulWidget {
  const HumToSearchButton({super.key});

  @override
  ConsumerState<HumToSearchButton> createState() => _HumToSearchButtonState();
}

class _HumToSearchButtonState extends ConsumerState<HumToSearchButton>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
    if (_isListening) {
      _pulseController.repeat(reverse: true);
      _showHumSheet();
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  void _showHumSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: WaveColors.surfaceCard,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _HumListenSheet(
        onDismiss: () {
          setState(() => _isListening = false);
          _pulseController.stop();
          _pulseController.reset();
        },
      ),
    ).then((_) {
      setState(() => _isListening = false);
      _pulseController.stop();
      _pulseController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _isListening ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: _toggleListening,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _isListening ? WaveColors.primary : WaveColors.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: WaveColors.primary.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Icon(
            _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
            color: _isListening ? Colors.white : WaveColors.textMuted,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _HumListenSheet extends StatefulWidget {
  const _HumListenSheet({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  State<_HumListenSheet> createState() => _HumListenSheetState();
}

class _HumListenSheetState extends State<_HumListenSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Hum, sing, or whistle',
            style: TextStyle(
              color: WaveColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll identify the song',
            style: TextStyle(color: WaveColors.textMuted, fontSize: 15),
          ),
          const SizedBox(height: 48),

          // Animated mic circle
          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse rings
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: 80 + i * 30 + (_waveController.value * 20),
                      height: 80 + i * 30 + (_waveController.value * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: WaveColors.primary
                              .withOpacity(0.3 - i * 0.08),
                          width: 1.5,
                        ),
                      ),
                    ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: WaveColors.gradientPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic_rounded,
                        color: Colors.white, size: 36),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 48),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDismiss();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: WaveColors.textMuted, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
