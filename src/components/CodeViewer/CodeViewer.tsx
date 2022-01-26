import React from 'react';
import clsx from 'clsx';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { nord } from 'react-syntax-highlighter/dist/cjs/styles/hljs';

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
      <div className={styles.codeBtnWrapper}>
        <button
          onClick={() => setViewMode('fragment')}
          className={clsx(sharedStyles.text, sharedStyles.textBox)}
        >
          View code
        </button>
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
          <SyntaxHighlighter language="glsl" showLineNumbers style={nord}>
            {fragmentShader}
          </SyntaxHighlighter>
        </div>

        <div
          className={clsx(
            styles.codeContainer,
            viewMode !== 'vertex' && styles.codeContainerHidden
          )}
        >
          <SyntaxHighlighter language="glsl" showLineNumbers style={nord}>
            {vertexShader}
          </SyntaxHighlighter>
        </div>
      </div>
    </>
  );
};
