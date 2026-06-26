import React, { useState } from 'react'
import { ChevronDown, Heart, MoreHorizontal, SkipBack, SkipForward, Play, Pause,
  Shuffle, Repeat, Mic2, List, Waves, Plus, Share2 } from 'lucide-react'
import { colors, gradients, glass } from '../theme.js'

export default function FullPlayer({ track, isPlaying, onTogglePlay, onClose }) {
  const [liked, setLiked] = useState(track?.liked ?? false)
  const [shuffle, setShuffle] = useState(false)
  const [repeat, setRepeat] = useState(false)
  const [progress, setProgress] = useState(38)

  if (!track) return null

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 1000,
      display: 'flex', flexDirection: 'column',
      overflow: 'hidden',
    }}>
      {/* Blurred pastel background */}
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: `url(https://picsum.photos/seed/${track.cover}/800/800)`,
        backgroundSize: 'cover', backgroundPosition: 'center',
        filter: 'blur(80px) saturate(0.4) brightness(1.5)',
        transform: 'scale(1.3)',
      }} />
      {/* White mist overlay */}
      <div style={{
        position: 'absolute', inset: 0,
        background: 'rgba(252,251,248,0.82)',
      }} />
      {/* Aurora tint */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse at 30% 20%, rgba(252,228,236,0.50) 0%, transparent 60%),
                     radial-gradient(ellipse at 75% 70%, rgba(232,234,246,0.45) 0%, transparent 55%)`,
      }} />

      {/* Content */}
      <div style={{
        position: 'relative', flex: 1, display: 'flex', flexDirection: 'column',
        padding: '0 24px 32px', maxWidth: 430, width: '100%', margin: '0 auto',
      }}>
        {/* Header */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '18px 0 8px' }}>
          <button onClick={onClose} style={{
            background: glass.panel.background,
            backdropFilter: glass.panel.backdropFilter,
            WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
            border: glass.panel.border,
            borderRadius: 12, width: 38, height: 38,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer', color: colors.textPrimary,
            boxShadow: glass.panel.boxShadow,
          }}>
            <ChevronDown size={22} />
          </button>

          <div style={{ textAlign: 'center' }}>
            <div style={{ color: colors.textMuted, fontSize: 10, fontWeight: 700, letterSpacing: 1.8, textTransform: 'uppercase' }}>Now Playing</div>
            <div style={{ color: colors.textPrimary, fontSize: 13, fontWeight: 700, marginTop: 3 }}>Daily Mix</div>
          </div>

          <button style={{
            background: glass.panel.background,
            backdropFilter: glass.panel.backdropFilter,
            WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
            border: glass.panel.border,
            borderRadius: 12, width: 38, height: 38,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer', color: colors.textSecondary,
            boxShadow: glass.panel.boxShadow,
          }}>
            <MoreHorizontal size={20} />
          </button>
        </div>

        {/* Levitating Album Art */}
        <div style={{
          flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center',
          padding: '8px 0 16px',
        }}>
          <div className={isPlaying ? 'float' : ''} style={{
            width: 'min(270px, 68vw)', aspectRatio: '1',
            borderRadius: 26,
            overflow: 'hidden',
            boxShadow: isPlaying
              ? `0 0 0 1px rgba(201,168,76,0.20), 0 24px 64px rgba(0,0,0,0.18), 0 0 60px rgba(201,168,76,0.15)`
              : '0 20px 56px rgba(0,0,0,0.14), 0 0 0 1px rgba(0,0,0,0.05)',
            transition: 'box-shadow 0.4s',
          }}>
            <img src={`https://picsum.photos/seed/${track.cover}/400/400`} alt={track.title}
              style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          </div>
        </div>

        {/* Track info */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 22 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              color: colors.textPrimary, fontSize: 22, fontWeight: 900, letterSpacing: -0.4,
              whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
            }}>
              {track.title}
            </div>
            <div style={{ color: colors.textSecondary, fontSize: 15, marginTop: 4 }}>{track.artist}</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginLeft: 12, flexShrink: 0 }}>
            {track.quality && (
              <span style={{
                background: track.quality === 'HI-RES' ? 'rgba(201,168,76,0.14)' : 'rgba(0,168,150,0.12)',
                color: track.quality === 'HI-RES' ? colors.qualityHiRes : colors.qualityLossless,
                fontSize: 9, fontWeight: 800, padding: '3px 8px', borderRadius: 6,
                border: `1px solid ${track.quality === 'HI-RES' ? 'rgba(201,168,76,0.30)' : 'rgba(0,168,150,0.25)'}`,
                letterSpacing: 0.5,
              }}>{track.quality}</span>
            )}
            <button onClick={() => setLiked(!liked)} style={{
              background: liked ? 'rgba(183,110,121,0.12)' : glass.panel.background,
              backdropFilter: glass.panel.backdropFilter,
              WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
              border: liked ? `1px solid rgba(183,110,121,0.30)` : glass.panel.border,
              borderRadius: 12, width: 38, height: 38,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer', color: liked ? colors.accentRose : colors.textMuted,
              transition: 'all 0.18s',
            }}>
              <Heart size={20} fill={liked ? colors.accentRose : 'none'} />
            </button>
            <button style={{
              background: glass.panel.background,
              backdropFilter: glass.panel.backdropFilter,
              WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
              border: glass.panel.border,
              borderRadius: 12, width: 38, height: 38,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer', color: colors.textMuted,
            }}>
              <Share2 size={18} />
            </button>
          </div>
        </div>

        {/* Seek slider */}
        <div style={{ marginBottom: 24 }}>
          <div style={{ position: 'relative', marginBottom: 6 }}>
            <input
              type="range" min={0} max={100} value={progress}
              onChange={e => setProgress(Number(e.target.value))}
              style={{
                width: '100%', cursor: 'pointer',
                background: `linear-gradient(to right, ${colors.accent} ${progress}%, rgba(0,0,0,0.10) ${progress}%)`,
              }}
            />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ color: colors.textMuted, fontSize: 12, fontWeight: 500 }}>1:34</span>
            <span style={{ color: colors.textMuted, fontSize: 12, fontWeight: 500 }}>{track.duration}</span>
          </div>
        </div>

        {/* Main Controls */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 28 }}>
          <button onClick={() => setShuffle(!shuffle)}
            style={{
              background: shuffle ? 'rgba(201,168,76,0.12)' : 'none',
              border: 'none', cursor: 'pointer', padding: 10, borderRadius: 12,
              color: shuffle ? colors.accent : colors.textMuted, transition: 'all 0.15s',
            }}>
            <Shuffle size={21} />
          </button>

          <button style={{
            background: glass.panel.background,
            backdropFilter: glass.panel.backdropFilter,
            WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
            border: glass.panel.border,
            borderRadius: '50%', width: 46, height: 46,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer', color: colors.textPrimary,
            boxShadow: glass.panel.boxShadow,
          }}>
            <SkipBack size={24} fill={colors.textPrimary} />
          </button>

          {/* Play/Pause — gold gradient */}
          <button onClick={onTogglePlay} style={{
            width: 70, height: 70, borderRadius: '50%',
            background: gradients.gold,
            border: 'none', cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: '0 8px 28px rgba(201,168,76,0.48)',
            transition: 'transform 0.1s, box-shadow 0.2s',
          }}>
            {isPlaying
              ? <Pause size={28} color="#fff" />
              : <Play size={28} fill="#fff" color="#fff" />
            }
          </button>

          <button style={{
            background: glass.panel.background,
            backdropFilter: glass.panel.backdropFilter,
            WebkitBackdropFilter: glass.panel.WebkitBackdropFilter,
            border: glass.panel.border,
            borderRadius: '50%', width: 46, height: 46,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer', color: colors.textPrimary,
            boxShadow: glass.panel.boxShadow,
          }}>
            <SkipForward size={24} fill={colors.textPrimary} />
          </button>

          <button onClick={() => setRepeat(!repeat)}
            style={{
              background: repeat ? 'rgba(201,168,76,0.12)' : 'none',
              border: 'none', cursor: 'pointer', padding: 10, borderRadius: 12,
              color: repeat ? colors.accent : colors.textMuted, transition: 'all 0.15s',
            }}>
            <Repeat size={21} />
          </button>
        </div>

        {/* Bottom action bar */}
        <div style={{
          display: 'flex', justifyContent: 'space-around',
          padding: '12px 0 0',
          borderTop: '1px solid rgba(0,0,0,0.06)',
        }}>
          {[
            { icon: <List size={19} />, label: 'Lyrics' },
            { icon: <Mic2 size={19} />, label: 'Karaoke' },
            { icon: <List size={19} />, label: 'Queue' },
            { icon: <Waves size={19} />, label: 'Spatial' },
          ].map(({ icon, label }) => (
            <button key={label} style={{
              background: 'none', border: 'none', cursor: 'pointer',
              display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5,
              color: colors.textMuted, padding: '6px 14px',
              borderRadius: 12, transition: 'background 0.15s',
            }}
              onMouseEnter={e => e.currentTarget.style.background = 'rgba(0,0,0,0.04)'}
              onMouseLeave={e => e.currentTarget.style.background = 'none'}
            >
              {icon}
              <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: 0.2 }}>{label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
