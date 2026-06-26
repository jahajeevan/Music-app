import React, { useState } from 'react'
import { Home, Search, Compass, Library, Users } from 'lucide-react'
import { colors } from './theme.js'
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
      minHeight: '100vh', background: '#050508', padding: '0',
    }}>
      <div style={{
        width: '100%', maxWidth: 430,
        minHeight: '100vh', background: colors.bg,
        display: 'flex', flexDirection: 'column',
        position: 'relative', overflow: 'hidden',
      }}>
        <div style={{ flex: 1, overflow: 'hidden', position: 'relative' }}>
          <div style={{ position: 'absolute', inset: 0, display: activeTab === 'home' ? 'flex' : 'none', flexDirection: 'column' }}>
            <HomeScreen {...screenProps} />
          </div>
          <div style={{ position: 'absolute', inset: 0, display: activeTab === 'search' ? 'flex' : 'none', flexDirection: 'column' }}>
            <SearchScreen {...screenProps} />
          </div>
          <div style={{ position: 'absolute', inset: 0, display: activeTab === 'discover' ? 'flex' : 'none', flexDirection: 'column' }}>
            <DiscoverScreen {...screenProps} />
          </div>
          <div style={{ position: 'absolute', inset: 0, display: activeTab === 'library' ? 'flex' : 'none', flexDirection: 'column' }}>
            <LibraryScreen {...screenProps} />
          </div>
          <div style={{ position: 'absolute', inset: 0, display: activeTab === 'social' ? 'flex' : 'none', flexDirection: 'column' }}>
            <SocialScreen {...screenProps} />
          </div>
        </div>

        {currentTrack && (
          <MiniPlayer
            track={currentTrack}
            isPlaying={isPlaying}
            onTogglePlay={handleTogglePlay}
            onOpen={() => setShowFullPlayer(true)}
          />
        )}

        <div style={{
          background: colors.surfaceCard,
          borderTop: `1px solid ${colors.surfaceOverlay}`,
          display: 'flex', paddingBottom: 'env(safe-area-inset-bottom, 0px)',
        }}>
          {tabs.map(({ id, label, icon: Icon }) => {
            const active = activeTab === id
            return (
              <button key={id} onClick={() => setActiveTab(id)} style={{
                flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center',
                justifyContent: 'center', padding: '10px 0 12px',
                background: 'none', border: 'none', cursor: 'pointer',
                position: 'relative', gap: 3,
              }}>
                {active && (
                  <div style={{
                    position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)',
                    width: 28, height: 3, borderRadius: '0 0 3px 3px',
                    background: colors.primary,
                  }} />
                )}
                <Icon size={22} color={active ? colors.primary : colors.textMuted}
                  style={{ transition: 'color 0.15s' }} />
                <span style={{
                  fontSize: 10, fontWeight: active ? 700 : 500,
                  color: active ? colors.primary : colors.textMuted,
                  transition: 'color 0.15s',
                }}>{label}</span>
              </button>
            )
          })}
        </div>
      </div>

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
