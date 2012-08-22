

class MSAParticleSystem {
  ArrayList particles;

  PVector initPos = new PVector();                  // initial position of particle
  PVector initPosVariance = new PVector();          // random distance to initPos where particle can be created

  PVector initVel = new PVector();                  // initial velocity of particle
  PVector initVelVariance = new PVector();          // random range of above
  PVector initVelInherit = new PVector();           // particle inherits this velocity
  PVector initVelInheritMult = new PVector();       // multiply above by this before adding to particle

  PVector initAcc = new PVector();                  // acceleration of particle
  float initAccVariance = 0;                        // random range of above

  float initRot = 0, initRotVariance = 0;           // initial rotation & random range

  float initRotVel = 0, initRotVelVariance = 0;     // initial rotation velocity & random range

  float initRadius = 1, initRadiusVariance = 0;             // initial radius & random range

  float initDrag = 0, initDragVariance = 0;                 // initial drag & random range

  float initAlpha = 1, initAlphaVariance = 0;               // initial alpha & random range
  float initTargetAlpha = 1, initTargetAlphaVariance = 0;   // initial rotation & random range
  float initFadeSpeed = 0, initFadeSpeedVariance = 0;

  ArrayList imgs = null;
  PImage img = null;

  int maxCount = 0;

  void start() {
    particles = new ArrayList();
  }


  void add() {
    MSAParticle p = new MSAParticle();
      
    if (img != null) {
      p.img = img;
    } 
    else if (imgs != null) {
      int imageIndex = (int)floor(random(0, imgs.size()));
      p.img = (PImage)imgs.get(imageIndex);
    } else {
      println("WARNING MSAParticleSystem has no images");
      return;
    }
    

    p.pos = getVectorWithVariance(initPos, initPosVariance);
    p.posVel = getVectorWithVariance(initVel, initVelVariance);
    p.posVel.add(PVector.mult(initVelInherit, initVelInheritMult));
    p.posAcc = getVectorWithVariance(initAcc, initAccVariance);

    p.rot = getValueWithVariance(initRot, initRotVariance);

    p.rotVel = getValueWithVariance(initRotVel, initRotVelVariance);

    p.radius = getValueWithVariance(initRadius, initRadiusVariance);

    p.drag = getValueWithVariance(initDrag, initDragVariance);

    p.alpha = getValueWithVariance(initAlpha, initAlphaVariance);
    p.targetAlpha = getValueWithVariance(initTargetAlpha, initTargetAlphaVariance);
    p.fadeSpeed = getValueWithVariance(initFadeSpeed, initFadeSpeedVariance);

    particles.add(p);
  }


  void draw() {
    pushStyle();
    while (particles.size () > maxCount) particles.remove(0);  // trim array

    // draw particles
    for (int i=0; i<particles.size(); i++) {
      MSAParticle p = (MSAParticle) particles.get(i);
      p.draw();
    }
    popStyle();
  }
};

