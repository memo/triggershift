class JamelStory extends TSStoryBase {

  JamelStory() {
    storyName = "JamelStory";
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
    addScene(new Scene11());
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }


  //----------------------------------
  // SCENES:
  //----------------------------------
  // jump through flag
  class Scene1 extends TSSceneBase {
    PImage imgFlag = loadImage("jamel/flag.png");
    Scene1() {
      sceneName = "Scene1 FLAG INTRO";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      image(imgFlag, 0, 0, width, height);

      // play BEEP sound
      if (keyPressed && key == ' ') {
        println("BEEEP");
      }
    }
  };



  //----------------------------------
  // draw graph and pound signs
  class Scene2 extends TSSceneBase {
    PImage imgPound = loadImage("jamel/pound.png");
    ArrayList posArray;
    ArrayList particles;

    //----------------
    Scene2() {
      sceneName = "Scene2 GRAPH";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      posArray = new ArrayList();
      particles = new ArrayList();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      PVector activeHand = getHighestHand();

      // add latest hand
      posArray.add(activeHand.get());
      if (posArray.size() > 100) posArray.remove(0);  // trim array

      // draw graph
      noFill();
      strokeWeight(10);
      strokeJoin(ROUND);
      strokeCap(ROUND);
      beginShape();
      PVector p1 = new PVector(-1000, -1000, -1000);
      for (int i=0; i<posArray.size(); i++) {
        PVector p2 = (PVector)posArray.get(i);
        PVector diff = PVector.sub(p1, p2);
        // only draw if distance between points is less than threshold
        if (diff.mag() < transform2D.targetSizePixels.y * 0.1) {
          stroke(255, 200, 100, i * 255.0/posArray.size());
          vertex(p2.x, p2.y);
        } 
        else {
          endShape();
          beginShape();
        }
        p1.set(p2);
      }
      endShape();

      // add particle if velocity is above threshold
      if (posArray.size() > 1) {
        PVector prv = ((PVector)posArray.get(posArray.size()-2)).get();
        PVector now = ((PVector)posArray.get(posArray.size()-1)).get();
        PVector vel = PVector.sub(prv, now);
        if (vel.mag() > transform2D.targetSizePixels.y * 0.03) {
          float r = transform2D.targetSizePixels.y * 0.1;
          now.x += random(-r, r);
          now.y += random(-r, r);
          now.z += random(-r, r);
          vel.mult(-0.2);
          particles.add(new MSAParticle(now, vel, random(-30, 30), random(-3, 3), random(height/80, height/40), 1.0, 1.0, 0.98));
        }
      }

      if (particles.size() > 20) particles.remove(0);  // trim array
      // draw particles
      for (int i=0; i<particles.size(); i++) {
        MSAParticle p = (MSAParticle) particles.get(i);
        p.draw(imgPound);
      }

      popStyle();
    }
  };


  //----------------------------------
  // Tramp
  class Scene3 extends TSSceneBase {
    PImage imgTramp1 = loadImage("jamel/tramp1.png");
    PImage imgTramp2 = loadImage("jamel/tramp2.png");
    
    Scene3() {
      sceneName = "Scene3";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene4 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene4() {
      sceneName = "Scene4";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene5 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene5() {
      sceneName = "Scene5";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene6 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene6() {
      sceneName = "Scene6";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene7 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene7() {
      sceneName = "Scene7";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene8 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene8() {
      sceneName = "Scene8";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene9 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene9() {
      sceneName = "Scene9";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene10 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene10() {
      sceneName = "Scene10";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene11 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene11() {
      sceneName = "Scene11";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };
}

