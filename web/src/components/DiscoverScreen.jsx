import React, { useState } from 'react'
import { TrendingUp, TrendingDown, Minus } from 'lucide-react'
import { colors } from '../theme.js'
import TrackRow from './TrackRow.jsx'
import { tracks } from '../theme.js'

const chartTracks = [
  { ...tracks[6], position: 1, change: 'up', prev: 3 },
  { ...tracks[3], position: 2, change: 'up', prev: 4 },
  { ...tracks[5], position: 3, change: 'same', prev: 3 },
  { ...tracks[0], position: 4, change: 'down', prev: 2 },
  { ...tracks[2], position: 5, change: 'up', prev: 7 },
]

const countries = ['🇺🇸', '🇬🇧', '🇯🇵', '🇰🇷', '🇧🇷', '🇳🇬', '🇮🇳', '🇲🇽']
const countryNames = ['USA', 'UK', 'Japan', 'Korea', 'Brazil', 'Nigeria', 'India', 'Mexico']

const genres = [
  { name: 'Afrobeats', color: '#00D4AA' },
  { name: 'K-Pop', color: '#FD79A8' },
  { name: 'Amapiano', color: '#FFA502' },
  { name: 'Drill', color: '#6C5CE7' },
  { name: 'Synthwave', color: '#74B9FF' },
  { name: 'Reggaeton', color: '#E17055' },
]

const newFriday = [
  { seed: 'fri1', title: 'Crimson Tide', artist: 'Echo Wave' },
  { seed: 'fri2', title: 'Solar Drift', artist: 'Nova Beat' },
  { seed: 'fri3', title: 'Neon Pulse', artist: 'Synthwave Collective' },
  { seed: 'fri4', title: 'Deep Current', artist: 'Aroha' },
]

export default function DiscoverScreen({ onPlayTrack, currentTrack }) {
  const [selectedCountry, setSelectedCountry] = useState(0)

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 8 }}>
      <div style={{ padding: '20px 20px 8px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 22 }}>Discover</div>
      </div>

      {/* Global Top 50 */}
      <div style={{ margin: '12px 20px', padding: '16px', background: colors.surfaceCard, borderRadius: 20 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
          <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16 }}>🌍 Global Top 50</span>
          <span style={{ color: colors.primary, fontSize: 12, fontWeight: 600, cursor: 'pointer' }}>Full chart →</span>
        </div>
        {chartTracks.map(t => (
          <div key={t.id} onClick={() => onPlayTrack(t)} style={{
            display: 'flex', alignItems: 'center', gap: 10, padding: '8px 0',
            borderBottom: `1px solid ${colors.surfaceOverlay}`, cursor: 'pointer',
          }}>
            <span style={{ color: colors.textMuted, fontWeight: 800, fontSize: 14, width: 20, textAlign: 'center' }}>{t.position}</span>
            <div style={{ color: t.change === 'up' ? colors.accent : t.change === 'down' ? colors.error : colors.textMuted, width: 14 }}>
              {t.change === 'up' ? <TrendingUp size={13} /> : t.change === 'down' ? <TrendingDown size={13} /> : <Minus size={13} />}
            </div>
            <img src={`https://picsum.photos/seed/${t.cover}/80/80`} alt={t.title}
              style={{ width: 36, height: 36, borderRadius: 6, objectFit: 'cover' }} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ color: currentTrack?.id === t.id ? colors.primary : colors.textPrimary, fontWeight: 700, fontSize: 13, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{t.title}</div>
              <div style={{ color: colors.textMuted, fontSize: 11 }}>{t.artist}</div>
            </div>
            <span style={{ color: colors.textMuted, fontSize: 12 }}>{t.duration}</span>
          </div>
        ))}
      </div>

      {/* Country charts */}
      <div style={{ padding: '0 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>Charts by Country</div>
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 4 }}>
          {countries.map((flag, i) => (
            <button key={i} onClick={() => setSelectedCountry(i)} style={{
              flexShrink: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
              padding: '10px 14px', borderRadius: 14,
              background: selectedCountry === i ? colors.primaryDim : colors.surfaceCard,
              border: `1.5px solid ${selectedCountry === i ? colors.primary : 'transparent'}`,
              cursor: 'pointer', fontFamily: 'Inter, sans-serif',
            }}>
              <span style={{ fontSize: 24 }}>{flag}</span>
              <span style={{ color: selectedCountry === i ? colors.primary : colors.textMuted, fontSize: 10, fontWeight: 600 }}>{countryNames[i]}</span>
            </button>
          ))}
        </div>
      </div>

      {/* New This Friday */}
      <div style={{ padding: '4px 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>New This Friday 🎉</div>
        <div style={{ display: 'flex', gap: 12, overflowX: 'auto' }}>
          {newFriday.map(a => (
            <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[0])}>
              <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
                style={{ width: 130, height: 130, borderRadius: 14, objectFit: 'cover', display: 'block' }} />
              <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8, maxWidth: 130, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
              <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Going Viral */}
      <div style={{ padding: '8px 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 10 }}>Going Viral 🔥</div>
        {tracks.slice(2, 5).map((t, i) => (
          <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
        ))}
      </div>

      {/* Genre pills */}
      <div style={{ padding: '8px 20px 24px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>Genre Deep Dives</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {genres.map(g => (
            <button key={g.name} style={{
              padding: '8px 18px', borderRadius: 20,
              background: g.color + '22', border: `1.5px solid ${g.color}55`,
              color: g.color, fontWeight: 700, fontSize: 13, cursor: 'pointer', fontFamily: 'Inter, sans-serif',
            }}>{g.name}</button>
          ))}
        </div>
      </div>
    </div>
  )
}
