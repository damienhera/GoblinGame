//all image assests are from the respective owners from CraftPixel and under license can be used for "any number of personal and commercial projects for yourself or a client."
//Controls are W A S D - left click to use slash (Must be in contact with enemy obj to damage) and right click to use explosion(works from any range)
//Objectives of the game is to defend the base that the enemies attack
//if you attack an enemy, they will then target you intsead of the base unti you fall outside of their range(can change range if needed)
//if the base looses all of its hp you loose. Also if you as the player looses your hp you will also loose.

enum GameMode
{
  MENU, RUNNING, END
}

GameMode game;
Wave w;
Base base;
Goblin en;
Ogre en2;
Player pl;



int score = 0, highScore;//score variables
int x = 480, y = 320;//button x,y variables
final int bHeight = 80, bWidth = 240 , gap = 20;//constant button variables that define the height, width and gap between each button
PImage bg, menu, endScreen, tree;//to store the background
boolean menuCheck, endScreenCheck;//checks to see if the menu or endscreen is open
String path = "score.txt";

//remove the can attack variable

void setup()
{
  size(1200, 780);
  imageMode(CENTER);
/////Load in images
  //HealthBar images
  PImage[] healthBar = new PImage[2];
  PImage[] baseHealthBar = new PImage[2];
  //Player images
  PImage[] playerIdleAnim = new PImage[18];
  PImage[] playerRunAnim = new PImage[12];
  PImage[] playerSlashAnim = new PImage[12];
  PImage[] playerRunSlashAnim = new PImage[12];
  PImage[] playerDyingAnim = new PImage[15];
  PImage[] playerHurtAnim = new PImage[12];
  //Explosion image
  PImage[] explosionAnim = new PImage[10];
  //base image
  PImage[] baseAnim = new PImage[3];
  
  PImage[][] anims = {baseAnim, healthBar, baseHealthBar, explosionAnim, 
                      playerIdleAnim, playerRunAnim, playerSlashAnim, playerRunSlashAnim, 
                      playerDyingAnim, playerHurtAnim};//holds a list of the PIMage arrays in one place
  

  String[] animName = { "base", "HealthBar", "bHealthBar", "Explosion", 
                        "PlayerIdle", "PlayerRunning", "PlayerSlashing", "PlayerRunSlashing", 
                        "PlayerDying", "PlayerHurt" };//the animation name used for each png so its easier to load in
  
  ///By splitting into animation and animation name im able to just use two for loops to load in the releavent animaitons instead of using individual forloops for every animation type
  
  for (int i = 0; i < animName.length; i++) {//loops through the different names
    for (int j = 0; j < anims[i].length; j++) {//loops through the different PImage lists
      anims[i][j] = loadImage(animName[i] + "_" + j + ".png");//assign images to array
    }
  }
  

    
  //background
  bg = loadImage("background.png");//background image
  
  //menu
  menu = loadImage("menu.png");//menu png
  //endScreen
  endScreen = loadImage("endScreen.png");//endscreen png
  
  tree = loadImage("trees.png");
  
/////////////////////////////////////////////////
  w = new Wave();//starts wave
  base = new Base(baseAnim,baseHealthBar,tree); //creates new base for player to protect
  pl = new Player(1000,500, playerIdleAnim,playerRunAnim,playerSlashAnim, playerRunSlashAnim, playerDyingAnim, playerHurtAnim, explosionAnim,healthBar);//loads in player 

  ///Menu
   game = GameMode.MENU;//sets to menu
  //load highScore
  loadScore();//loads in the highscore

}


void draw()
{
  switch(game)//switches through the game modes depending on the variable game
  {
    case MENU:
    menu();//loads menu
    break;
    
    case RUNNING:
    game();//runs the game
    break;
    
    case END:
    endMenu();//end screen when game ends
    break;
  }
}



void menu() {
  endScreenCheck = false;//stops collition for end screen menu
  menuCheck = true;// allows the menu button collition
  background(menu); // sets background to menu image
  button(x,y,"Play");//play button
  button(x,y+bHeight+gap,"Quit");//quit button
  score = 0;//resets the score
  textSize(25);
  fill(255,255,255);
  text("HighScore: "+highScore,20,50);//highScore button


}

void game() {
  // draw the game here
  if(!pl.isDead && !base.isDead)
  {
    menuCheck = false;//disables menu
    background(bg);
    base.render();
    w.run(pl,base);//takes in player and base as parameter
    w.spawnCount(25,10);//spawns in set amount of enemies
    w.removeDeadEnemies();//removes any dead enemies
    pl.render(w.enemyG, w.enemyO);//renders player
    base.displayHealth();//displays health of base
    fill(255, 255, 255);
    textSize(32);
    text("Score: " + score,20,50);//displayes the current score
  }
  else
  {
    pl.reset();//reset player values
    w.wipeEnemies();//reset the wave
    base.reset();//reset the base
    game = GameMode.END;
  }
}

void endMenu() {
  // draw the end screen here
  endScreenCheck = true;
  background(endScreen);
  
  //output score and say that the game is over
  textSize(100);
  fill(255,255,255);
  text("Game Over",x-120,y-100);
  textSize(50);
  text("Score: " + score,x,y-50);
  button(x,y,"Menu");
  
  //store if highscore
  if(score>highScore)
  {
    highScore = score;
    saveScore();
  }
  
}


void button(int x, int y, String text)//create button
{
  fill(168, 153, 104);
  rect(x, y, bWidth, bHeight);
  fill(0, 0, 0);
  textSize(56);
  text(text, x+bWidth/4, y+60);
}


void loadScore() 
{
   BufferedReader file = createReader(path);//loads file path
   String line = null;//sets string to null
   try//try to read file
   {//reads the first line
     line = file.readLine(); 
     file.close();
   }
   catch(IOException x){ print(x);}//throw error if failed
   
   //convert to int
   try{highScore = Integer.parseInt(line);}//try to parse as int
   catch(NumberFormatException x){print(x);}//throw format error
}


void saveScore()//save score
{
  PrintWriter file = createWriter(path);//loads filepath
  file.println(highScore);//writes highscore to file
  file.flush();//writes it
  file.close();//close file 
}
