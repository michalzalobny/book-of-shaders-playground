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
        <LinkHandler isExternal elHref="https://thebookofshaders.com/">
          <span
            className={clsx(
              sharedStyles.blobBtn,
              sharedStyles.blobBtnSmall,
              sharedStyles.blobNoShadow
            )}
          >
            Test
          </span>
        </LinkHandler>
      </div>
    </>
  );
}
