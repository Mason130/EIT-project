/*
A simple TPS game
*/
import processing.serial.*;
Serial myPort;
float gunX; //initial position of gun
float bulletX, bulletY; //initial position of bullet

float enemyX, enemyY; //initial position of enemy
int enemyLives; // enemy's life count
int initLives;

boolean moveDown = true, moveUp = false; //enemy starts moving down, bullet starts not moving

boolean bullet = true;
boolean bang = false; //if bullet hits enemy
boolean shot = false; //check whether bullet is shot

int scoreE = 0; // score of E
int scoreP = 0; // score of player 

PFont font; //scoreboard font
PImage enemy;
PImage gun, gun2, gun3;
PImage fire;
int gunSelection;
int gunPower;
float moveSpeed;

boolean gameOver = false; // To track if the game is over
int playerLives = 6; // Player's life count

void setup() {
  size(950, 650);  //board size
  background(255);
  font = loadFont("DINCondensed-Bold-48.vlw"); //add font

  enemy = loadImage("alien.png");;
  gun = loadImage("fighter1.png");
  gun2 = loadImage("fighter2.png");
  gun3 = loadImage("fighter3.png");
  fire = loadImage("fire.png");
  enemyLives = 6;
  initLives = enemyLives;
  
  gunSelection = 2;   // select different fighters
  // Initialize positions based on screen size
  gunX = width * 0.35;
  bulletY = height * 0.9;

  enemyX = width * 0.35;
  enemyY = height * 0.1;
  
  String portName = Serial.list()[2];  // first port from the list. Make sure to have the right serial port
  myPort = new Serial(this, portName, 115200);  // opening the serial port
}

void draw() {
  if (!gameOver) {
    background(255);
    
    if(gunSelection == 1){
      image(gun, gunX, 570, 111, 81); //gun
      bulletX = gunX + 55;
      moveSpeed = 11;
      gunPower = 2;
    } else if(gunSelection == 2) {
      image(gun2, gunX, 585, 102, 63); //gun2
      bulletX = gunX + 50;
      moveSpeed = 19;
      gunPower = 1;
    } else {
      image(gun3, gunX, 555, 140, 92); //gun3
      bulletX = gunX + 67;
      moveSpeed = 6;
      gunPower = 6;
    }
    
    fill(0, 0, 255); //blue
    rect(bulletX, bulletY, 1, 45); // bullet hidden in gun
    
    /*
    Controlled by controller
    */
    if (myPort.available() > 0) {
      String data = myPort.readStringUntil('\n');
      if (data != null) {
        data = data.trim(); // Remove any whitespace
        String[] parts = split(data, ','); // Split the data by comma
        float yAccel = ((int)(float(parts[1])));
        float dx = -yAccel/10.0;
        //float yAccel = float(parts[1])/1023.0;
        //println(yAccel);
        if (gunX + dx >width - width * 0.116){
          gunX = width - width * 0.116;
        }else if( gunX + dx <= 0){
          gunX = 0;
        }
        
        if(gunSelection == 1) gunX += dx;
        else if(gunSelection == 2) gunX += 2 * dx;
        else gunX += 0.5 * dx;
        
        float force = float(parts[2]);
        if (force > 500)
          shot = true;
         else
           shot = false;
      }
    }
    
    // Control gun movement within screen bounds
    if (keyPressed && key == CODED) {
      if (keyCode == LEFT && gunX > -30) {
        gunX -= moveSpeed;
      } else if (keyCode == RIGHT && gunX < width - width * 0.1) {
        gunX += moveSpeed;
      }
    }
  
    enemyY += height * 0.005;  //enemy speed
  
    if(enemyY <= 650) {
      moveDown = true;
    }
    if (enemyY > height * 0.9) {
      enemyY = 0;
      enemyX = random(30, width - 30);
      scoreE++;
      playerLives--; // Decrement life when an enemy is missed
      if (playerLives <= 0) {
        gameOver = true; // Game over when no lives left
      }
    }
  
    if(keyPressed && key == ' ') { //press space to shoot
      moveUp = true; // player shoots bullet
    }
    
    if (shot) {
    moveUp = true;
  }
  
    if (moveUp) {
      bulletY -= height * 0.1;
    }

    if (bulletY < 10) {
      bulletY = height * 0.94;
      moveUp = false;
    }

    if ((enemyY - 40 < bulletY && bulletY < enemyY + 50) && (enemyX - 20 < bulletX && bulletX < enemyX + 95)) {
      enemyLives -= gunPower;
      image(fire, bulletX - 50,  bulletY + 20, 621 * 0.15, 616 * 0.13);
      bulletY = 0;
    }

    if (enemyLives == 0) {
      enemyLives = initLives;
      enemyY = 0;
      enemyX = random(30, width-30);
      moveDown = true;
      scoreP++; // Increment score when an enemy is hit
    }
    textFont(font);
    fill(0);
    textSize(35);
    text("Player Lives: " + playerLives, width * 0.1, height * 0.08);
    text("Score: " + scoreP, width * 0.75, height * 0.08);
    image(enemy, enemyX, enemyY, 100, 62); //enemy
    fill(0,128,0);
    textSize(25);
    text(enemyLives + "/" +initLives, enemyX+40, enemyY-10);
  } else {
    // Game Over
    background(0);
    textSize(65);
    fill(255, 0, 0);
    text("GAME OVER", width * 0.4, height * 0.5);
    textSize(40);
    text("Final Score: " + scoreP, width * 0.45, height * 0.6);
  }
}
