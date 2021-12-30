import React from 'react';

import { Head } from 'seo/Head/Head';
import { Experience } from './Experience';

export default function Page1() {
  const rendererEl = React.useRef(null);

  React.useEffect(() => {
    if (!rendererEl.current) return;
    const experience = new Experience({ rendererEl: rendererEl.current });
    return () => {
      experience.destroy();
    };
  }, []);

  return (
    <>
      <Head />
      {/* <div
        style={{
          position: 'fixed',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%,-50%)',
          width: '90%',
          height: '90%',
        }}
      > */}
      <div
        style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100%' }}
        ref={rendererEl}
      />
      {/* </div> */}
    </>
  );
}
