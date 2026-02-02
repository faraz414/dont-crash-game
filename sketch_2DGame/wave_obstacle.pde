class WaveObstacle extends Obstacle {
  float waveAngle = 0; // this is the angle for wave movement
  float waveHeight = 50; // Height of the sine wave motion

  WaveObstacle(float x, float y, float speedX, float speedY, PImage[] imgs) {
    super(x, y, speedX * 0.5, speedY * 0.3, imgs); // inherit behaviour from Obstacle
  }

  @Override
  void moveObstacle() {
    xPosition += speedX; // Horizontal movement
    yPosition += sin(waveAngle) * waveHeight * 0.2; // this is for wave like vertical movement
    waveAngle += 0.02; // this slows the wave down

    // Wrap-around at screen edges
    if (xPosition < 0) xPosition = width;
    if (xPosition > width) yPosition = 0;
    if (yPosition < 0) yPosition = height;
    if (yPosition > height) yPosition = 0;

    // Animate the obstacle
    frameTimer++;
    if (frameTimer % frameDelay == 0) {
      currentFrame = (currentFrame + 1) % obstacleImages.length;
    }
  }
}
