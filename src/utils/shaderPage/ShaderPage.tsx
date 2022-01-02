import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';

import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { Head } from 'seo/Head/Head';
import { ShaderPageProps } from 'utils/sharedTypes';
import { Experience } from 'utils/shaderPage/Experience';
import sharedStyles from 'utils/sharedStyles.module.scss';

import styles from './ShaderPage.module.scss';

export default function Page(props: ShaderPageProps) {
  const { fragmentShader, vertexShader } = props;
  const rendererEl = React.useRef(null);

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
    });
    return () => {
      experience.destroy();
    };
  }, [fragmentShader, vertexShader]);

  return (
    <>
      <Head />

      <div
        style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100%' }}
        ref={rendererEl}
      />

      <div className={styles.backWrapper}>
        <LinkHandler elHref="/">
          <span className={sharedStyles.underlineText}>Back</span>
        </LinkHandler>
      </div>

      <div className={styles.codeWrapper}>
        <LinkHandler
          isExternal
          elHref={`https://github.com/javusScriptus/book-of-shaders-playground/tree/main/src/containers/Shaders/${shaderNumber}`}
        >
          <span className={sharedStyles.underlineText}>Shader Code on GitHub</span>
        </LinkHandler>
      </div>
    </>
  );
}
