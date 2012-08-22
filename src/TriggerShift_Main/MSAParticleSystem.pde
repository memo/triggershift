

class MSAParticleSystem {
  ArrayList particles;

  PVector initPos = new PVector();                  // initial position
  PVector initPosVariance = new PVector();          // how far from creation point can particle be created

  PVector initVel = new PVector();                  // initial velocity
  PVector initVelVariance = new PVector();          // randomness of above
  //  PVector initVelAdd = new PVector();               // add some more velocity on top
  //  PVector initVelAddVariance = new PVector();       // randomness of above
  //  PVector initVelAddMult = new PVector(1, 1, 1);    // how much of the init vel does the particle take


  PVector initAcc = new PVector();
  float initAccVariance = 0;

  float initRot = 0, initRotVariance = 0;        

  float initRotVel = 0, initRotVelVariance = 0;  

  float initRadius = 1, initRadiusVariance = 0;  

  float initDrag = 0, initDragVariance = 0;        

  float initAlpha = 1, initAlphaVariance = 0;      
  float initTargetAlpha = 1, initTargetAlphaVariance = 0;
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

