/**
 * @providesModule Song
 * @flow
 */

export type Song = {
  +name: string,
  +artist: string,
  +album: string,
  +label: string,
  +year: ?number,
  +request: boolean,
  +new: boolean,
  +local: boolean,
  +at: Date,
}

export const defaultSong: Song = {
  name: '',
  artist: '',
  album: '',
  label: '',
  year: null,
  request: false,
  new: false,
  local: false,
  at: new Date(),
}
