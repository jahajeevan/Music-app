import React, { useState } from 'react'
import { Plus, Music, Disc3, Users } from 'lucide-react'
import { colors, gradients, tracks, artists } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const tabs = ['Playlists', 'Songs', 'Albums', 'Artists']

const playlists = [
  { name: 'Late Night Drive', count: 34, seed: 'pl1' },
  { name: 'Morning Boost', count: 22, seed: 'pl2' },
  { name: 'Study Mode', count: 47, seed: 'pl3' },
  { name: 'Afro Vibes', count: 18, seed: 'pl4' },
]

const albums = [
  { title: 'Monsters', artist: 'The Midnight', seed: 'mon' },
  { title: 'Lagos Nights', artist: 'DJ Kofi', seed: 'lag' },
  { title: 'Mariposa', artist: 'Luna García', seed: 'mar' },
  { title: 'Sakura Protocol', artist: 'Yuki Tanaka', seed: 'sak' },
  { title: 'Te Ao Hou', artist: 'Aroha', seed: 'tao' },
  { title: 'After Hours', artist: 'The Weeknd', seed: 'blind' },
]

export default function LibraryScreen({ onPlayTrack, currentTrack }) {
  const [tab, setTab] = useState('Playlists')
  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      {/* Header */}
      <div style={{ padding: '20px 20px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
        <span style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 22 }}>Your Library</span>
        <button style={{ background: colors.surfaceCard, border: 'none', cursor: 'pointer', width: 36, height: 36, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.textPrimary }}>
          <Plus size={20} />
        </button>
      </div>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: 6, padding: '14px 20px 0', overflowX: 'auto', flexShrink: 0 }}>
        {tabs.map(t => (
          <button key={t} onClick={() => setTab(t)} style={{
            flexShrink: 0, padding: '7px 18px', borderRadius: 20,
            background: tab === t ? colors.primary : colors.surfaceCard,
            border: 'none', color: tab === t ? '#fff' : colors.textSecondary,
            fontWeight: 700, fontSize: 13, cursor: 'pointer', transition: 'all 0.15s', fontFamily: 'Inter, sans-serif',
          }}>{t}</button>
        ))}
      </div>

      {/* Content */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '14px 0 8px' }}>
        {tab === 'Playlists' && (
          <div>
            {/* Liked Songs */}
            <div onClick={() => onPlayTrack(tracks[0])} style={{
              margin: '0 20px 12px', padding: 16, borderRadius: 16,
              background: gradients.likedSongs, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14,
            }}>
              <div style={{ width: 60, height: 60, borderRadius: 12, background: 'rgba(255,255,255,0.2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Music size={28} color="#fff" />
              </div>
              <div>
                <div style={{ color: '#fff', fontWeight: 900, fontSize: 17 }}>Liked Songs</div>
                <div style={{ color: 'rgba(255,255,255,0.7)', fontSize: 12, marginTop: 2 }}>847 songs</div>
              </div>
            </div>
            {playlists.map(pl => (
              <div key={pl.name} onClick={() => onPlayTrack(tracks[0])} style={{
                display: 'flex', alignItems: 'center', gap: 12, padding: '10px 20px',
                cursor: 'pointer',
              }}
                onMouseEnter={e => e.currentTarget.style.background = colors.surfaceCard}
                onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
              >
                <img src={`https://picsum.photos/seed/${pl.seed}/200/200`} alt={pl.name}
                  style={{ width: 52, height: 52, borderRadius: 10, objectFit: 'cover', flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 14 }}>{pl.name}</div>
                  <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 2 }}>Playlist · {pl.count} songs</div>
                </div>
              </div>
            ))}
          </div>
        )}

        {tab === 'Songs' && (
          <div>
            {tracks.map((t, i) => (
              <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
            ))}
          </div>
        )}

        {tab === 'Albums' && (
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, padding: '0 20px' }}>
            {albums.map(a => (
              <div key={a.seed} style={{ cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[0])}>
                <img src={`https://picsum.photos/seed/${a.seed}/400/400`} alt={a.title}
                  style={{ width: '100%', aspectRatio: '1', borderRadius: 14, objectFit: 'cover', display: 'block' }} />
                <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
                <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
              </div>
            ))}
          </div>
        )}

        {tab === 'Artists' && (
          <div>
            {artists.map(a => (
              <div key={a.id} style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '10px 20px', cursor: 'pointer' }}
                onMouseEnter={e => e.currentTarget.style.background = colors.surfaceCard}
                onMouseLeave={e => e.currentTarget.style.background = 'transparent'}>
                <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.name}
                  style={{ width: 56, height: 56, borderRadius: '50%', objectFit: 'cover', flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 14 }}>{a.name}</div>
                  <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 2 }}>Artist · {a.listeners} monthly</div>
                </div>
                <Users size={16} color={colors.textMuted} />
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
