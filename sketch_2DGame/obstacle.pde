class Obstacle {
  float xPosition, yPosition; // Position
  float speedX, speedY; // Speed in x and y directions
  float size = 50; // Size of the obstacle
  PImage[] obstacleImages; // Array to hold the sequence of images
  int currentFrame = 0; // index for the current frame in animation
  int frameDelay = 5; // this si for controling the animation speed
  int frameTimer = 0; // Counter to track timing for frame updates

  // Constructor accepts image sequence as an array
  Obstacle(float x, float y, float speedX, float speedY, PImage[] imgs) {
    this.xPosition = x;
    this.yPosition = y;
    this.speedX = speedX;
    this.speedY = speedY;
    this.obstacleImages = imgs;
  }

  // Render the obstacle
  void drawObstacle() {
    if (obstacleImages != null && obstacleImages.length > 0) {
      // this display the current frame of animation
      image(obstacleImages[currentFrame], xPosition - size / 2, yPosition - size / 2, size, size);
    } else {
      // Fallback to a green ellipse if no images are loaded
      fill(0, 255, 0);
      ellipse(xPosition, yPosition, size, size);
    }
  }

  // Update the obstacle's position and handle animation
  void moveObstacle() {
    xPosition += speedX; // Move horizontally
    yPosition += speedY; // Move vertically

    yPosition += sin(frameCount * 0.1) * 2; // Wavy movement on the y-axis

    // Bounce back when hitting screen edges
    if (xPosition < 0 || xPosition > width) {
      speedX *= -1; // this reverse horizontal direction when hitting screen edges
    }
    if (yPosition < 0 || yPosition > height) {
      speedY *= -1; // Reverse vertical direction when hitting screen edges.
    }

    // Animate the obstacle by updating frames
    frameTimer++;
    if (frameTimer >= frameDelay) {
      currentFrame = (currentFrame + 1) % obstacleImages.length; // Loop through frames
      frameTimer = 0; // Reset the counter
    }
  }

  // makes sure obstacle wraps around the screen
  void bounceAround() {
    if (xPosition < 0) xPosition = width;
    if (xPosition > width) xPosition = 0;
    if (yPosition < 0) yPosition = height;
    if (yPosition > height) yPosition = 0;
  }
}
