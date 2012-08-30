class MSAAudioPlayers {
  MSAAudioPlayer []player;
  int currentIndex = 0;
  
  MSAAudioPlayers(String s, int count) {
    player = new MSAAudioPlayer[count];
    for(int i=0; i<count; i++) {
      player[i] = new MSAAudioPlayer(s);
    }
  }
  
  void play() {
    player[currentIndex].play(0);
    currentIndex = (currentIndex + 1) % player.length;
  }
//  
//  void play(AudioEffect effect) {
//    player[currentIndex].addEffect(effect);
//    play();
//  }

  void setGain(float volume) {
    player[currentIndex].setGain(volume);
  }
  
  void close() {
    for(int i=0; i<player.length; i++) {
      player[i].close();
    }
  }
};
