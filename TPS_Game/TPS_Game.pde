// Global variables
float gunX; // initial position of gun
float bulletX, bulletY; // initial position of bullet

float enemyX, enemyY; // initial position of enemy

boolean moveDown = true, moveUp = false; // enemy starts moving down, bullet starts not moving

boolean bullet = true;
boolean bang = false; // if bullet hits enemy

int scoreE = 0; // score of Enemies
int scoreP = 0; // score of Player
int playerLives = 3; // Player's life count

PFont font; // scoreboard font
PImage enemy;
PImage gun;
PImage fire;

boolean gameOver = false; // To track if the game is over

void setup() {
  fullScreen(); // Set the size of the canvas
  background(255);
  font = loadFont("DINCondensed-Bold-48.vlw"); // add font

  enemy = loadImage("enemy.png");
  gun = loadImage("gun.png");
  fire = loadImage("fire.png");

  // Initialize positions based on screen size
  gunX = width * 0.35;
  bulletX = gunX + width * 0.095;
  bulletY = height * 0.9;

  enemyX = width * 0.35;
  enemyY = height * 0.1;
}

void draw() {
  if (!gameOver) {
    background(255);
    textFont(font);

    // Control gun movement within screen bounds
    if (keyPressed && key == CODED) {
      if (keyCode == LEFT && gunX > 0) {
        gunX -= 25;
      } else if (keyCode == RIGHT && gunX < width - width * 0.116) {
        gunX += 25;
      }
    }

    // Update positions
    enemyY += height * 0.006;

    if (enemyY > height * 0.9) {
      enemyY = 0;
      enemyX = random(30, width - 30);
      scoreE++;
      playerLives--; // Decrement life when an enemy is missed
      if (playerLives <= 0) {
        gameOver = true; // Game over when no lives left
      }
    }

    if (keyPressed && key == ' ') {
      moveUp = true;
    }

    if (moveUp) {
      bulletY -= height * 0.1;
    }

    if (bulletY < 10) {
      bulletY = height * 0.94;
      moveUp = false;
    }

    if (enemyY - 50 < bulletY && bulletY < enemyY + 50 && enemyX - 20 < bulletX && bulletX < enemyX + 95) {
      bang = true;
    }

    if (bang) {
      image(fire, gunX + width * 0.05, height * 0.5, width * 0.112, height * 0.186);
      enemyY -= height * 0.06;
    }

    if (bang && enemyY < 10) {
      enemyY = 0;
      enemyX = random(30, width - 30);
      bang = false;
      moveDown = true;
      scoreP++; // Increment score when an enemy is hit
      bulletY = 0;
    }

    // Display elements
    textSize(30);
    text("Press Left/Right to move, Space to fire", width * 0.33, height * 0.058);

    image(enemy, enemyX, enemyY, width * 0.1, height * 0.1);
    textSize(56);
    text("Enemies: " + scoreE, width * 0.05, height * 0.083);
    text("Player: " + scoreP + " Lives: " + playerLives, width * 0.75, height * 0.083);

    image(gun, gunX, height * 0.83, width * 0.116, height * 0.298);
    textSize(56);

    bulletX = gunX + width * 0.095;
    fill(0, 0, 255); // blue
    rect(bulletX, bulletY, 5, 25); // bullet hidden in gun
  } else {
    // Game Over Screen
    background(0);
    textSize(72);
    fill(255, 0, 0);
    text("GAME OVER", width * 0.4, height * 0.5);
    textSize(48);
    text("Final Score: " + scoreP, width * 0.45, height * 0.6);
  }
}
