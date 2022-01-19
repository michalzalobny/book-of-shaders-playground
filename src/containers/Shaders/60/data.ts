import { GetStaticProps } from 'next';

import fragmentShader from './fragment.glsl';
import vertexShader from './vertex.glsl';

export const getStaticProps: GetStaticProps = async () => {
  return {
    props: {
      fragmentShader,
      vertexShader,
    },
  };
};
