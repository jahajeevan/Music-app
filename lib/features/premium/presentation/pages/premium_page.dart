import 'package:flutter/material.dart';
import '../../../../app/theme/color_tokens.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  int _selectedPlan = 1; // 0=free, 1=premium, 2=premium+

  final _plans = [
    (
      name: 'Free',
      price: '\$0',
      period: '/forever',
      color: WaveColors.textMuted,
      features: [
        'Ad-supported listening',
        'Shuffle only on mobile',
        '128 kbps audio',
        'Limited skips',
        'Basic search',
      ],
      missing: ['Offline playback', 'High quality audio', 'AI DJ Flux'],
    ),
    (
      name: 'Premium',
      price: '\$9.99',
      period: '/month',
      color: WaveColors.primary,
      features: [
        'Ad-free listening',
        'Offline playback (1000 tracks)',
        '320 kbps audio',
        'Lossless streaming',
        'AI Playlist Generator',
        'Lyrics + translation',
        'Social features',
        'Karaoke mode',
        'Equalizer + DSP',
      ],
      missing: ['Hi-Res Lossless', 'AI DJ Flux personas'],
    ),
    (
      name: 'Premium+',
      price: '\$14.99',
      period: '/month',
      color: WaveColors.qualityHiRes,
      features: [
        'Everything in Premium',
        'Hi-Res Lossless (24-bit/192kHz)',
        'Spatial / Dolby Atmos audio',
        'AI DJ Flux (all personas)',
        'Stem separation (10/month)',
        'AI Remix Studio',
        'Priority support',
        'Early access to new features',
      ],
      missing: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaveColors.bg,
      appBar: AppBar(
        backgroundColor: WaveColors.bg,
        title: const Text('Choose Your Plan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Hero
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: WaveColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.graphic_eq_rounded,
                            color: Colors.white, size: 40),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wavelength Premium',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Music without limits. Cancel anytime.',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Plan cards
                  ...List.generate(_plans.length, (i) {
                    final plan = _plans[i];
                    final selected = _selectedPlan == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPlan = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: selected
                              ? plan.color.withOpacity(0.1)
                              : WaveColors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? plan.color : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan.name,
                                          style: TextStyle(
                                            color: plan.color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              plan.price,
                                              style: const TextStyle(
                                                color: WaveColors.textPrimary,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                plan.period,
                                                style: const TextStyle(
                                                    color:
                                                        WaveColors.textMuted,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: plan.color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 16),
                                    ),
                                ],
                              ),
                              if (selected) ...[
                                const SizedBox(height: 16),
                                const Divider(color: WaveColors.surfaceOverlay),
                                const SizedBox(height: 12),
                                ...plan.features.map(
                                  (f) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded,
                                            color: plan.color, size: 16),
                                        const SizedBox(width: 10),
                                        Text(
                                          f,
                                          style: const TextStyle(
                                            color: WaveColors.textPrimary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Other plans
                  Text(
                    'Also available: Student (\$4.99/mo), Family (\$15.99/mo), Artist (\$19.99/mo)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: WaveColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPlan == 0
                        ? null
                        : () => Navigator.pop(context),
                    child: Text(
                      _selectedPlan == 0
                          ? 'Current Plan'
                          : 'Start 1-Month Free Trial',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cancel anytime. No commitment.',
                  style:
                      TextStyle(color: WaveColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
