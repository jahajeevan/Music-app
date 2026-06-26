import React, { useState } from 'react'
import { Heart, Play, MoreHorizontal } from 'lucide-react'
import { colors } from '../theme.js'

export default function TrackRow({ track, index, onPlay, isActive }) {
  const [liked, setLiked] = useState(track.liked)
  return (
    <div
      onClick={() => onPlay(track)}
      style={{
        display: 'flex', alignItems: 'center', gap: 12, padding: '10px 16px',
        background: isActive ? colors.primaryDim : 'transparent',
        borderRadius: 12, cursor: 'pointer', transition: 'background 0.15s',
      }}
      onMouseEnter={e => { if (!isActive) e.currentTarget.style.background = colors.surfaceCard }}
      onMouseLeave={e => { if (!isActive) e.currentTarget.style.background = 'transparent' }}
    >
      <div style={{ position: 'relative', flexShrink: 0 }}>
        <img src={`https://picsum.photos/seed/${track.cover}/80/80`} alt={track.title}
          style={{ width: 46, height: 46, borderRadius: 8, objectFit: 'cover', display: 'block' }} />
        {isActive && (
          <div style={{
            position: 'absolute', inset: 0, background: 'rgba(108,99,255,0.6)',
            borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Play size={16} fill="#fff" color="#fff" />
          </div>
        )}
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          color: isActive ? colors.primary : colors.textPrimary,
          fontWeight: 700, fontSize: 14,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
        }}>{track.title}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 2 }}>
          {track.quality && (
            <span style={{
              background: track.quality === 'HI-RES' ? '#FFD70022' : colors.accent + '22',
              color: track.quality === 'HI-RES' ? '#FFD700' : colors.accent,
              fontSize: 8, fontWeight: 800, padding: '2px 5px', borderRadius: 3, letterSpacing: 0.3,
            }}>{track.quality}</span>
          )}
          <span style={{ color: colors.textMuted, fontSize: 12, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {track.artist}
          </span>
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
        <span style={{ color: colors.textMuted, fontSize: 12 }}>{track.duration}</span>
        <button
          onClick={e => { e.stopPropagation(); setLiked(!liked) }}
          style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, color: liked ? colors.error : colors.textMuted }}
        >
          <Heart size={16} fill={liked ? colors.error : 'none'} />
        </button>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, color: colors.textMuted }}>
          <MoreHorizontal size={16} />
        </button>
      </div>
    </div>
  )
}
