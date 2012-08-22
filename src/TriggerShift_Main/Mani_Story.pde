class ManiStory extends TSStoryBase {

  ManiStory() {
    storyName = "ManiStory";
    println(storyName + "::" + storyName);
    addScene(new Scene1());
    addScene(new Scene2());
    addScene(new Scene3());
    addScene(new Scene4());
    addScene(new Scene5());
    addScene(new Scene6());
    addScene(new Scene7());
    addScene(new Scene8());
    addScene(new Scene9());
    addScene(new Scene10());
  }

  //------------------------------------------------------------------------------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }


  //----------------
  class Sky {
    PImage img = loadImage("mani/nightandday.png");
    float alpha;
    float targetAlpha;
    float rot;
    float targetRot;

    void start() {
      alpha = 0;
      targetAlpha = 1;
      rot = 0;
      targetRot = 0;
    }

    void draw() {
      alpha += (targetAlpha - alpha) * 0.1;
      rot += (targetRot - rot) * 0.1;

      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      translate(width/2, height);
      rotate(radians(rot));
      scale(width / img.width);
      tint(255, alpha * 255);
      image(img, 0, 0);
      popMatrix();
      popStyle();
    }
  };
  Sky sky = new Sky();


  //----------------
  class City {
    PImage img;
    float s;    // scale
    float a;    // alpha
    float ts;   // target scale
    float ta;   // target alpha
    float speed = 0.05;

    City(String imgName) {
      img = loadImage(imgName);
    }

    void set(float _s, float _ts, float _a, float _ta) {
      s = _s;
      ts = _ts;
      a = _a;
      ta = _ta;
    }

    void draw() {
      s += (ts - s) * speed;
      a += (ta - a) * speed;

      pushStyle();
      pushMatrix();
      tint(255, a*a * 255);
      imageMode(CENTER);
      translate(width/2, height/2);
      scale(s);
      image(img, 0, 0, width, height);
      popMatrix();
      popStyle();
    }
  };
  City cityGrey = new City("mani/citygrey.png");
  City cityColor = new City("mani/citycolor.png");


  //----------------
  class Flowers {
    class Flower {
      PVector pos = new PVector();
      float s;
      float r;
      PImage img;

      void draw() {
        if (img == null) {
          println("Mani::Flower.img == null");
          return;
        }
        s += (1-s) * 0.1;
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(radians(r));
        scale(s / img.height * height * 0.2);
        imageMode(CENTER);
        image(img, 0, 0);
        popMatrix();
      }
    };

    PImage[] images = { 
      loadImage("mani/flower1.png"), loadImage("mani/flower2.png"), loadImage("mani/flower3.png"), loadImage("mani/flower4.png"), loadImage("mani/flower5.png")
      };

      ArrayList flowersArray;

    void start() {
      flowersArray = new ArrayList();
    }

    void add(PVector _pos) {
      // look to see if there is a flower nearby
      boolean flowerFound = false;
      for (int i=0; i<flowersArray.size(); i++) {
        Flower f = (Flower)flowersArray.get(i);
        if (abs(f.pos.y-_pos.y) < height * 0.02) flowerFound = true;
      }
      if (flowerFound) return;

      Flower f = new Flower();
      f.pos = _pos;
      f.s = 0;
      f.r = random(-30, 30);
      f.img = images[(int)floor(random(0, 5))];
      flowersArray.add(f);
    }

    void draw() {
      for (int i=0; i<flowersArray.size(); i++) {
        Flower f = (Flower)flowersArray.get(i);
        f.draw();
      }
    }
  };
  Flowers flowers = new Flowers();


  //----------------
  class ColorWheel {
    PImage img = loadImage("mani/colourwheel.png");
    PVector pos = new PVector(width * 0.2, height * 0.3);
    float rot, rotSpeed;
    float radius; 
    float targetRadius = width * 0.1;

    void start() {
      rot = 0;
      rotSpeed = 0;
      radius = 0;
    }

    void draw() {
      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(radians(rot));
      radius += (targetRadius - radius) * 0.1;
      scale(radius * 2 / img.width);
      image(img, 0, 0);
      popMatrix();
      popStyle();

      rot += rotSpeed;
      rotSpeed *= 0.99;
    }
  };
  ColorWheel colorWheel = new ColorWheel();


  //----------------
  class Basketball {
    PImage img = loadImage("mani/basketball.png");
    PVector pos, vel;
    float rot, rotSpeed;
    float radius; 
    float targetRadius = width * 0.05;
    float bounce = 0.9;

    void start() {
      vel = new PVector(width*0.02, 0);
      pos = new PVector(width + radius, -radius);
    }

    void draw() {
      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(radians(rot));
      radius += (targetRadius - radius) * 0.1;
      scale(radius * 2 / img.width);
      image(img, 0, 0);
      popMatrix();
      popStyle();

      rot += rotSpeed;
      rotSpeed *= 0.99;

      pos.add(vel);
      // gravity
      vel.y += height * 0.01; 

      // bounce off edges
      if (pos.y > height - radius) {
        pos.y = height - radius;
        vel.y = -abs(vel.y * bounce);
      } 
      else if (pos.y < radius) {
        pos.y = radius;
        vel.y = abs(vel.y * bounce);
      }
      if (pos.x > width - radius) {
        pos.x = width - radius;
        vel.x = -abs(vel.x * bounce);
      } 
      else if (pos.x < radius) {
        pos.x = radius;
        vel.x = abs(vel.x * bounce);
      }

      // collide with hand
      for (int i=0; i<2; i++) {
        PVector handPos = getHand(i);
        PVector handVel = getHandVelocity(i);
        PVector diff = PVector.sub(pos, handPos);
        float distance = diff.mag();
        if (distance < radius) {
          PVector normDiff = diff.get();
          normDiff.normalize();
          pos.add(PVector.mult(normDiff, radius-distance));
          float speeddot = vel.dot(normDiff);  // component of speed into hand
          PVector veldot = PVector.mult(normDiff, speeddot);  // component of velocity into hand
          PVector veltan = PVector.sub(vel, veldot); // comopnent of velocty tangent to hand
          veldot.mult(-bounce);  // flip velocity
          vel = PVector.add(veldot, veltan);
        }
      }
    }
  };
  Basketball basketball = new Basketball();


  //----------------
  class TrafficLights {
    PImage img = loadImage("mani/trafficlight.png");
    float targetPosY = height * 0.55;
    PVector pos = new PVector(width * 0.75, targetPosY);
    float radius = width * 0.05;

    void start() {
      pos.y = height;
    }

    void draw() {
      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      pos.y += (targetPosY - pos.y) * 0.2;
      translate(pos.x, pos.y);
      scale(radius * 2 / img.width);
      image(img, 0, 0);
      popMatrix();
      popStyle();
      //
      //      rot += rotSpeed;
      //      rotSpeed *= 0.99;
    }
  };
  TrafficLights trafficLights = new TrafficLights();


  //------------------------------------------------------------------------------------------------------
  // SCENES:
  //------------------------------------------------------------------------------------------------------
  // grey city
  class Scene1 extends TSSceneBase {
    PImage imgRain = loadImage("mani/raindrop.png");
    MSAParticleSystem particleSystem = new MSAParticleSystem();

    Scene1() {
      sceneName = "Scene1 GREY CITY";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      cityGrey.set(1, 1, 0, 1);
      particleSystem.start();

      particleSystem.initPos.set(0, 0, 0);
      particleSystem.initPosVariance.set(units(50), units(10), 0);

      particleSystem.initVel.set(0, units(120), 0);
      particleSystem.initVelVariance.set(0, 0, 0);

      particleSystem.initAcc.set(0, units(12), 0);
      particleSystem.initAccVariance = 0;

      particleSystem.initRot = 0;
      particleSystem.initRotVariance = 30;        

      particleSystem.initRotVel = 0;
      particleSystem.initRotVelVariance = 3;  

      particleSystem.initRadius = units(10);
      particleSystem.initRadiusVariance = units(3);  

      particleSystem.initDrag = 0;
      particleSystem.initDragVariance = 0;        

      particleSystem.initAlpha = 0;
      particleSystem.initAlphaVariance = 0;
      particleSystem.initTargetAlpha = 1;
      particleSystem.initTargetAlphaVariance = 0;
      particleSystem.initFadeSpeed = 0.2;
      particleSystem.initFadeSpeedVariance = 0;

      particleSystem.maxCount = 100;

      particleSystem.img = imgRain;

      //      particleSystem.initVelMult.set(width, height, 0);
      //      particleSystem.initVel.set(0, height * 0.02, 0);
      //      particleSystem.initRadius = 0.02;
      //      particleSystem.initRadiusVariance = 0.001;
      //      particleSystem.initAlpha = 1;
      //      particleSystem.initAlphaVariance = 0;
      //      particleSystem.initDrag = 0;
      //      particleSystem.initDragVariance = 0;
      //      particleSystem.initFadeSpeed = 0;
      //      particleSystem.initFadeSpeedVariance = 0;
      //      p.radius = random(height/80, height/40);
      //      p.alpha = 1;
      //      p.drag = 1;
      //      p.fade = 1;
      //      p.img = img;
      //      particles.add(p);
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      cityGrey.draw();
      drawMaskedUser();

      for (int i=0; i<2; i++) {
        particleSystem.initPos = getHand(i);
        particleSystem.initVel = getHandVelocity(i);
        particleSystem.add();
      }

      particleSystem.draw();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // main city
  class Scene2 extends TSSceneBase {
    Scene2() {
      sceneName = "Scene2 MAIN CITY";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      cityGrey.set(1, 0, 1, 0);
      cityColor.set(5, 1, 0, 1);
      sky.start();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      cityGrey.draw();
      drawMaskedUser();
      cityColor.draw();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // flowers
  class Scene3 extends TSSceneBase {
    Scene3() {
      sceneName = "Scene3 FLOWERS";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      flowers.start();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
      PVector leftHand = getLeftHand();
      PVector rightHand = getRightHand();
      pushStyle();
      flowers.add(new PVector(width * 0.95, rightHand.y));
      flowers.draw();
      popStyle();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // color wheel
  class Scene4 extends TSSceneBase {
    Scene4() {
      sceneName = "Scene4 COLOR WHEEL";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      colorWheel.start();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
      flowers.draw();
      colorWheel.draw();
      if (getLeftHand().x < colorWheel.pos.x + colorWheel.radius) {
        colorWheel.rotSpeed *= 0.9;
        colorWheel.rotSpeed += getLeftHandVelocity().y * 50;
      }
    }
  };

  //------------------------------------------------------------------------------------------------------
  // Hip Hop
  class Scene5 extends TSSceneBase {
    Scene5() {
      sceneName = "Scene5 HIP HOP";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      basketball.start();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
      flowers.draw();
      colorWheel.draw();
      if (getLeftHand().x < colorWheel.pos.x + colorWheel.radius) {
        colorWheel.rotSpeed *= 0.9;
        colorWheel.rotSpeed += getLeftHandVelocity().y * 50;
      }
      basketball.draw();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // traffic lights
  class Scene6 extends TSSceneBase {
    Scene6() {
      sceneName = "Scene6 TRAFFIC LIGHTS";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      trafficLights.start();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      drawMaskedUser();
      trafficLights.draw();
      cityColor.draw();
      flowers.draw();
      colorWheel.draw();
      if (getLeftHand().x < colorWheel.pos.x + colorWheel.radius) {
        colorWheel.rotSpeed *= 0.9;
        colorWheel.rotSpeed += getLeftHandVelocity().y * 50;
      }
      basketball.draw();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // music
  class Scene7 extends TSSceneBase {
    Scene7() {
      sceneName = "Scene7 MUSIC";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      sky.draw();
      drawMaskedUser();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // ballerina
  class Scene8 extends TSSceneBase {
    Scene8() {
      sceneName = "Scene8 BALLERINA";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // night
  class Scene9 extends TSSceneBase {
    Scene9() {
      sceneName = "Scene9 NIGHT";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
    }
  };    


  //------------------------------------------------------------------------------------------------------
  // stars
  class Scene10 extends TSSceneBase {
    Scene10() {
      sceneName = "Scene10 STARS";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
    }
  };
};
