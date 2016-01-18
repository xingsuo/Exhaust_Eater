public class Factory extends Polluter {
  Vector2D position;
  int pollterLevel;
  
  public Factory (String _kind, int _level,  Vector2D _position){
    super(_kind, _level);   // how to overcome the overlap?
    factoryRender(_position);
    position = _position;
  }

  public void factoryRender(Vector2D picPosition){
    println("factory" + picPosition);
  }
  
  public Vector2D getPosition(){
    return position;
  }
  

  
  
}
