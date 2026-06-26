import React, { useState } from 'react'
import { Heart, Flame, MessageCircle, Users, Music2 } from 'lucide-react'
import { colors, gradients, glass, tracks } from '../theme.js'

const friends = [
  { name: 'Alex', seed: 'f1', track: 'Blinding Lights', live: true },
  { name: 'Maya', seed: 'f2', track: 'Los Angeles', live: true },
  { name: 'Juno', seed: 'f3', track: 'Lagos Flex', live: false },
  { name: 'Kim', seed: 'f4', track: 'Mariposa', live: true },
  { name: 'Ravi', seed: 'f5', track: 'Monsters', live: false },
]

const feedItems = [
  { id: 1, user: 'Alex', seed: 'f1', action: 'liked', track: 'Blinding Lights', artist: 'The Weeknd', cover: 'blind', time: '2m ago', hearts: 12 },
  { id: 2, user: 'Maya', seed: 'f2', action: 'started a Listening Party', track: 'Friday Night Vibes', artist: '12 friends', cover: 'party', time: '8m ago', hearts: 28 },
  { id: 3, user: 'Kim', seed: 'f4', action: 'added to playlist', track: 'Lagos Flex', artist: 'DJ Kofi', cover: 'lag2', time: '15m ago', hearts: 5 },
  { id: 4, user: 'Juno', seed: 'f3', action: 'liked', track: 'Mariposa', artist: 'Luna García', cover: 'mar', time: '32m ago', hearts: 9 },
  { id: 5, user: 'Ravi', seed: 'f5', action: 'shared', track: 'Cherry Blossom', artist: 'Yuki Tanaka', cover: 'sak', time: '1h ago', hearts: 17 },
]

