class Wave
{

   Goblin gob;
   Ogre og;
   
   ArrayList<Goblin> enemyG;
   ArrayList<Ogre> enemyO;
   
   //recode all of this saturday and sunday
   
  //HealthBar 
  PImage[] healthBar = new PImage[2];
    //Goblin
  PImage[] goblinIdleAnim = new PImage[18];
  PImage[] goblinRunAnim = new PImage[12];
  PImage[] goblinSlashAnim = new PImage[12];
  PImage[] goblinRunSlashAnim = new PImage[12];
  PImage[] goblinDyingAnim = new PImage[15];
  PImage[] goblinHurtAnim = new PImage[12];
  //Orc
  PImage[] ogreIdleAnim = new PImage[18];
  PImage[] ogreRunAnim = new PImage[12];
  PImage[] ogreSlashAnim = new PImage[12];
  PImage[] ogreRunSlashAnim = new PImage[12];
  PImage[] ogreDyingAnim = new PImage[15];
  PImage[] ogreHurtAnim = new PImage[12];
   

  Wave()
  {
    PImage[][] anims = {goblinIdleAnim,goblinRunAnim, goblinSlashAnim, goblinRunSlashAnim, goblinDyingAnim, goblinHurtAnim, 
                        ogreIdleAnim, ogreRunAnim, ogreSlashAnim, ogreRunSlashAnim, ogreDyingAnim, ogreHurtAnim, healthBar};//holds an array of the PIMage arrays in one place
    String[] animName = { "GoblinIdle", "GoblinRunning", "GoblinSlashing", 
                        "GoblinRunSlashing", "GoblinDying", "GoblinHurt", "OgreIdle", "OgreRunning", 
                        "OgreSlashing", "OgreRunSlashing", "OgreDying", "OgreHurt","HealthBar"};//array of png names
    
    for (int i = 0; i < animName.length; i++) {//loops through each PImage array and stores the releavent images
      for (int j = 0; j < anims[i].length; j++) {
        anims[i][j] = loadImage(animName[i] + "_" + j + ".png");
      }
    }
 
    //Create list to store enemies
    enemyG = new ArrayList<Goblin>();
    enemyO = new ArrayList<Ogre>();
  }
  

  int numGoblinsAlive() {
    int count = 0;
    for (Goblin x : enemyG) {
      if (x.currentHP > 0) {//checks the amount of goblins that are alive
        count++;
      }
    }
    return count;//returns the amount
  }
  
  int numOgresAlive() {
    int count = 0;
    for (Ogre x : enemyO) {
      if (x.currentHP > 0) {//checks the amount of ogres that are alive
        count++;
      }
    }
    return count; //returns number
  }
  
  void spawnCount(int numGoblins, int numOgres) {
    int numGoblinsToSpawn = numGoblins - numGoblinsAlive();//checks the amount needed with the amount actuall alive
    int numOgresToSpawn = numOgres - numOgresAlive();
    if (numGoblinsToSpawn < 0) {//if its zero, sets the amount to spawn to zero
      numGoblinsToSpawn = 0;
    }
    if (numOgresToSpawn < 0) {
      numOgresToSpawn = 0;
    }
    spawnEnemies(numGoblinsToSpawn, numOgresToSpawn);
  }
  
  
  
  void spawnEnemies(int numGoblinsToSpawn, int numOgresToSpawn) {
    for (int i = 0; i < numGoblinsToSpawn; i++) {
      enemyG.add(new Goblin((int)((Math.random()*(-width-200))+1),(int)((Math.random()*(height))+1),//randomises spawn location
      goblinIdleAnim,goblinRunAnim,goblinSlashAnim,goblinRunSlashAnim ,goblinDyingAnim, goblinHurtAnim,healthBar));//creates new objects of the class goblin and stores in the arrayList
    }
  
    for (int i = 0; i < numOgresToSpawn; i++) {
      enemyO.add(new Ogre((int)((Math.random()*(-width-200))+1),(int)((Math.random()*(height))+1),//randomises spawn locations
      ogreIdleAnim,ogreRunAnim,ogreSlashAnim,ogreRunSlashAnim ,ogreDyingAnim, ogreHurtAnim,healthBar));//creates new objects of the class ogre and stores in the arrayList
    }
  }


 ////////////////////////////////////////////////////////////////////////////////////// 
  
 void removeDeadEnemies() {
   for (int i = 0; i < enemyG.size(); i++) {
    if (enemyG.get(i).currentHP == 0 && enemyG.get(i).played == true) //runs after the death animation is played as it waits until the animation is played
    {
      score += enemyG.get(i).points;
      enemyG.remove(i);
      i--;
    }
  }

  for (int i = 0; i < enemyO.size(); i++) {
      if (enemyO.get(i).currentHP == 0 && enemyO.get(i).played == true) 
      {
        score += enemyO.get(i).points;
        enemyO.remove(i);
        i--;
      }
    }
  }
  
  void wipeEnemies()//wipes all of the enemies in the list and is used to reset the wave when the game finishes
  {
    for (int i = 0; i < enemyG.size(); i++) {
        enemyG.remove(i);
        i--;
    }
    
    for (int i = 0; i < enemyO.size(); i++) {
      enemyO.remove(i);
      i--;
    }
  }

  
  void run(Player pl, Base base)//runs the render function of the enemy characters
  {    
    for(Goblin x: enemyG)
    {
      x.render(pl,base);
    }
    
    for(Ogre y: enemyO)
    {
      y.render(pl,base);
    
    }  
    //////////////////
    removeDeadEnemies(); // remove dead enemies  
  }

}
