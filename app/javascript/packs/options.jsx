/**
 * @providesModule Options
 * @flow
 */

import ReactOnRails from 'react-on-rails'
import React from 'react'
import { Button, Menu, MenuItem, Position, Popover } from '@blueprintjs/core'

type Props = {
  button?: {
    text?: string,
    minimal?: boolean,
    icon: string,
  },
  items: Array<{
    text: string,
    href: string,
    icon?: string,
  }>,
}

const Options = ({ button = { icon: 'cog', minimal: true }, items }: Props) => (
  <Popover
    content={
      <Menu>
        {items.map(({ text, href, icon }, i) => (
          <MenuItem key={i} href={href} icon={icon} text={text} />
        ))}
      </Menu>
    }
    position={Position.BOTTOM_RIGHT}
  >
    <Button className={button.minimal ? 'pt-minimal' : ''} icon={button.icon} />
  </Popover>
)

ReactOnRails.register({ Options })
