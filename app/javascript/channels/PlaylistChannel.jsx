/**
 * @providesModule withPlaylistChannel
 * @flow
 */

/* global App */

import * as React from 'react'

import { defaultSong } from 'models'
import type { Song } from 'models'

type SongCreatedMessage = {| +type: 'song_created', +song: Song |}
type SongUpdatedMessage = {| +type: 'song_updated', +song: Song |}
type SongDestroyedMessage = {| +type: 'song_destroyed', +id: number |}
type PlaylistChannelMessage =
  | SongCreatedMessage
  | SongCreatedMessage
  | SongDestroyedMessage

type State = {
  song: Song,
}
function withPlaylistChannel<Props: {}> (
  Component: React.ComponentType<State & Props>
): React.ComponentType<Props> {
  class WrapperComponent extends React.Component<Props, State> {
    subscription: ?ActionCable$Subscription
    state = { song: defaultSong }

    componentDidMount () {
      this._connect()
    }

    render () {
      const { song } = this.state
      return <Component {...this.props} song={song} />
    }

    _connect () {
      if (App == null) return
      this.subscription = App.cable.subscriptions.create('PlaylistChannel', {
        received: (message: PlaylistChannelMessage) => {
          switch (message.type) {
            case 'song_created':
              this.setState({ song: message.song })
              break

            case 'song_updated':
              if (this.state.song.id === message.song.id) {
                this.setState({ song: message.song })
              }
              break

            case 'song_destroyed':
              this._disconnect()
              this._connect()
              break
          }
        },
      })
    }

    _disconnect () {
      if (this.subscription == null) return
      this.subscription.unsubscribe()
    }
  }

  WrapperComponent.displayName = `withPlaylistChannel(${Component.displayName ||
    Component.name})`
  return WrapperComponent
}

export default withPlaylistChannel
