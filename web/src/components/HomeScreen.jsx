import React, { useState } from 'react'
import { Play, Radio, TrendingUp, Brain, CloudRain, Moon, Zap, Music2, ChevronRight } from 'lucide-react'
import { colors, gradients, glass, tracks, artists } from '../theme.js'
import TrackRow from './TrackRow.jsx'

const moods = [
  { label: 'All', emoji: '✨', color: colors.accent },
  { label: 'Happy', emoji: '☀️', color: '#F4A261' },
  { label: 'Chill', emoji: '🌊', color: '#48CAE4' },
  { label: 'Focus', emoji: '🎯', color: '#7B68EE' },
  { label: 'Energetic', emoji: '⚡', color: '#E05C6A' },
  { label: 'Romantic', emoji: '🌹', color: '#B76E79' },
  { label: 'Sleep', emoji: '🌙', color: '#74789A' },
]

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

const aiFeatures = [
  { icon: Brain, label: 'Mood AI', desc: 'Detected: Focused', color: '#7B68EE', bg: 'rgba(123,104,238,0.10)' },
  { icon: CloudRain, label: 'Weather', desc: 'Rainy Day Mix', color: '#48CAE4', bg: 'rgba(72,202,228,0.10)' },
  { icon: Moon, label: 'Sleep', desc: '45 min timer', color: '#74789A', bg: 'rgba(116,120,154,0.10)' },
  { icon: Zap, label: 'BPM Sync', desc: '128 BPM run', color: '#F4A261', bg: 'rgba(244,162,97,0.10)' },
]

function SectionHeader({ title, action }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 20px', marginBottom: 14 }}>
      <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, letterSpacing: -0.3 }}>{title}</span>
      {action && (
        <button style={{ display: 'flex', alignItems: 'center', gap: 2, background: 'none', border: 'none', cursor: 'pointer', color: colors.accent, fontSize: 13, fontWeight: 600, padding: 0 }}>
          {action} <ChevronRight size={14} />
        </button>
      )}
    </div>
  )
}

