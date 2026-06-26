export const colors = {
  bg: '#FCFBF8',
  surface: '#F8F6F2',
  surfaceCard: '#FAF7F3',
  glass: 'rgba(255,255,255,0.72)',
  glassStrong: 'rgba(255,255,255,0.90)',
  border: 'rgba(201,168,76,0.15)',
  borderLight: 'rgba(255,255,255,0.90)',
  primary: '#1E6FDB',
  primaryDim: 'rgba(30,111,219,0.10)',
  accent: '#C9A84C',
  accentRose: '#B76E79',
  accentChampagne: '#E8D5B0',
  accentPurple: '#7B68EE',
  accentTeal: '#00B4D8',
  accentEmerald: '#00A896',
  textPrimary: '#1A1A2E',
  textSecondary: '#4A4A6A',
  textMuted: '#9090B0',
  error: '#E05C6A',
  warning: '#D4A017',
  qualityLossless: '#00A896',
  qualityHiRes: '#C9A84C',
  shadowSm: 'rgba(0,0,0,0.05)',
  shadowMd: 'rgba(0,0,0,0.09)',
  shadowLg: 'rgba(0,0,0,0.14)',
}

export const gradients = {
  aurora: 'linear-gradient(-45deg, #FCE4EC, #E8EAF6, #E0F7FA, #FFF8E1, #F3E5F5, #E8F5E9)',
  auroraSubtle: 'linear-gradient(135deg, #FFF9F4 0%, #F0F4FF 50%, #F4FFF9 100%)',
  gold: 'linear-gradient(135deg, #C9A84C 0%, #E8D5B0 60%, #C9A84C 100%)',
  roseGold: 'linear-gradient(135deg, #B76E79 0%, #E8B4B8 60%, #C9A84C 100%)',
  royal: 'linear-gradient(135deg, #1E6FDB 0%, #7B68EE 100%)',
  emerald: 'linear-gradient(135deg, #00B4D8 0%, #00A896 100%)',
  warmSunset: 'linear-gradient(135deg, #FFCBA4 0%, #FFB347 50%, #E8A87C 100%)',
  likedSongs: 'linear-gradient(135deg, #B76E79 0%, #7B68EE 100%)',
  heroMesh: `radial-gradient(ellipse at 20% 30%, rgba(252,228,236,0.85) 0%, transparent 55%),
             radial-gradient(ellipse at 80% 15%, rgba(232,234,246,0.80) 0%, transparent 50%),
             radial-gradient(ellipse at 60% 85%, rgba(224,247,250,0.75) 0%, transparent 55%),
             radial-gradient(ellipse at 10% 80%, rgba(255,248,225,0.70) 0%, transparent 50%)`,
  cardSheen: 'linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(255,255,255,0.6) 100%)',
}

export const glass = {
  panel: {
    background: 'rgba(255,255,255,0.72)',
    backdropFilter: 'blur(20px)',
    WebkitBackdropFilter: 'blur(20px)',
    border: '1px solid rgba(255,255,255,0.90)',
    boxShadow: '0 8px 32px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04)',
  },
  card: {
    background: 'rgba(255,255,255,0.82)',
    backdropFilter: 'blur(16px)',
    WebkitBackdropFilter: 'blur(16px)',
    border: '1px solid rgba(255,255,255,0.95)',
    boxShadow: '0 4px 24px rgba(0,0,0,0.06), 0 1px 4px rgba(0,0,0,0.04)',
    borderRadius: 20,
  },
  strong: {
    background: 'rgba(255,255,255,0.93)',
    backdropFilter: 'blur(24px)',
    WebkitBackdropFilter: 'blur(24px)',
    border: '1px solid rgba(255,255,255,1)',
    boxShadow: '0 12px 40px rgba(0,0,0,0.08)',
  },
  nav: {
    background: 'rgba(252,251,248,0.88)',
    backdropFilter: 'blur(28px)',
    WebkitBackdropFilter: 'blur(28px)',
    borderTop: '1px solid rgba(201,168,76,0.15)',
    boxShadow: '0 -4px 24px rgba(0,0,0,0.05)',
  },
}

export const tracks = [
  { id: 1, title: 'Los Angeles', artist: 'The Midnight', duration: '4:08', cover: 'mon', liked: true, quality: 'LOSSLESS' },
  { id: 2, title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20', cover: 'blind', liked: false, quality: 'HI-RES' },
  { id: 3, title: 'Accra Sunset', artist: 'DJ Kofi', duration: '3:44', cover: 'lag', liked: true, quality: '' },
  { id: 4, title: 'Mariposa', artist: 'Luna García', duration: '3:58', cover: 'mar', liked: false, quality: '' },
  { id: 5, title: 'Cherry Blossom', artist: 'Yuki Tanaka', duration: '6:24', cover: 'sak', liked: true, quality: 'LOSSLESS' },
  { id: 6, title: 'Monsters', artist: 'The Midnight', duration: '5:12', cover: 'mon2', liked: false, quality: '' },
  { id: 7, title: 'Lagos Flex', artist: 'DJ Kofi', duration: '3:28', cover: 'lag2', liked: true, quality: '' },
  { id: 8, title: 'Daydream', artist: 'The Midnight', duration: '4:38', cover: 'day', liked: false, quality: '' },
]

export const artists = [
  { id: 1, name: 'The Midnight', listeners: '4.2M', seed: 'tm' },
  { id: 2, name: 'Aroha', listeners: '1.8M', seed: 'aroha' },
  { id: 3, name: 'DJ Kofi', listeners: '3.1M', seed: 'kofi' },
  { id: 4, name: 'Yuki Tanaka', listeners: '920K', seed: 'yuki' },
  { id: 5, name: 'Luna García', listeners: '2.4M', seed: 'luna' },
]
