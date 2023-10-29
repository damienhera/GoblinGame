class Base
{
  //Variables
  final int sizeX = 80, sizeY = 420;
  final float x = width-80, y = height/4;
  float moveHP;
  int maxHealth = 500,minHealth = 0, health = maxHealth;
  PImage[] baseAnim, healthBar;
  PImage tree;
  boolean isDead = false;

  Base(PImage[] baseAnim, PImage[] healthBar, PImage tree)
  {
    //assign variables
    this.tree = tree;
    this.baseAnim = baseAnim;
    this.healthBar = healthBar;
  }
  
  void display()
  {
    imageMode(CORNER);
    //display the house
    if(health>maxHealth/2){image(baseAnim[0],x,y);}
    else if(health<=maxHealth/2 & health>minHealth){image(baseAnim[1],x,y);}
    else{image(baseAnim[2],x,y);}
    //display tree
    image(tree,width-tree.width,0);
    imageMode(CENTER);//resets the imagemode back to center
    
  }
  
  void displayHealth()
  {
    float targetHP;//where the healthbar should be
    int xPos, yPos;//x position and y positon used in this function
    xPos = width/2-100;
    yPos = height-80;
    
    text("Base Health ",xPos+20,yPos);
    
    imageMode(CORNER);//set to corner to make sure the health bar moves in one direction
    if(health>maxHealth){health = maxHealth;}//if the current hp > maxHealth then sets it to that value. Doing this would prevent errors and confine the healthBar
    if(health<minHealth)
    {
      health = minHealth;
      isDead = true;
      targetHP = healthBar[0].width*health/maxHealth;
    }//if the current hp < 0 then sets it to zero
    else{targetHP = healthBar[0].width*health/maxHealth;}

    moveHP = lerp(moveHP,targetHP,0.1);
    image(healthBar[0], xPos,yPos);
    healthBar[1].resize((int)moveHP,healthBar[0].height);
    image(healthBar[1], xPos+1,yPos);
    imageMode(CENTER);//resets the imagemode back to center
  }

  void reset()//reset the player
  {
    health = maxHealth;//sets health to max
    isDead = false;//lets the game know the player is alive
  }

  
  void render()//renders base
  {
    display();
  }
}
