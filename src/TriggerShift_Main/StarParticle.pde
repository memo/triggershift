
class StarParticle {
  PVector pos, posVel;
  float rot, rotVel, radius;
  boolean alive;
  float al=1;
  StarParticle(PVector _pos, PVector _posVel, float _rot, float _rotVel, float _radius) {
    pos = _pos.get();
    rot = _rot;
    posVel= _posVel;
    rotVel = _rotVel;
    radius = _radius;
    alive =true;
  }
  void update(PVector attractionPoint, float amt) {
    pos.x =lerp(pos.x, attractionPoint.x, amt);
    pos.y =lerp(pos.y, attractionPoint.y, amt);
  }
  void draw() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(rot));
    imageMode(CENTER);
    // tint(255, alpha * 255);
    //ellipse(0, 0, radius, radius);
    if (alive) {
      drawStar(0, 0, 6, radius);
    }
    //alpha *= 0.95;
    //pos.add(posVel);
    // rot += rotVel;

    popMatrix();
    popStyle();
  }
  void setAlive(boolean _alive) {
    alive=_alive;
  }

  void drawStar(int x, int y, int numStalks, float rad_of_inner_disc) {
    pushStyle();
    int numEllipses=10;
    float inc=4.0;
    float start=4;
    noStroke();
    //tint(255,random(255));
    al =random(0.9, 1.0);

    for (int i=0;i<numEllipses;i++) {
      //fill(245, 255, 15, 155/(i+1));
      fill(255, al*(155/(i+1)));
      ellipse(x, y, start+(i*inc), start+(i*inc));
    }
    color strokeColour = color(140, 140, 140);
    stroke(strokeColour);
    float innerDia=rad_of_inner_disc+(1.4*rad_of_inner_disc);
    float outerDia = innerDia+(0.2*innerDia);

    fill(245, 255, 15, 100);
    float angle= TWO_PI/numStalks;
    popStyle();
  }
};

