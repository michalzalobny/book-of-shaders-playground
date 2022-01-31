import React, { useEffect, useRef, useState } from 'react';
import clsx from 'clsx';
import { AnimatePresence } from 'framer-motion';
import { motion, Variants } from 'framer-motion';
import { useRouter } from 'next/router';

import { ShaderTile } from 'components/ShaderTile/ShaderTile';
import { Tile } from 'utils/sharedTypes';
import sharedStyles from 'utils/sharedStyles.module.scss';
import { tween } from 'components/Animations/framerTransitions';
import { useElementSize } from 'hooks/useElementSize';

import styles from './TilesRenderer.module.scss';

import img1 from 'assets/tileImages/1.jpg';
import img2 from 'assets/tileImages/2.jpg';
import img3 from 'assets/tileImages/3.jpg';
import img4 from 'assets/tileImages/4.jpg';
import img5 from 'assets/tileImages/5.jpg';
import img6 from 'assets/tileImages/6.jpg';
import img7 from 'assets/tileImages/7.jpg';
import img8 from 'assets/tileImages/8.jpg';
import img9 from 'assets/tileImages/9.jpg';
import img10 from 'assets/tileImages/10.jpg';
import img11 from 'assets/tileImages/11.jpg';
import img12 from 'assets/tileImages/12.jpg';
import img13 from 'assets/tileImages/13.jpg';
import img14 from 'assets/tileImages/14.jpg';
import img15 from 'assets/tileImages/15.jpg';
import img16 from 'assets/tileImages/16.jpg';
import img17 from 'assets/tileImages/17.jpg';
import img18 from 'assets/tileImages/18.jpg';
import img19 from 'assets/tileImages/19.jpg';
import img20 from 'assets/tileImages/20.jpg';
import img21 from 'assets/tileImages/21.jpg';
import img22 from 'assets/tileImages/22.jpg';
import img23 from 'assets/tileImages/23.jpg';
import img24 from 'assets/tileImages/24.jpg';
import img25 from 'assets/tileImages/25.jpg';
import img26 from 'assets/tileImages/26.jpg';
import img27 from 'assets/tileImages/27.jpg';
import img28 from 'assets/tileImages/28.jpg';
import img29 from 'assets/tileImages/29.jpg';
import img30 from 'assets/tileImages/30.jpg';
import img31 from 'assets/tileImages/31.jpg';
import img32 from 'assets/tileImages/32.jpg';
import img33 from 'assets/tileImages/33.jpg';
import img34 from 'assets/tileImages/34.jpg';
import img35 from 'assets/tileImages/35.jpg';
import img36 from 'assets/tileImages/36.jpg';
import img37 from 'assets/tileImages/37.jpg';
import img38 from 'assets/tileImages/38.jpg';
import img39 from 'assets/tileImages/39.jpg';
import img40 from 'assets/tileImages/40.jpg';
import img41 from 'assets/tileImages/41.jpg';
import img42 from 'assets/tileImages/42.jpg';
import img43 from 'assets/tileImages/43.jpg';
import img44 from 'assets/tileImages/44.jpg';
import img45 from 'assets/tileImages/45.jpg';
import img46 from 'assets/tileImages/46.jpg';
import img47 from 'assets/tileImages/47.jpg';
import img48 from 'assets/tileImages/48.jpg';
import img49 from 'assets/tileImages/49.jpg';
import img50 from 'assets/tileImages/50.jpg';

const wrapperV: Variants = {
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
      //@ts-ignore
      duration: 0.25,
    },
  },
};

