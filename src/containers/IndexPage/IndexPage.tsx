import React from 'react';
import clsx from 'clsx';

import { Head } from 'seo/Head/Head';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';

import styles from './IndexPage.module.scss';
import sharedStyles from 'utils/sharedStyles.module.scss';

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
              <span className={styles.contactText}>Michal Zalobny</span>
            </LinkHandler>
            <span className={styles.spacer} />
            <LinkHandler isExternal elHref="https://github.com/javusScriptus">
              <span className={clsx(styles.contactText, styles.contactTextBold)}>
                javusScriptus
              </span>
            </LinkHandler>
          </div>
        </header>
      </div>
    </>
  );
}
