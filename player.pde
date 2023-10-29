class Player extends CharBase
{
  final int range = 50, explosionRange = 150, explosionDamage = 40; // given this range to make it easier for player to attack
  PImage[] explosion;
  int regenCounter, explosionPosX, explosionPosY, explosionCounter;
  boolean explode = false ,regen = false, canExplode;

  Player(float x, float y, PImage[] idleAnim, PImage [] runAnim, PImage[] slashAnim, PImage[] runSlashAnim, PImage[] dyingAnim,PImage[] hurtAnim, PImage [] explosion, PImage[] healthBar)//setting up the variables for the enemy class // take in objective locations
  {
    //initialze variables
    this.x = x;//x position
    this.y = y;//y position
    speedX = 1;
    speedY = 1;
    //load animations
    this.idleAnim = idleAnim;
    this.runAnim = runAnim;
    this.slashAnim = slashAnim;
    this.runSlashAnim = runSlashAnim;
    this.dyingAnim = dyingAnim;
    this.hurtAnim = hurtAnim;
    this.healthBar = healthBar;
    this.explosion = explosion;
    isLeft = true;
    maxHP = 150;
    minHP = 0;
    currentHP = maxHP;
    idle = false;
    damage = 20;//sets player damage
    

  }



//fix movement  
  void move()
  {
    idle = left?false:right?false:up?false:down?false:true;//checks if player is idle
    walk =  left?true:right?true:up?true:down?true:false;//checks if player is moving ---- take away when reCoding
    //by using the key pressed funciton, movement is alot smoother
    if(!isDead)
    {
      if(left)//if the left key was pressed
      {
        x-=speedX; // move in the left direction
        isLeft = true;//set image orientation to left
      }
      if(right)//if right
      {
        x+=speedX;//move right
        isLeft = false;//make the player look right
      }
      if(up)//if upKey pressed move up
      {
        y-=speedY;
      }
      if(down)//if down key pressed move down
      {
        y+=speedY;
      }
    }
  }
  
  
  @Override
  void displayAnim()
  {
    //change display for char
    if(!isDead)//if the character is considered dead, the animations would stop running
    {
      if(walk&&!hurt){runAnim();}//if wakk does walk run animation
      else if (idle && !hurt){idleAnim();}//if idle char does idle animation
    }
    animCounter++;
  
  }
  
  @Override
    void hurtAnim()
  {
    if(hurt & !isDead)
    {
      walk = !walk;//sets to opposite of what it is
      canAttack = !canAttack;//sets to opposite of what it is and prevents from attacking whilst stunned
      frame = animCounter/2%12;//makes smoother animation
      animate(frame, hurtAnim);//animates
      if(frame == hurtAnim.length-1)
      {
        //resets all variables after reaching the end;
        canAttack = !canAttack;
        hurt = !hurt;
        walk = !walk;
      }
    
    }
  
  }
  

    
  void attack()//take in list of enemies
  {
    
    if(walk & mouseClick & !isDead)//if player is walking and mouse if clicked and player is not dead
    {
      canAttack = true;//can attack is set to true
      walk = !walk;//walk = false
      runSlashAnim();//use the runSlash anim
      explosionCondition();//checks if explosion conditions are met
      
    }
    
    else if(!walk && mouseClick && !isDead)
    {
      canAttack = true;//allows to attacm
      idle = false;//sets idle to false to prevent animation clash with idle
      slashAnim();//allows slash anim
      explosionCondition();//checks if explosion conditions are met
    }
    canExplode=explosionCounter>50;
    explosionCounter++;
  }
  
  void explosionCondition()
  {
     if(rightClick && canExplode)//if right click and can do explosion
      {
         explode = true;//sets explode to true wich would allow the explosion to occur
         explosionPosX = mouseX;//uses mouse x position
         explosionPosY = mouseY;//use mouse y position
         canExplode = false;//adter animation sets can explode to false
         explosionCounter = 0;
      }
  }
  
  void explodeAnim(int x, int y, ArrayList<Goblin> enemyG, ArrayList<Ogre> enemyO)//explosion animation
  {
    if(explode == true & !isDead)//if explode and not dead
    {  
      if(!played){animCounter = animCounter>4?0:animCounter; played = true;}//and if the animation is not already played, set the animCounter to 0 if it is above 4 to prevent major skipped frames.
      frame = animCounter/11%explosion.length;//sets up frame to show
      image(explosion[frame],x,y); //show the frame
      if(frame == explosion.length-1)//if animation is complete
      {
        explosionDamage(enemyG,enemyO);//damages enemies
        explode = false;//sets explode to false to stop from replaying
        played = false;//sets played to false to allow the played check again
      }
        
      animCounter++;//increments animCounter
    }
    
  }
  
  
  
  void explosionDamage(ArrayList<Goblin> enemyG, ArrayList<Ogre> enemyO) //explosion damage
  {
    if(explode)//if exploded
    {
      for (Goblin g : enemyG) //loops through goblin list
      {
      float distance = dist(g.x, g.y, explosionPosX, explosionPosY);//gets the distance between explosion and enemies
      if (distance <= explosionRange) //if in range
      {
        g.currentHP -= explosionDamage;//damage
        g.hurt = true;//hurt is set to true to trigger hurt anim
      }
    }
    
    for (Ogre o : enemyO) //loops through ogre
    {
      float distance = dist(o.x, o.y, explosionPosX, explosionPosY);//gets distance between explosion and enemies
      if (distance <= explosionRange)//if in range
      {
        o.currentHP -= explosionDamage;//damage
        o.hurt = true;//set off hurt animation
      }
    } 
   }
  }
    

  @Override
  void getHit()//check to see if hit
  {
    if(hurt)//if hurt
    {
      //hurt anim
      hurtAnim();
    }
  
  }
  

  
  void getEnemy(ArrayList<Goblin> enemyG, ArrayList<Ogre> enemyO) {//get enemy 
    float closestG = width, closestO = width, currentDistance;//sets the closest to ones as any in the canvas to start
    Goblin closestGoblin = null;//sets closestGoblin to null as we have not found one yet
    Ogre closestOgre = null;//sets closestOgre to null as we have not found one yet
    
    for (Goblin goblin : enemyG) {//loops through goblin list
      currentDistance = findDistance(goblin.x, goblin.y, goblin.size, goblin.size);//get current distance
      if (currentDistance < closestG) {//checks if its closer than the closestGoblin
        closestG = currentDistance;//sets the closest distance to the current distance
        closestGoblin = goblin;//sets closests goblin to current goblin
      }
    }
    
    for (Ogre ogre : enemyO) {//similar to the top but configured for the ogre class
      currentDistance = findDistance(ogre.x, ogre.y, ogre.size, ogre.size);
      if (currentDistance < closestO) {
        closestO = currentDistance;
        closestOgre = ogre;
      }
    }
    
    if (closestG < closestO) {//compares and attacks the closest enemy
      if (closestGoblin != null) {
        attackEnemy(closestGoblin);
      }
    } else {
      if (closestOgre != null) {
        attackEnemy(closestOgre);
      }
    }
  }

  void attackEnemy(Goblin goblin) {//attack enemy for the goblin
    if (leftClick && !hit && findDistance(goblin.x, goblin.y, goblin.size, goblin.size) <= range) {//checks the distance to make sure its within range
      goblin.currentHP -= damage;//does damage to the char
      goblin.hurt = true;
      hit = true;//sets hit to true to prevent the player from doing more damage than intended
      hitCounter = 0;//acts as a way to slow down damage done
    }
    hit = hitCounter >= 60 ? false : true;//sets hit to false after some time
    hitCounter++;//increment 
  }

  void attackEnemy(Ogre ogre) {//attack enemy for the ogre
  if (leftClick && !hit && findDistance(ogre.x, ogre.y, ogre.size, ogre.size) <= range) {
    ogre.currentHP -= damage;
    ogre.hurt = true;
    hit = true;
    hitCounter = 0;
  }
  hit = hitCounter >= 60 ? false : true;
  hitCounter++;
  }
  
  
  void healthRegen()
  {
    if(currentHP < maxHP && currentHP>=0 &&!regen)//if the health has not regenerated
    {
      currentHP += 1;//add 1 to HP
      regen = true;//set condition to true
      regenCounter = 0;
    }
    regen= regenCounter<15;
    regenCounter++;
  }


  @Override
  void wallColl()//due to the player images being a different size than the other enemies I have redfine the wallcoll
  {
    if(this.x>width-imgWidth+size*1/2){x-=speedX;}
    if(this.x<0){x+=speedX;}
    if(this.y>height-imgHeight/2){y-=speedY;}
    if(this.y<0){y+=speedY;}    
  
  }
  
  void reset()//resets character
  {
    x = 1000;//sets default x and y
    y = 500;
    currentHP = maxHP;//resets health
    isDead = false;//sets char to alive
  }
  
  
  


  void render(ArrayList<Goblin> enemyG, ArrayList<Ogre> enemyO)//render the player
  {
    //call releavent functions
    move();
    wallColl();
    getEnemy(enemyG, enemyO);
    attack();
    getHit();
    explodeAnim(explosionPosX, explosionPosY, enemyG, enemyO);
    healthRegen();
    healthCheck();
    displayHealth();
    displayAnim();
  }

}
