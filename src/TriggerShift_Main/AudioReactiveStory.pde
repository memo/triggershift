
class AudioReactiveStory extends TSStoryBase {

  AudioReactiveStory() {
    storyName = "AudioReactiveStory";
    println(storyName + "::" + storyName);
    addScene(new Scene1());
  }

  //------------------------------------------------------------------------------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }

  //------------------------------------------------------------------------------------------------------
  // SCENES:
  //------------------------------------------------------------------------------------------------------
  class Scene1 extends TSSceneBase {
    AudioInput audioIn = minim.getLineIn(Minim.STEREO, 512);
    float volume = 0;
    float maxVolume = 0;

    Scene1() {
      sceneName = "Scene1";
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
      pushStyle();
      pushMatrix();
      scale(width * 1.0/(audioIn.bufferSize()), height/200.0);
      stroke(0, 200, 255);
      for (int i = 0; i < audioIn.bufferSize() - 1; i++) {
        line(i, 50 + audioIn.left.get(i)*50, i+1, 50 + audioIn.left.get(i+1)*50);
        line(i, 150 + audioIn.right.get(i)*50, i+1, 150 + audioIn.right.get(i+1)*50);
        float v = (abs(audioIn.left.get(i)) + abs(audioIn.right.get(i)))/2;
        if(v > volume) volume = v;
      }
      popMatrix();
      
      if(volume > maxVolume) maxVolume = volume;
      volume *= 0.9;
      
      noStroke();
      fill(0, 255, 0, 50);
      rect(width/2-units(50), height - height * volume, units(100), height * volume);
      
      fill(255, 0, 0, 255);
      rect(0, height - height * maxVolume, width, units(20));
      popStyle();
    };
  }
};

