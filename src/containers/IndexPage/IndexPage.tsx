import React from 'react';
import clsx from 'clsx';

import { Head } from 'seo/Head/Head';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';

import sharedStyles from 'utils/sharedStyles.module.scss';

import styles from './IndexPage.module.scss';
import { TilesRenderer } from 'components/TilesRenderer/TilesRenderer';

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
            <LinkHandler isExternal elHref="https://creativeprojects.vercel.app/">
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
        <TilesRenderer />
      </div>
    </>
  );
}
