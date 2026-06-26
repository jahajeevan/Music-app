import React, { useState } from 'react'
import { TrendingUp, TrendingDown, Minus, Flame, Globe, Calendar, ChevronRight } from 'lucide-react'
import { colors, gradients, glass, tracks } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const chartTracks = [
  { ...tracks[6], position: 1, change: 'up', prev: 3 },
  { ...tracks[3], position: 2, change: 'up', prev: 4 },
  { ...tracks[5], position: 3, change: 'same', prev: 3 },
  { ...tracks[0], position: 4, change: 'down', prev: 2 },
  { ...tracks[2], position: 5, change: 'up', prev: 7 },
]

const countries = ['🇺🇸', '🇬🇧', '🇯🇵', '🇰🇷', '🇧🇷', '🇳🇬', '🇮🇳', '🇲🇽']
const countryNames = ['USA', 'UK', 'Japan', 'Korea', 'Brazil', 'Nigeria', 'India', 'Mexico']

const genrePills = [
  { name: 'Afrobeats', color: '#00A896' },
  { name: 'K-Pop', color: '#E84393' },
  { name: 'Amapiano', color: '#C9A84C' },
  { name: 'Drill', color: '#7B68EE' },
  { name: 'Synthwave', color: '#48CAE4' },
  { name: 'Reggaeton', color: '#E17055' },
]

const newFriday = [
  { seed: 'fri1', title: 'Crimson Tide', artist: 'Echo Wave' },
  { seed: 'fri2', title: 'Solar Drift', artist: 'Nova Beat' },
  { seed: 'fri3', title: 'Neon Pulse', artist: 'Synthwave Collective' },
  { seed: 'fri4', title: 'Deep Current', artist: 'Aroha' },
]

function ChangeIcon({ change }) {
  if (change === 'up') return <TrendingUp size={12} color={colors.accentEmerald} />
  if (change === 'down') return <TrendingDown size={12} color={colors.error} />
  return <Minus size={12} color={colors.textMuted} />
}

