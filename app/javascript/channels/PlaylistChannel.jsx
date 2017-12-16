/**
 * @providesModule withPlaylistChannel
 * @flow
 */

/* global App */

import * as React from 'react'

import { defaultSong } from 'models'
import type { Song } from 'models'

type SongCreatedMessage = {| +type: 'song_created', +song: Song |}
type PlaylistChannelMessage = SongCreatedMessage // | OtherMessage

type State = {
  song: Song,
}
function withPlaylistChannel<Props: {}> (
  Component: React.ComponentType<State & Props>
): React.ComponentType<Props> {
  class WrapperComponent extends React.Component<Props, State> {
    state = { song: defaultSong }

    componentDidMount () {
      if (App == null) return
      App.cable.subscriptions.create('PlaylistChannel', {
        received: (message: PlaylistChannelMessage) => {
          switch (message.type) {
            case 'song_created':
              this.setState({ song: message.song })
          }
        },
      })
    }

    render () {
      const { song } = this.state
      return <Component {...this.props} song={song} />
    }
  }

  WrapperComponent.displayName = `withPlaylistChannel(${Component.displayName ||
    Component.name})`
  return WrapperComponent
}

export default withPlaylistChannel
