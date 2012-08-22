
class MSAParticle {
  PVector pos = new PVector(), posVel = new PVector(), posAcc = new PVector();
  float rot = 0;
  float rotVel = 0;
  float rotDrag = 0;
  float radius = 1;
  float targetRadius = 1;
  float radiusSpeed = 0;
  float alpha = 1;
  float targetAlpha = 1;
  float drag = 0;
  float alphaSpeed = 0;
  PImage img;
  
  MSAParticle() {}
  
  MSAParticle(PImage _img) {
    img = _img;
  }
    

  void draw() {
    if(alphaSpeed>0) alpha += (targetAlpha - alpha) * alphaSpeed;
    if(radiusSpeed>0) radius += (targetRadius - radius) * radiusSpeed;
    pos.add(PVector.mult(posVel, secondsSinceLastFrame));
    posVel.mult(1-drag);
    posVel.add(PVector.mult(posAcc, secondsSinceLastFrame));
    rot += rotVel * secondsSinceLastFrame;
    rotVel *= (1-rotDrag);
    
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotate(radians(rot));
    scale(radius * 2 / img.width);
    imageMode(CENTER);
    tint(255, alpha * 255);
    image(img, 0, 0);
    popMatrix();
    popStyle();
  }
};


