/* autonick, approximation of a Nick Wivekyolamal idea and workflow 
 * processing implementation by Bob Verkouteren http://applesandchickens.com */

//settings
int brightdiff = 30; //difference in brightness to consider a new color 
int maxcolors = 3; // stops scanning for colors when these are reached

Boolean skipfirstcolor = true; //if enabled, ignores the color of the first pixel
//dont change anything below this unless you know what you are doing


PImage img, bmap, result;
void setup() { 
  img = loadImage("source.jpg");
  //resize map to source size
  PImage tmap = loadImage("map.jpg");
  bmap = createImage(img.width, img.height, RGB);
  bmap.copy(tmap, 0, 0, tmap.width, tmap.height, 0, 0, bmap.width, bmap.height);
  size(img.width, img.height, P2D);
  noLoop();
}

void draw() { 
  result = createImage(img.width, img.height, RGB);
  result.copy(img, 0, 0, img.width, img.height, 0, 0, result.width, result.height);
  image(autonick(result, img, bmap), 0, 0);
  save("result.png");
}

void mouseClicked() { 
  bmap.pixels = reverse(bmap.pixels);
  redraw();
}

PImage autonick(PImage result, PImage img, PImage map) { 
  //detect colormap
  img.loadPixels(); 
  result.loadPixels(); 
  map.loadPixels();
  color[] colors = new color[maxcolors];
  int[] shifts = new int[maxcolors];
  float prev = -brightdiff;
  color toignore = -1;
  if ( skipfirstcolor ) { 
    toignore = map.pixels[0];
  }
  int idx = 0;
  for ( int i = map.pixels.length - 1; i>-1; i-- ) { 
    color c = map.pixels[i];
    float br;
    //br = brightness(c);
    //println(c);
    //if ( br != prev ) { 

    if ( !( skipfirstcolor && c == toignore )  && abs(( br = brightness(c)) - prev) > brightdiff ) { 
      prev = br;
      colors[idx++] = c;
      println("found "+c);
    }
    if  (idx >= maxcolors) break;
  }
  while ( idx < maxcolors  ) { 
    // haven't reached our colors yet, looping found colors until filled ( this will make the duplicated color shift multiple times )
    colors[idx++] = colors[maxcolors-idx];
    idx++;
  }
  // we have our colors, time to set our offsets and map accordingly
  for ( int i = 0, l = colors.length; i<l; i++ ) { 
    int shiftx = (int)map(random(1), 0, 1, -width+1, width-1);
  }
  for ( int i = 0, l = colors.length; i<l; i++ ) { 
    int shiftx = (int)map(random(1), 0, 1, -width+1, width-1);
    for ( int x = img.pixels.length -1; x > -1; x-- ) { 
      if ( x + shiftx < 0 ) shiftx = -shiftx;
      int tp = x + shiftx;
      color test = map.pixels[x];
      if ( tp < 0 || tp >= result.pixels.length  ) continue;
      if ( iscol(test, colors[i], brightdiff) ) 
        result.pixels[tp] = img.pixels[x];
    }
  }
  result.updatePixels();
  return result;
}

Boolean iscol(color c1, color c2, int diff) { 
  return(abs(red(c1)-red(c2))<diff
    && abs(green(c1)-green(c2))<diff
    && abs(blue(c1)-blue(c2))<diff
    );
}

