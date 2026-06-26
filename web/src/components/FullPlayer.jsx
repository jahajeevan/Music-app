import React, { useState } from 'react'
import { ChevronDown, Heart, MoreHorizontal, SkipBack, SkipForward, Play, Pause, Shuffle, Repeat, Mic2, List, Waves, Plus } from 'lucide-react'
import { colors } from '../theme.js'

export default function FullPlayer({ track, isPlaying, onTogglePlay, onClose }) {
  const [liked, setLiked] = useState(track?.liked ?? false)
  const [shuffle, setShuffle] = useState(false)
  const [repeat, setRepeat] = useState(false)
  const [progress, setProgress] = useState(38)
  if (!track) return null
  return (
    <div style={{ position: 'fixed', inset: 0, zIndex: 1000, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div style={{ position: 'absolute', inset: 0, backgroundImage: `url(https://picsum.photos/seed/${track.cover}/800/800)`, backgroundSize: 'cover', backgroundPosition: 'center', filter: 'blur(60px) brightness(0.3)', transform: 'scale(1.2)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(10,10,15,0.6)' }} />
      <div style={{ position: 'relative', flex: 1, display: 'flex', flexDirection: 'column', padding: '0 24px 24px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 0' }}>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.textPrimary, padding: 4 }}><ChevronDown size={28} /></button>
          <div style={{ textAlign: 'center' }}>
            <div style={{ color: colors.textMuted, fontSize: 11, fontWeight: 600, letterSpacing: 1.5, textTransform: 'uppercase' }}>Now Playing</div>
            <div style={{ color: colors.textPrimary, fontSize: 14, fontWeight: 700, marginTop: 2 }}>Daily Mix</div>
          </div>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: colors.textPrimary, padding: 4 }}><MoreHorizontal size={24} /></button>
        </div>
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '16px 0' }}>
          <div style={{ width: 'min(280px, 70vw)', aspectRatio: '1', borderRadius: 20, overflow: 'hidden', boxShadow: isPlaying ? `0 0 60px ${colors.primary}55, 0 20px 60px rgba(0,0,0,0.6)` : '0 20px 60px rgba(0,0,0,0.6)', transition: 'box-shadow 0.3s' }}>
            <img src={`https://picsum.photos/seed/${track.cover}/400/400`} alt={track.title} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          </div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ color: colors.textPrimary, fontSize: 22, fontWeight: 900, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{track.title}</div>
            <div style={{ color: colors.textSecondary, fontSize: 15, marginTop: 2 }}>{track.artist}</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginLeft: 12 }}>
            {track.quality && (
              <span style={{ background: track.quality === 'HI-RES' ? colors.qualityHiRes + '22' : colors.accent + '22', color: track.quality === 'HI-RES' ? colors.qualityHiRes : colors.accent, fontSize: 9, fontWeight: 800, padding: '3px 7px', borderRadius: 4, border: `1px solid ${track.quality === 'HI-RES' ? colors.qualityHiRes : colors.accent}44`, letterSpacing: 0.5 }}>{track.quality}</span>
            )}
            <button onClick={() => setLiked(!liked)} style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, color: liked ? colors.error : colors.textMuted }}>
              <Heart size={22} fill={liked ? colors.error : 'none'} />
            </button>
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, color: colors.textMuted }}><Plus size={22} /></button>
          </div>
        </div>
        <div style={{ marginBottom: 20 }}>
          <input type="range" min={0} max={100} value={progress} onChange={e => setProgress(Number(e.target.value))} style={{ width: '100%', accentColor: colors.primary, height: 4, cursor: 'pointer' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 6 }}>
            <span style={{ color: colors.textMuted, fontSize: 12 }}>1:34</span>
            <span style={{ color: colors.textMuted, fontSize: 12 }}>{track.duration}</span>
          </div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 28 }}>
          <button onClick={() => setShuffle(!shuffle)} style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 8, color: shuffle ? colors.primary : colors.textMuted }}><Shuffle size={20} /></button>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 8, color: colors.textPrimary }}><SkipBack size={26} fill={colors.textPrimary} /></button>
          <button onClick={onTogglePlay} style={{ width: 64, height: 64, borderRadius: '50%', background: colors.primary, border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', boxShadow: `0 0 30px ${colors.primary}66` }}>
            {isPlaying ? <Pause size={28} /> : <Play size={28} fill="#fff" />}
          </button>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 8, color: colors.textPrimary }}><SkipForward size={26} fill={colors.textPrimary} /></button>
          <button onClick={() => setRepeat(!repeat)} style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 8, color: repeat ? colors.primary : colors.textMuted }}><Repeat size={20} /></button>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-around' }}>
          {[{ icon: <List size={20} />, label: 'Lyrics' }, { icon: <Mic2 size={20} />, label: 'Karaoke' }, { icon: <List size={20} />, label: 'Queue' }, { icon: <Waves size={20} />, label: 'Spatial' }].map(({ icon, label }) => (
            <button key={label} style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, color: colors.textMuted, padding: '6px 12px' }}>
              {icon}
              <span style={{ fontSize: 10, fontWeight: 600 }}>{label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
