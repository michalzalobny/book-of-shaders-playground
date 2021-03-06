import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import clsx from 'clsx';

import { CodeViewer } from 'components/CodeViewer/CodeViewer';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { Head } from 'seo/Head/Head';
import { ShaderPageProps, ViewMode } from 'utils/sharedTypes';
import { Experience } from 'utils/shaderPage/Experience';
import sharedStyles from 'utils/sharedStyles.module.scss';
import { globalState } from 'utils/globalState';

import styles from './ShaderPage.module.scss';

export default function Page(props: ShaderPageProps) {
  const [viewMode, setViewMode] = useState<ViewMode>('none');
  const { fragmentShader, vertexShader } = props;
  const rendererEl = React.useRef(null);
  const [shouldUncover, setShouldUncover] = useState(false);

  const router = useRouter();

  const [shaderNumber, setShaderNumber] = useState('');

  //Get shader number from the pathnem to later pass it to github link
  useEffect(() => {
    const paramNumber = router.pathname.replace('/shaders/', '');
    setShaderNumber(paramNumber);
  }, [router]);

  React.useEffect(() => {
    if (!rendererEl.current) return;
    const experience = new Experience({
      rendererEl: rendererEl.current,
      fragmentShader,
      vertexShader,
      setShouldUncover,
    });
    return () => {
      experience.destroy();
    };
  }, [fragmentShader, vertexShader]);

  return (
    <>
      <Head />

      <CodeViewer
        viewMode={viewMode}
        setViewMode={setViewMode}
        fragmentShader={fragmentShader}
        vertexShader={vertexShader}
      />

      <div className={clsx(styles.pageWrapper, shouldUncover && styles.pageWrapperUncover)} />

      <div className={styles.wrapper} ref={rendererEl} />

      <div className={styles.backWrapper}>
        <LinkHandler
          onClickFn={() => {
            if (globalState.hasVisitedLanding) {
              router.back();
            } else {
              router.push('/');
            }
          }}
        >
          <span className={clsx(sharedStyles.text, sharedStyles.textBox)}>Back</span>
        </LinkHandler>
      </div>

      <div className={styles.codeWrapper}>
        <LinkHandler
          isExternal
          elHref={`https://github.com/michalzalobny/book-of-shaders-playground/tree/main/src/containers/Shaders/${shaderNumber}`}
        >
          <span className={clsx(sharedStyles.text, sharedStyles.textUnderline)}>GitHub Repo</span>
        </LinkHandler>
      </div>

      <div className={styles.numberWrapper}>
        <div className={styles.numberContainer}>
          <div className={styles.number}>{shaderNumber}</div>
        </div>
      </div>
    </>
  );
}