export default function DiscoverScreen({ onPlayTrack, currentTrack }) {
  const [selectedCountry, setSelectedCountry] = useState(0)

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 8 }}>

      {/* Header */}
      <div style={{
        padding: '20px 20px 20px',
        background: `radial-gradient(ellipse at 80% 20%, rgba(30,111,219,0.12) 0%, transparent 60%),
                     radial-gradient(ellipse at 20% 80%, rgba(123,104,238,0.10) 0%, transparent 60%)`,
      }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 26, letterSpacing: -0.5 }}>Discover</div>
        <div style={{ color: colors.textMuted, fontSize: 13, marginTop: 4 }}>Charts · New releases · Viral tracks</div>
      </div>

      {/* Global Top 50 Chart */}
      <div style={{ margin: '0 20px 22px' }}>
        <div style={{
          ...glass.card,
          padding: '0', overflow: 'hidden',
          border: '1px solid rgba(201,168,76,0.20)',
        }}>
          {/* Chart header */}
          <div style={{
            padding: '14px 16px 12px',
            background: gradients.royal,
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <Globe size={16} color="rgba(255,255,255,0.9)" />
              <span style={{ color: '#fff', fontWeight: 800, fontSize: 16 }}>Global Top 50</span>
            </div>
            <button style={{ display: 'flex', alignItems: 'center', gap: 3, background: 'rgba(255,255,255,0.2)', border: 'none', borderRadius: 20, padding: '4px 10px', cursor: 'pointer', color: '#fff', fontSize: 11, fontWeight: 600 }}>
              Full chart <ChevronRight size={12} />
            </button>
          </div>

          {/* Chart rows */}
          {chartTracks.map((t, idx) => (
            <div key={t.id} onClick={() => onPlayTrack(t)} style={{
              display: 'flex', alignItems: 'center', gap: 10, padding: '10px 16px',
              borderBottom: idx < chartTracks.length - 1 ? `1px solid rgba(0,0,0,0.04)` : 'none',
              cursor: 'pointer', transition: 'background 0.15s',
              background: currentTrack?.id === t.id ? 'rgba(201,168,76,0.06)' : 'transparent',
            }}
              onMouseEnter={e => e.currentTarget.style.background = 'rgba(0,0,0,0.025)'}
              onMouseLeave={e => e.currentTarget.style.background = currentTrack?.id === t.id ? 'rgba(201,168,76,0.06)' : 'transparent'}
            >
              {/* Position badge */}
              <div style={{
                width: 26, height: 26, borderRadius: 8, flexShrink: 0,
                background: t.position <= 3 ? gradients.gold : 'rgba(0,0,0,0.05)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <span style={{
                  color: t.position <= 3 ? '#fff' : colors.textMuted,
                  fontWeight: 900, fontSize: 12,
                }}>{t.position}</span>
              </div>

              <ChangeIcon change={t.change} />

              <img src={`https://picsum.photos/seed/${t.cover}/80/80`} alt={t.title}
                style={{ width: 38, height: 38, borderRadius: 8, objectFit: 'cover', flexShrink: 0 }} />

              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{
                  color: currentTrack?.id === t.id ? colors.accent : colors.textPrimary,
                  fontWeight: 700, fontSize: 13,
                  whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                }}>{t.title}</div>
                <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 1 }}>{t.artist}</div>
              </div>
              <span style={{ color: colors.textMuted, fontSize: 12, flexShrink: 0 }}>{t.duration}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Country Charts */}
      <div style={{ padding: '0 20px 20px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, marginBottom: 14, letterSpacing: -0.3 }}>Charts by Country</div>
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 2 }}>
          {countries.map((flag, i) => (
            <button key={i} onClick={() => setSelectedCountry(i)} style={{
              flexShrink: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5,
              padding: '10px 14px', borderRadius: 16,
              background: selectedCountry === i ? 'rgba(30,111,219,0.10)' : glass.panel.background,
              backdropFilter: glass.panel.backdropFilter,
              WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
              border: `1.5px solid ${selectedCountry === i ? colors.primary : 'rgba(255,255,255,0.9)'}`,
              cursor: 'pointer', transition: 'all 0.15s',
              boxShadow: selectedCountry === i ? `0 4px 16px rgba(30,111,219,0.15)` : '0 2px 8px rgba(0,0,0,0.04)',
            }}>
              <span style={{ fontSize: 22 }}>{flag}</span>
              <span style={{
                color: selectedCountry === i ? colors.primary : colors.textMuted,
                fontSize: 10, fontWeight: 700,
              }}>{countryNames[i]}</span>
            </button>
          ))}
        </div>
      </div>

      {/* New This Friday */}
      <div style={{ padding: '0 20px 0' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <div style={{ width: 32, height: 32, borderRadius: 10, background: gradients.warmSunset, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <Calendar size={15} color="#fff" />
            </div>
            <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, letterSpacing: -0.3 }}>New This Friday</span>
          </div>
          <button style={{ display: 'flex', alignItems: 'center', gap: 2, background: 'none', border: 'none', cursor: 'pointer', color: colors.accent, fontSize: 13, fontWeight: 600, padding: 0 }}>
            All <ChevronRight size={14} />
          </button>
        </div>
        <div style={{ display: 'flex', gap: 14, overflowX: 'auto', paddingBottom: 4 }}>
          {newFriday.map(a => (
            <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[0])}>
              <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
                style={{ width: 130, height: 130, borderRadius: 16, objectFit: 'cover', display: 'block',
                  boxShadow: '0 6px 20px rgba(0,0,0,0.10)' }} />
              <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8,
                maxWidth: 130, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
              <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Going Viral */}
      <div style={{ padding: '22px 20px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
          <Flame size={18} color={colors.error} />
          <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, letterSpacing: -0.3 }}>Going Viral</span>
        </div>
        {tracks.slice(2, 5).map((t, i) => (
          <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
        ))}
      </div>

      {/* Genre Deep Dives */}
      <div style={{ padding: '16px 20px 28px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, marginBottom: 14, letterSpacing: -0.3 }}>Genre Deep Dives</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {genrePills.map(g => (
            <button key={g.name} style={{
              padding: '9px 18px', borderRadius: 24,
              background: `${g.color}12`,
              border: `1.5px solid ${g.color}30`,
              color: g.color, fontWeight: 700, fontSize: 13, cursor: 'pointer',
              transition: 'all 0.15s',
              boxShadow: `0 2px 10px ${g.color}10`,
            }}>{g.name}</button>
          ))}
        </div>
      </div>

    </div>
  )
}
