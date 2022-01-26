import React from 'react';
import clsx from 'clsx';
import { motion, Variants } from 'framer-motion';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { PreloadImage } from 'components/PreloadImage/PreloadImage';
import { tween } from 'components/Animations/framerTransitions';

import styles from './ShaderTile.module.scss';

interface Props {
  imageSrc: string;
  number: string;
  elHref: string;
  isPro?: boolean;
  isMotion?: boolean;
}

const shaderTileV: Variants = {
  initial: {
    opacity: 0,
  },
  animate: {
    opacity: 1,
  },
  exit: {
    opacity: 0,
    transition: {
      ...tween,
    },
  },
};

export const ShaderTile = (props: Props) => {
  const { isMotion, isPro, elHref, imageSrc, number } = props;

  return (
    <>
      <motion.div
        transition={tween}
        variants={shaderTileV}
        animate="animate"
        initial="initial"
        exit="exit"
      >
        <LinkHandler elHref={elHref}>
          <div className={styles.wrapper}>
            <div className={styles.badgesWrapper}>
              {isPro && <div className={styles.badge}>Pro</div>}
              {isMotion && <div className={clsx(styles.badge, styles.badgePurple)}>Motion</div>}
            </div>
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
      </motion.div>
    </>
  );
};
