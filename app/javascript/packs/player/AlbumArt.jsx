import * as React from 'react'
import styled from 'styled-components'
import { rgba } from 'polished'

import ImageZoom from '../styled/ImageZoom'

const Image = styled(ImageZoom).attrs({ role: 'presentation' })`
  background-color: ${p => rgba(p.theme.white, 0.4)};
  width: 40px;
  height: 40px;
  object-fit: cover;
  margin-right: 10px;
`
class AlbumArt extends React.Component<Props, State> {
  state = { imageSrc: null }

  componentDidUpdate (prevProps) {
    if (this.props.song !== prevProps.song) this._getArtworkURL()
  }

  render () {
    if (this.state.imageSrc == null) return null
    return (
      <Image
        image={{ src: this.state.imageSrc }}
        zoomImage={{ src: this._largeImageSrc() }}
      />
    )
  }

  _getArtworkURL () {
    fetch(this._queryURL())
      .then(r => r.json())
      .then(data => {
        const { results } = data
        const [firstResult] = results
        const imageSrc = firstResult != null ? firstResult.artworkUrl100 : null
        this.setState({ imageSrc })
      })
  }

  /**
   * The high-resolution image is lazy-loaded when the album art is zoomed in
   */
  _largeImageSrc () {
    const { imageSrc } = this.state
    if (imageSrc == null) return null
    return imageSrc.replace(/100x100/, '1000x1000')
  }

  _queryURL () {
    const { album, artist } = this.props.song
    return (
      'https://itunes.apple.com/search?limit=1&version=2&entity=album&' +
      `term=${encodeURIComponent(`${album} ${artist}`)}`
    )
  }
}
export default AlbumArt
