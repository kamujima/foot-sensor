import processing.serial.*;

Serial myPort;  // Create object from Serial class
int[][] data = new int[16][50];
int temp;

void setup() 
{
  size(256, 800);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  println(Serial.list());
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    temp = myPort.read();         // read it and store it in val
    println(binary(temp));
  }
  background(0);             // Set background to black
 // for (int i = 0; i < 14; i++) {
  //  for(int j = 0; j < 50; i++) {
      
  //  }
 // }
}
