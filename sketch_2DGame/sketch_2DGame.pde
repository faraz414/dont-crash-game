int highScore = 0; // this is a variable for storing all-time best score
int score = 0; // this keeps track of the player's current score in the game
int lives = 9; // when the game starts player has 9 lives
int maxAllowedObstacles = 20; // this is for the maximux number of the obstacles on the screen 
boolean GameOver = false; //this is to check if the game is over
PFont gameFont; // this is the font for Game Over text

Player player;
ArrayList<Obstacle> obstacles; //this is a list to store all obstacle on the screen.
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

PImage[] asteroidImages; // this is an Array for different animation franmes for the obstacles.
PImage spaceBackground; //this is the image i used as the backgournd of the game.
PImage rocket;// this is the image used for the player.

void setup() {
  size(800, 800); // this is for setting the game's screen size
  gameFont = createFont("Arial", 32, true); //  this Load's the font
  textFont(gameFont); // Set font
  highScore = loadHighScore(); // Load the high score at the start
  
  // Load animation frames for obstacles
  asteroidImages = new PImage[4]; // this line of code is loading 4 images for animating the obstacles.
  asteroidImages[0] = loadImage("obstacle1.png");
  asteroidImages[1] = loadImage("obstacle2.png");
  asteroidImages[2] = loadImage("obstacle3.png");
  asteroidImages[3] = loadImage("obstacle4.png");
  

  spaceBackground = loadImage("space1.png"); // this is the Background image
  rocket = loadImage("rocket.png"); // this loads a rocket image for the player.
  
  player = new Player(width / 2, height / 2, 50); // this is for the player to be in centre
  obstacles = new ArrayList<Obstacle>(); // Initialize obstacle list
  
  // this part of the code add obstacles with random positions and speeds
  for (int i = 0; i < 5; i++) {
    if (random(1) > 0.5) {
      obstacles.add(new Obstacle(random(width), random(height), random(2, 5), random(2, 5), asteroidImages));
    } else {
      obstacles.add(new WaveObstacle(random(width), random(height), random(2, 5), random(2, 5), asteroidImages));
    }
  }
}

int obstacleSpawnTimer = 0; // Timer to control obstacle spawning

void draw() {
  background(0); // Black background
  image(spaceBackground, 0, 0, width, height); 
  
  if (!GameOver) {
    score += 1; // this is for adjusting the value to control score increase rate
  }
  
  if (GameOver) {
    background(0); // for adding black background
    fill(255, 0, 0); 
    textAlign(CENTER, CENTER);
    text("GAME OVER", width / 2, height / 2); // Display Game Over message

    // this checks if the current score is a new high score
    if (score > highScore) {
      highScore = score; // this updates the high score
      saveHighScore(highScore); // this saves the new high score to the file
    }

    // Display the high score and the player's score
    fill(255); // White text
    text("High Score: " + highScore, width / 2, height / 2 + 40); // this will show the high score
    text("Your Score: " + score, width / 2, height / 2 + 80); // this displays the current score

    noLoop(); // Stop the draw loop
    return; // Exit the function
  }

  // Draw and update obstacles (polymorphic behavior here)
  for (Obstacle obstacle : obstacles) {
    obstacle.moveObstacle(); // Calls the correct update method depending on the type (Obstacle or WaveObstacle)
    obstacle.drawObstacle(); // Same for render method
  }
  
  // this part of the code render the explosions and remove the finished ones
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion explosion = explosions.get(i);
    explosion.render();
    if (explosion.isFinished()) {
      explosions.remove(i); // this reemoves explosion when they are finished
    }
  }
  
  player.displayPlayer(); // Draw the player
  checkCollisions(); // this is for checking the collision.
  displayLives(); // Show remaining lives
  
  // thsi part of the code adds new obstacles every 0.5 seconds, up to the maxObstacles limit
  if (frameCount % 30 == 0 & obstacles.size() < maxAllowedObstacles) {
    if (random(1) > 0.5) {
      // this will add a normal bouncing obstacle with animation
      obstacles.add(new Obstacle(random(width), random(height), random(2, 5), random(2, 5), asteroidImages));
    } else {
      // but this will add a wavy obstacle with animation
      obstacles.add(new WaveObstacle(random(width), random(height), random(2, 5), random(2, 5), asteroidImages));
    }
  }
}

void keyPressed() {
  // Inverted controls: this move obstacles instead of the player
  if (keyCode == UP) { 
    for (Obstacle obstacle : obstacles) {
      obstacle.yPosition += 20; // this Moves the obstacle down
      obstacle.bounceAround(); // this makes sure it stays on screen
    }
    player.changeDirection('U'); //this changes the player's direction to up
  } else if (keyCode == DOWN) {
    for (Obstacle obstacle : obstacles) {
      obstacle.yPosition -= 20; // this moves the obstacles up
      obstacle.bounceAround(); // make sure it stays on the screen
    }
    player.changeDirection('D'); //this Changes the player's direction to down
  } else if (keyCode == LEFT) {
    for (Obstacle obstacle : obstacles) {
      obstacle.xPosition += 20; // Moves the obstacles to the right
      obstacle.bounceAround(); //this is for makig sure obstacles stay in teh screen boundry
    }
    player.changeDirection('L'); // Changes the player's direction to left
  } else if (keyCode == RIGHT) {
    for (Obstacle obstacle : obstacles) {
      obstacle.xPosition -= 20; // this will move obstacles to the left
      obstacle.bounceAround(); // for making sure obstacles stays on screen
    }
    player.changeDirection('R'); // for changing the player's direction to right
  }
}

void checkCollisions() {
  for (int i = 0; i < obstacles.size(); i++) {
    Obstacle obstacle = obstacles.get(i);
    
    // Check if a collision occurs using the Player's collision method
    if (player.checkCollisionWithObstacle(obstacle)) {
      lives--; // this will reduce a life when player collides.
      explosions.add(new Explosion(obstacle.xPosition, obstacle.yPosition)); // Add explosion at collision point
      obstacles.remove(i);// this will remove the collided obstacle from the list
      obstacle.xPosition = random(width); // this resets the obstacle position
      obstacle.yPosition = random(height);
      
      if (lives <= 0) {
        GameOver = true; // game will end when player loses all it's lives
      }
      break; // Exit the loop after processing one collision
    }
  }
}

void displayLives() {
  fill(255); //this set the txt colour white color
  textSize(20); // this sent the font size to 20
  text("Lives: " + lives, 10, 30); // this will display lives at the top left corner
  text("Score: " + score, 10, 50); // this shows the score at the top left corner
}

int loadHighScore() {
  String[] highScore;
  try {
    highScore = loadStrings("highScore.txt"); // Try to load the file with the high score
    return int(highScore[0]); // this will return the high score as an integer
  } catch (Exception e) {
    return 0; // if an error happen then it will return 0
  }
}

void saveHighScore(int score) {
  String[] highScore = {str(score)}; // this converts the score to a String and store it in an array
  saveStrings("highScore.txt", highScore); // this saves the hightscore to a file named hightscore.txt
}
