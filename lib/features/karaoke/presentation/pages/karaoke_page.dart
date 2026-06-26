import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';

class KaraokePage extends ConsumerStatefulWidget {
  const KaraokePage({super.key, required this.trackId});

  final String trackId;

  @override
  ConsumerState<KaraokePage> createState() => _KaraokePageState();
}

class _KaraokePageState extends ConsumerState<KaraokePage> {
  bool _vocalsRemoved = true;
  bool _isRecording = false;
  double _score = 0;

  final _lyrics = [
    (text: 'I\'ve been tryna call', active: false, timestamp: 0),
    (text: 'I\'ve been on my own for long enough', active: false, timestamp: 5000),
    (text: 'Maybe you can show me how to love, maybe', active: true, timestamp: 11000),
    (text: 'I\'m going through withdrawals', active: false, timestamp: 17000),
    (text: 'You don\'t even have to do too much', active: false, timestamp: 22000),
    (text: 'You can turn me on with just a touch, baby', active: false, timestamp: 28000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: WaveColors.textPrimary, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Karaoke Mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: WaveColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded,
                        color: WaveColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Score bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: WaveColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('🎤',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _score / 100,
                        backgroundColor: WaveColors.surfaceOverlay,
                        valueColor: AlwaysStoppedAnimation(
                          _score > 70
                              ? WaveColors.accent
                              : _score > 40
                                  ? WaveColors.warning
                                  : WaveColors.error,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_score.round()}',
                    style: const TextStyle(
                      color: WaveColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lyrics display
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _lyrics.length,
                itemBuilder: (_, i) {
                  final line = _lyrics[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      line.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: line.active
                            ? WaveColors.textPrimary
                            : WaveColors.textMuted.withOpacity(0.5),
                        fontSize: line.active ? 24 : 18,
                        fontWeight: line.active
                            ? FontWeight.w900
                            : FontWeight.w400,
                        height: 1.4,
                        shadows: line.active
                            ? [
                                Shadow(
                                  color:
                                      WaveColors.primary.withOpacity(0.5),
                                  blurRadius: 20,
                                )
                              ]
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Vocal removal toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Remove Vocals',
                          style: TextStyle(color: WaveColors.textMuted)),
                      const SizedBox(width: 12),
                      Switch(
                        value: _vocalsRemoved,
                        onChanged: (v) =>
                            setState(() => _vocalsRemoved = v),
                        activeColor: WaveColors.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Record button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRecording = !_isRecording;
                        if (!_isRecording) _score = 78;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording
                            ? WaveColors.error
                            : WaveColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording
                                    ? WaveColors.error
                                    : WaveColors.primary)
                                .withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRecording ? 'Recording...' : 'Tap to sing',
                    style: const TextStyle(
                        color: WaveColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
