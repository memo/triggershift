class JamelStory extends TSStoryBase {

  JamelStory() {
    storyName = "JamelStory";
    println(storyName + "::" + storyName);
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }
}
