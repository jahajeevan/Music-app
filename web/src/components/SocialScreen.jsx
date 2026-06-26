import React, { useState } from 'react'
import { Heart, Flame, MessageCircle, Users } from 'lucide-react'
import { colors, gradients, tracks } from '../theme.js'

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
      <div style={{ padding: '20px 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 900, fontSize: 22 }}>Social</div>
      </div>

      {/* Friends listening now */}
      <div style={{ padding: '0 20px 8px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 15, marginBottom: 12 }}>Friends Listening Now</div>
        <div style={{ display: 'flex', gap: 14, overflowX: 'auto', paddingBottom: 4 }}>
          {friends.map(f => (
            <div key={f.seed} style={{ flexShrink: 0, textAlign: 'center', cursor: 'pointer' }}>
              <div style={{ position: 'relative', display: 'inline-block' }}>
                <img src={`https://picsum.photos/seed/${f.seed}/200/200`} alt={f.name}
                  style={{
                    width: 60, height: 60, borderRadius: '50%', objectFit: 'cover', display: 'block',
                    border: f.live ? `2px solid ${colors.accent}` : `2px solid ${colors.surfaceOverlay}`,
                  }} />
                {f.live && (
                  <div style={{
                    position: 'absolute', bottom: 2, right: 2,
                    width: 12, height: 12, borderRadius: '50%', background: colors.accent,
                    border: `2px solid ${colors.bg}`,
                  }} />
                )}
              </div>
              <div style={{ color: colors.textPrimary, fontWeight: 600, fontSize: 11, marginTop: 6 }}>{f.name}</div>
              <div style={{ color: colors.textMuted, fontSize: 9, marginTop: 1, maxWidth: 60, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{f.track}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Listening Party banner */}
      <div style={{ margin: '12px 20px', padding: 18, borderRadius: 20, background: gradients.warm, cursor: 'pointer' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ color: '#fff', fontWeight: 900, fontSize: 16 }}>Friday Night Vibes 🎉</div>
            <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 12, marginTop: 3, display: 'flex', alignItems: 'center', gap: 6 }}>
              <Users size={13} /> 12 friends listening
            </div>
          </div>
          <button style={{
            background: 'rgba(255,255,255,0.25)', border: '1.5px solid rgba(255,255,255,0.5)',
            color: '#fff', fontWeight: 800, fontSize: 13, padding: '8px 18px', borderRadius: 20,
            cursor: 'pointer', fontFamily: 'Inter, sans-serif',
          }}>JOIN</button>
        </div>
      </div>

      {/* Activity feed */}
      <div style={{ padding: '4px 20px 12px' }}>
        <div style={{ color: colors.textPrimary, fontWeight: 800, fontSize: 16, marginBottom: 12 }}>Activity</div>
        {feedItems.map(item => (
          <div key={item.id} style={{ marginBottom: 12 }}>
            <div style={{ background: colors.surfaceCard, borderRadius: 16, padding: 14 }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10, marginBottom: 10 }}>
                <img src={`https://picsum.photos/seed/${item.seed}/100/100`} alt={item.user}
                  style={{ width: 36, height: 36, borderRadius: '50%', objectFit: 'cover', flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <span style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13 }}>{item.user}</span>
                  <span style={{ color: colors.textMuted, fontSize: 13 }}> {item.action}</span>
                  <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{item.time}</div>
                </div>
              </div>

              {/* Track embed */}
              <div onClick={() => onPlayTrack(tracks[0])} style={{
                display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px',
                background: colors.surfaceElevated, borderRadius: 12, cursor: 'pointer',
              }}>
                <img src={`https://picsum.photos/seed/${item.cover}/100/100`} alt={item.track}
                  style={{ width: 44, height: 44, borderRadius: 8, objectFit: 'cover', flexShrink: 0 }} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 13, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{item.track}</div>
                  <div style={{ color: colors.textMuted, fontSize: 11, marginTop: 2 }}>{item.artist}</div>
                </div>
              </div>

              {/* Reactions */}
              <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                {[
                  { type: 'heart', icon: <Heart size={14} />, count: item.hearts },
                  { type: 'fire', icon: <Flame size={14} />, count: Math.floor(item.hearts * 0.6) },
                  { type: 'comment', icon: <MessageCircle size={14} />, count: Math.floor(item.hearts * 0.3) },
                ].map(({ type, icon, count }) => {
                  const active = reactions[`${item.id}_${type}`]
                  return (
                    <button key={type} onClick={() => toggleReaction(item.id, type)} style={{
                      display: 'flex', alignItems: 'center', gap: 5, padding: '5px 10px', borderRadius: 20,
                      background: active ? colors.primaryDim : colors.surfaceOverlay,
                      border: `1px solid ${active ? colors.primary : 'transparent'}`,
                      color: active ? colors.primary : colors.textMuted,
                      cursor: 'pointer', fontSize: 12, fontWeight: 600, fontFamily: 'Inter, sans-serif',
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
