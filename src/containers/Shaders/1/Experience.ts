import TWEEN from '@tweenjs/tween.js';
import * as THREE from 'three';
import debounce from 'lodash/debounce';
import { OrbitControls } from 'three-stdlib';

import fragmentShader from './fragment.glsl';
import vertexShader from './vertex.glsl';

interface Constructor {
  rendererEl: HTMLDivElement;
}

export class Experience extends THREE.EventDispatcher {
  static defaultFps = 60;
  static dtFps = 1000 / Experience.defaultFps;

  _rendererEl: HTMLDivElement;
  _rafId: number | null = null;
  _isResumed = true;
  _lastFrameTime: number | null = null;
  _canvas: HTMLCanvasElement;
  _camera: THREE.PerspectiveCamera;
  _renderer: THREE.WebGLRenderer;
  _controls: OrbitControls;
  _scene = new THREE.Scene();
  _geometry: THREE.PlaneGeometry | null = null;
  _material: THREE.ShaderMaterial | null = null;
  _mesh: THREE.Mesh<THREE.PlaneGeometry, THREE.ShaderMaterial> | null = null;

  constructor({ rendererEl }: Constructor) {
    super();
    this._rendererEl = rendererEl;
    this._canvas = document.createElement('canvas');
    this._rendererEl.appendChild(this._canvas);
    this._camera = new THREE.PerspectiveCamera();

    this._renderer = new THREE.WebGLRenderer({
      canvas: this._canvas,
      antialias: false,
      alpha: false,
    });

    this._renderer.outputEncoding = THREE.sRGBEncoding;

    this._onResize();
    this._addListeners();
    this._resumeAppFrame();

    this._controls = new OrbitControls(this._camera, this._rendererEl);
    this._controls.update();

    this._addPlane();
  }

  _onResizeDebounced = debounce(() => this._onResize(), 300);

  _onResize() {
    const rendererBounds = this._rendererEl.getBoundingClientRect();
    const aspectRatio = rendererBounds.width / rendererBounds.height;
    this._camera.aspect = aspectRatio;

    this._camera.position.z = 4;

    this._renderer.setSize(rendererBounds.width, rendererBounds.height);
    this._renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    this._camera.updateProjectionMatrix();

    if (this._mesh)
      this._mesh.material.uniforms.uViewportSizes.value = [
        rendererBounds.width,
        rendererBounds.height,
      ];
  }

  _onVisibilityChange = () => {
    if (document.hidden) {
      this._stopAppFrame();
    } else {
      this._resumeAppFrame();
    }
  };

  _addListeners() {
    window.addEventListener('resize', this._onResizeDebounced);
    window.addEventListener('visibilitychange', this._onVisibilityChange);
  }

  _removeListeners() {
    window.removeEventListener('resize', this._onResizeDebounced);
    window.removeEventListener('visibilitychange', this._onVisibilityChange);
  }

  _resumeAppFrame() {
    this._rafId = window.requestAnimationFrame(this._renderOnFrame);
    this._isResumed = true;
  }

  _renderOnFrame = (time: number) => {
    this._rafId = window.requestAnimationFrame(this._renderOnFrame);

    if (this._isResumed || !this._lastFrameTime) {
      this._lastFrameTime = window.performance.now();
      this._isResumed = false;
      return;
    }

    TWEEN.update(time);

    const delta = time - this._lastFrameTime;
    let slowDownFactor = delta / Experience.dtFps;

    //Rounded slowDown factor to the nearest integer reduces physics lags
    const slowDownFactorRounded = Math.round(slowDownFactor);

    if (slowDownFactorRounded >= 1) {
      slowDownFactor = slowDownFactorRounded;
    }
    this._lastFrameTime = time;

    if (this._mesh) this._mesh.material.uniforms.uTime.value = time * 0.001;

    this._renderer.render(this._scene, this._camera);
  };

  _stopAppFrame() {
    if (this._rafId) {
      window.cancelAnimationFrame(this._rafId);
    }
  }

  _addPlane() {
    this._material = new THREE.ShaderMaterial({
      side: THREE.DoubleSide,
      vertexShader,
      fragmentShader,
      depthWrite: false,
      depthTest: false,
      uniforms: {
        uTime: { value: 0 },
        uRandom: { value: Math.random() },
        uViewportSizes: {
          value: [0, 0],
        },
      },
    });

    this._geometry = new THREE.PlaneGeometry(1, 1, 32, 32);
    this._mesh = new THREE.Mesh(this._geometry, this._material);
    this._scene.add(this._mesh);
  }

  destroy() {
    if (this._canvas.parentNode) {
      this._canvas.parentNode.removeChild(this._canvas);
    }

    this._geometry?.dispose();
    this._material?.dispose();
    if (this._mesh) this._scene.remove(this._mesh);

    this._stopAppFrame();
    this._removeListeners();
  }
}