export default function HomeScreen({ onPlayTrack, currentTrack }) {
  const [selectedMood, setSelectedMood] = useState('All')

  const hour = new Date().getHours()
  const greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening'

  return (
    <div style={{ overflowY: 'auto', height: '100%', paddingBottom: 8 }}>

      {/* Hero Header with aurora */}
      <div style={{
        margin: '0 0 0 0',
        padding: '20px 20px 24px',
        background: gradients.heroMesh,
        position: 'relative', overflow: 'hidden',
      }}>
        {/* Decorative orbs */}
        <div style={{
          position: 'absolute', top: -40, right: -40, width: 180, height: 180,
          borderRadius: '50%',
          background: 'radial-gradient(circle, rgba(201,168,76,0.18) 0%, transparent 70%)',
          pointerEvents: 'none',
        }} />
        <div style={{
          position: 'absolute', bottom: -30, left: -20, width: 140, height: 140,
          borderRadius: '50%',
          background: 'radial-gradient(circle, rgba(183,110,121,0.14) 0%, transparent 70%)',
          pointerEvents: 'none',
        }} />

        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', position: 'relative' }}>
          <div>
            <div style={{ color: colors.textMuted, fontSize: 13, fontWeight: 500, marginBottom: 4 }}>{greeting}</div>
            <div style={{ color: colors.textPrimary, fontSize: 26, fontWeight: 900, letterSpacing: -0.5, lineHeight: 1.1 }}>
              What's the<br />
              <span style={{
                background: gradients.gold,
                WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent',
                backgroundClip: 'text',
              }}>vibe today?</span>
            </div>
            <div style={{ marginTop: 8, display: 'flex', alignItems: 'center', gap: 6 }}>
              <div style={{ width: 8, height: 8, borderRadius: '50%', background: colors.accentEmerald }} />
              <span style={{ color: colors.textMuted, fontSize: 12 }}>847 songs in library</span>
            </div>
          </div>

          {/* Avatar with gold ring */}
          <div style={{
            width: 48, height: 48, borderRadius: '50%',
            padding: 2,
            background: gradients.gold,
            flexShrink: 0,
          }}>
            <img src="https://picsum.photos/seed/user1/80/80" alt="avatar"
              style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover', display: 'block' }} />
          </div>
        </div>
      </div>

      {/* AI Features Row */}
      <div style={{ padding: '20px 20px 0', marginBottom: 20 }}>
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto' }}>
          {aiFeatures.map(({ icon: Icon, label, desc, color, bg }) => (
            <button key={label} style={{
              flexShrink: 0, display: 'flex', alignItems: 'center', gap: 10,
              padding: '11px 14px', borderRadius: 16,
              background: bg, border: `1px solid ${color}22`,
              cursor: 'pointer', textAlign: 'left',
              boxShadow: '0 2px 12px rgba(0,0,0,0.04)',
              transition: 'transform 0.15s',
            }}>
              <div style={{
                width: 34, height: 34, borderRadius: 10,
                background: `${color}22`, display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon size={16} color={color} />
              </div>
              <div>
                <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 12, whiteSpace: 'nowrap' }}>{label}</div>
                <div style={{ color, fontSize: 10, fontWeight: 600, marginTop: 1, whiteSpace: 'nowrap' }}>{desc}</div>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Mood chips */}
      <div style={{ padding: '0 20px', marginBottom: 24 }}>
        <div style={{ display: 'flex', gap: 8, overflowX: 'auto' }}>
          {moods.map(({ label, emoji, color }) => {
            const sel = selectedMood === label
            return (
              <button key={label} onClick={() => setSelectedMood(label)} style={{
                flexShrink: 0, display: 'flex', alignItems: 'center', gap: 6,
                padding: '8px 16px', borderRadius: 24,
                background: sel ? `${color}18` : glass.panel.background,
                backdropFilter: glass.panel.backdropFilter,
                WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
                border: `1.5px solid ${sel ? color : 'rgba(255,255,255,0.9)'}`,
                color: sel ? color : colors.textSecondary,
                fontWeight: sel ? 700 : 500, fontSize: 13, cursor: 'pointer',
                transition: 'all 0.18s',
                boxShadow: sel ? `0 4px 16px ${color}22` : '0 2px 8px rgba(0,0,0,0.04)',
              }}>
                <span>{emoji}</span> {label}
              </button>
            )
          })}
        </div>
      </div>

      {/* Recently Played */}
      <SectionHeader title="Recently Played" action="See all" />
      <div style={{ display: 'flex', gap: 14, padding: '0 20px 24px', overflowX: 'auto' }}>
        {recentAlbums.map(a => (
          <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }}
            onClick={() => onPlayTrack(tracks[0])}>
            <div style={{ position: 'relative', width: 118, height: 118 }}>
              <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
                style={{ width: 118, height: 118, borderRadius: 16, objectFit: 'cover', display: 'block',
                  boxShadow: '0 8px 24px rgba(0,0,0,0.10)' }} />
              <div style={{
                position: 'absolute', bottom: 8, right: 8,
                width: 28, height: 28, borderRadius: '50%',
                background: 'rgba(255,255,255,0.92)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
              }}>
                <Play size={12} fill={colors.textPrimary} color={colors.textPrimary} />
              </div>
            </div>
            <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 8,
              whiteSpace: 'nowrap', maxWidth: 118, overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
            <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
          </div>
        ))}
      </div>

      {/* AI DJ Banner */}
      <div style={{ margin: '0 20px 24px' }}>
        <div style={{
          padding: '20px', borderRadius: 22,
          background: gradients.gold,
          position: 'relative', overflow: 'hidden', cursor: 'pointer',
          boxShadow: '0 8px 32px rgba(201,168,76,0.35)',
        }}>
          <div style={{ position: 'absolute', right: -20, top: -20, width: 130, height: 130, borderRadius: '50%', background: 'rgba(255,255,255,0.15)' }} />
          <div style={{ position: 'absolute', right: 30, bottom: -30, width: 90, height: 90, borderRadius: '50%', background: 'rgba(255,255,255,0.10)' }} />
          <div style={{ display: 'flex', alignItems: 'center', gap: 14, position: 'relative' }}>
            <div style={{
              width: 52, height: 52, borderRadius: 14,
              background: 'rgba(255,255,255,0.3)',
              backdropFilter: 'blur(8px)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              boxShadow: '0 4px 16px rgba(0,0,0,0.12)',
            }}>
              <Radio size={24} color="#fff" />
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ color: '#fff', fontWeight: 900, fontSize: 16, letterSpacing: -0.2 }}>AI DJ is ready</div>
              <div style={{ color: 'rgba(255,255,255,0.80)', fontSize: 12, marginTop: 3 }}>Your personal radio host · Start now</div>
            </div>
            <div style={{
              width: 38, height: 38, borderRadius: '50%',
              background: 'rgba(255,255,255,0.30)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Play size={17} color="#fff" fill="#fff" />
            </div>
          </div>
        </div>
      </div>

      {/* Top Tracks */}
      <div style={{ marginBottom: 4 }}>
        <div style={{ padding: '0 20px', marginBottom: 8, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, letterSpacing: -0.3 }}>Top Tracks</span>
          <TrendingUp size={17} color={colors.accent} />
        </div>
        {tracks.slice(0, 5).map((t, i) => (
          <TrackRow key={t.id} track={t} index={i} onPlay={onPlayTrack} isActive={currentTrack?.id === t.id} />
        ))}
      </div>

      {/* New Releases */}
      <div style={{ marginTop: 24, marginBottom: 4 }}>
        <SectionHeader title="New Releases" action="See all" />
        <div style={{ display: 'flex', gap: 14, padding: '0 20px 20px', overflowX: 'auto' }}>
          {newReleases.map(a => (
            <div key={a.seed} style={{ flexShrink: 0, cursor: 'pointer' }}
              onClick={() => onPlayTrack(tracks[1])}>
              <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.title}
                style={{ width: 140, height: 140, borderRadius: 16, objectFit: 'cover', display: 'block',
                  boxShadow: '0 8px 24px rgba(0,0,0,0.10)' }} />
              <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, marginTop: 9,
                maxWidth: 140, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.title}</div>
              <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{a.artist}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Trending Artists */}
      <div style={{ marginBottom: 24 }}>
        <SectionHeader title="Trending Artists" />
        <div style={{ display: 'flex', gap: 18, padding: '0 20px', overflowX: 'auto' }}>
          {artists.map(a => (
            <div key={a.id} style={{ flexShrink: 0, textAlign: 'center', cursor: 'pointer' }}>
              <div style={{
                width: 76, height: 76, borderRadius: '50%',
                padding: 2.5,
                background: gradients.roseGold,
                boxShadow: '0 6px 20px rgba(183,110,121,0.25)',
              }}>
                <img src={`https://picsum.photos/seed/${a.seed}/200/200`} alt={a.name}
                  style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover', display: 'block' }} />
              </div>
              <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 12, marginTop: 8,
                maxWidth: 76, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{a.name}</div>
              <div style={{ color: colors.textMuted, fontSize: 10, marginTop: 2 }}>{a.listeners}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Music DNA teaser */}
      <div style={{ margin: '0 20px 28px' }}>
        <div style={{
          padding: '18px 20px',
          borderRadius: 20,
          background: gradients.royal,
          boxShadow: '0 8px 28px rgba(30,111,219,0.28)',
          display: 'flex', alignItems: 'center', gap: 14, cursor: 'pointer',
          position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', right: -10, top: -10, width: 100, height: 100, borderRadius: '50%', background: 'rgba(255,255,255,0.08)' }} />
          <div style={{
            width: 46, height: 46, borderRadius: 12,
            background: 'rgba(255,255,255,0.2)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Music2 size={22} color="#fff" />
          </div>
          <div style={{ flex: 1, position: 'relative' }}>
            <div style={{ color: '#fff', fontWeight: 900, fontSize: 15, letterSpacing: -0.2 }}>Your Music DNA</div>
            <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 11, marginTop: 2 }}>See your taste profile — updated weekly</div>
          </div>
          <ChevronRight size={18} color="rgba(255,255,255,0.8)" />
        </div>
      </div>

    </div>
  )
}