export default function SocialScreen({ onPlayTrack }) {
  const [reactions, setReactions] = useState({})

  const toggleReaction = (id, type) => {
    setReactions(r => ({ ...r, [`${id}_${type}`]: !r[`${id}_${type}`] }))
  }

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 8 }}>

      {/* Header */}
      <div style={{
        padding: '20px 20px 18px',
        background: `radial-gradient(ellipse at 70% 10%, rgba(183,110,121,0.12) 0%, transparent 60%)`,
      }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 26, letterSpacing: -0.5 }}>Social</div>
        <div style={{ color: colors.textMuted, fontSize: 13, marginTop: 4 }}>See what friends are listening to</div>
      </div>

      {/* Friends Listening Now — stories */}
      <div style={{ padding: '0 20px 20px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 15, marginBottom: 14 }}>
          Friends Listening Now
        </div>
        <div style={{ display: 'flex', gap: 16, overflowX: 'auto', paddingBottom: 2 }}>
          {friends.map(f => (
            <div key={f.seed} style={{ flexShrink: 0, textAlign: 'center', cursor: 'pointer' }}>
              <div style={{ position: 'relative', display: 'inline-block' }}>
                {/* Animated ring for live */}
                <div style={{
                  width: 66, height: 66, borderRadius: '50%', padding: 2.5,
                  background: f.live ? gradients.roseGold : 'rgba(0,0,0,0.08)',
                  boxShadow: f.live ? '0 4px 18px rgba(183,110,121,0.30)' : 'none',
                }}>
                  <img src={`https://picsum.photos/seed/${f.seed}/200/200`} alt={f.name}
                    style={{
                      width: '100%', height: '100%', borderRadius: '50%',
                      objectFit: 'cover', display: 'block',
                    }} />
                </div>
                {f.live && (
                  <div style={{
                    position: 'absolute', bottom: 2, right: 2,
                    width: 14, height: 14, borderRadius: '50%',
                    background: colors.accentEmerald,
                    border: `2px solid ${colors.bg}`,
                  }} />
                )}
              </div>
              <div style={{ color: colors.textPrimary, fontWeight: 600, fontSize: 11, marginTop: 7 }}>{f.name}</div>
              <div style={{
                color: f.live ? colors.accentRose : colors.textMuted,
                fontSize: 9, marginTop: 1, maxWidth: 66,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
              }}>{f.live ? '🎵 Live' : f.track}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Listening Party Banner */}
      <div style={{ margin: '0 20px 22px' }}>
        <div style={{
          padding: '18px 20px',
          borderRadius: 22,
          background: gradients.warmSunset,
          cursor: 'pointer',
          boxShadow: '0 8px 28px rgba(244,162,97,0.30)',
          position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', right: -20, top: -20, width: 110, height: 110, borderRadius: '50%', background: 'rgba(255,255,255,0.14)' }} />
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', position: 'relative' }}>
            <div>
              <div style={{ color: '#fff', fontWeight: 900, fontSize: 17 }}>Friday Night Vibes</div>
              <div style={{ color: 'rgba(255,255,255,0.78)', fontSize: 12, marginTop: 4, display: 'flex', alignItems: 'center', gap: 6 }}>
                <Users size={13} /> 12 friends · Listening now
              </div>
            </div>
            <button style={{
              background: 'rgba(255,255,255,0.28)',
              backdropFilter: 'blur(8px)',
              border: '1.5px solid rgba(255,255,255,0.60)',
              color: '#fff', fontWeight: 800, fontSize: 13,
              padding: '8px 20px', borderRadius: 24,
              cursor: 'pointer',
            }}>JOIN</button>
          </div>
        </div>
      </div>

      {/* Activity Feed */}
      <div style={{ padding: '0 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 18, marginBottom: 14, letterSpacing: -0.3 }}>Activity</div>

        {feedItems.map(item => (
          <div key={item.id} style={{ marginBottom: 12 }}>
            <div style={{
              ...glass.card,
              padding: 14,
              border: '1px solid rgba(255,255,255,0.92)',
            }}>
              {/* User row */}
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10, marginBottom: 12 }}>
                <div style={{
                  width: 38, height: 38, borderRadius: '50%', flexShrink: 0,
                  padding: 2,
                  background: gradients.roseGold,
                }}>
                  <img src={`https://picsum.photos/seed/${item.seed}/100/100`} alt={item.user}
                    style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover', display: 'block' }} />
                </div>
                <div style={{ flex: 1 }}>
                  <span style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 13 }}>{item.user}</span>
                  <span style={{ color: colors.textSecondary, fontSize: 13 }}> {item.action}</span>
                  <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{item.time}</div>
                </div>
              </div>

              {/* Track embed */}
              <div onClick={() => onPlayTrack(tracks[0])} style={{
                display: 'flex', alignItems: 'center', gap: 10,
                padding: '10px 12px',
                background: 'rgba(0,0,0,0.03)',
                borderRadius: 14, cursor: 'pointer',
                border: '1px solid rgba(0,0,0,0.04)',
                transition: 'background 0.15s',
              }}
                onMouseEnter={e => e.currentTarget.style.background = 'rgba(0,0,0,0.06)'}
                onMouseLeave={e => e.currentTarget.style.background = 'rgba(0,0,0,0.03)'}
              >
                <img src={`https://picsum.photos/seed/${item.cover}/100/100`} alt={item.track}
                  style={{ width: 44, height: 44, borderRadius: 10, objectFit: 'cover', flexShrink: 0,
                    boxShadow: '0 3px 10px rgba(0,0,0,0.10)' }} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13,
                    whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{item.track}</div>
                  <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{item.artist}</div>
                </div>
                <Music2 size={16} color={colors.textMuted} style={{ flexShrink: 0 }} />
              </div>

              {/* Reactions */}
              <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                {[
                  { type: 'heart', icon: <Heart size={13} />, count: item.hearts, activeColor: colors.accentRose },
                  { type: 'fire', icon: <Flame size={13} />, count: Math.floor(item.hearts * 0.6), activeColor: '#E17055' },
                  { type: 'comment', icon: <MessageCircle size={13} />, count: Math.floor(item.hearts * 0.3), activeColor: colors.primary },
                ].map(({ type, icon, count, activeColor }) => {
                  const active = reactions[`${item.id}_${type}`]
                  return (
                    <button key={type} onClick={() => toggleReaction(item.id, type)} style={{
                      display: 'flex', alignItems: 'center', gap: 5,
                      padding: '5px 11px', borderRadius: 20,
                      background: active ? `${activeColor}12` : 'rgba(0,0,0,0.04)',
                      border: `1px solid ${active ? activeColor + '35' : 'transparent'}`,
                      color: active ? activeColor : colors.textMuted,
                      cursor: 'pointer', fontSize: 12, fontWeight: 600,
                      transition: 'all 0.15s',
                    }}>
                      {icon} {count + (active ? 1 : 0)}
                    </button>
                  )
                })}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
