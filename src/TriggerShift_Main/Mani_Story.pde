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
        if (abs(f.pos.y-_pos.y) < height * 0.05) flowerFound = true;
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
    float rot = 0;
    float s = 0;
    
    void start() {
      s = 0;
    }

    void draw() {
      s += (1-s) * 0.1;
      
      pushStyle();
      pushMatrix();
      imageMode(CENTER);
      translate(width * 0.2, height * 0.3);
      rotate(radians(rot));
      scale(s * width * 0.2 / img.width);
      image(img, 0, 0);
      rot += 1;
      popMatrix();
      popStyle();
    }
  };
  ColorWheel colorWheel = new ColorWheel();


  //------------------------------------------------------------------------------------------------------
  // SCENES:
  //------------------------------------------------------------------------------------------------------
  // grey city
  class Scene1 extends TSSceneBase {
    PImage imgRain = loadImage("mani/raindrop.png");
    ArrayList particles;
//    PVector[] prevHandPos = new PVector[2];


    Scene1() {
      sceneName = "Scene1 GREY CITY";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      cityGrey.set(1, 1, 0, 1);
      particles = new ArrayList();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      cityGrey.draw();
      drawMaskedUser();

      PVector[] handPos = { 
        getLeftHand().get(), getRightHand().get()
      };
      PVector[] handVel = {
        getLeftHandVelocity().get(), getRightHandVelocity().get()
      };


      pushStyle();
      // add particle if velocity is above threshold
      for (int i=0; i<2; i++) {
//        if (prevHandPos[i] != null) {
//          PVector prv = prevHandPos[i].get();
          PVector now = handPos[i].get();
          PVector vel = handVel[i].get();//PVector.sub(prv, now);
          //          if (vel.mag() > transform2D.targetSizePixels.y * 0.03) {
          float r = transform2D.targetSizePixels.y * 0.1;
          now.x += random(-r, r);
          now.y += random(-r, r);
          now.z += random(-r, r);
          vel.mult(-height);
          MSAParticle p = new MSAParticle();//now, vel, random(-30, 30), random(-3, 3), random(height/80, height/40), 1.0, 1.0, 0.98);
          p.pos = now;
          p.posVel = vel;
          p.rot = random(-30, 30);
          p.rotVel = random(-3, 3);
          p.radius = random(height/80, height/40);
          p.alpha = 1;
          p.drag = 1;
          p.fade = 1;
          p.posAcc = new PVector(0, 10, 0);
          p.img = imgRain;
          particles.add(p);
          //          }
//        }

//        prevHandPos[i] = handPos[i].get();
      }

      while (particles.size () > 100) particles.remove(0);  // trim array
      // draw particles
      for (int i=0; i<particles.size(); i++) {
        MSAParticle p = (MSAParticle) particles.get(i);
        p.draw();
      }

      popStyle();
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
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
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
      drawMaskedUser();
      cityColor.draw();
      PVector leftHand = getLeftHand().get();
      PVector rightHand = getRightHand().get();
      pushStyle();
      flowers.add(new PVector(width * 0.95, leftHand.y));
      //      flowers.add(rightHand);
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
      drawMaskedUser();
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
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
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
}

