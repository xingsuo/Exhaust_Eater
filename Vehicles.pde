public class Vehicles extends Polluter {
  Vector2D position;
  float maxX = 100, minX = 80;
  float maxY = 100, minY = 80;

  
  public Vehicles (String _kind, int _level, int _amount){
    super(_kind, _level);
    vehiclesRender(_amount);
  }

  public void vehiclesRender(int vehicleAmount){
    println("vehicle" + vehicleAmount);
  }
  
  public Vector2D getPosition(){
    position = new Vector2D(100, 80);
    //position.x = (double)100;
    //position.y = (double)100;
    //position.x = (double)random(minX, maxX);
    //position.y = (double)random(minY, maxY);
    return position;
  }
  
   
  
}
