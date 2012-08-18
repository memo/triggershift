
class MSAParticle {
  PVector pos, posVel;
  float rot, rotVel, radius, alpha, drag, fade;

  MSAParticle(PVector _pos, PVector _posVel, float _rot, float _rotVel, float _radius, float _alpha, float _drag, float _fade) {
    pos = _pos.get();
    posVel = _posVel.get();
    rot = _rot;
    rotVel = _rotVel;
    radius = _radius;
    alpha = _alpha;
    drag = _drag;
    fade = _fade;
  }

  void draw(PImage img) {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(rot));
    imageMode(CENTER);
    tint(255, alpha * 255);
    image(img, 0, 0, radius*2, radius*2);

    alpha *= 0.95;
    pos.add(posVel);
    rot += rotVel;

    popMatrix();
    popStyle();
  }
};



