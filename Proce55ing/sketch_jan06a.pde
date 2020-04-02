import processing.serial.*;

Serial myPort;  // Create object from Serial class
int [][] data=new int [16][50];
int lf = 64;
String myString = null;
boolean flag = false;

void setup() 
{
  size(256, 800);
  frameRate(60);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  smooth();
}

void draw()
{
    if ( myPort.available() > 3500) {  // If data is available,
        for (int y = 0; y < 49; y++) {
          myString = myPort.readStringUntil(lf);
            if (myString != null) {
              int tmp[] = int(split(myString.substring(0, myString.length() - 1), ','));
              for (int x = 0;x < 14; x++) { data[x][y] = tmp[x]; }
            }
          }
      showpix();
    }
}

void showpix() {
    for (int i = 0; i < 50; i++) {
      for (int j = 0; j < 16; j++) {
          fill(data[j][i]);
          rect(j*16, i*16, j*16+16, i*16+16);
      }
    }
}
