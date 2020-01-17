/**
 * @providesModule ImageZoom
 * @flow
 */

import * as React from 'react'
import BaseImageZoom from 'react-medium-image-zoom'

/**
 * The react-medium-image-zoom component is great, but doesn’t support being
 * styled with styled-components. This shim passes the className given it by
 * styled-components into the image props object that react-medium-image-zoom
 * expects from us.
 */

type Props = { className: string, image: { [string]: string } }
const ImageZoom = ({ className, image, ...rest }: Props) => (
  <BaseImageZoom image={{ ...image, className }} {...rest} />
)
export default ImageZoom
