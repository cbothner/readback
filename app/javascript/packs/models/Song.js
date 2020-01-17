/**
 * @providesModule Song
 * @flow
 */

export type Song = {
  +id: ?number,
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
  id: null,
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
