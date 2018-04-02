/**
 * @providesModule Player
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'

import PlayPauseButton from './PlayPauseButton'
import SongInformation from './SongInformation'

import type { Song } from 'models'

const WCBN_HD_STREAM_URL = 'http://floyd.wcbn.org:8000/wcbn-hd.mp3'

const Container = styled.div`
  position: fixed;
  bottom: 0;
  left: 0;
  display: flex;
  align-items: stretch;

  width: ${p => (p.playing ? 'auto' : '0')};
  color: ${p => p.theme.white};
  font-family: 'Lato';
`

function drupalLinks (): NodeList<HTMLAnchorElement> {
  if (!document) return new NodeList()
  return document.querySelectorAll(
    // Typecating this string to the literal 'a' so that our NodeList knows it’s
    // full of HTMLAnchorElements
    (('#wcbn-org-nav a[href^="http"], #wcbn-org-nav a[href^="//"]': any): 'a')
  )
}

function addTargetBlankToDrupalLinks () {
  drupalLinks().forEach(link => {
    link.target = '_blank'
    link.rel = 'noopener noreferrer'
  })
}

function removeTargetBlankFromDrupalLinks () {
  drupalLinks().forEach(link => {
    link.target = ''
    link.rel = ''
  })
}

type Props = { song: Song }
class Player extends React.Component<Props, { playing: boolean }> {
  audioElement: ?HTMLAudioElement
  state = { playing: false }

  componentDidMount () {
    this.audioElement = document.createElement('audio')

    const url = new URL(window.location)
    if (url.searchParams.has('autoplay')) {
      this._play()
    }
  }

  render () {
    const { song } = this.props
    const { playing } = this.state

    return (
      <Container playing={playing}>
        <PlayPauseButton playing={playing} onClick={this.handlePlayPause} />
        <SongInformation visible={playing} song={song} />
      </Container>
    )
  }

  handlePlayPause = () => (this.state.playing ? this._pause() : this._play())

  _play = () =>
    this.setState({ playing: true }, () => {
      this.audioElement && (this.audioElement.src = WCBN_HD_STREAM_URL)
      this.audioElement && this.audioElement.play()
      addTargetBlankToDrupalLinks()
    })
  _pause = () =>
    this.setState({ playing: false }, () => {
      this.audioElement && this.audioElement.pause()
      this.audioElement && (this.audioElement.src = '')
      removeTargetBlankFromDrupalLinks()
    })
}
export default Player
