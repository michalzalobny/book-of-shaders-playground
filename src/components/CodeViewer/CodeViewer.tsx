import React from 'react';
import clsx from 'clsx';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { nord } from 'react-syntax-highlighter/dist/cjs/styles/hljs';
import { AnimatePresence, motion, Variants } from 'framer-motion';

import { ViewMode } from 'utils/sharedTypes';
import sharedStyles from 'utils/sharedStyles.module.scss';
import { springSlow } from 'components/Animations/framerTransitions';

import styles from './CodeViewer.module.scss';

interface Props {
  fragmentShader: string;
  vertexShader: string;
  viewMode: ViewMode;
  setViewMode: React.Dispatch<React.SetStateAction<ViewMode>>;
}

const backgroundV: Variants = {
  initial: {
    opacity: 0,
  },
  animate: {
    opacity: 1,
  },
  exit: {
    opacity: 0,
    pointerEvents: 'none',
    userSelect: 'none',
  },
};

const containersWrapperV: Variants = {
  initial: {
    opacity: 0,
  },
  animate: {
    opacity: 1,
  },
  exit: {
    opacity: 0,
    pointerEvents: 'none',
    userSelect: 'none',
  },
};

export const CodeViewer = (props: Props) => {
  const { setViewMode, viewMode, fragmentShader, vertexShader } = props;

  return (
    <>
      <div className={styles.codeBtnWrapper}>
        <button
          onClick={() => setViewMode('fragment')}
          className={clsx(sharedStyles.text, sharedStyles.textBox)}
        >
          View code
        </button>
      </div>
      <AnimatePresence>
        {viewMode !== 'none' && (
          <motion.div
            transition={springSlow}
            animate="animate"
            initial="initial"
            exit="exit"
            variants={backgroundV}
            onClick={() => setViewMode('none')}
            className={clsx(
              styles.background,
              (viewMode === 'vertex' || viewMode === 'fragment') && styles.backgroundOpened
            )}
          />
        )}
      </AnimatePresence>

      <AnimatePresence>
        {viewMode !== 'none' && (
          <motion.div
            transition={springSlow}
            animate="animate"
            initial="initial"
            exit="exit"
            variants={containersWrapperV}
            className={clsx(
              styles.containersWrapper,
              (viewMode === 'vertex' || viewMode === 'fragment') && styles.containersWrapperOpened
            )}
          >
            <div className={styles.buttonsWrapper}>
              <button
                onClick={() => setViewMode('fragment')}
                className={clsx(sharedStyles.text, sharedStyles.textBox)}
              >
                Fragment shader
              </button>

              <span className={styles.buttonsWrapperSpacer}></span>

              <button
                onClick={() => setViewMode('vertex')}
                className={clsx(sharedStyles.text, sharedStyles.textBox)}
              >
                Vertex shader
              </button>
            </div>

            <div
              className={clsx(
                styles.codeContainer,
                viewMode !== 'fragment' && styles.codeContainerHidden
              )}
            >
              <div
                className={clsx(
                  styles.codeContainerWrapper,
                  viewMode !== 'fragment' && styles.codeContainerWrapperHidden
                )}
              >
                <SyntaxHighlighter language="glsl" showLineNumbers style={nord}>
                  {fragmentShader}
                </SyntaxHighlighter>
              </div>
            </div>

            <div
              className={clsx(
                styles.codeContainer,
                viewMode !== 'vertex' && styles.codeContainerHidden
              )}
            >
              <div
                className={clsx(
                  styles.codeContainerWrapper,
                  viewMode !== 'vertex' && styles.codeContainerWrapperHidden
                )}
              >
                <SyntaxHighlighter language="glsl" showLineNumbers style={nord}>
                  {vertexShader}
                </SyntaxHighlighter>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
