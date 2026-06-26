import React, { useState } from 'react'
import { Play, Radio, TrendingUp } from 'lucide-react'
import { colors, gradients, tracks, artists } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const moods = ['All', 'Happy', 'Chill', 'Energetic', 'Sad', 'Focus', 'Party']
const moodColors = { Happy: '#FFA502', Chill: '#74B9FF', Energetic: '#FF6B6B', Sad: '#6C5CE7', Focus: '#00D4AA', Party: '#FD79A8' }

const recentAlbums = [
  { seed: 'mon', title: 'Monsters', artist: 'The Midnight' },
  { seed: 'blind', title: 'After Hours', artist: 'The Weeknd' },
  { seed: 'lag', title: 'Lagos Nights', artist: 'DJ Kofi' },
  { seed: 'mar', title: 'Mariposa', artist: 'Luna García' },
  { seed: 'sak', title: 'Sakura Protocol', artist: 'Yuki Tanaka' },
]

const newReleases = [
  { seed: 'rel1', title: 'Neon Dreams', artist: 'Synthwave Collective' },
  { seed: 'rel2', title: 'Afro Spirit', artist: 'DJ Kofi' },
  { seed: 'rel3', title: 'Midnight Drive', artist: 'The Midnight' },
  { seed: 'rel4', title: 'Bloom', artist: 'Aroha' },
]

export default function HomeScreen({ onPlayTrack, currentTrack }) {
  const [selectedMood, setSelectedMood] = useState('All')

  return (
    <div style={{ overflowY: 'auto', height: '100%', paddingBottom: 8 }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '20px 20px 12px' }}>
        <div>
          <div style={{ color: colors.textMuted, fontSize: 13 }}>Good Evening 👋</div>
          <div style={{ color: colors.textPrimary, fontSize: 22, fontWeight: 900 }}>What's the vibe?</div>
        </div>
        <img src="https://picsum.photos/seed/user1/80/80" alt="avatar"
          style={{ width: 40, height: 40, borderRadius: '50%', objectFit: 'cover' }} />
      </div>

      {/* Mood chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 20px 20px', overflowX: 'auto', paddingBottom: 4 }}>
        {moods.map(mood => {
          const sel = selectedMood === mood
          const c = moodColors[mood] || colors.primary
          return (
            <button key={mood} onClick={() => setSelectedMood(mood)} style={{
              flexShrink: 0, padding: '7px 16px', borderRadius: 20,
              background: sel ? c + '22' : colors.surfaceCard,
              border: `1.5px solid ${sel ? c : 'transparent'}`,
              color: sel ? c : colors.textSecondary,
              fontWeight: 700, fontSize: 13, cursor: 'pointer', transition: 'all 0.15s',
              fontFamily: 'Inter, sans-serif',
            }}>{mood}</button>
          )
        })}
      </div>

      {/* Recently Played */}
      <div style={{ padding: '0 20px 4px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18 }}>Recently Played</span>
        <span style={{ color: colors.primary, fontSize: 13, fontWeight: 600, cursor: 'pointer' }}>See all</span>
      </div>
      <div style={{ display: 'flex', gap: 12, padding: '12px 20px 20px', overflowX: 'auto' }}>
        {recentAlbums.map(a => (
          <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[0])}>
            <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
              style={{ width: 120, height: 120, borderRadius: 14, objectFit: 'cover', display: 'block' }} />
            <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8, whiteSpace: 'nowrap', maxWidth: 120, overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
            <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
          </div>
        ))}
      </div>

      {/* AI DJ Banner */}
      <div style={{ margin: '0 20px 20px', padding: '20px', borderRadius: 20, background: gradients.primary, position: 'relative', overflow: 'hidden', cursor: 'pointer' }}>
        <div style={{ position: 'absolute', right: -20, top: -20, width: 120, height: 120, borderRadius: '50%', background: 'rgba(255,255,255,0.08)' }} />
        <div style={{ position: 'absolute', right: 20, top: 10, width: 60, height: 60, borderRadius: '50%', background: 'rgba(255,255,255,0.06)' }} />
        <div style={{ display: 'flex', alignItems: 'center', gap: 16, position: 'relative' }}>
          <div style={{
            width: 52, height: 52, borderRadius: '50%', background: 'rgba(255,255,255,0.2)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Radio size={26} color="#fff" />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ color: '#fff', fontWeight: 900, fontSize: 16 }}>AI DJ Flux is ready</div>
            <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 12, marginTop: 2 }}>Your personal AI radio host. Start now.</div>
          </div>
          <div style={{ width: 36, height: 36, borderRadius: '50%', background: 'rgba(255,255,255,0.25)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <Play size={18} color="#fff" fill="#fff" />
          </div>
        </div>
      </div>

      {/* Top Tracks */}
      <div style={{ padding: '0 20px 12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18 }}>Top Tracks This Week</span>
        <TrendingUp size={18} color={colors.primary} />
      </div>
      <div style={{ paddingBottom: 4 }}>
        {tracks.slice(0, 5).map((t, i) => (
          <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
        ))}
      </div>

      {/* New Releases */}
      <div style={{ padding: '16px 20px 12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18 }}>New Releases 🎵</span>
        <span style={{ color: colors.primary, fontSize: 13, fontWeight: 600, cursor: 'pointer' }}>See all</span>
      </div>
      <div style={{ display: 'flex', gap: 12, padding: '0 20px 20px', overflowX: 'auto' }}>
        {newReleases.map(a => (
          <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[1])}>
            <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
              style={{ width: 140, height: 140, borderRadius: 14, objectFit: 'cover', display: 'block' }} />
            <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8, maxWidth: 140, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
            <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
          </div>
        ))}
      </div>

      {/* Trending Artists */}
      <div style={{ padding: '0 20px 12px' }}>
        <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18 }}>Trending Artists</span>
      </div>
      <div style={{ display: 'flex', gap: 16, padding: '0 20px 24px', overflowX: 'auto' }}>
        {artists.map(a => (
          <div key={a.id} style={{ flexShrink: 0, textAlign: 'center', cursor: 'pointer' }}>
            <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.name}
              style={{ width: 76, height: 76, borderRadius: '50%', objectFit: 'cover', display: 'block', border: `2px solid ${colors.surfaceOverlay}` }} />
            <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 12, marginTop: 8, maxWidth: 76, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.name}</div>
            <div style={{ color: colors.textMuted, fontSize: 10, marginTop: 2 }}>{a.listeners}</div>
          </div>
        ))}
      </div>
    </div>
  )
}
