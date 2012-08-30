class MSAAudioPlayer {
  AudioPlayer audioPlayer;
  
  MSAAudioPlayer(String s) {
//    loadFile(s);
    audioPlayer = minim.loadFile(s);
  }
  
//  void loadFile(String s) {
//    audioPlayer = minim.loadFile(s);
//  }

  void setGain( float volume) {
    float kAudioMax = -13.9794;
    float kAudioMin = -80.0;
    volume = constrain(volume, 0, 1);
    volume = 1 - volume;
    volume *= volume * volume * volume * volume * volume;
    volume = 1 - volume;
    audioPlayer.setGain(map(volume, 0, 1, kAudioMin, kAudioMax));
  }
  
  void play() {
    audioPlayer.play();
  }
  
  void loop() {
    audioPlayer.loop();
  }
  
  void play(float f) {
    audioPlayer.play((int)(f * 1000));
  }
  
  void pause() {
    audioPlayer.pause();
  }
  
  boolean isPlaying() {
    return audioPlayer.isPlaying();
  }
  
  void close() {
    audioPlayer.close();
  }
}

