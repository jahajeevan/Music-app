import React, { useState } from 'react'
import { Search, Mic, X, Waves } from 'lucide-react'
import { colors, glass, tracks } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const genres = [
  { name: 'Pop', gradient: 'linear-gradient(135deg, #FF6B9D, #FF8E6E)', seed: 'pop' },
  { name: 'Hip-Hop', gradient: 'linear-gradient(135deg, #F4A261, #E76F51)', seed: 'hiphop' },
  { name: 'Rock', gradient: 'linear-gradient(135deg, #7B68EE, #5A4FCF)', seed: 'rock' },
  { name: 'Electronic', gradient: 'linear-gradient(135deg, #00CEC9, #00B4D8)', seed: 'elec' },
  { name: 'R&B', gradient: 'linear-gradient(135deg, #FD79A8, #E84393)', seed: 'rnb' },
  { name: 'Jazz', gradient: 'linear-gradient(135deg, #C9A84C, #E8D5B0)', seed: 'jazz' },
  { name: 'K-Pop', gradient: 'linear-gradient(135deg, #E84393, #B76E79)', seed: 'kpop' },
  { name: 'Latin', gradient: 'linear-gradient(135deg, #E17055, #D63031)', seed: 'latin' },
  { name: 'Afrobeats', gradient: 'linear-gradient(135deg, #00A896, #02C39A)', seed: 'afro' },
  { name: 'Bollywood', gradient: 'linear-gradient(135deg, #FF7675, #E17055)', seed: 'bolly' },
  { name: 'Podcasts', gradient: 'linear-gradient(135deg, #74B9FF, #48CAE4)', seed: 'pod' },
  { name: 'Workout', gradient: 'linear-gradient(135deg, #55EFC4, #00B894)', seed: 'work' },
]

const aiSearchModes = [
  { label: 'Hum to Search', icon: '🎵', desc: 'Sing a melody' },
  { label: 'Identify Song', icon: '👂', desc: 'Hear around you' },
  { label: 'Mood Search', icon: '✨', desc: 'Describe a feeling' },
]

export default function SearchScreen({ onPlayTrack, currentTrack }) {
  const [query, setQuery] = useState('')
  const filtered = query.length > 1 ? tracks.filter(t =>
    t.title.toLowerCase().includes(query.toLowerCase()) ||
    t.artist.toLowerCase().includes(query.toLowerCase())
  ) : []

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 8, background: 'transparent' }}>

      {/* Header */}
      <div style={{ padding: '20px 20px 0' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 26, letterSpacing: -0.5, marginBottom: 16 }}>
          Search
        </div>

        {/* Search bar — glass */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          ...glass.strong,
          borderRadius: 16, padding: '12px 16px',
          border: query
            ? `1.5px solid ${colors.accent}`
            : '1.5px solid rgba(255,255,255,0.95)',
          transition: 'all 0.2s',
          boxShadow: query ? `0 4px 24px rgba(201,168,76,0.18)` : glass.strong.boxShadow,
        }}>
          <Search size={18} color={query ? colors.accent : colors.textMuted} style={{ flexShrink: 0 }} />
          <input
            value={query} onChange={e => setQuery(e.target.value)}
            placeholder="Songs, artists, albums, moods..."
            style={{
              flex: 1, background: 'none', border: 'none', outline: 'none',
              color: colors.textPrimary, fontSize: 15,
            }}
          />
          {query ? (
            <button onClick={() => setQuery('')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.textMuted, padding: 2 }}>
              <X size={17} />
            </button>
          ) : (
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.accent, padding: 2 }}>
              <Mic size={17} />
            </button>
          )}
        </div>
      </div>

      {query.length > 1 ? (
        <div style={{ padding: '16px 0 0' }}>
          {filtered[0] && (
            <div style={{ padding: '0 20px 16px' }}>
              <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>Top Result</div>
              <div
                onClick={() => onPlayTrack(filtered[0])}
                style={{
                  ...glass.card,
                  padding: 16, cursor: 'pointer',
                  display: 'flex', alignItems: 'center', gap: 14,
                  transition: 'transform 0.15s',
                }}>
                <img src={`https://picsum.photos/seed/${filtered[0].cover}/200/200`} alt={filtered[0].title}
                  style={{ width: 74, height: 74, borderRadius: 14, objectFit: 'cover',
                    boxShadow: '0 4px 16px rgba(0,0,0,0.12)' }} />
                <div>
                  <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 18 }}>{filtered[0].title}</div>
                  <div style={{ color: colors.textMuted, fontSize: 13, marginTop: 4 }}>Song · {filtered[0].artist}</div>
                </div>
              </div>
            </div>
          )}
          <div style={{ padding: '0 20px 8px' }}>
            <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 4 }}>Tracks</div>
          </div>
          {filtered.map((t, i) => (
            <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
          ))}
          {filtered.length === 0 && (
            <div style={{ textAlign: 'center', padding: '40px 20px', color: colors.textMuted }}>
              No results for "{query}"
            </div>
          )}
        </div>
      ) : (
        <div style={{ padding: '20px 20px 0' }}>

          {/* AI Search Modes */}
          <div style={{ marginBottom: 22 }}>
            <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>AI-Powered Search</div>
            <div style={{ display: 'flex', gap: 10 }}>
              {aiSearchModes.map(m => (
                <button key={m.label} style={{
                  flex: 1, padding: '12px 10px', borderRadius: 16,
                  ...glass.card,
                  display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
                  cursor: 'pointer', border: '1px solid rgba(201,168,76,0.20)',
                  transition: 'transform 0.15s',
                }}>
                  <span style={{ fontSize: 24 }}>{m.icon}</span>
                  <span style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 11, textAlign: 'center' }}>{m.label}</span>
                  <span style={{ color: colors.textMuted, fontSize: 10 }}>{m.desc}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Browse by Genre — staggered grid */}
          <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 14 }}>Browse Categories</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            {genres.map((g, i) => (
              <div key={g.name} style={{
                borderRadius: 16, overflow: 'hidden', cursor: 'pointer',
                height: i === 0 ? 110 : 88,
                background: g.gradient,
                display: 'flex', alignItems: 'flex-end', padding: '14px 14px',
                position: 'relative',
                boxShadow: '0 4px 16px rgba(0,0,0,0.10)',
                transition: 'transform 0.15s',
              }}>
                <img src={`https://picsum.photos/seed/${g.seed}/100/100`} alt={g.name}
                  style={{
                    position: 'absolute', right: -6, top: -6,
                    width: i === 0 ? 80 : 64, height: i === 0 ? 80 : 64,
                    borderRadius: 12, objectFit: 'cover',
                    opacity: 0.55, transform: 'rotate(18deg)',
                    boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
                  }} />
                <span style={{
                  color: '#fff', fontWeight: 800, fontSize: i === 0 ? 17 : 15,
                  position: 'relative', textShadow: '0 1px 6px rgba(0,0,0,0.25)',
                }}>{g.name}</span>
              </div>
            ))}
          </div>

          <div style={{ height: 24 }} />
        </div>
      )}
    </div>
  )
}
