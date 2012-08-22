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
    MSAParticle p = new MSAParticle();
    
    Sky() {
      p.img = loadImage("mani/nightandday.png");
    }

    void start() {
      p.alpha = 0;
      p.targetAlpha = 1;
      p.alphaSpeed = 0.1;

      p.rot = 0;
      
      p.radius = 0;
      p.targetRadius = height * 1.5;
      p.radiusSpeed = 0.05;
      
      p.pos.set(width/2, height, 0);
    }

    void draw() {
      p.draw();
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
    MSAParticleSystem particleSystem = new MSAParticleSystem();

    PImage[] imgs = { 
      loadImage("mani/flower1.png"), loadImage("mani/flower2.png"), loadImage("mani/flower3.png"), loadImage("mani/flower4.png"), loadImage("mani/flower5.png")
      };

    void start() {
      particleSystem.start();

      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.startVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.acc.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.inheritVelMult.set(new PVector(0, 0, 0), new PVector(0, 0, 0));

      particleSystem.startRot.set(0, 30);
      particleSystem.rotVel.set(0, 0);

      particleSystem.startRadius.set(0, 0);
      particleSystem.targetRadius.set(units(20), units(5));
      particleSystem.radiusSpeed.set(0.1, 0.0);

      particleSystem.startAlpha.set(1, 0);
      particleSystem.targetAlpha.set(1, 0);
      particleSystem.alphaSpeed.set(0.0, 0.0);

      particleSystem.drag.set(0, 0);
      particleSystem.maxCount = 200;
      particleSystem.imgs = imgs;      
    }

    void add(PVector _pos) {
      particleSystem.startPos.base = _pos.get();
      particleSystem.add();
    }

    void draw() {
      particleSystem.draw();
    }
  };
  Flowers flowers = new Flowers();


  //----------------
  class ColorWheel {
    PImage img = loadImage("mani/colourwheel.png");
    PVector pos = new PVector(width * 0.2, height * 0.3);
    float rot, rotSpeed;
    float radius; 
    float targetRadius;

    void start() {
      rot = 0;
      rotSpeed = 0;
      radius = 0;
      targetRadius = width * 0.1;
    }

    void end() {
      targetRadius = 0;
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

      rot += rotSpeed * secondsSinceLastFrame;
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
      vel = new PVector(-units(100), 0);
      pos = new PVector(width + radius, -radius);
    }

    void draw() {
      if (radius > 1) {
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
      }

      rot += rotSpeed * secondsSinceLastFrame;
      rotSpeed *= 0.99;

      pos.add(PVector.mult(vel, secondsSinceLastFrame));

      // gravity
      vel.y += units(80) * secondsSinceLastFrame; 

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

      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(50), units(10), units(10)));
      particleSystem.startVel.set(new PVector(0, units(150), 0), new PVector(units(0), units(150), units(150)));
      particleSystem.acc.set(new PVector(0, units(100), 0), new PVector(0, 0, 0));
      particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.inheritVelMult.set(new PVector(width*0.2, height*0.2, 0), new PVector(0, 0, 0));

      particleSystem.startRot.set(0, 5);
      particleSystem.rotVel.set(0, 0);

      particleSystem.startRadius.set(0, 0);
      particleSystem.targetRadius.set(units(10), units(3));
      particleSystem.radiusSpeed.set(0.3, 0.0);

      particleSystem.startAlpha.set(0, 0);
      particleSystem.targetAlpha.set(1, 0);
      particleSystem.alphaSpeed.set(0.5, 0.1);

      particleSystem.drag.set(0.02, 0.005);
      particleSystem.maxCount = 500;
      particleSystem.img = imgRain;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
      cityGrey.draw();
      drawMaskedUser();

      for (int i=0; i<2; i++) {
        particleSystem.startPos.base = getHand(i);
        particleSystem.inheritVel.base = getHandVelocity(i);
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
      background(0);
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
      background(0);
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
//      PVector leftHand = getLeftHand();
      PVector rightHand = getRightHand();
      if(getRightHandVelocity().mag() > 1) flowers.add(new PVector(width * 0.95, rightHand.y));
      flowers.draw();
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
      background(0);
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
      colorWheel.end();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
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
      background(0);
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
    MSAParticleSystem particleSystem = new MSAParticleSystem();
    PImage[] imgs = { 
      loadImage("mani/note1.png"), loadImage("mani/note2.png"), loadImage("mani/note3.png"), loadImage("mani/note4.png"), loadImage("mani/note5.png"), loadImage("mani/note6.png")
      };


      Scene7() {
        sceneName = "Scene7 MUSIC";
        println(storyName + "::" + sceneName);
        setTrigger(new MouseClickTrigger());
      }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      particleSystem.start();

      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(50), units(10), units(10)));
      particleSystem.startVel.set(new PVector(0, 0, 0), new PVector(units(100), units(100), units(100)));
      particleSystem.acc.set(new PVector(0, units(-20), 0), new PVector(0, units(5), 0));
      particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.inheritVelMult.set(new PVector(width, height, 0), new PVector(0, 0, 0));

      particleSystem.startRot.set(0, 30);
      particleSystem.rotVel.set(0, 3);

      particleSystem.startRadius.set(0, 0);
      particleSystem.targetRadius.set(units(7), units(2));
      particleSystem.radiusSpeed.set(0.5, 0.1);

      particleSystem.startAlpha.set(1, 0);
      particleSystem.targetAlpha.set(0, 0);
      particleSystem.alphaSpeed.set(0.02, 0.01);

      particleSystem.drag.set(0.04, 0.005);
      particleSystem.maxCount = 100;

      particleSystem.maxCount = 100;
      particleSystem.imgs = imgs;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
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

      for (int i=0; i<2; i++) {
        if (getHandVelocity(i).mag() > 0.1) {
          particleSystem.startPos.base = getHand(i);
          particleSystem.inheritVel.base = getHandVelocity(i);
          particleSystem.add();
        }
      }

      particleSystem.draw();
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
      background(0);
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
      background(0);
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

