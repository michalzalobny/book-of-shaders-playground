import React from 'react';
import clsx from 'clsx';

import { Head } from 'seo/Head/Head';
import { LinkHandler } from 'components/LinkHandler/LinkHandler';
import { ShaderTile } from 'components/ShaderTile/ShaderTile';
import sharedStyles from 'utils/sharedStyles.module.scss';
import img1 from 'assets/tileImages/1.jpg';
import img2 from 'assets/tileImages/2.jpg';
import img3 from 'assets/tileImages/3.jpg';
import img4 from 'assets/tileImages/4.jpg';
import img5 from 'assets/tileImages/5.jpg';
import img6 from 'assets/tileImages/6.jpg';
import img7 from 'assets/tileImages/7.jpg';
import img8 from 'assets/tileImages/8.jpg';
import img9 from 'assets/tileImages/9.jpg';
import img10 from 'assets/tileImages/10.jpg';
import img11 from 'assets/tileImages/11.jpg';
import img12 from 'assets/tileImages/12.jpg';
import img13 from 'assets/tileImages/13.jpg';
import img14 from 'assets/tileImages/14.jpg';
import img15 from 'assets/tileImages/15.jpg';
import img16 from 'assets/tileImages/16.jpg';
import img17 from 'assets/tileImages/17.jpg';
// import img18 from 'assets/tileImages/18.jpg';
// import img19 from 'assets/tileImages/19.jpg';
// import img20 from 'assets/tileImages/20.jpg';
// import img21 from 'assets/tileImages/21.jpg';
// import img22 from 'assets/tileImages/22.jpg';
// import img23 from 'assets/tileImages/23.jpg';
// import img24 from 'assets/tileImages/24.jpg';
// import img25 from 'assets/tileImages/25.jpg';
// import img26 from 'assets/tileImages/26.jpg';
// import img27 from 'assets/tileImages/27.jpg';
// import img28 from 'assets/tileImages/28.jpg';
// import img29 from 'assets/tileImages/29.jpg';
// import img30 from 'assets/tileImages/30.jpg';
// import img31 from 'assets/tileImages/31.jpg';
// import img32 from 'assets/tileImages/32.jpg';
// import img33 from 'assets/tileImages/33.jpg';
// import img34 from 'assets/tileImages/34.jpg';
// import img35 from 'assets/tileImages/35.jpg';
// import img36 from 'assets/tileImages/36.jpg';
// import img37 from 'assets/tileImages/37.jpg';

import styles from './IndexPage.module.scss';

export default function IndexPage() {
  return (
    <>
      <Head />
      <div className={styles.wrapper}>
        <header className={styles.header}>
          <div className={styles.titleWrapper}>
            <h1 className={styles.title}>Shaders Playground</h1>
            <div className={styles.bookInfoWrapper}>
              <p className={styles.text}>based on</p>
              <LinkHandler isExternal elHref="https://thebookofshaders.com/">
                <span
                  className={clsx(
                    sharedStyles.blobBtn,
                    sharedStyles.blobBtnSmall,
                    sharedStyles.blobBtnNoShadow
                  )}
                >
                  The Book Of Shaders
                </span>
              </LinkHandler>
            </div>
          </div>
          <div className={styles.contactWrapper}>
            <LinkHandler isExternal elHref="https://creativeprojects.vercel.app/">
              <span
                className={clsx(
                  sharedStyles.text,
                  sharedStyles.textBlack,
                  sharedStyles.textUnderline
                )}
              >
                Michal Zalobny
              </span>
            </LinkHandler>
            <span className={styles.spacer} />
            <LinkHandler isExternal elHref="https://github.com/javusScriptus">
              <span
                className={clsx(
                  sharedStyles.text,
                  sharedStyles.textBold,
                  sharedStyles.textBlack,
                  sharedStyles.textUnderline
                )}
              >
                javusScriptus
              </span>
            </LinkHandler>
          </div>
        </header>
        <div className={styles.tilesWrapper}>
          <ShaderTile elHref="/shaders/1" imageSrc={img1.src} number="1" />
          <ShaderTile elHref="/shaders/2" imageSrc={img2.src} number="2" />
          <ShaderTile elHref="/shaders/3" imageSrc={img3.src} number="3" />
          <ShaderTile elHref="/shaders/4" imageSrc={img4.src} number="4" />
          <ShaderTile elHref="/shaders/5" imageSrc={img5.src} number="5" />
          <ShaderTile elHref="/shaders/6" imageSrc={img6.src} number="6" />
          <ShaderTile elHref="/shaders/7" imageSrc={img7.src} number="7" />
          <ShaderTile elHref="/shaders/8" imageSrc={img8.src} number="8" />
          <ShaderTile elHref="/shaders/9" imageSrc={img9.src} number="9" />
          <ShaderTile elHref="/shaders/10" imageSrc={img10.src} number="10" />
          <ShaderTile elHref="/shaders/11" imageSrc={img11.src} number="11" />
          <ShaderTile elHref="/shaders/12" imageSrc={img12.src} number="12" />
          <ShaderTile elHref="/shaders/13" imageSrc={img13.src} number="13" />
          <ShaderTile elHref="/shaders/14" imageSrc={img14.src} number="14" />
          <ShaderTile elHref="/shaders/15" imageSrc={img15.src} number="15" />
          <ShaderTile elHref="/shaders/16" imageSrc={img16.src} number="16" />
          <ShaderTile elHref="/shaders/17" imageSrc={img17.src} number="17" />
        </div>
      </div>
    </>
  );
}
