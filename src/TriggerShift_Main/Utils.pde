

void drawMaskedUser() {
  syphon.update();
  image(syphon.img, 0, 0, width, height);
//  transform2D.drawImage(syphon.img);
}

void drawUserDepthPlane() {
  drawMaskedUser();
//  transform2D.drawImage( masker.getMask() );
}

float getWithVariance(float f, float variance) {
  return random(f - variance, f + variance);
}

PVector getWithVariance(PVector v, float variance) {
  return new PVector(getWithVariance(v.x, variance), getWithVariance(v.y, variance), getWithVariance(v.z, variance));
}

PVector getWithVariance(PVector v, PVector variance) {
  return new PVector(getWithVariance(v.x, variance.x), getWithVariance(v.y, variance.x), getWithVariance(v.z, variance.x));
}


// convert pixel dimensions done on a 800 pixel high screen, to resolution independent
float units(float f) {
  return f/800 * height;
}



class FloatWithVariance {
  float base, variance;
  FloatWithVariance() {
    set(0, 0);
  }

  FloatWithVariance(float _base, float _variance) {
    set(_base, _variance);
  }

  void set(float _base, float _variance) {
    base = _base;
    variance = _variance;
  }

  float get() {
    return getWithVariance(base, variance);
  }
};



class VectorWithVariance {
  PVector base, variance;

  VectorWithVariance() {
    set(new PVector(), new PVector());
  }

  VectorWithVariance(PVector _base, PVector _variance) {
    set(_base, _variance);
  }

  void set(PVector _base, PVector _variance) {
    base = _base;
    variance = _variance;
  }

  PVector get() {
    return getWithVariance(base, variance);
  }
};

