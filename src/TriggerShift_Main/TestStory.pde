
// A TEST STORY

class TestStory extends TSStoryBase {

  TestStory() {
    println("TestStory::TestStory");
    addScene(new Scene1());
    addScene(new Scene2());
  }


  //----------------------------------
  // SCENES:
  //----------------------------------
  class Scene1 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene1() {
      println("TestStory::Scene1");
      setTrigger(new MouseAreaTrigger(0, 0, 250, 250, false));
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println("TestStory::Scene1::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println("TestStory::Scene1::onDraw");
      fill(255, 0, 0);
      ellipse(50, 200, 300, 200);
    }
  };


  //----------------------------------
  class Scene2 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene2() {
      println("TestStory::Scene2");
      setTrigger(new MouseAreaTrigger(0, 0, 250, 250, false));
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println("TestStory::Scene2::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println("TestStory::Scene2::onDraw");
      fill(0, 255, 0);
      ellipse(250, 200, 300, 200);
    }
  };
};

