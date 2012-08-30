
class MSAParticle {
  PVector pos = new PVector(), posVel = new PVector(), posAcc = new PVector();
  float rot = 0;
  float rotY = 0;
  float rotVel = 0;
  float rotDrag = 0;
  float radius = 1;
  float targetRadius = 1;
  float radiusSpeed = 0;
  float alpha = 1;
  float targetAlpha = 1;
  float alphaSpeed = 0;
  float drag = 0;
  boolean alignToDir = false;
  PImage img;
  
  MSAParticle() {}
  
  MSAParticle(PImage _img) {
    img = _img;
  }
  
  float x1() {
    return pos.x - targetRadius;
  }
  
  float y1() {
    return pos.y - targetRadius * img.height / img.width;
  }
    
  float x2() {
    return pos.x + targetRadius;
  }
  
  float y2() {
    return pos.y + targetRadius * img.height / img.width;
  }
  
  boolean pointXIn(PVector p) {
    return p.x > x1() && p.x < x2();
  }

  boolean pointYIn(PVector p) {
    return p.y > y1() && p.y < y2();
  }
  
  boolean pointIn(PVector p) {
    return pointXIn(p) && pointYIn(p);
  }
  


  void draw() {
    if(alphaSpeed>0) alpha += (targetAlpha - alpha) * alphaSpeed;
    if(radiusSpeed>0) radius += (targetRadius - radius) * radiusSpeed;
    pos.add(PVector.mult(posVel, secondsSinceLastFrame));
    posVel.mult(1-drag);
    posVel.add(PVector.mult(posAcc, secondsSinceLastFrame));
    
    if(alignToDir) {
      rot = degrees(atan2(posVel.y, posVel.x)) - 90;
    } else {
      rot += rotVel * secondsSinceLastFrame;
      rotVel *= (1-rotDrag);
    }
    
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotate(radians(rot));
    rotateY(radians(rotY));
    scale(radius * 2 / img.width);
    imageMode(CENTER);
    tint(255, alpha * 255);
    image(img, 0, 0);
    popMatrix();
    popStyle();
  }
};


