abstract class  CharBase//character base used by bothe enemies and player
{
  //base variables
  int currentHP, maxHP,minHP,damage, imgWidth, imgHeight, frame, animCounter, size = 10, hitCounter;
  float x,y, speedX = 0.5, speedY = 0.5, moveHP;
  boolean hit = false, isLeft = false, played = false, idle = false,isDead = false, walk = false, canAttack = false, hurt = false, canMove = true, deathAnimStart = false;
  PImage [] idleAnim, runAnim, slashAnim, runSlashAnim, dyingAnim, hurtAnim, healthBar;


  
   void wallColl()//wall collition
  {
    if(this.x>width-imgWidth){x-=speedX;}
    if(this.x<0){x+=speedX;}
    if(this.y>height-imgHeight-size*2){y-=speedY;}
    if(this.y<0+imgHeight+size*2){y+=speedY;}    
  }

  //Default Character Animations
  void idleAnim()//animation for when the char is still
  {
    frame =animCounter/4%18;//sets frame to show depending on animCounter.
    animate(frame,idleAnim);
  }
  
  void runAnim()//the walk animation for the char
  {
    frame =animCounter/5%11;
    animate(frame, runAnim);
  }
   
  void deathAnim()//death animation for the char (fix this) ---Create seperate animation funciton for this as it will fail if its linked with everything else
  {
    if(!deathAnimStart){animCounter = animCounter>3?0:animCounter; deathAnimStart = true;}
    frame = animCounter/5%15;
    animate(frame, dyingAnim);
    if(frame == 14)//when the animation reaches the last frame, the game sets the animation to played
    {
      played = true;//sets played to true so the animation would not repeat
    }
  }
  
  
  
  void hurtAnim()
  {
    if(hurt & !isDead)
    {
      canMove = false;//sets it to false
      walk = !walk;//sets to opposite of what it is
      canAttack = !canAttack;//sets to opposite of what it is and prevents from attacking whilst stunned
      frame = animCounter/5%12;//makes smoother animation
      animate(frame, hurtAnim);//animates
      if(frame == hurtAnim.length-1)
      {
        //resets all variables after reaching the end;
        hurt = false;
        walk = !walk;
        canMove = true;
      }
    
    }
  
  }
  
  
  void slashAnim()//slash animation 
  {
    frame = animCounter/4%12;
    animate(frame, slashAnim);
    
  }
  
  void runSlashAnim()
  {
    frame = animCounter/7%12;
    animate(frame,runSlashAnim);
  }


  void displayAnim()//calls all of the animations
  {
    
    if(!isDead)//if the character is considered dead, the animations would stop running
    {
      if(walk && !canAttack && canMove){runAnim();}
      else if (walk == false && !canAttack && canMove){idleAnim();}
    }
    animCounter++;
  }  
 
  void animate(int frame, PImage[] anim) // renders the animation
  {
    if(isLeft)//checks to see if the character is facing left
    {
      imgWidth = anim[frame].width;
      imgHeight = anim[frame].height;
      pushMatrix();//push and pop allows you to add transformations to an image
      scale( -1, 1 );
      image(anim[frame],-(x+imgWidth/8),y+imgHeight/4);
      popMatrix();
      
    }
    else
    {
      image(anim[frame],(x+imgWidth/8),y+imgHeight/4);
    }
  }
//////////////////////////////////////////////////////////////////////////////  
  
  
    float findDistance(float targetX, float  targetY,int  sizeX,int sizeY) // finds the distance of targets
  {
    //Calculate distance between the goal and the current location
    float tX = targetX, tY = targetY;
    float x = this.x, y = this.y;
    if(x<tX){ x= tX;  }//left edge
    else if(x > tX + sizeX){x = tX+sizeX;  }//right edge
    if(y<tY){y =tY; }//top
    else if(y>tY+(sizeY)){y = tY+sizeY;}//bottom
    float distX = this.x - x;
    float distY = this.y - y;
    float distance =sqrt((distX*distX)+(distY*distY));

    return distance;
  }
  
  void displayHealth()
  {
    float targetHP;
    int xPos, yPos;
    xPos = (int)x-50;
    yPos = (int)y - 25;
    
    imageMode(CORNER);//set to corner to make sure the health bar moves in one direction
    if(currentHP<minHP){currentHP = minHP;}//if the current hp < 0 then sets it to zero
    if(currentHP<minHP)
    {
      currentHP = minHP;
      targetHP = healthBar[0].width*currentHP/maxHP;
    }//if the current hp < 0 then sets it to zero
    else{targetHP = healthBar[0].width*currentHP/maxHP;}

    
    
    moveHP = lerp(moveHP,targetHP,0.1);
    image(healthBar[0], xPos,yPos);
    healthBar[1].resize((int)moveHP,healthBar[0].height);
    image(healthBar[1], xPos,yPos);
    imageMode(CENTER);//resets the imagemode back to center
  }
  
  void healthCheck()//checks the current health of the char
  {
    if(currentHP <=0)//if its below zero
    {
      isDead = true;//set that its dead and play death animation
      deathAnim();
    }
  }
  
  void getHit(){}
  
  void render(){}
}
