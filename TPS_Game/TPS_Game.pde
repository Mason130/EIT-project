/*
A simple TPS game
*/

float gunX = 350; //initial position of gun
float bulletX = 355, bulletY = 940; //initial position of bullet

float enemyX = 350, enemyY = 0; //initial position of enemy

boolean moveDown = true, moveUp = false; //enemy starts moving down, bullet starts not moving

boolean bullet = true;
boolean bang = false; //if bullet hits enemy

int scoreE = 0; // score of E
int scoreP = 0; // score of player 

PFont font; //scoreboard font
PImage enemy;
PImage gun;
PImage fire;

void setup() {
  size(1000, 1000);  //board size
  background(255);
  font = loadFont("DINCondensed-Bold-48.vlw"); //add font
  
  enemy = loadImage("enemy.png");;
  gun = loadImage("gun.png");
  fire = loadImage("fire.png");
}

void draw() {
  background(255);
  textFont(font);
  
  if(keyPressed && key == CODED && keyCode == LEFT && gunX > -77) {
    gunX -= 25;
  }
  if(keyPressed && key == CODED && keyCode == RIGHT && gunX < 900) {
    gunX += 25;
  }
  
  if(moveDown == true) {
    enemyY += 6;  //enemy speed
  }
  
  if(enemyY <= 650) {
    moveDown = true;
  }
  if(enemyY > 650) {
    enemyY = 0;
    enemyX = random(30, 670); //randomly generate enemies
    moveDown = true;
    scoreE++; //// enemies get one pointenemies get one point
  }
  
  if(keyPressed && key == ' ') { //press space to shoot
    moveUp = true; // player shoots bullet
  }
  
  if(moveUp) {
    bulletY -= 100;
  }
  
  if(bulletY < 10) {
    bulletY = 940;
    moveUp = false;
  }
  
  if(enemyY-50 < bulletY && bulletY < enemyY+50 && enemyX-20 < bulletX && bulletX < enemyX+95) { // bullet kill an enemy
    bang = true;
  }
  
  if(bang) {
    image(fire, gunX+50, 300, 112, 112);
    enemyY -= 60;
  }
  if(bang && enemyY < 10) {
    enemyY = 0;
    enemyX = random(30, 670); //randomly generate enemies
    bang = false; 
    moveDown = true;
    scoreP++; // player get one point
    bulletY = 0;
  }
  
  fill(0); //black
  textSize(30); 
  text("Press Left/Right to move, Space to fire", 330, 35);
  
  fill(0, 255, 0);  //green
  image(enemy, enemyX, enemyY, 100, 100); //enemy
  textSize(56);
  text("Enemies:", 50, 50);
  text(scoreE, 220, 50);
  
  fill(255, 0, 0);  //red
  image(gun, gunX, 830, 116, 179); //enemy
  textSize(56);
  text("Player:", 750, 50);
  text(scoreP, 890, 50);
  
  bulletX = gunX + 95;
  fill(0, 0, 255); //blue
  rect(bulletX, bulletY, 5, 25); // bullet hidden in gun
}
