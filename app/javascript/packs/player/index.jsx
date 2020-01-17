import * as React from 'react'
import styled from 'styled-components'

import PlayPauseButton from './PlayPauseButton'
import SongInformation from './SongInformation'

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

function drupalLinks () {
  return document.querySelectorAll(
    '#wcbn-org-nav a[href^="http"], #wcbn-org-nav a[href^="//"]'
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

class Player extends React.Component {
  audioElement
  state = { playing: false }

  constructor (props) {
    super(props)

    this.audioElement = document.createElement('audio')
  }

  componentDidMount () {
    const url = new URL(window.location)
    if (url.searchParams.has('autoplay')) {
      this._play()
    }
  }

  handleChangeVolume = e => {
    this.audioElement.volume = parseInt(e.currentTarget.value) / 10
  }

  render () {
    const { song } = this.props
    const { playing } = this.state

    return (
      <Container playing={playing}>
        <PlayPauseButton playing={playing} onClick={this.handlePlayPause} />
        <SongInformation
          visible={playing}
          song={song}
          handleChangeVolume={this.handleChangeVolume}
        />
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
