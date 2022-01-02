import React from 'react';
import clsx from 'clsx';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { useRouter } from 'next/router';

import styles from './Layout.module.scss';

interface Props {
  isReady: boolean;
}

export const Layout = (props: Props) => {
  const { isReady } = props;

  const router = useRouter();

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

      {router.pathname === '/' && (
        <div className={styles.codeWrapper}>
          <LinkHandler
            isExternal
            elHref="https://github.com/javusScriptus/book-of-shaders-playground/tree/main/src/containers/Shaders"
          >
            <span className={styles.codeText}>GitHub Repo</span>
          </LinkHandler>
        </div>
      )}
    </>
  );
};
