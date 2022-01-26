import styled from 'styled-components';
import { motion } from 'framer-motion';

interface Props {}

export const MeasureWrapper = styled(motion.span)<Props>`
  display: inline-block;
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
`;
