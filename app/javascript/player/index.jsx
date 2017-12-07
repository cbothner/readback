/**
 * @providesModule Player
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'

const Container = styled.div`
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100vw;
  height: 60px;
  background-color: ${props => props.theme.blue};
  padding: 6px;
  display: flex;
`

const PlayPauseButton = styled.button`
  width: 100px;
`

class Player extends React.Component<{}, { playing: boolean }> {
  audioElement: HTMLAudioElement
  state = { playing: false }

  constructor (props: {}) {
    super(props)

    this.audioElement = document.createElement('audio')
    this.audioElement.src = 'http://floyd.wcbn.org:8000/wcbn-hd.mp3'
  }

  render () {
    const { playing } = this.state
    return (
      <Container>
        <PlayPauseButton playing={playing} onClick={this.handlePlayPause}>
          {playing ? 'Stop' : 'Play'}
        </PlayPauseButton>
      </Container>
    )
  }

  handlePlayPause = () => (this.state.playing ? this._pause() : this._play())

  _play = () => this.setState({ playing: true }, () => this.audioElement.play())
  _pause = () =>
    this.setState({ playing: false }, () => this.audioElement.pause())
}
export default Player
