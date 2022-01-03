import TWEEN from '@tweenjs/tween.js';
import * as THREE from 'three';
import debounce from 'lodash/debounce';
import { OrbitControls } from 'three-stdlib';

import { MouseMove } from 'utils/shaderPage/MouseMove';
import { Coords2D } from 'utils/shaderPage/Coords2D';
import { RendererBounds } from 'utils/sharedTypes';

interface Constructor {
  rendererEl: HTMLDivElement;
  fragmentShader: string;
  vertexShader: string;
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
  _rendererBounds: RendererBounds = { width: 1, height: 1 };
  _mouseMove = MouseMove.getInstance();
  _mouse = { x: 1, y: 1 };
  _vertexShader: string;
  _fragmentShader: string;
  _coords2D = new Coords2D();
  _dpr = 1;

  constructor({ fragmentShader, vertexShader, rendererEl }: Constructor) {
    super();
    this._rendererEl = rendererEl;
    this._canvas = document.createElement('canvas');
    this._rendererEl.appendChild(this._canvas);
    this._camera = new THREE.PerspectiveCamera();

    this._vertexShader = vertexShader;
    this._fragmentShader = fragmentShader;

    this._renderer = new THREE.WebGLRenderer({
      canvas: this._canvas,
      antialias: true,
      alpha: true,
    });

    this._renderer.outputEncoding = THREE.sRGBEncoding;
    this._addPlane();
    this._onResize();
    this._addListeners();
    this._resumeAppFrame();

    this._controls = new OrbitControls(this._camera, this._rendererEl);
    this._controls.enableDamping = true;
    this._controls.enableZoom = false;

    this._controls.update();
  }

  _onResizeDebounced = debounce(() => this._onResize(), 300);

  _onResize() {
    const boundingRect = this._rendererEl.getBoundingClientRect();
    this._rendererBounds = { width: boundingRect.width, height: boundingRect.height };
    const aspectRatio = this._rendererBounds.width / this._rendererBounds.height;
    this._camera.aspect = aspectRatio;
    //Update device pixel ratio
    this._dpr = Math.min(window.devicePixelRatio, 2);

    //Set to match pixel size of the elements in three with pixel size of DOM elements
    this._camera.position.z = 500;
    this._camera.fov =
      2 * Math.atan(this._rendererBounds.height / 2 / this._camera.position.z) * (180 / Math.PI);

    this._renderer.setSize(this._rendererBounds.width, this._rendererBounds.height);
    this._renderer.setPixelRatio(this._dpr);
    this._camera.updateProjectionMatrix();

    this._updatePlaneScale();
    this._coords2D.setRendererBounds(this._rendererBounds);
  }

  _handleMouseMove = (e: THREE.Event) => {
    const { mouse } = e.target as MouseMove;

    this._mouse.x = mouse.x;
    this._mouse.y = mouse.y;

    if (this._mesh) this._mesh.material.uniforms.uMouse.value = [this._mouse.x, this._mouse.y];
  };

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
    this._mouseMove.addEventListener('mousemove', this._handleMouseMove);
  }

  _removeListeners() {
    window.removeEventListener('resize', this._onResizeDebounced);
    window.removeEventListener('visibilitychange', this._onVisibilityChange);
    this._mouseMove.removeEventListener('mousemove', this._handleMouseMove);
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
    this._mouseMove.update();
    this._coords2D.update();
    this._controls.update();

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
      vertexShader: this._vertexShader,
      fragmentShader: this._fragmentShader,
      depthWrite: false,
      depthTest: false,
      uniforms: {
        uTime: { value: 0 },
        uRandom: { value: Math.random() },
        uCanvasRes: {
          value: [0, 0], //Canvas size in pixels
        },
        uPlaneRes: {
          value: [0, 0], //Plane size in pixels
        },
        uMouse: {
          value: [0, 0], //Mouse coords from [0,0] (top left corner) to [screenWidth , screenHeight]
        },
        uPixelRatio: { value: this._dpr },
      },
    });

    this._geometry = new THREE.PlaneGeometry(1, 1, 32, 32);
    this._mesh = new THREE.Mesh(this._geometry, this._material);
    this._scene.add(this._mesh);
  }

  _updatePlaneScale() {
    if (this._mesh) {
      //Adjust plane size to the device
      if (this._rendererBounds.width >= 768) {
        this._mesh.scale.x = 500;
        this._mesh.scale.y = 500;
      } else {
        this._mesh.scale.x = 250;
        this._mesh.scale.y = 250;
      }

      this._mesh.material.uniforms.uCanvasRes.value = [
        this._rendererBounds.width,
        this._rendererBounds.height,
      ];

      this._mesh.material.uniforms.uPlaneRes.value = [this._mesh.scale.x, this._mesh.scale.y];

      this._mesh.material.uniforms.uPixelRatio.value = this._dpr;
    }
  }

  destroy() {
    if (this._canvas.parentNode) {
      this._canvas.parentNode.removeChild(this._canvas);
    }

    this._geometry?.dispose();
    this._material?.dispose();
    if (this._mesh) this._scene.remove(this._mesh);

    this._coords2D.destroy();

    this._stopAppFrame();
    this._removeListeners();
  }
}
