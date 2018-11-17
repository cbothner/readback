/**
 * @providesModule Volume
 * @flow
 */

import styled from 'styled-components'
import { rgba } from 'polished'

const Volume = styled.input.attrs({ type: 'range', min: 0, max: 10 })`
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

  .tab-focus &:focus {

    &::-webkit-slider-thumb,
    input[type='range' i]::-webkit-media-slider-thumb, -moz-range-thumb {
      box-shadow: 0 0 0px 1px ${props => props.theme.blue};
    }

    box-shadow: 0 0 9px 2px #ffffffa6;
    border: 1px solid ${props => props.theme.blue};
    
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
export default Volume
