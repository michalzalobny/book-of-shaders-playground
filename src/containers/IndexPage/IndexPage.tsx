import React, { useEffect } from 'react';
import clsx from 'clsx';

import { Head } from 'seo/Head/Head';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { TilesRenderer } from 'components/TilesRenderer/TilesRenderer';
import sharedStyles from 'utils/sharedStyles.module.scss';
import { globalState } from 'utils/globalState';

import styles from './IndexPage.module.scss';

export default function IndexPage() {
  //Marks that the user has visited landing, and can use the back button on the shader subpage
  useEffect(() => {
    if (globalState.hasVisitedLanding) return;
    globalState.hasVisitedLanding = true;
  }, []);

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
            <LinkHandler isExternal elHref="https://github.com/michalzalobny">
              <span
                className={clsx(
                  sharedStyles.text,
                  sharedStyles.textBold,
                  sharedStyles.textBlack,
                  sharedStyles.textUnderline
                )}
              >
                michalzalobny
              </span>
            </LinkHandler>
          </div>
        </header>
        <TilesRenderer />
      </div>
    </>
  );
}
