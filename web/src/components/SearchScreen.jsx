import React, { useState } from 'react'
import { Search, Mic, X } from 'lucide-react'
import { colors } from '../theme.js'
import TrackRow from './TrackRow.jsx'
import { tracks } from '../theme.js'

const genres = [
  { name: 'Pop', color: '#FF6B6B', seed: 'pop' },
  { name: 'Hip-Hop', color: '#FFA502', seed: 'hiphop' },
  { name: 'Rock', color: '#6C5CE7', seed: 'rock' },
  { name: 'Electronic', color: '#00CEC9', seed: 'elec' },
  { name: 'R&B', color: '#FD79A8', seed: 'rnb' },
  { name: 'Jazz', color: '#FDCB6E', seed: 'jazz' },
  { name: 'K-Pop', color: '#E84393', seed: 'kpop' },
  { name: 'Latin', color: '#E17055', seed: 'latin' },
  { name: 'Afrobeats', color: '#00D4AA', seed: 'afro' },
  { name: 'Bollywood', color: '#FF7675', seed: 'bolly' },
  { name: 'Podcasts', color: '#74B9FF', seed: 'pod' },
  { name: 'Workout', color: '#55EFC4', seed: 'work' },
]

export default function SearchScreen({ onPlayTrack, currentTrack }) {
  const [query, setQuery] = useState('')
  const filtered = query.length > 1 ? tracks.filter(t =>
    t.title.toLowerCase().includes(query.toLowerCase()) ||
    t.artist.toLowerCase().includes(query.toLowerCase())
  ) : []
  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 8 }}>
      <div style={{ padding: '20px 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 22, marginBottom: 16 }}>Search</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: colors.surfaceCard, borderRadius: 14, padding: '12px 16px', border: `1.5px solid ${query ? colors.primary : 'transparent'}`, transition: 'border 0.15s' }}>
          <Search size={18} color={colors.textMuted} style={{ flexShrink: 0 }} />
          <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Songs, artists, albums..." style={{ flex: 1, background: 'none', border: 'none', outline: 'none', color: colors.textPrimary, fontSize: 15, fontFamily: 'Inter, sans-serif' }} />
          {query ? (<button onClick={() => setQuery('')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.textMuted }}><X size={18} /></button>) : (<button style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.primary }}><Mic size={18} /></button>)}
        </div>
      </div>
      {query.length > 1 ? (
        <div>
          {filtered[0] && (
            <div style={{ padding: '0 20px 16px' }}>
              <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>Top Result</div>
              <div onClick={() => onPlayTrack(filtered[0])} style={{ background: colors.surfaceCard, borderRadius: 16, padding: 16, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14 }}>
                <img src={`https://picsum.photos/seed/${filtered[0].cover}/200/200`} alt={filtered[0].title} style={{ width: 72, height: 72, borderRadius: 12, objectFit: 'cover' }} />
                <div>
                  <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 18 }}>{filtered[0].title}</div>
                  <div style={{ color: colors.textMuted, fontSize: 13, marginTop: 3 }}>Song · {filtered[0].artist}</div>
                </div>
              </div>
            </div>
          )}
          <div style={{ padding: '0 20px 4px' }}><div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 8 }}>Tracks</div></div>
          {filtered.map((t, i) => (<TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />))}
          {filtered.length === 0 && (<div style={{ textAlign: 'center', padding: '40px 20px', color: colors.textMuted }}>No results for "{query}"</div>)}
        </div>
      ) : (
        <div style={{ padding: '0 20px' }}>
          <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 14 }}>Browse Categories</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            {genres.map(g => (
              <div key={g.name} style={{ borderRadius: 14, overflow: 'hidden', cursor: 'pointer', height: 80, background: `linear-gradient(135deg, ${g.color}dd, ${g.color}77)`, display: 'flex', alignItems: 'flex-end', padding: 14, position: 'relative' }}>
                <img src={`https://picsum.photos/seed/${g.seed}/100/100`} alt={g.name} style={{ position: 'absolute', right: -8, top: -8, width: 70, height: 70, borderRadius: 10, objectFit: 'cover', opacity: 0.6, transform: 'rotate(20deg)' }} />
                <span style={{ color: '#fff', fontWeight: 800, fontSize: 15, position: 'relative', textShadow: '0 1px 4px rgba(0,0,0,0.4)' }}>{g.name}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
