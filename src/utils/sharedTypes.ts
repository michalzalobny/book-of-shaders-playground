export type RendererBounds = {
  width: number;
  height: number;
};

export interface ShaderPageProps {
  fragmentShader: string;
  vertexShader: string;
}

export interface Bounds {
  width: number;
  height: number;
}

export type ViewMode = 'fragment' | 'vertex' | 'none';

export interface Tile {
  num: number;
  isPro?: boolean;
  imgSrc: string;
  isMotion?: boolean;
}

export interface Size {
  clientRect: DomRectSSR;
  offsetTop: number;
  isReady: boolean;
}

export interface DomRectSSR {
  bottom: number;
  height: number;
  left: number;
  right: number;
  top: number;
  width: number;
  x: number;
  y: number;
}
