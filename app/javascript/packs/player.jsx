/**
 * @flow
 */

import * as React from 'react'
import { render } from 'react-dom'

import { ThemeProvider } from 'styled-components'
import theme from 'styled/theme'

import Player from 'player'

const container = document.getElementById('player-app')
if (container) {
  render(
    <ThemeProvider theme={theme}>
      <Player />
    </ThemeProvider>,
    container
  )
}
