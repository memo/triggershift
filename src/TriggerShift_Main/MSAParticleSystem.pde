

class MSAParticleSystem {
  ArrayList particles;

  VectorWithVariance startPos = new VectorWithVariance();
  VectorWithVariance startVel = new VectorWithVariance();
  VectorWithVariance acc = new VectorWithVariance();
  VectorWithVariance inheritVel = new VectorWithVariance();           // particle inherits this velocity
  VectorWithVariance inheritVelMult = new VectorWithVariance();       // multiply above by this before adding to particle

  FloatWithVariance startRot = new FloatWithVariance(0, 0);
  FloatWithVariance rotVel = new FloatWithVariance(0, 0);

  FloatWithVariance startRadius = new FloatWithVariance(0, 0);
  FloatWithVariance targetRadius = new FloatWithVariance(0, 0);
  FloatWithVariance radiusSpeed = new FloatWithVariance(0, 0);

  FloatWithVariance startAlpha = new FloatWithVariance(0, 0);
  FloatWithVariance targetAlpha = new FloatWithVariance(0, 0);
  FloatWithVariance alphaSpeed = new FloatWithVariance(0, 0);

  FloatWithVariance drag = new FloatWithVariance(0, 0);

  PImage[] imgs = null;
  PImage img = null;

  int maxCount = 0;

  MSAParticleSystem() {}
  
  MSAParticleSystem(PImage _img) {
    img = _img;
  }
    
  MSAParticleSystem(PImage[] _imgs) {
    imgs = _imgs;
  }


  void start() {
    particles = new ArrayList();
  }


  void add() {
    MSAParticle p = new MSAParticle();
      
    if (img != null) {
      p.img = img;
    } 
    else if (imgs != null) {
      int imageIndex = (int)floor(random(0, imgs.length));
      p.img = imgs[imageIndex];
    } else {
      println("WARNING MSAParticleSystem has no images");
      return;
    }
    

    p.pos = startPos.get();
    p.posVel = startVel.get();
    p.posVel.add(PVector.mult(inheritVel.get(), inheritVelMult.get()));
    p.posAcc = acc.get();

    p.rot = startRot.get();

    p.rotVel = rotVel.get();

    p.radius = startRadius.get();
    p.targetRadius = targetRadius.get();
    p.radiusSpeed = radiusSpeed.get();

    p.drag = drag.get();

    p.alpha = startAlpha.get();
    p.targetAlpha = targetAlpha.get();
    p.alphaSpeed = alphaSpeed.get();

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

