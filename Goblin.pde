class Goblin extends CharBase
{
  int idleCounter = 0 , idleNum=0, points = 10;
  boolean findPl = false;
    
  
  final int range = 1100;//how far the char can follow
 
  
  Goblin(float x, float y, PImage[] idleAnim, PImage [] runAnim, PImage[] slashAnim, PImage[] runSlashAnim,PImage[] dyingAnim,PImage[] hurtAnim, PImage[] healthBar)//setting up the variables for the enemy class // take in objective locations
  {
    this.healthBar = healthBar;
    this.x = x;
    this.y = y;
    this.idleAnim = idleAnim;
    this.runAnim = runAnim;
    this.slashAnim = slashAnim;
    this.runSlashAnim = runSlashAnim;
    this.dyingAnim = dyingAnim;
    this.hurtAnim = hurtAnim;
    
    damage = 10;
    maxHP = 50;
    minHP = 0;
    currentHP = maxHP;
  }
  
//////////////////////////////////////////////////////////////////////////////////////////
  void idleMov()
  {
    if(idle && !isDead)//if idle is true
    {
        switch(idleNum)//switches between options that changes the char's location
        {
           case 1:
          { 
            walk = true;
            isLeft = false;
            this.x += speedX;//move right
            break;  
          }
          
          case 2:
          {
              walk = true; 
              this.y += speedY;//move down
              break;
          }
          case 3:
          {
              walk = true;
              this.y -= speedY;//move up
              break;
          } 
          default:
            walk = false;//sets walk to false
            break;

         }
      idleCounter++;
      if(idleCounter>=60){idleCounter=0; idleNum = (int) ((Math.random() * (5)) + 1);}//given range of 5 to 1 to increase rest time between cycles
    }
  
  }

 void getTarget(Player pl, Base b)//gets the player and targets size and co-ordinates
  {
    float x,y;
    int sizeX, sizeY;
    if(findPl == true)
    {
     x = pl.x;
     y = pl.y;
     sizeX = size;//sets the size to 10 as the images are not properly formated 
     sizeY = size;
    }
    else
    {
     x = b.x;
     y = b.y;
     sizeX = b.sizeX;
     sizeY = b.sizeY;
    }
    
    
    float distance = findDistance(x,y,sizeX, sizeY);
    if(distance <range && !isDead & canMove){//check to make sure that the target is within range to follow
      canAttack = false;
      if(this.x!= x | this.y!=y)
      {
        idle = false;
        walk = true;  
        ////collition detection
        if(y>this.y){this.y += speedY;}//bottom
        if(y+sizeY<this.y){this.y -= speedY;} //top
        if(x>this.x){this.x += speedX; isLeft = false;}//left
        if(x+sizeX<this.x){this.x -= speedX;isLeft = true;}//right
      }
      
      if(distance <= size/4)//normal slash animation
      {
        idle = false;
        walk = false;//stop running animation
        canAttack = true;
        //attack animation
        slashAnim();
        damageTarget(pl,b);
        //attack player or base
      }
      else if(distance >size/4 && distance <=size*4)//run and slash animation
      {
        idle = false;
        walk = false;//stop running animation
        canAttack = true;
        //attack animation
        runSlashAnim();
        damageTarget(pl,b);
        //attack player or base
      }
    }
    else
    {
      idle = true;//sets idle to true
      findPl = false;//sets find player to false if outside of range
    }
  }
  
  //attack base/attack player
  void damageTarget(Player pl, Base b)
  {
    if(!hit)
    {
      if(findPl == true)
      {
        pl.currentHP -= damage;
        pl.hurt = true;
      }
      else{b.health -= damage;}
      hit = true;
      hitCounter = 0;
    }
    //this part of the code makes sure that there is a limit on the amount of damaged placed. It reduces damage done every second by delaying it through a counter.
    hit = hitCounter >=60?false:true;
    hitCounter++;
  }
  

  @Override
  void getHit()//hit check
  {
    if(hurt)//if hurt
    {
      hurtAnim();//run hurt animation
      findPl = true;//allows to find player after hit
    }
  
  }

  ///////////// OUPUT/ DRAW Char 

  void render(Player pl, Base b)
  {
    displayHealth();
    getHit();
    healthCheck();
    getTarget(pl, b);
    idleMov();
    wallColl();
    displayAnim();
  }
  
}
