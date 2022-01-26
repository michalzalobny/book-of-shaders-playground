import styled from 'styled-components';
import { motion } from 'framer-motion';

interface Props {}

export const Wrapper = styled(motion.span)<Props>`
  display: inline-block;
  overflow: hidden;
  position: relative;
  transition: width 0.5s ease-out, height 0.5s ease-out;
  width: 100%;
`;
