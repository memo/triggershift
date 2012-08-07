
// interface for a Scene
// A Scene is a single unit of a story, it has a way of displaying itself, and an interaction

interface TSIScene {
  
  void start();
  
  void draw(PImage userImage, TSSkeleton skeleton);

};
