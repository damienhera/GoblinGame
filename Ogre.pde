class Ogre extends Goblin
{
  //////////////////////////////////
  public Ogre(float x, float y, PImage[] idleAnim, PImage[] runAnim, PImage[] slashAnim, PImage[] runSlashAnim, PImage[] dyingAnim, PImage[] hurtAnim, PImage[] healthBar) {
        super(x, y, idleAnim, runAnim, slashAnim, runSlashAnim, dyingAnim, hurtAnim, healthBar);//calls and sets variables
        //changed variables
        speedX = 0.35;
        speedY = 0.35;
        maxHP = 100;
        minHP = 0;
        currentHP = maxHP;
        damage = 25;
        points = 50;
    }
}
