export const colors = {
  bg: '#0A0A0F',
  surface: '#111118',
  surfaceCard: '#1A1A2E',
  surfaceElevated: '#16213E',
  surfaceOverlay: '#2A2A4A',
  primary: '#6C63FF',
  primaryDim: 'rgba(108,99,255,0.15)',
  accent: '#00D4AA',
  accentWarm: '#FF6B6B',
  textPrimary: '#F0F0FF',
  textSecondary: '#A0A0C0',
  textMuted: '#606080',
  error: '#FF4757',
  warning: '#FFA502',
  qualityLossless: '#00D4AA',
  qualityHiRes: '#FFD700',
}

export const gradients = {
  primary: 'linear-gradient(135deg, #6C63FF, #00D4AA)',
  warm: 'linear-gradient(135deg, #FF6B6B, #FFA502)',
  dark: 'linear-gradient(180deg, #1A1A2E, #0A0A0F)',
  likedSongs: 'linear-gradient(135deg, #6C63FF, #4A90D9)',
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
