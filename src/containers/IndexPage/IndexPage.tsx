import React from 'react';

import { Head } from 'seo/Head/Head';

import styles from './IndexPage.module.scss';
import sharedStyles from 'utils/sharedStyles.module.scss';

export default function IndexPage() {
  return (
    <>
      <Head />
      <div className={styles.wrapper}>
        <div className={sharedStyles.blobBtn}>dasd</div>
      </div>
    </>
  );
}
