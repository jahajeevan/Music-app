import React, { useState } from 'react'
import { Plus, Music, Users, Download, Heart, ChevronRight } from 'lucide-react'
import { colors, gradients, glass, tracks, artists } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const libTabs = ['Playlists', 'Songs', 'Albums', 'Artists']

const playlists = [
  { name: 'Late Night Drive', count: 34, seed: 'pl1', gradient: gradients.royal },
  { name: 'Morning Boost', count: 22, seed: 'pl2', gradient: gradients.warmSunset },
  { name: 'Study Mode', count: 47, seed: 'pl3', gradient: gradients.emerald },
  { name: 'Afro Vibes', count: 18, seed: 'pl4', gradient: 'linear-gradient(135deg, #C9A84C, #00A896)' },
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
      <div style={{
        padding: '20px 20px 0', flexShrink: 0,
        background: `radial-gradient(ellipse at 30% 0%, rgba(201,168,76,0.12) 0%, transparent 60%)`,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <span style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 26, letterSpacing: -0.5 }}>Library</span>
          <button style={{
            ...glass.card,
            width: 38, height: 38, borderRadius: '50%',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: `1px solid rgba(201,168,76,0.25)`, cursor: 'pointer',
            padding: 0,
          }}>
            <Plus size={20} color={colors.accent} />
          </button>
        </div>

        {/* Stats row */}
        <div style={{ display: 'flex', gap: 12, marginBottom: 16 }}>
          {[
            { icon: Music, label: '847 Songs', color: colors.primary },
            { icon: Heart, label: '234 Liked', color: colors.accentRose },
            { icon: Download, label: '12 Downloads', color: colors.accentEmerald },
          ].map(({ icon: Icon, label, color }) => (
            <div key={label} style={{
              display: 'flex', alignItems: 'center', gap: 6,
              padding: '7px 12px', borderRadius: 12,
              background: `${color}0F`,
              border: `1px solid ${color}20`,
            }}>
              <Icon size={13} color={color} />
              <span style={{ color: colors.textSecondary, fontSize: 11, fontWeight: 600, whiteSpace: 'nowrap' }}>{label}</span>
            </div>
          ))}
        </div>

        {/* Tabs */}
        <div style={{ display: 'flex', gap: 6, paddingBottom: 14, overflowX: 'auto' }}>
          {libTabs.map(t => (
            <button key={t} onClick={() => setTab(t)} style={{
              flexShrink: 0, padding: '8px 18px', borderRadius: 24,
              background: tab === t ? colors.accent : glass.panel.background,
              backdropFilter: glass.panel.backdropFilter,
              WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
              border: tab === t ? 'none' : '1px solid rgba(255,255,255,0.9)',
              color: tab === t ? '#fff' : colors.textSecondary,
              fontWeight: 700, fontSize: 13, cursor: 'pointer', transition: 'all 0.18s',
              boxShadow: tab === t ? '0 4px 16px rgba(201,168,76,0.35)' : '0 2px 8px rgba(0,0,0,0.04)',
            }}>{t}</button>
          ))}
        </div>
      </div>

      {/* Content */}
      <div style={{ flex: 1, overflowY: 'auto', paddingTop: 4 }}>

        {tab === 'Playlists' && (
          <div>
            {/* Liked Songs hero */}
            <div onClick={() => onPlayTrack(tracks[0])} style={{
              margin: '6px 20px 14px',
              padding: '16px 18px',
              borderRadius: 20,
              background: gradients.likedSongs,
              cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14,
              boxShadow: '0 8px 28px rgba(183,110,121,0.30)',
              position: 'relative', overflow: 'hidden',
            }}>
              <div style={{ position: 'absolute', right: -15, top: -15, width: 90, height: 90, borderRadius: '50%', background: 'rgba(255,255,255,0.12)' }} />
              <div style={{
                width: 56, height: 56, borderRadius: 14,
                background: 'rgba(255,255,255,0.22)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                backdropFilter: 'blur(8px)',
              }}>
                <Heart size={26} color="#fff" fill="#fff" />
              </div>
              <div style={{ flex: 1, position: 'relative' }}>
                <div style={{ color: '#fff', fontWeight: 900, fontSize: 18 }}>Liked Songs</div>
                <div style={{ color: 'rgba(255,255,255,0.72)', fontSize: 12, marginTop: 3 }}>847 songs · 48h 23m</div>
              </div>
              <div style={{ width: 36, height: 36, borderRadius: '50%', background: 'rgba(255,255,255,0.25)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <ChevronRight size={17} color="#fff" />
              </div>
            </div>

            {/* Playlists list */}
            {playlists.map(pl => (
              <div key={pl.name} onClick={() => onPlayTrack(tracks[0])} style={{
                display: 'flex', alignItems: 'center', gap: 14, padding: '10px 20px',
                cursor: 'pointer', transition: 'background 0.15s',
                borderRadius: 12, margin: '0 8px',
              }}
                onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.65)'}
                onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
              >
                <div style={{
                  width: 54, height: 54, borderRadius: 14, flexShrink: 0,
                  background: pl.gradient,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  boxShadow: '0 4px 14px rgba(0,0,0,0.12)',
                  overflow: 'hidden',
                }}>
                  <img src={`https://picsum.photos/seed/${pl.seed}/200/200`} alt={pl.name}
                    style={{ width: '100%', height: '100%', objectFit: 'cover', opacity: 0.7 }} />
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 15 }}>{pl.name}</div>
                  <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 2 }}>Playlist · {pl.count} songs</div>
                </div>
                <ChevronRight size={16} color={colors.textMuted} />
              </div>
            ))}
          </div>
        )}

        {tab === 'Songs' && (
          <div style={{ paddingTop: 4 }}>
            {tracks.map((t, i) => (
              <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
            ))}
          </div>
        )}

        {tab === 'Albums' && (
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, padding: '8px 20px 20px' }}>
            {albums.map(a => (
              <div key={a.seed} style={{ cursor: 'pointer' }} onClick={() => onPlayTrack(tracks[0])}>
                <div style={{ position: 'relative', borderRadius: 16, overflow: 'hidden', boxShadow: '0 6px 20px rgba(0,0,0,0.10)' }}>
                  <img src={`https://picsum.photos/seed/${a.seed}/400/400`} alt={a.title}
                    style={{ width: '100%', aspectRatio: '1', objectFit: 'cover', display: 'block' }} />
                </div>
                <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 9,
                  whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
                <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
              </div>
            ))}
          </div>
        )}

        {tab === 'Artists' && (
          <div style={{ paddingTop: 4 }}>
            {artists.map(a => (
              <div key={a.id} style={{
                display: 'flex', alignItems: 'center', gap: 14, padding: '10px 20px',
                cursor: 'pointer', transition: 'background 0.15s',
                borderRadius: 12, margin: '0 8px',
              }}
                onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.65)'}
                onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
              >
                <div style={{
                  width: 56, height: 56, borderRadius: '50%', flexShrink: 0,
                  padding: 2.5, background: gradients.roseGold,
                  boxShadow: '0 4px 14px rgba(183,110,121,0.22)',
                }}>
                  <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.name}
                    style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover', display: 'block' }} />
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 15 }}>{a.name}</div>
                  <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 2 }}>Artist · {a.listeners} monthly listeners</div>
                </div>
                <Users size={15} color={colors.textMuted} />
              </div>
            ))}
          </div>
        )}

      </div>
    </div>
  )
}
