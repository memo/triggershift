class MSAAudioPlayer {
  AudioPlayer []player;
  int currentIndex = 0;
  
  MSAAudioPlayer(String s, int count) {
    player = new AudioPlayer[count];
    for(int i=0; i<count; i++) {
      player[i] = minim.loadFile(s);
    }
  }
  
  void play() {
    player[currentIndex].play(0);
    currentIndex = (currentIndex + 1) % player.length;
  }
  
  void play(AudioEffect effect) {
    player[currentIndex].addEffect(effect);
    play();
  }

  
  void close() {
    for(int i=0; i<player.length; i++) {
      player[i].close();
    }
  }
};
