/**
 * @providesModule SelectNav
 * @flow
 */

import ReactOnRails from 'react-on-rails'
import React from 'react'

type Props = {
  blankItem?: string,
  items: Array<{ text: string, url: string }>,
  selectedUrl?: string,
}

const SelectNav = ({ blankItem, items, selectedUrl = '' }: Props) => (
  <div className="pt-select">
    <select
      defaultValue={selectedUrl}
      onChange={e => e.target.value && (window.location = e.target.value)}
    >
      {blankItem && (
        <option disabled value="">
          {blankItem}
        </option>
      )}
      {items.map(item => <option value={item.url}>{item.text}</option>)}
    </select>
  </div>
)

ReactOnRails.register({ SelectNav })
