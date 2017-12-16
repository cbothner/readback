/**
 * @providesModule Player
 * @flow
 */

import * as React from 'react'
import styled, { css } from 'styled-components'
import { rgba } from 'polished'

import type { Song } from 'models'

const WCBN_HD_STREAM_URL = 'http://floyd.wcbn.org:8000/wcbn-hd.mp3'

const Container = styled.div`
  position: fixed;
  bottom: 0;
  left: 0;
  background-color: ${props => props.theme.blue};
  padding: 10px;
  display: flex;

  border-top-right-radius: 4px;
`

const PlayPauseButton = styled.button`
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;

  color: ${p => p.theme.white};
  text-shadow: none;

  border: none;
  border-radius: 50%;
  box-shadow: none;
  background: transparent;

  cursor: pointer;

  .tab-focus &:focus {
    border: 1px solid ${p => rgba(p.theme.white, 0.4)};
    background: ${p => rgba(p.theme.white, 0.15)};
  }

  &:hover {
    background: ${p => rgba(p.theme.white, 0.15)};
  }

  &:active {
    box-shadow: none;
    background: ${p => rgba(p.theme.white, 0.3)};
  }

  &:focus {
    box-shadow: none;
  }
`

const PlayPauseIcon = styled.i.attrs({
  'aria-label': p =>
    p.playing ? 'Stop radio playback.' : 'Listen to the radio.',
  className: p => `fa fa-2x fa-${p.playing ? 'pause' : 'play'}`,
})`
  ${p =>
    p.playing ||
    css`
      margin-left: 4px; /* to make the play button visually centered */
    `};
`

function drupalLinks (): NodeList<HTMLAnchorElement> {
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
  audioElement: HTMLAudioElement
  state = { playing: false }

  constructor (props: Props) {
    super(props)

    this.audioElement = document.createElement('audio')
  }

  render () {
    const { playing } = this.state
    return (
      <Container>
        <PlayPauseButton onClick={this.handlePlayPause}>
          <PlayPauseIcon playing={playing} />
        </PlayPauseButton>
      </Container>
    )
  }

  handlePlayPause = () => (this.state.playing ? this._pause() : this._play())

  _play = () =>
    this.setState({ playing: true }, () => {
      this.audioElement.src = WCBN_HD_STREAM_URL
      this.audioElement.play()
      addTargetBlankToDrupalLinks()
    })
  _pause = () =>
    this.setState({ playing: false }, () => {
      this.audioElement.pause()
      this.audioElement.src = ''
      removeTargetBlankFromDrupalLinks()
    })
}
export default Player
