import React from 'react'
import { Play, Pause, SkipForward, Heart, ChevronUp } from 'lucide-react'
import { colors, gradients, glass } from '../theme.js'

export default function MiniPlayer({ track, isPlaying, onTogglePlay, onOpen }) {
  if (!track) return null

  return (
    <div style={{
      ...glass.strong,
      borderTop: 'none',
      borderRadius: '20px 20px 0 0',
      padding: '0 0 2px',
      margin: '0 8px',
      overflow: 'hidden',
      position: 'relative',
    }}>
      {/* Gold progress bar */}
      <div style={{ height: 3, background: 'rgba(0,0,0,0.06)', borderRadius: '20px 20px 0 0' }}>
        <div style={{
          width: '38%', height: '100%',
          background: gradients.gold,
          borderRadius: 3,
          boxShadow: '0 0 8px rgba(201,168,76,0.50)',
        }} />
      </div>

      <div style={{ padding: '10px 14px 12px', display: 'flex', alignItems: 'center', gap: 12 }}>
        {/* Expand handle */}
        <button onClick={onOpen} style={{
          background: 'none', border: 'none', cursor: 'pointer', padding: 0,
          color: colors.textMuted, position: 'absolute', top: 6, left: '50%',
          transform: 'translateX(-50%)',
        }}>
          <div style={{ width: 32, height: 3, borderRadius: 2, background: 'rgba(0,0,0,0.12)' }} />
        </button>

        {/* Album art */}
        <div onClick={onOpen} style={{ cursor: 'pointer', flexShrink: 0, marginTop: 4 }}>
          <img
            src={`https://picsum.photos/seed/${track.cover}/80/80`}
            alt={track.title}
            style={{
              width: 46, height: 46, borderRadius: 12, objectFit: 'cover', display: 'block',
              boxShadow: '0 4px 14px rgba(0,0,0,0.14)',
            }}
          />
        </div>

        {/* Track info */}
        <div style={{ flex: 1, minWidth: 0 }} onClick={onOpen} >
          <div style={{
            color: colors.textPrimary, fontWeight: 700, fontSize: 14,
            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
          }}>
            {track.title}
          </div>
          <div style={{ color: colors.textMuted, fontSize: 12, marginTop: 2 }}>{track.artist}</div>
        </div>

        {/* Controls */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 2, flexShrink: 0 }}>
          <button
            onClick={e => { e.stopPropagation(); }}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 6,
              color: track.liked ? colors.accentRose : colors.textMuted }}
          >
            <Heart size={19} fill={track.liked ? colors.accentRose : 'none'} />
          </button>
          <button
            onClick={e => { e.stopPropagation(); onTogglePlay(); }}
            style={{
              width: 40, height: 40, borderRadius: '50%',
              background: gradients.gold,
              border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              boxShadow: '0 4px 16px rgba(201,168,76,0.40)',
              transition: 'transform 0.1s',
            }}
          >
            {isPlaying
              ? <Pause size={17} color="#fff" />
              : <Play size={17} fill="#fff" color="#fff" />
            }
          </button>
          <button
            onClick={e => e.stopPropagation()}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 6, color: colors.textMuted }}
          >
            <SkipForward size={19} />
          </button>
        </div>
      </div>
    </div>
  )
}
