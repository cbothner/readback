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
  width: 60px;
  height: 60px;
  border: 3px solid black;
  border-radius: 50%;
  display: flex;
  vertical-align: middle;
  align-items: center;
  justify-content: center;
`

const PlayPauseIcon = styled.i.attrs({
  className: ({ playing }) => `fa fa-2x fa-${playing ? 'pause' : 'play'}`,
})``

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
        <PlayPauseButton onClick={this.handlePlayPause}>
          <PlayPauseIcon playing={playing} />
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
