/**
 * @providesModule SongInformation
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'
import { rgba } from 'polished'

import type { Song } from 'models'

const Container = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 10px;
  padding: 0 5px 0 15px;
  border-left: 1px solid ${p => rgba(p.theme.white, 0.4)};
`

type Props = { song: Song }
const SongInformation = ({ song }: Props) => {
  const { artist, name, album, label, year } = song
  return (
    <Container>
      <strong>
        {artist && `${artist}: `}
        “{name}”
      </strong>
      <span>
        <cite>{album}</cite>
        {(label || year != null) &&
          ` (${label}${label && year ? ' ' : ''}${year || ''})`}
      </span>
    </Container>
  )
}
export default SongInformation
