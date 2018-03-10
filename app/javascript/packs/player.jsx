/**
 * @flow
 */

import * as React from 'react'
import ReactOnRails from 'react-on-rails'

import { ThemeProvider } from 'styled-components'
import theme from 'styled/theme'

import Player from 'player'
import withPlaylistChannel from 'channels/PlaylistChannel'

const PlayerWithPlaylistChannel = withPlaylistChannel(Player)

const Component = () => (
  <ThemeProvider theme={theme}>
    <PlayerWithPlaylistChannel />
  </ThemeProvider>
)

ReactOnRails.register({
  Player: Component,
})
