import React from 'react';
import clsx from 'clsx';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { agate } from 'react-syntax-highlighter/dist/cjs/styles/hljs';

import { ViewMode } from 'utils/sharedTypes';
import sharedStyles from 'utils/sharedStyles.module.scss';

import styles from './CodeViewer.module.scss';

interface Props {
  fragmentShader: string;
  vertexShader: string;
  viewMode: ViewMode;
  setViewMode: React.Dispatch<React.SetStateAction<ViewMode>>;
}

export const CodeViewer = (props: Props) => {
  const { setViewMode, viewMode, fragmentShader, vertexShader } = props;

  return (
    <>
      <div className={styles.codeBtnWrapper} onClick={() => setViewMode('fragment')}>
        <span className={clsx(sharedStyles.text, sharedStyles.textBox)}>View code</span>
      </div>
      <div
        onClick={() => setViewMode('none')}
        className={clsx(styles.background, viewMode === 'none' && styles.backgroundHidden)}
      />

      <div
        className={clsx(
          styles.containersWrapper,
          viewMode === 'none' && styles.containersWrapperHidden
        )}
      >
        <div className={styles.buttonsWrapper}>
          <span
            onClick={() => setViewMode('fragment')}
            className={clsx(sharedStyles.text, sharedStyles.textBox)}
          >
            Fragment shader
          </span>

          <span className={styles.buttonsWrapperSpacer}></span>

          <span
            onClick={() => setViewMode('vertex')}
            className={clsx(sharedStyles.text, sharedStyles.textBox)}
          >
            Vertex shader
          </span>
        </div>

        <div
          className={clsx(
            styles.codeContainer,
            viewMode !== 'fragment' && styles.codeContainerHidden
          )}
        >
          <SyntaxHighlighter language="glsl" style={agate}>
            {fragmentShader}
          </SyntaxHighlighter>
        </div>

        <div
          className={clsx(
            styles.codeContainer,
            viewMode !== 'vertex' && styles.codeContainerHidden
          )}
        >
          <SyntaxHighlighter language="glsl" style={agate}>
            {vertexShader}
          </SyntaxHighlighter>
        </div>
      </div>
    </>
  );
};
