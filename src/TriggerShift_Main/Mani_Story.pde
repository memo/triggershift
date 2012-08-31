class ManiStory extends TSStoryBase {
  MSAAudioPlayer audioRain = new MSAAudioPlayer("mani/audio/rain-loop.mp3");

  MSAAudioPlayer audioForward = new MSAAudioPlayer("mani/audio/goforwards.mp3");

  MSAAudioPlayer audioWheel = new MSAAudioPlayer("mani/audio/colorwheel.mp3");

  MSAAudioPlayer audioBallBounce = new MSAAudioPlayer("mani/audio/basketball-catch.mp3");

  MSAAudioPlayer audioBallCatch = new MSAAudioPlayer("mani/audio/basketball-bounce.mp3");

  MSAAudioPlayer audioBees = new MSAAudioPlayer("mani/audio/bees.mp3");
  
  MSAAudioPlayers audioFlowers = new MSAAudioPlayers( new String[] {
    "mani/audio/flowers/1.mp3", "mani/audio/flowers/2.mp3", "mani/audio/flowers/3.mp3", "mani/audio/flowers/4.mp3", "mani/audio/flowers/5.mp3"
  } );

  MSAAudioPlayers audioStars = new MSAAudioPlayers( new String[] {
    "mani/audio/stars/1.mp3", "mani/audio/stars/2.mp3", "mani/audio/stars/3.mp3"
  } );

  MSAAudioPlayers audioTraffic = new MSAAudioPlayers( new String[] {
    "mani/audio/trafficlights/red.mp3", "mani/audio/trafficlights/yellow.mp3", "mani/audio/trafficlights/green.mp3"
  } );

  MSAAudioPlayer audioBallet = new MSAAudioPlayer("mani/audio/ballerina.mp3");

  MSAAudioPlayer audioNightSky = new MSAAudioPlayer("mani/audio/world-turn.mp3");

  MSAAudioPlayer audioMelody = new MSAAudioPlayer("mani/audio/mani-melody.mp3");

  //  String []audioNoteNames = ;

  MSAAudioPlayers audioNotes = new MSAAudioPlayers( new String[] {
    "mani/audio/notes/1.mp3", "mani/audio/notes/2.mp3", "mani/audio/notes/3.mp3", "mani/audio/notes/4.mp3", "mani/audio/notes/5.mp3", "mani/audio/notes/6.mp3", "mani/audio/notes/7.mp3", "mani/audio/notes/8.mp3", "mani/audio/notes/9.mp3"
  } );


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
    if(useInstallationMode == false) addScene(new Scene9());
    addScene(new Scene10());
  }


  //------------------------------------------------------------------------------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
    audioRain.close();
    audioForward.close();
    audioWheel.close();
    audioBallBounce.close();
    audioBallCatch.close();
    audioBees.close();
    audioFlowers.close();
    audioStars.close();
    audioTraffic.close();
    audioNightSky.close();
    audioMelody.close();
    audioNotes.close();
  }


  //----------------
  class Sky {
    MSAParticle p = new MSAParticle(loadImage("mani/nightandday.png"));
    float targetRot;

    void start() {
      targetRot = 0;
      p.alpha = 0;
      p.targetAlpha = 1;
      p.alphaSpeed = 0.1;
      p.rot = 0;
      p.rotVel = 0;
      p.radius = height * 1.3;
      p.pos.set(width/2, height, 0);
    }

    void startDay() {
      targetRot = 0;
    }

    void startNight() {
      targetRot = 180;
    }


    void draw() {
      p.rotVel = (targetRot - p.rot) * 0.2 / secondsSinceLastFrame;
//      sky.p.rot += ;
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
    float speed = 0.1;
    float tintAmount = 1;

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
      tint(255 * tintAmount, a*a * 255);
      imageMode(CENTER);
      translate(width/2, height/2);
      scale(s);
      image(img, 0, (height-img.height)/2, width, width * img.height / img.width);
      popMatrix();
      popStyle();
    }
  };
  City cityGrey = new City("mani/citygrey.png");
  City cityColor = new City("mani/citycolor.png");


  //----------------
  class Flowers {
    PImage[] imgs = { 
      loadImage("mani/flower1.png"), loadImage("mani/flower2.png"), loadImage("mani/flower3.png"), loadImage("mani/flower4.png"), loadImage("mani/flower5.png")
      };
      MSAParticleSystem particleSystem = new MSAParticleSystem(imgs);

    void start() {
      particleSystem.start();

      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(30), units(30), 0));
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
      particleSystem.maxCount = 100;
    }

    void end() {
      for (int i=0; i<particleSystem.particles.size(); i++) {
        MSAParticle p = (MSAParticle)particleSystem.particles.get(i);
        p.posAcc.x = -random(units(20), units(50));
        p.posAcc.y = -random(units(70), units(150));
      }
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
    MSAParticle p = new MSAParticle(loadImage("mani/colourwheel.png"));

    void start() {
      p.pos = new PVector(width * 0.3, height * 0.3);
      p.rot = 0;
      p.rotVel = 0;
      p.radius = 0;
      p.targetRadius = units(90);
      p.radiusSpeed = 0.1;
      p.alpha = 0;
      p.targetAlpha = 1;
      p.alphaSpeed = 0.5;

      audioWheel.loop();
    }

    void end() {
      p.targetAlpha = 0;
      audioWheel.pause();
    }

    void draw() {
      if (p.pointIn(getLeftHand())) {
        p.rotVel *= 0.98;
        p.rotVel += getLeftHandVelocity().y * 50;
      }

      p.draw();
      audioWheel.setGain(abs(p.rotVel) * 0.003);
    }
  };
  ColorWheel colorWheel = new ColorWheel();


  //----------------
  class Basketball {
    MSAParticle p = new MSAParticle(loadImage("mani/basketball.png"));
    float bounce = 0.9;

    void start() {
      p.alpha = 0;
      p.targetAlpha = 1;
      p.alphaSpeed = 0.5;
      p.posVel = new PVector(units(100), 0);
      p.pos = colorWheel.p.pos.get();
      p.radius = colorWheel.p.targetRadius;
      p.targetRadius = units(64);
      p.radiusSpeed = 0.2;
      p.rotVel = colorWheel.p.rotVel;
      p.posAcc.y = units(400);
    }

    void end() {
      p.targetRadius = 0;
    }

    void draw() {
      if (p.radius > 0.1) {
        // bounce off edges
        if (p.pos.y > height - p.radius) {
          p.pos.y = height - p.radius;
          p.posVel.y = -abs(p.posVel.y * bounce);
          audioBallBounce.play(0);
        } 
        else if (p.pos.y < p.radius) {
          p.pos.y = p.radius;
          p.posVel.y = abs(p.posVel.y * bounce);
          audioBallBounce.play(0);
        }
        if (p.pos.x > width - p.radius) {
          p.pos.x = width - p.radius;
          p.posVel.x = -abs(p.posVel.x * bounce);
          audioBallBounce.play(0);
        } 
        else if (p.pos.x < p.radius) {
          p.pos.x = p.radius;
          p.posVel.x = abs(p.posVel.x * bounce);
          audioBallBounce.play(0);
        }

        // collide with hand
        for (int i=0; i<2; i++) {
          PVector handPos = getHand(i);
          PVector handVel = getHandVelocity(i);
          PVector diff = PVector.sub(p.pos, handPos);
          float distance = diff.mag();
          if (distance < p.radius) {
            PVector normDiff = diff.get();
            normDiff.normalize();
            p.pos.add(PVector.mult(normDiff, p.radius-distance));
            float speeddot = p.posVel.dot(normDiff);  // component of speed into hand
            PVector veldot = PVector.mult(normDiff, speeddot);  // component of velocity into hand
            PVector veltan = PVector.sub(p.posVel, veldot); // comopnent of velocty tangent to hand
            veldot.mult(-bounce);  // flip velocity
            p.posVel = PVector.add(veldot, veltan);
            if(!audioBallCatch.isPlaying()) audioBallCatch.play(0);
          }
        }
      }

      p.draw();
    }
  };
  Basketball basketball = new Basketball();


  //----------------
  class TrafficLights {
    PImage[] imgs = { 
      loadImage("mani/trafficlight1.png"), loadImage("mani/trafficlight2.png"), loadImage("mani/trafficlight3.png")
      };
      float targetPosY = height * 0.5;
    PVector pos = new PVector(units(420), targetPosY);
    int currentLight = 0;

    void start() {
      pos.y = height;
      currentLight = 0;
    }

    void end() {
      targetPosY = height;
    }

    void draw() {
      PVector leftHand = getLeftHand();
      float w = units(120);
      float h = w * imgs[0].height / imgs[0].width;

      float topY = pos.y - h * 0.45;
      float bottomY = pos.y + h * 0.2;
      if (leftHand.x < pos.x + w * 0.2 && leftHand.y > topY && leftHand.y < bottomY) {
        int newLight = (int)round(map(leftHand.y, topY, bottomY, 0, 2));
        if (newLight != currentLight) {
          currentLight = newLight;
          audioTraffic.playIndex(currentLight, 0);
        }
      }

      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      pos.y += (targetPosY - pos.y) * 0.1;
      translate(pos.x, pos.y);
      image(imgs[currentLight], 0, 0, w, h);
      popMatrix();
      popStyle();
    }
  };
  TrafficLights trafficLights = new TrafficLights();



  class MusicNotes {
    boolean doCreate;

    MSAParticleSystem particleSystem = new MSAParticleSystem();
    PImage[] imgs = { 
      loadImage("mani/note1.png"), loadImage("mani/note2.png"), loadImage("mani/note3.png"), loadImage("mani/note4.png"), loadImage("mani/note5.png")
      };


      void start() {
        particleSystem.start();

        particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(10), units(10), units(5)));
        particleSystem.startVel.set(new PVector(0, 0, 0), new PVector(units(30), units(30), units(0)));
        particleSystem.acc.set(new PVector(0, units(-30), 0), new PVector(0, units(0), 0));
        particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
        particleSystem.inheritVelMult.set(new PVector(width/100, height/100, 0), new PVector(0, 0, 0));

        particleSystem.startRot.set(0, 30);
        particleSystem.rotVel.set(0, 3);

        particleSystem.startRadius.set(0, 0);
        particleSystem.targetRadius.set(units(7), units(2));
        particleSystem.radiusSpeed.set(0.3, 0.1);

        particleSystem.startAlpha.set(1, 0);
        particleSystem.targetAlpha.set(0, 0);
        particleSystem.alphaSpeed.set(0.005, 0.001);

        particleSystem.drag.set(0.01, 0.001);

        particleSystem.maxCount = 100;
        particleSystem.imgs = imgs;

        doCreate = true;
      }

    void end() {
      //doCreate = false;
    }

    void draw() {
      if (doCreate) {
        for (int i=0; i<2; i++) {
          if (getHandVelocity(i).mag() > 0.1) {
            if (random(1.0)<0.5) {
              particleSystem.startPos.base = getHand(i);
              particleSystem.inheritVel.base = getHandVelocity(i);
              particleSystem.add();
              audioNotes.playRandomIndex();
              audioNotes.randomGain();

            }
          }
        }
      }

      particleSystem.draw();
    }
  };
  MusicNotes musicNotes = new MusicNotes();


  class Stars {
    MSAParticleSystem particleSystem = new MSAParticleSystem();
    PImage[] imgs = { 
      loadImage("mani/star1.png"), loadImage("mani/star2.png")
      };


      void start() {
        particleSystem.start();

        particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(0), units(0), units(0)));
        particleSystem.startVel.set(new PVector(0, 0, 0), new PVector(units(0), units(0), units(0)));
        particleSystem.acc.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
        particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
        particleSystem.inheritVelMult.set(new PVector(0, 0, 0), new PVector(0, 0, 0));

        particleSystem.startRot.set(0, 360);
        particleSystem.rotVel.set(0, 0);

        particleSystem.startRadius.set(0, 0);
        particleSystem.targetRadius.set(units(7), units(2));
        particleSystem.radiusSpeed.set(0.3, 0.1);

        particleSystem.startAlpha.set(0, 0);
        particleSystem.targetAlpha.set(1, 0);
        particleSystem.alphaSpeed.set(0.1, 0.01);

        particleSystem.drag.set(0.0, 0.0);

        particleSystem.maxCount = 100;
        particleSystem.imgs = imgs;
      }

    void end() {
      //doCreate = false;
    }

    void draw() {
      for (int i=0; i<2; i++) {
        if (getHandVelocity(i).mag() > 0.1) {
          if (random(1.0)<0.2) {
            particleSystem.startPos.base = getHand(i);
            particleSystem.inheritVel.base = getHandVelocity(i);
            particleSystem.add();
            audioStars.playRandomIndex();
            audioStars.randomGain();
          }
        }
      }

      particleSystem.draw();
    }
  };
  Stars stars = new Stars();



  //----------------
  class Ballerina {
    MSAParticle p = new MSAParticle(loadImage("mani/ballerina.png"));
    void start() {
      p.radius = 0;
      p.targetRadius = units(150);
      p.radiusSpeed = 0.05;
      p.pos = new PVector(width * 0.75, height * 0.5);
      audioBallet.loop();
      audioMelody.setGain(0.5);
    }

    void end() {
      p.targetRadius = 0;
      p.radiusSpeed = 0.2;
      audioBallet.pause();
      audioMelody.setGain(1.0);
    } 

    void draw() {
      p.draw();
    }
  };
  Ballerina ballerina = new Ballerina();


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
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      cityGrey.set(1, 1, 0, 1);
      particleSystem.start();

      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(50), units(0), units(0)));
      particleSystem.startVel.set(new PVector(0, units(150), 0), new PVector(units(0), units(150), units(150)));
      particleSystem.acc.set(new PVector(0, units(200), 0), new PVector(0, 0, 0));
      particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      particleSystem.inheritVelMult.set(new PVector(width*0.2, height*0.2, 0), new PVector(0, 0, 0));

      particleSystem.startRot.set(0, 5);
      particleSystem.rotVel.set(0, 0);

      particleSystem.startRadius.set(0, 0);
      particleSystem.targetRadius.set(units(5), units(2));
      particleSystem.radiusSpeed.set(0.3, 0.0);

      particleSystem.startAlpha.set(0, 0);
      particleSystem.targetAlpha.set(1, 0);
      particleSystem.alphaSpeed.set(0.5, 0.1);

      particleSystem.drag.set(0.02, 0.005);
      particleSystem.maxCount = 300;
      particleSystem.img = imgRain;

      particleSystem.alignToDir = true;

      audioRain.loop();
    }

    //----------------
    void onEnd() {
      audioRain.pause();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      audioRain.setGain(1 - getHighestHand().y/height);

      background(0);
      cityGrey.draw();
      drawMaskedUser();

      for (int i=0; i<2; i++) {
        particleSystem.startPos.base = getHand(i);
        particleSystem.startPos.base.y += units(20);
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
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      cityGrey.set(1, 0, 1, 0);
      cityColor.set(5, 1, 0, 1);
      sky.start();
      audioForward.play(0);
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
      sky.draw();
      cityGrey.draw();
      drawMaskedUser();
      cityColor.draw();
      if(useInstallationMode && getElapsedSeconds() > 5) nextScene();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // flowers
  class Scene3 extends TSSceneBase {
    Scene3() {
      sceneName = "Scene3 FLOWERS";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      flowers.start();
    }

    //----------------
    void onEnd() {
      flowers.end();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
      //      PVector leftHand = getLeftHand();
      PVector rightHand = getRightHand();
      if (getRightHandVelocity().mag() > 0.01) {
        flowers.add(new PVector(width * 0.95, rightHand.y));
        audioFlowers.playRandomIndex();
        audioFlowers.randomGain();
      }
      flowers.draw();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // color wheel
  class Scene4 extends TSSceneBase {
    Scene4() {
      sceneName = "Scene4 COLOR WHEEL";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      colorWheel.start();
    }

    //----------------
    void onEnd() {
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
    }
  };

  //------------------------------------------------------------------------------------------------------
  // Hip Hop
  class Scene5 extends TSSceneBase {
    Scene5() {
      sceneName = "Scene5 HIP HOP";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      basketball.start();
    }

    //----------------
    void onEnd() {
      basketball.end();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
      sky.draw();
      drawMaskedUser();
      cityColor.draw();
      //      flowers.draw();
      colorWheel.draw();
      basketball.draw();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // traffic lights
  class Scene6 extends TSSceneBase {
    Scene6() {
      sceneName = "Scene6 TRAFFIC LIGHTS";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      trafficLights.start();
    }

    //----------------
    void onEnd() {
      trafficLights.end();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      background(0);
      sky.draw();
      drawMaskedUser();
      trafficLights.draw();
      cityColor.draw();
      //      flowers.draw();
      colorWheel.draw();
      basketball.draw();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // music
  class Scene7 extends TSSceneBase {
    Scene7() {
      sceneName = "Scene7 MUSIC";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      musicNotes.start();
      audioMelody.loop();
      audioBees.loop();
    }
    
    //----------------
    void onEnd() {
     audioBees.pause(); 
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      audioBees.setGain(1 - getHighestHand().y/height);
      background(0);
      sky.draw();
      drawMaskedUser();
      trafficLights.draw();
      cityColor.draw();
      //      flowers.draw();
      colorWheel.draw();
      //      basketball.draw();
      musicNotes.draw();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // ballerina
  class Scene8 extends TSSceneBase {
    Scene8() {
      sceneName = "Scene8 BALLERINA";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      ballerina.start();
    }

    //----------------
    void onEnd() {
      ballerina.end();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      PVector handToHand = PVector.sub(getLeftHand3D(), getRightHand3D());
      ballerina.p.rotY += (180 + degrees(atan2(handToHand.y, handToHand.x)) - ballerina.p.rotY) * 0.1;

      background(0);
      sky.draw();
      drawMaskedUser();
      //      trafficLights.draw();
      cityColor.draw();
      ballerina.draw();
      //      flowers.draw();
      colorWheel.draw();
      //      basketball.draw();
      //      musicNotes.draw();
    }
  };


  //------------------------------------------------------------------------------------------------------
  // night
  class Scene9 extends TSSceneBase {
    boolean doInteraction;

    Scene9() {
      sceneName = "Scene9 NIGHT";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      doInteraction = false;
      sky.startDay();
      cityColor.tintAmount = 1;
      audioNightSky.loop();
    }


    //----------------
    void onEnd() {
      audioNightSky.pause();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      PVector hand = getLeftHand();
      float nightAmount = map(degrees(atan2(hand.y - height/2, hand.x - width/2)), -180, 0, 0, 1);
      //      println(nightAmount);
      if (nightAmount > 1.5) {
        nightAmount = 0;
        doInteraction = true;
      } 
      else if (nightAmount > 1) {
        nightAmount = 1;
        if (sky.p.rot > 179) {
          doInteraction = false;
          nextScene();
        }
      }

      if (doInteraction) {
        sky.targetRot = nightAmount * 180;
        cityColor.tintAmount = 1 - nightAmount * 0.8;
      }


      audioNightSky.setGain(abs(sky.p.rotVel) * 1);

      background(0);
      sky.draw();
      drawMaskedUser();
      //      trafficLights.draw();
      cityColor.draw();
      ballerina.draw();
      //      flowers.draw();
      //      colorWheel.draw();
      //      basketball.draw();
    }
  };    


  //------------------------------------------------------------------------------------------------------
  // stars
  class Scene10 extends TSSceneBase {
    Scene10() {
      sceneName = "Scene10 STARS";
      println(storyName + "::" + sceneName);
      //      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      stars.start();
      sky.startNight();
      cityColor.tintAmount = 0.2;
    }


    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      for (int i=0; i<stars.particleSystem.particles.size(); i++) {
        MSAParticle p = (MSAParticle)stars.particleSystem.particles.get(i);
        p.alpha = random(1.0);
        p.radius = random(units(1), units(10));
      }
      background(0);

      sky.draw();
      stars.draw();
      drawMaskedUser();
      //      trafficLights.draw();
      cityColor.draw();
      //      ballerina.draw();
      //      flowers.draw();
      //      colorWheel.draw();
      basketball.draw();
    }
  };
};

