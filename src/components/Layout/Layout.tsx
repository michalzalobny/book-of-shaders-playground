import React from 'react';
import clsx from 'clsx';

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
      {children}
    </>
  );
};
