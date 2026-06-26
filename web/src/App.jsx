import React, { useState } from 'react'
import { Home, Search, Compass, Library, Users } from 'lucide-react'
import { colors, gradients, glass } from './theme.js'
import HomeScreen from './components/HomeScreen.jsx'
import SearchScreen from './components/SearchScreen.jsx'
import DiscoverScreen from './components/DiscoverScreen.jsx'
import LibraryScreen from './components/LibraryScreen.jsx'
import SocialScreen from './components/SocialScreen.jsx'
import MiniPlayer from './components/MiniPlayer.jsx'
import FullPlayer from './components/FullPlayer.jsx'

const tabs = [
  { id: 'home', label: 'Home', icon: Home },
  { id: 'search', label: 'Search', icon: Search },
  { id: 'discover', label: 'Discover', icon: Compass },
  { id: 'library', label: 'Library', icon: Library },
  { id: 'social', label: 'Social', icon: Users },
]

export default function App() {
  const [activeTab, setActiveTab] = useState('home')
  const [currentTrack, setCurrentTrack] = useState(null)
  const [isPlaying, setIsPlaying] = useState(false)
  const [showFullPlayer, setShowFullPlayer] = useState(false)

  const handlePlayTrack = (track) => {
    setCurrentTrack(track)
    setIsPlaying(true)
  }

  const handleTogglePlay = () => setIsPlaying(p => !p)

  const screenProps = { onPlayTrack: handlePlayTrack, currentTrack }

  return (
    <div style={{
      display: 'flex', justifyContent: 'center', alignItems: 'flex-start',
      minHeight: '100vh',
      background: 'linear-gradient(160deg, #F5F0FF 0%, #FFF5F0 30%, #F0F5FF 60%, #FFFFF0 100%)',
    }}>
      {/* Phone shell */}
      <div style={{
        width: '100%', maxWidth: 430,
        minHeight: '100vh', background: colors.bg,
        display: 'flex', flexDirection: 'column',
        position: 'relative', overflow: 'hidden',
        boxShadow: '0 0 80px rgba(0,0,0,0.12)',
      }}>
        {/* Aurora mesh background layer */}
        <div style={{
          position: 'fixed', inset: 0, zIndex: 0, pointerEvents: 'none',
          background: gradients.heroMesh,
          maxWidth: 430,
        }} />

        {/* Screen content */}
        <div style={{ flex: 1, overflow: 'hidden', position: 'relative', zIndex: 1 }}>
          {[
            { id: 'home', Comp: HomeScreen },
            { id: 'search', Comp: SearchScreen },
            { id: 'discover', Comp: DiscoverScreen },
            { id: 'library', Comp: LibraryScreen },
            { id: 'social', Comp: SocialScreen },
          ].map(({ id, Comp }) => (
            <div key={id} style={{
              position: 'absolute', inset: 0,
              display: activeTab === id ? 'flex' : 'none',
              flexDirection: 'column',
            }}>
              <Comp {...screenProps} />
            </div>
          ))}
        </div>

        {/* Mini Player */}
        {currentTrack && !showFullPlayer && (
          <div style={{ position: 'relative', zIndex: 10 }}>
            <MiniPlayer
              track={currentTrack}
              isPlaying={isPlaying}
              onTogglePlay={handleTogglePlay}
              onOpen={() => setShowFullPlayer(true)}
            />
          </div>
        )}

        {/* Glass Bottom Nav */}
        <div style={{
          ...glass.nav,
          display: 'flex',
          paddingBottom: 'env(safe-area-inset-bottom, 0px)',
          position: 'relative', zIndex: 10,
        }}>
          {tabs.map(({ id, label, icon: Icon }) => {
            const active = activeTab === id
            return (
              <button key={id} onClick={() => setActiveTab(id)} style={{
                flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center',
                justifyContent: 'center', padding: '10px 0 12px',
                background: 'none', border: 'none', cursor: 'pointer',
                position: 'relative', gap: 3, transition: 'opacity 0.15s',
              }}>
                {active && (
                  <div style={{
                    position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)',
                    width: 24, height: 2.5, borderRadius: '0 0 3px 3px',
                    background: colors.accent,
                  }} />
                )}
                <div style={{
                  padding: '4px 10px', borderRadius: 12,
                  background: active ? `rgba(201,168,76,0.12)` : 'transparent',
                  transition: 'background 0.2s',
                }}>
                  <Icon size={21} color={active ? colors.accent : colors.textMuted}
                    strokeWidth={active ? 2.2 : 1.7}
                    style={{ transition: 'color 0.15s' }} />
                </div>
                <span style={{
                  fontSize: 10, fontWeight: active ? 700 : 500,
                  color: active ? colors.accent : colors.textMuted,
                  transition: 'color 0.15s', letterSpacing: 0.2,
                }}>{label}</span>
              </button>
            )
          })}
        </div>
      </div>

      {/* Full Player overlay */}
      {showFullPlayer && currentTrack && (
        <div style={{
          position: 'fixed', inset: 0, zIndex: 1000,
          display: 'flex', justifyContent: 'center', alignItems: 'flex-end',
        }}>
          <div style={{ width: '100%', maxWidth: 430, height: '100%' }}>
            <FullPlayer
              track={currentTrack}
              isPlaying={isPlaying}
              onTogglePlay={handleTogglePlay}
              onClose={() => setShowFullPlayer(false)}
            />
          </div>
        </div>
      )}
    </div>
  )
}
