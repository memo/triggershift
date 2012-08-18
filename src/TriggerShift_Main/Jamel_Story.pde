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
    PImage imgFlag;
    Scene1() {
      sceneName = "Scene1 FLAG INTRO";
      println(storyName + "::" + sceneName);
      imgFlag = loadImage("jamel/flag.png");
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
    PImage imgPound;
    ArrayList posArray;
    Scene2() {
      sceneName = "Scene2 GRAPH";
      println(storyName + "::" + sceneName);
      imgPound = loadImage("jamel/pound.png");
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      posArray = new ArrayList();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
      PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
      PVector activeHand = leftHand.y < rightHand.y ? leftHand : rightHand;

      // draw graph
      posArray.add(activeHand.get());
      if(posArray.size() > 100) posArray.remove(0);  // trim array
      noFill();
      strokeWeight(10);
      strokeJoin(ROUND);
      strokeCap(ROUND);
      beginShape();
      PVector p1 = new PVector(-1000, -1000, -1000);
      for (int i=0; i<posArray.size(); i++) {
        PVector p2 = (PVector)posArray.get(i);
        PVector pdiff = PVector.sub(p1, p2);
        // only draw if distance between points is less than threshold
        if(pdiff.mag() < transform2D.targetSizePixels.y/10) {
          stroke(255, 200, 100, i * 255.0/posArray.size());
          vertex(p2.x, p2.y);
        } else {
          endShape();
          beginShape();
        }
        p1.set(p2);
      }
      endShape();
      popStyle();
    }
  };


  //----------------------------------
  class Scene3 extends TSSceneBase {
    // create triggers and other init in constructor
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

