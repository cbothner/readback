/**
 * @providesModule Volume
 * @flow
 */

import * as React from 'react'
import styled from 'styled-components'

const Slider = styled.input`
  writing-mode: bt-lr; /* IE */
  width: 50px;
  margin: -17px;
  height: 1px;
  background: ${props => props.theme.white};
  transform: rotate(270deg);
  -webkit-appearance: none;
  cursor: pointer;
  padding: 0;

  &:focus {
    outline: none;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
  }

  /* CHROME */
  &::-webkit-slider-thumb,
  input[type='range' i]::-webkit-media-slider-thumb {
    width: 2px;
    background: ${props => props.theme.white};
    -webkit-appearance: none;
    height: 11px;
  }

  /* FIREFOX */
  &::-moz-range-track {
    background-color: ${props => props.theme.white};
  }
  &::-moz-range-thumb {
    width: 2px;
    background: ${props => props.theme.white};
    height: 11px;
    border: none;
    border-radius: 0;
  }
  &::-moz-focus-outer {
    border: 0;
  }
`

const Volume = () => <Slider id="volume-bar" type="range" min="0" max="10" />
export default Volume
