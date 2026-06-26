import React from 'react'
import { Play, Pause, SkipForward, Heart } from 'lucide-react'
import { colors } from '../theme.js'

export default function MiniPlayer({ track, isPlaying, onTogglePlay, onOpen }) {
  if (!track) return null
  return (
    <div
      style={{
        background: colors.surfaceCard,
        borderTop: `1px solid ${colors.surfaceOverlay}`,
        padding: '10px 16px',
        cursor: 'pointer',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Progress bar */}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 2, background: colors.surfaceOverlay }}>
        <div style={{ width: '38%', height: '100%', background: colors.primary, borderRadius: 2 }} />
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }} onClick={onOpen}>
        <img
          src={`https://picsum.photos/seed/${track.cover}/80/80`}
          alt={track.title}
          style={{ width: 44, height: 44, borderRadius: 8, objectFit: 'cover', flexShrink: 0 }}
        />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ color: colors.textPrimary, fontWeight: 700, fontSize: 14, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {track.title}
          </div>
          <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 1 }}>{track.artist}</div>
        </div>
        <button
          onClick={e => { e.stopPropagation(); }}
          style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 6, color: track.liked ? colors.error : colors.textMuted }}
        >
          <Heart size={18} fill={track.liked ? colors.error : 'none'} />
        </button>
        <button
          onClick={e => { e.stopPropagation(); onTogglePlay(); }}
          style={{
            width: 36, height: 36, borderRadius: '50%', background: colors.primary,
            border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', flexShrink: 0,
          }}
        >
          {isPlaying ? <Pause size={16} /> : <Play size={16} fill="#fff" />}
        </button>
        <button
          onClick={e => { e.stopPropagation(); }}
          style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.textMuted, padding: 6 }}
        >
          <SkipForward size={18} />
        </button>
      </div>
    </div>
  )
}
