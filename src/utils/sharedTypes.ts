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
  isPro: boolean;
  imgSrc: string;
  isMotion: boolean;
}
