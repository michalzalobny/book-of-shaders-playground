import styled from 'styled-components';
import { motion } from 'framer-motion';

interface Props {}

export const ContentWrapper = styled(motion.span)<Props>`
  display: inline-block;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
`;

ContentWrapper.defaultProps = {
  variants: {
    initial: {},
    animate: {},
    exit: {},
  },
  initial: 'initial',
  animate: 'animate',
  exit: 'exit',
};
