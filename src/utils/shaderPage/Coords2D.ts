import TWEEN, { Tween } from '@tweenjs/tween.js';
import * as THREE from 'three';

import { Bounds } from 'utils/sharedTypes';
import { MouseMove } from 'utils/shaderPage/MouseMove';

export class Coords2D {
  _mouseMove = MouseMove.getInstance();
  _canvas: HTMLCanvasElement;
  _ctx: CanvasRenderingContext2D | null;
  _color = '#ffffff';
  _rendererBounds: Bounds = { height: 1, width: 1 };
  _mouse = { x: 1, y: 1 };
  _showProgress = 0;
  _showProgressTween: Tween<{ progress: number }> | null = null;
  _isInit = false;

  constructor() {
    this._canvas = document.createElement('canvas');
    this._canvas.className = 'coords-2d';
    this._ctx = this._canvas.getContext('2d');
    document.body.appendChild(this._canvas);

    this._addListeners();
  }

  _setSizes() {
    if (this._canvas && this._ctx) {
      const w = this._rendererBounds.width;
      const h = this._rendererBounds.height;
      const ratio = Math.min(window.devicePixelRatio, 2);

      this._canvas.width = w * ratio;
      this._canvas.height = h * ratio;
      this._canvas.style.width = w + 'px';
      this._canvas.style.height = h + 'px';
      this._ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
    }
  }

  _animateShow(destination: number) {
    if (this._showProgressTween) {
      this._showProgressTween.stop();
    }

    this._showProgressTween = new TWEEN.Tween({
      progress: this._showProgress,
    })
      .to({ progress: destination }, 200)
      .easing(TWEEN.Easing.Linear.None)
      .onUpdate(obj => {
        this._showProgress = obj.progress;
      });

    this._showProgressTween.start();
  }

  _onMouseMove = (e: THREE.Event) => {
    this._mouse.x = (e.target as MouseMove).mouse.x;
    this._mouse.y = (e.target as MouseMove).mouse.y;
  };

  _onMouseMoveInternal = () => {
    this._init();
  };

  _onPointerDown = () => {
    this._init();
  };

  _init() {
    if (!this._isInit) {
      this._isInit = true;
      this._animateShow(1);
    }
  }

  _onMouseOut = (event: MouseEvent) => {
    if (
      event.clientY <= 0 ||
      event.clientX <= 0 ||
      event.clientX >= this._rendererBounds.width ||
      event.clientY >= this._rendererBounds.height
    ) {
      this._animateShow(0);
    }
  };

  _onMouseEnter = () => {
    this._animateShow(1);
  };

  _addListeners() {
    this._mouseMove.addEventListener('mousemove', this._onMouseMove);
    document.addEventListener('mouseenter', this._onMouseEnter);
    document.addEventListener('mouseleave', this._onMouseOut);
    document.addEventListener('mousemove', this._onMouseMoveInternal);
    document.addEventListener('pointerdown', this._onPointerDown);
  }

  _removeListeners() {
    this._mouseMove.removeEventListener('mousemove', this._onMouseMove);
    document.removeEventListener('mouseenter', this._onMouseEnter);
    document.removeEventListener('mouseleave', this._onMouseOut);
    document.removeEventListener('mousemove', this._onMouseMoveInternal);
    document.removeEventListener('pointerdown', this._onPointerDown);
  }

  _draw() {
    if (!this._ctx) return;

    this._ctx.fillStyle = `rgba(255,255,255, ${this._showProgress})`;
    this._ctx.font = '14px opensans';
    this._ctx.fillText(`x: ${this._mouse.x}, y: ${this._mouse.y}`, this._mouse.x, this._mouse.y);
  }

  _clear() {
    if (this._ctx) this._ctx.clearRect(0, 0, this._canvas.width, this._canvas.height);
  }

  update() {
    this._clear();
    this._draw();
  }

  setRendererBounds(rendererBounds: Bounds) {
    this._rendererBounds = rendererBounds;
    this._setSizes();
  }

  destroy() {
    this._removeListeners();
    this._clear();
  }
}
