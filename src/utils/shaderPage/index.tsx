import React from 'react';

import { Head } from 'seo/Head/Head';
import { ShaderPageProps } from 'utils/sharedTypes';

import { Experience } from 'utils/shaderPage/Experience';

export default function Page(props: ShaderPageProps) {
  const { fragmentShader, vertexShader } = props;
  const rendererEl = React.useRef(null);

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
    </>
  );
}
