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
    addScene(new Scene12());
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }


  //----------------------------------
  // SCENES:
  //----------------------------------
  class Scene1 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene1() {
      sceneName = "Scene1";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      fill(255, 0, 0);
      ellipse(50, 200, 300, 200);
    }
  };


  //----------------------------------
  class Scene2 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene2() {
      sceneName = "Scene2";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 255, 0);
      ellipse(250, 200, 300, 200);
    }
  };


  //----------------------------------
  class Scene3 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene3() {
      sceneName = "Scene3";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene4 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene4() {
      sceneName = "Scene4";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene5 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene5() {
      sceneName = "Scene5";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene6 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene6() {
      sceneName = "Scene6";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene7 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene7() {
      sceneName = "Scene7";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene8 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene8() {
      sceneName = "Scene8";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene9 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene9() {
      sceneName = "Scene9";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene10 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene10() {
      sceneName = "Scene10";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene11 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene11() {
      sceneName = "Scene11";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };

  //----------------------------------
  class Scene12 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene12() {
      sceneName = "Scene12";
      println(storyName + "::" + sceneName);
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };
}

