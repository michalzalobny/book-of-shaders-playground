import React from 'react';
import clsx from 'clsx';

import { Head } from 'seo/Head/Head';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { ShaderTile } from 'components/ShaderTile/ShaderTile';
import sharedStyles from 'utils/sharedStyles.module.scss';
import img1 from 'assets/tileImages/1.jpg';
import img2 from 'assets/tileImages/2.jpg';
import img3 from 'assets/tileImages/3.jpg';

import styles from './IndexPage.module.scss';

export default function IndexPage() {
  return (
    <>
      <Head />
      <div className={styles.wrapper}>
        <header className={styles.header}>
          <div className={styles.titleWrapper}>
            <h1 className={styles.title}>Shaders Playground</h1>
            <div className={styles.bookInfoWrapper}>
              <p className={styles.text}>based on</p>
              <LinkHandler isExternal elHref="https://thebookofshaders.com/">
                <span
                  className={clsx(
                    sharedStyles.blobBtn,
                    sharedStyles.blobBtnSmall,
                    sharedStyles.blobBtnNoShadow
                  )}
                >
                  The Book Of Shaders
                </span>
              </LinkHandler>
            </div>
          </div>
          <div className={styles.contactWrapper}>
            <LinkHandler isExternal elHref="https://www.linkedin.com/in/michal-zalobny-1a8257204/">
              <span
                className={clsx(
                  sharedStyles.text,
                  sharedStyles.textBlack,
                  sharedStyles.textUnderline
                )}
              >
                Michal Zalobny
              </span>
            </LinkHandler>
            <span className={styles.spacer} />
            <LinkHandler isExternal elHref="https://github.com/javusScriptus">
              <span
                className={clsx(
                  sharedStyles.text,
                  sharedStyles.textBold,
                  sharedStyles.textBlack,
                  sharedStyles.textUnderline
                )}
              >
                javusScriptus
              </span>
            </LinkHandler>
          </div>
        </header>
        <div className={styles.tilesWrapper}>
          <ShaderTile elHref="/shaders/1" imageSrc={img1.src} number="1" />
          <ShaderTile elHref="/shaders/2" imageSrc={img2.src} number="2" />
          <ShaderTile elHref="/shaders/3" imageSrc={img3.src} number="3" />
        </div>
      </div>
    </>
  );
}
