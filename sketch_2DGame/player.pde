class Player {
  int xPosition, yPosition; // this is the Position
  color playerColor = color(255, 0, 0); // Initial player color (Red)
  float playerSize; // the is the Player's size (for scaling the rocket)
  
  // these are directional images for the player
  PImage rocketUp, rocketDown, rocketLeft, rocketRight;
  PImage currentImage; // To hold the current image to display

  Player(int startX, int startY, float startSize) {
    this.xPosition = startX;
    this.yPosition = startY;
    this.playerSize = startSize; // Set the player's size

    // this load the image for each direction.
    rocketUp = loadImage("rocketUp.png");
    rocketDown = loadImage("rocketDown.png");
    rocketLeft = loadImage("rocketLeft.png");
    rocketRight = loadImage("rocketRight.png");

    // Default image: this will set the initial rocket image to be facing up
    currentImage = rocketUp;
  }
  
  void displayPlayer() {
    // Get the largest dimension (width or height) for consistent scaling
    float maxDimension = max(currentImage.width, currentImage.height);
    
    // Calculate the scale factor based on the maximum dimension
    float scaleFactor = playerSize / maxDimension;
    
    // Draw the scaled image at the player's position
    image(currentImage, xPosition - currentImage.width * scaleFactor / 2, yPosition - currentImage.height * scaleFactor / 2, currentImage.width * scaleFactor, currentImage.height * scaleFactor);
  }

  // Check for collision with obstacles
  boolean checkCollisionWithObstacle(Obstacle obstacle) {
    float distX = this.xPosition - obstacle.xPosition;
    float distY = this.yPosition - obstacle.yPosition;
    float distance = sqrt(distX * distX + distY * distY);
    return distance < (rocket.width / 2 + obstacle.size / 2); // Adjust collision check with image size
  }
  // Change the direction of the player based on the key pressed
  void changeDirection(char direction) {
    switch (direction) {
      case 'U': 
        currentImage = rocketUp;
        break;
      case 'D': 
        currentImage = rocketDown;
        break;
      case 'L': 
        currentImage = rocketLeft;
        break;
      case 'R': 
        currentImage = rocketRight;
        break;
    }
  }
}
