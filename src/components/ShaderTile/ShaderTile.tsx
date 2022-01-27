import React from 'react';
import clsx from 'clsx';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { PreloadImage } from 'components/PreloadImage/PreloadImage';

import styles from './ShaderTile.module.scss';

interface Props {
  imageSrc: string;
  number: string;
  elHref: string;
  isPro?: boolean;
  isMotion?: boolean;
}

export const ShaderTile = (props: Props) => {
  const { isMotion, isPro, elHref, imageSrc, number } = props;

  return (
    <>
      <LinkHandler elHref={elHref}>
        <div className={styles.wrapper}>
          <div className={styles.badgesWrapper}>
            {isPro && <div className={styles.badge}>Pro</div>}
            {isMotion && <div className={clsx(styles.badge, styles.badgePurple)}>Motion</div>}
          </div>
          <div className={styles.numberWrapper}>
            <span className={styles.number}>{number}</span>
          </div>
          <div className={styles.imagesContainer}>
            <div data-card="1" className={styles.imageWrapper}>
              <PreloadImage imageSrc={imageSrc} alt={number} />
            </div>
            <div data-card="2" className={styles.imageWrapper}>
              <PreloadImage imageSrc={imageSrc} alt={number} />
            </div>
          </div>
        </div>
      </LinkHandler>
    </>
  );
};
