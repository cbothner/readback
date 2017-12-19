/**
 * @providesModule SongInformation
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'
import { rgba } from 'polished'

import { Motion, spring } from 'react-motion'

import AlbumArt from './AlbumArt'

import type { Song } from 'models'

const Container = styled.div`
  padding-left: 4px;
  background-color: ${props => props.theme.blue};
  border-top-right-radius: 4px;
  display: flex;
  align-items: center;
`

const InfoBox = styled.div`
  padding: 0 15px;
  border-left: 1px solid ${p => rgba(p.theme.white, 0.4)};
  display: flex;
  align-items: center;
`

type Props = { song: Song, visible: boolean }
const SongInformation = ({ song, visible }: Props) => {
  const { artist, name, album, label, year } = song
  return (
    <Motion style={{ x: spring(visible ? 0 : 1) }}>
      {({ x }) => (
        <Container
          style={{
            transform: `translate(calc(${x * -100}% + ${x * 4}px))`,
          }}
        >
          <InfoBox>
            <AlbumArt song={song} />
            <div>
              <div>
                <strong>
                  {artist && `${artist}: `}
                  “{name}”
                </strong>
              </div>
              <div>
                <span>
                  <cite>{album}</cite>
                  {(label || year != null) &&
                    ` (${label}${label && year ? ' ' : ''}${year || ''})`}
                </span>
              </div>
            </div>
          </InfoBox>
        </Container>
      )}
    </Motion>
  )
}
export default SongInformation
