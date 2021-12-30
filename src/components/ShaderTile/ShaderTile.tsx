import React from 'react';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { PreloadImage } from 'components/PreloadImage/PreloadImage';

import styles from './ShaderTile.module.scss';

interface Props {
  imageSrc: string;
  number: string;
  elHref: string;
}

export const ShaderTile = (props: Props) => {
  const { elHref, imageSrc, number } = props;

  return (
    <>
      <LinkHandler elHref={elHref}>
        <div className={styles.wrapper}>
          <div className={styles.numberWrapper}>
            <span className={styles.number}>{number}</span>
          </div>
          <div data-card="1" className={styles.imageWrapper}>
            <PreloadImage imageSrc={imageSrc} alt={number} />
          </div>

          <div data-card="2" className={styles.imageWrapper}>
            <PreloadImage imageSrc={imageSrc} alt={number} />
          </div>
        </div>
      </LinkHandler>
    </>
  );
};
