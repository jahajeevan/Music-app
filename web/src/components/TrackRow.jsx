import React, { useState } from 'react'
import { Heart, MoreHorizontal } from 'lucide-react'
import { colors, glass } from '../theme.js'

export default function TrackRow({ track, index, onPlay, isActive }) {
  const [liked, setLiked] = useState(track.liked)

  return (
    <div
      onClick={() => onPlay(track)}
      style={{
        display: 'flex', alignItems: 'center', gap: 12, padding: '9px 16px',
        background: isActive
          ? 'rgba(201,168,76,0.08)'
          : 'transparent',
        borderRadius: 14, cursor: 'pointer', transition: 'background 0.15s',
        margin: '1px 8px',
      }}
      onMouseEnter={e => { if (!isActive) e.currentTarget.style.background = 'rgba(255,255,255,0.70)' }}
      onMouseLeave={e => { if (!isActive) e.currentTarget.style.background = 'transparent' }}
    >
      {/* Album art */}
      <div style={{ position: 'relative', flexShrink: 0 }}>
        <img src={`https://picsum.photos/seed/${track.cover}/80/80`} alt={track.title}
          style={{
            width: 46, height: 46, borderRadius: 10, objectFit: 'cover', display: 'block',
            boxShadow: '0 3px 10px rgba(0,0,0,0.10)',
          }} />
        {isActive && (
          <div style={{
            position: 'absolute', inset: 0,
            background: 'rgba(201,168,76,0.55)',
            borderRadius: 10,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            gap: 2,
          }}>
            <span className="wave-bar" />
            <span className="wave-bar" />
            <span className="wave-bar" />
            <span className="wave-bar" />
          </div>
        )}
      </div>

      {/* Info */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          color: isActive ? colors.accent : colors.textPrimary,
          fontWeight: 700, fontSize: 14,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
        }}>{track.title}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 2 }}>
          {track.quality && (
            <span style={{
              background: track.quality === 'HI-RES'
                ? 'rgba(201,168,76,0.15)'
                : 'rgba(0,168,150,0.12)',
              color: track.quality === 'HI-RES' ? colors.qualityHiRes : colors.qualityLossless,
              fontSize: 8, fontWeight: 800, padding: '2px 6px', borderRadius: 4,
              letterSpacing: 0.4, border: `1px solid ${track.quality === 'HI-RES' ? 'rgba(201,168,76,0.3)' : 'rgba(0,168,150,0.25)'}`,
            }}>{track.quality}</span>
          )}
          <span style={{ color: colors.textMuted, fontSize: 12,
            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {track.artist}
          </span>
        </div>
      </div>

      {/* Right controls */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, flexShrink: 0 }}>
        <span style={{ color: colors.textMuted, fontSize: 12, marginRight: 2 }}>{track.duration}</span>
        <button
          onClick={e => { e.stopPropagation(); setLiked(!liked) }}
          style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4,
            color: liked ? colors.accentRose : colors.textMuted, transition: 'color 0.15s' }}
        >
          <Heart size={16} fill={liked ? colors.accentRose : 'none'} />
        </button>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, color: colors.textMuted }}>
          <MoreHorizontal size={16} />
        </button>
      </div>
    </div>
  )
}
