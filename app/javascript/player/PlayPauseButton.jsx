/**
 * @providesModule PlayPauseButton
 * @flow
 */

import * as React from 'react'
import styled, { css } from 'styled-components'
import { rgba } from 'polished'

const Container = styled.div`
  background-color: ${props => props.theme.blue};
  padding: 10px;
  padding-right: 6px;

  z-index: 1;
`

const Button = styled.button`
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

  transition: background-color 0.7s ease;

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

const Icon = styled.i.attrs({
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

type Props = { onClick: (e: SyntheticMouseEvent<*>) => mixed, playing: boolean }
const PlayPauseButton = ({ onClick, playing }: Props) => (
  <Container>
    <Button onClick={onClick}>
      <Icon playing={playing} />
    </Button>
  </Container>
)
export default PlayPauseButton
