import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';

class AiDjPage extends ConsumerStatefulWidget {
  const AiDjPage({super.key});

  @override
  ConsumerState<AiDjPage> createState() => _AiDjPageState();
}

class _AiDjPageState extends ConsumerState<AiDjPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbitController;
  bool _isActive = false;
  String _selectedPersona = 'chill';

  final _personas = [
    (id: 'chill', name: 'Chill Host', emoji: '😌', desc: 'Laid-back late-night vibe'),
    (id: 'hype', name: 'Hype MC', emoji: '🔥', desc: 'High-energy party starter'),
    (id: 'critic', name: 'Music Critic', emoji: '🎓', desc: 'Deep dives & insights'),
    (id: 'nostalgic', name: 'Time Traveler', emoji: '⏳', desc: 'Old-school throwbacks'),
  ];

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaveColors.playerBgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Nav
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: WaveColors.textPrimary, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'AI DJ · Flux',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: WaveColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: WaveColors.textMuted),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Flux avatar
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _orbitController,
                      builder: (_, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer orbit ring
                            Transform.rotate(
                              angle:
                                  _orbitController.value * 2 * 3.14159,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _isActive
                                        ? WaveColors.primary.withOpacity(0.3)
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            // Pulse rings
                            if (_isActive) ...[
                              for (int i = 0; i < 3; i++)
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500 + i * 200),
                                  width: 130 + i * 25.0,
                                  height: 130 + i * 25.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: WaveColors.primary
                                          .withOpacity(0.15 - i * 0.04),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                            ],
                            // Main circle
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _isActive
                                    ? WaveColors.gradientPrimary
                                    : const LinearGradient(
                                        colors: [
                                          WaveColors.surfaceCard,
                                          WaveColors.surfaceElevated
                                        ],
                                      ),
                                boxShadow: _isActive
                                    ? [
                                        BoxShadow(
                                          color: WaveColors.primary
                                              .withOpacity(0.4),
                                          blurRadius: 40,
                                          spreadRadius: 5,
                                        )
                                      ]
                                    : null,
                              ),
                              child: const Icon(
                                Icons.radio_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Text(
                      _isActive ? 'Flux is live...' : 'Start Flux DJ',
                      style: TextStyle(
                        color: _isActive
                            ? WaveColors.primary
                            : WaveColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (_isActive) ...[
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: WaveColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '"Welcome back! I can tell you\'re in a late-night mood. Let me take you through something special..."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: WaveColors.textSecondary,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Persona selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DJ Persona',
                    style: TextStyle(
                      color: WaveColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _personas.length,
                      itemBuilder: (_, i) {
                        final p = _personas[i];
                        final selected = _selectedPersona == p.id;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPersona = p.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? WaveColors.primary.withOpacity(0.2)
                                  : WaveColors.surfaceCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? WaveColors.primary
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(p.emoji,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 4),
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    color: selected
                                        ? WaveColors.primary
                                        : WaveColors.textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Text request
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(color: WaveColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Tell Flux what you want...',
                  hintStyle: const TextStyle(color: WaveColors.textMuted),
                  prefixIcon: const Icon(Icons.auto_awesome_rounded,
                      color: WaveColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: WaveColors.primary),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Start/stop button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isActive = !_isActive),
                  icon: Icon(_isActive ? Icons.stop_rounded : Icons.play_arrow_rounded),
                  label: Text(_isActive ? 'Stop Flux' : 'Start Flux DJ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isActive
                        ? WaveColors.error
                        : WaveColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
