
class MSAParticle {
  PVector pos, posVel, posAcc;
  float rot = 0;
  float rotVel = 0;
  float rotDrag = 0;
  float radius = 1;
  float alpha = 1;
  float targetAlpha = 1;
  float drag = 0;
  float fadeSpeed = 0;
  PImage img;

  void draw() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(rot));
    imageMode(CENTER);
    tint(255, alpha * 255);
    image(img, 0, 0, radius*2, radius*2);
    popMatrix();
    popStyle();

    if(fadeSpeed>0) alpha += (targetAlpha - alpha) * fadeSpeed;
    pos.add(posVel);
    posVel.mult(1-drag);
    posVel.add(posAcc);
    rot += rotVel;
    rotVel *= (1-rotDrag);
  }
};