export const TilesRenderer = () => {
  const tiles: Tile[] = [
    {
      num: 50,
      imgSrc: img50.src,
      isMotion: true,
    },
    {
      num: 49,
      imgSrc: img49.src,
      isMotion: true,
      isSpatial: true,
    },
    {
      num: 48,
      imgSrc: img48.src,
      isMotion: true,
      isSpatial: true,
    },
    {
      num: 47,
      imgSrc: img47.src,
      isMotion: true,
      isSpatial: true,
    },
    {
      num: 46,
      imgSrc: img46.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 45,
      imgSrc: img45.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 44,
      imgSrc: img44.src,
      isMotion: true,
    },
    {
      num: 43,
      imgSrc: img43.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 42,
      imgSrc: img42.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 41,
      imgSrc: img41.src,
    },
    {
      num: 40,
      imgSrc: img40.src,
    },
    {
      num: 39,
      imgSrc: img39.src,
    },
    {
      num: 38,
      imgSrc: img38.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 37,
      imgSrc: img37.src,
      isMotion: true,
    },
    {
      num: 36,
      imgSrc: img36.src,
      isMotion: true,
    },
    {
      num: 35,
      imgSrc: img35.src,
      isMotion: true,
    },
    {
      num: 34,
      imgSrc: img34.src,
      isMotion: true,
    },
    {
      num: 33,
      imgSrc: img33.src,
      isMotion: true,
    },
    {
      num: 32,
      imgSrc: img32.src,
      isMotion: true,
    },
    {
      num: 31,
      imgSrc: img31.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 30,
      imgSrc: img30.src,
    },
    {
      num: 29,
      imgSrc: img29.src,
    },
    {
      num: 28,
      imgSrc: img28.src,
      isMotion: true,
    },
    {
      num: 27,
      imgSrc: img27.src,
    },
    {
      num: 26,
      imgSrc: img26.src,
      isPro: true,
      isMotion: true,
    },
    {
      num: 25,
      imgSrc: img25.src,
      isMotion: true,
    },
    {
      num: 24,
      imgSrc: img24.src,
      isMotion: true,
    },
    {
      num: 23,
      imgSrc: img23.src,
    },
    {
      num: 22,
      imgSrc: img22.src,
      isMotion: true,
    },
    {
      num: 21,
      imgSrc: img21.src,
    },
    {
      num: 20,
      imgSrc: img20.src,
    },
    {
      num: 19,
      imgSrc: img19.src,
      isMotion: true,
    },
    {
      num: 18,
      imgSrc: img18.src,
    },
    {
      num: 17,
      imgSrc: img17.src,
    },
    {
      num: 16,
      imgSrc: img16.src,
    },
    {
      num: 15,
      imgSrc: img15.src,
    },
    {
      num: 14,
      imgSrc: img14.src,
    },
    {
      num: 13,
      imgSrc: img13.src,
    },
    {
      num: 12,
      imgSrc: img12.src,
    },
    {
      num: 11,
      imgSrc: img11.src,
    },
    {
      num: 10,
      imgSrc: img10.src,
    },
    {
      num: 9,
      imgSrc: img9.src,
      isMotion: true,
    },
    {
      num: 8,
      imgSrc: img8.src,
    },
    {
      num: 7,
      imgSrc: img7.src,
    },
    {
      num: 6,
      imgSrc: img6.src,
    },
    {
      num: 5,
      imgSrc: img5.src,
    },
    {
      num: 4,
      imgSrc: img4.src,
    },
    {
      num: 3,
      imgSrc: img3.src,
    },
    {
      num: 2,
      imgSrc: img2.src,
      isMotion: true,
    },
    {
      num: 1,
      imgSrc: img1.src,
      isMotion: true,
    },
  ];

  const router = useRouter();
  type Mode = 'all' | 'pro' | 'spatial' | 'motion';
  const [mode, setMode] = useState<Mode>((router.query.filter as Mode) || 'all');

  const allBtnRef = useRef(null);
  const proBtnRef = useRef(null);
  const spatialBtnRef = useRef(null);
  const motionBtnRef = useRef(null);

  const allBtnSize = useElementSize(allBtnRef);
  const proBtnSize = useElementSize(proBtnRef);
  const spatialBtnSize = useElementSize(spatialBtnRef);
  const motionBtnSize = useElementSize(motionBtnRef);

  useEffect(() => {
    if (router.query.filter) {
      setMode(router.query.filter as Mode);
    }
  }, [router]);

  return (
    <>
      <div className={styles.filterWrapper}>
        <p className={clsx(sharedStyles.text, sharedStyles.textBlack, styles.filterText)}>
          filter:
        </p>

        <div className={styles.buttonsWrapper}>
          <button
            ref={allBtnRef}
            onClick={() => {
              router.replace('?filter=all');
            }}
            className={styles.filterBtn}
          >
            <span className={clsx(sharedStyles.text, sharedStyles.textBlack)}>All</span>
          </button>

          <button
            ref={proBtnRef}
            onClick={() => {
              router.replace('?filter=pro');
            }}
            className={styles.filterBtn}
          >
            <span className={clsx(sharedStyles.text, sharedStyles.textBlack)}>Pro</span>
          </button>

          <button
            ref={spatialBtnRef}
            onClick={() => {
              router.replace('?filter=spatial');
            }}
            className={styles.filterBtn}
          >
            <span className={clsx(sharedStyles.text, sharedStyles.textBlack)}>3D</span>
          </button>

          <button
            ref={motionBtnRef}
            onClick={() => {
              router.replace('?filter=motion');
            }}
            className={styles.filterBtn}
          >
            <span className={clsx(sharedStyles.text, sharedStyles.textBlack)}>Motion</span>
          </button>
          <span
            style={{
              width:
                allBtnSize.size.isReady && proBtnSize.size.isReady && motionBtnSize.size.isReady
                  ? (mode === 'all' && allBtnSize.size.clientRect.width) ||
                    (mode === 'pro' && proBtnSize.size.clientRect.width) ||
                    (mode === 'spatial' && spatialBtnSize.size.clientRect.width) ||
                    (mode === 'motion' && motionBtnSize.size.clientRect.width) ||
                    1
                  : 51.95,

              transform:
                (mode === 'pro' && `translateX(${allBtnSize.size.clientRect.width + 10}px)`) ||
                (mode === 'spatial' &&
                  `translateX(${
                    allBtnSize.size.clientRect.width + proBtnSize.size.clientRect.width + 20
                  }px)`) ||
                (mode === 'motion' &&
                  `translateX(${
                    allBtnSize.size.clientRect.width +
                    proBtnSize.size.clientRect.width +
                    spatialBtnSize.size.clientRect.width +
                    30
                  }px)`) ||
                'translateX(0)',
            }}
            className={styles.floatingBorder}
          ></span>
        </div>
      </div>
      <AnimatePresence exitBeforeEnter>
        <motion.div
          transition={tween}
          variants={wrapperV}
          key={mode}
          animate="animate"
          initial="initial"
          exit="exit"
          className={styles.tilesWrapper}
        >
          {tiles.map(
            tile =>
              (mode === 'all' ||
                (mode === 'pro' && tile.isPro) ||
                (mode === 'spatial' && tile.isSpatial) ||
                (mode === 'motion' && tile.isMotion)) && (
                <ShaderTile
                  key={tile.num}
                  isMotion={tile.isMotion}
                  isPro={tile.isPro}
                  isSpatial={tile.isSpatial}
                  elHref={`/shaders/${tile.num}`}
                  imageSrc={tile.imgSrc}
                  number={tile.num.toString()}
                />
              )
          )}
        </motion.div>
      </AnimatePresence>
    </>
  );
};
