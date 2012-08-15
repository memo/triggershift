
// A TEST STORY

class StoryTest extends TSStoryBase {

  StoryTest() {
    storyName = "StoryTest";
    println(storyName + "::" + storyName);
    addScene(new Scene1());
    addScene(new Scene2());
    addScene(new Scene3());
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
      println(storyName + "::Scene1");
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::Scene1::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene1::onDraw");
      fill(255, 0, 0);
      ellipse(50, 200, 300, 200);
    }
  };


  //----------------------------------
  class Scene2 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene2() {
      println(storyName + "::Scene2");
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::Scene2::onStart");
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
      println(storyName + "::Scene3");
      setTrigger(new MouseClickTrigger());
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println(storyName + "::Scene3::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println(storyName + "::Scene2::onDraw");
      fill(0, 0, 255);
      ellipse(450, 200, 300, 200);
    }
  };
};

