
public class Pollutant extends Vehicle{   //this Vehicle means a class in game2dai package
  
  public int initalFactoryVehicleAmount = 5;
  String FactoryLevel1 = "SO2";
  String FactoryLevel2 = "SO2 & NO2";
  String FactoryLevel3 = "SO2 & NO2 & CO";
  String VehicleLevel1 = "O3";
  String VehicleLevel2 = "O3 & PM10";
  String VehicleLevel3 = "O3 & PM10 & PM2.5";
  String noFound = "noFound";
  String _name;
  BitmapPic view;
  

  
  PImage fac1;
  PImage fac2;
  PImage fac3; 
  PImage veh1; 
  PImage veh2; 
  PImage veh3; 
  
  double _radius;
  
  
  public float x, y;
  
  double speedX, speedY;
  
  float windDirectionX, windDirectionY;
  
  public Pollutant (String name,  Vector2D position, double radius, Vector2D velocity, 
  double max_speed, Vector2D heading, double mass, 
  double max_turn_rate, double max_force){  
    
    
    super(name, position, radius, velocity, max_speed, heading, mass, max_turn_rate, max_force);
    addFSM();
    _name = name;
  
    speedX = heading.x * max_speed/50*mass;
    speedY = heading.y * max_speed/50*mass;
    
    _radius = radius;
   }
  
  public void popUp(int level){
    
    fac1 = loadImage("Molecule_SO2.png");
    fac2 = loadImage("Molecule_NO2.png");
    fac3 = loadImage("Molecule_CO.png");
    veh1 = loadImage("Molecule_O3.png");
    veh2 = loadImage("Molecule_PM10.png");
    veh3 = loadImage("Molecule_PM2.5.png");

    
    if (name.equals ("factory")==true)
    {
      switch(level){
        case 1:
              pollutantsRender(fac1);
              //return 1;
              break;
        case 2:
              if(_radius<=1.5)
              {
              pollutantsRender(fac1);
              }else
              {
              pollutantsRender(fac2);
              }
              break;
        case 3:
              if(_radius<1)
              {
              pollutantsRender(fac1);
              }else if(_radius>=1 && _radius< 2)
              {
              pollutantsRender(fac2);
              }
              else
              {
              pollutantsRender(fac3); 
              }
              break;
        default:
              break;   
      }
    }
     if (name.equals ("vehicle")==true)
    {
      switch(level){
        case 1:
              pollutantsRender(veh1) ;
              
              break;
        case 2:
               if(_radius<=1.5)
              {
              pollutantsRender(veh1) ;
              }
              else
              {
              pollutantsRender(veh2) ;
              }
              break;
              
        case 3:
            if(_radius< 1)
              {
              pollutantsRender(veh1) ;
              }else if(_radius>=1 && _radius< 2)
              {
              pollutantsRender(veh2) ;
              }
              else
              {
              pollutantsRender(veh3) ;
              }
              break;
        default:
         break; 
      }
    
    }

  }
  
    void pollutantsRender(PImage pollutantsKind){
    //ellipse((float)this.pos().x, (float)this.pos().y, 10, 10);
    image(pollutantsKind,(float)this.pos().x,(float)this.pos().y);
    this.moveBy(speedX,speedY);
    //println(pollutantsKind);
  }
  
  /*
  void pollutantsMoving()
  {
    if(worldDay%2 == 0)
    {
    windDirectionX = radom(-50, 50);
    windDirectionY = radom(-50, 50);
    }
    speedX = windDirectionX * ;
    speedY = ;
  }
  */
}
