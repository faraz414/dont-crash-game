class Explosion {
  float xPosition, yPosition; // this is teh position of the explosion
  int frames; // this is the number of frames the explosion will last
  int maxFrames = 30; //this is the maximum duration of the explosion
  
  Explosion(float x, float y) {
    this.xPosition = x;
    this.yPosition = y;
    this.frames = 0;
  }
  
  void render() {
    if (frames < maxFrames) {
      float size = frames * 8; // Explosion grows with time
      fill(255, 150, 0, 255 - frames * 8); // this is for orange fading effect
      noStroke();
      ellipse(xPosition, yPosition, size, size);//draw th explosion
      frames++;
    }
  }
  
  boolean isFinished() {
    return frames >= maxFrames; // Explosion is finished after maxFrames
  }
}
