/* eslint-disable @next/next/no-img-element */
import React from 'react';
import clsx from 'clsx';

import { useMediaPreload } from 'hooks/useMediaPreload';

import styles from './PreloadImage.module.scss';

interface Props {
  imageSrc: string;
  alt: string;
}

export const PreloadImage = (props: Props) => {
  const { alt, imageSrc } = props;

  const { isLoaded } = useMediaPreload({ isImage: true, mediaSrc: imageSrc });

  return (
    <>
      <img
        className={clsx(styles.image, isLoaded && styles.imageLoaded)}
        src={imageSrc}
        alt={alt}
      />
    </>
  );
};
