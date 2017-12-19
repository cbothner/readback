/**
 * @providesModule AlbumArt
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'
import { rgba } from 'polished'

import type { Song } from 'models'

const Image = styled.img.attrs({ role: 'presentation' })`
  background-color: ${p => rgba(p.theme.white, 0.4)};
  width: 40px;
  height: 40px;
  object-fit: cover;
  margin-right: 10px;
`

type Props = { song: Song }
type State = { imageSrc: ?string }
class AlbumArt extends React.Component<Props, State> {
  state = { imageSrc: null }

  componentDidUpdate (prevProps: Props) {
    if (this.props.song !== prevProps.song) this._getArtworkURL()
  }

  render () {
    if (this.state.imageSrc == null) return null
    return <Image src={this.state.imageSrc} />
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

  _queryURL () {
    const { album, artist } = this.props.song
    return (
      'https://itunes.apple.com/search?limit=1&version=2&entity=album&' +
      `term=${encodeURIComponent(`${album} ${artist}`)}`
    )
  }
}
export default AlbumArt
