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

  &:focus {
    outline: none;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
  }

  // &::-webkit-slider-runnable-track {
  //   width: 2px;
  //   height: 2px;
  //   cursor: pointer;
  //   box-shadow: none;
  //   background: black;
  //   border-radius: 0px;
  //   border: none;
  // }

  // &::-webkit-slider-thumb {
  //   content: '';
  //   box-shadow: none;
  //   border: none;
  //   height: 16px;
  //   width: 4px;
  //   border-radius: 4px;
  //   background: black;
  //   cursor: pointer;
  //   -webkit-appearance: none;
  //   margin-top: -7px;
  // }
`

const Volume = () => <Slider id="volume-bar" type="range" min="0" max="10" />
export default Volume
