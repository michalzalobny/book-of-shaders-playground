import React from 'react';
import clsx from 'clsx';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';

import styles from './Layout.module.scss';

interface Props {
  children: React.ReactNode;
  isReady: boolean;
}

export const Layout = (props: Props) => {
  const { isReady, children } = props;

  return (
    <>
      <div className={clsx(styles.readyWrapper, isReady && styles.readyWrapperReady)}></div>
      <div className={styles.authorWrapper}>
        <span className={styles.contactText}>Shaders Playground by</span>
        <span className={styles.contactSpacer} />
        <LinkHandler isExternal elHref="https://www.linkedin.com/in/michal-zalobny-1a8257204/">
          <span className={clsx(styles.contactText, styles.contactTextBold)}>Michal Zalobny</span>
        </LinkHandler>
      </div>
      {children}
    </>
  );
};
