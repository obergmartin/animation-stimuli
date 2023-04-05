class Particle {

  Body body;
  
  //Particle(float x, float y, float w_, float h_, Body body_, color c_) {
  Particle(Body body_) {
    //col = c_;
    //w = w_;
    //h = h_;
    body = body_;
    body.setUserData(this);
  }
  
  void display(){}

  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }
}
