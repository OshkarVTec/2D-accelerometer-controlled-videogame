# 2D-accelerometer-controlled-videogame
# The game
This is a 2D collaborative game, which is inspired by the Hollow Knight game. The objective is to capture the 3 masks that appear on top of the map. The first player moves the character and has the ability to transform it through the movement of an accelerometer connected to an FPGA Arty board. The second player uses the mouse to create platforms that the character uses to reach the masks. There is a 7-segment display attached to the Arty, which displays the current score. There are 4 LED indicators on the Arty, which show the state of the movement (left, right, still) on red, and the transformation on green.

# Demonstration video
https://www.youtube.com/watch?v=_4v0L5nA6wU

# Game architecture
The architecture of this project is made of 6 VHDL components: the picoblaze, UART, SPI, LED output and display output modules, and an input register. The communication with the computer is made through the uart module, which sends and receives data between the Arty and the computer. The position data is read through the SPI module, which acts as a slave in the SPI protocole, and is conected to the picoblaze module, as its master. The picoblaze soft processor takes all the inputs and generates the outputs depending on the conditions previously stated on the assembly language code. The wiring of the components is made on a top-level file, which uses temporal signals to connect inputs and outputs to all the components. The graphic side is made on Processing, and consists of a series of functions that generate all the game, and three classes for the mask and the two characters.
The processor used is the picoblaze soft processor. The main code is written in picoblaze assembly language.

# Assembly code
The main loop reads data from the designated ports and stores it on the registers. It first read data from the UART port. The data read from the UART is read in ASCII, so it has to be transformed to binary to be sent to the display. Then, the picoblaze reads data from the SPI port. A bit mask is used to leave only the most important bits for the comparisons. The data from the SPI is compared to the previously established positions. If a coincidence occurs, a letter is sent to the UART port. 
```
loop:
        ;revisar rx
        ;leer datos rx
        INPUT		EstadoRX, PuertoDatoListoRX
		COMPARE		EstadoRX, 01
		CALL		Z, rx_uart    
        ;imprimir datos en display
        COMPARE DatoSerial, 30
		CALL 		Z, cero
		COMPARE DatoSerial, 31
		CALL 		Z, uno
		COMPARE DatoSerial, 32
		CALL 		Z, dos
		COMPARE DatoSerial, 33
		CALL 		Z, tres
		COMPARE DatoSerial, 34
		CALL 		Z, cuatro
		COMPARE DatoSerial, 35
		CALL 		Z, cinco
		COMPARE DatoSerial, 36
		CALL 		Z, seis
		COMPARE DatoSerial, 37
		CALL 		Z, siete
		COMPARE DatoSerial, 38
		CALL 		Z, ocho
		COMPARE DatoSerial, 39
		CALL 		Z, nueve
		COMPARE DatoSerial, 61
		CALL 		Z, diez
		COMPARE DatoSerial, 62
		CALL 		Z, once
		COMPARE DatoSerial, 63
		CALL 		Z, doce
		COMPARE DatoSerial, 64
		CALL 		Z, trece
		COMPARE DatoSerial, 65
		CALL 		Z, catorce
		COMPARE DatoSerial, 66
		CALL 		Z, quince
        ;leer datos de SPI
        INPUT		RegXMSB, PuertoEntradaXM
		INPUT		RegXLSB, PuertoEntradaXL
		INPUT		RegYMSB, PuertoEntradaYM
		INPUT		RegYLSB, PuertoEntradaYL
		INPUT		RegZMSB, PuertoEntradaZM
		INPUT		RegZLSB, PuertoEntradaZL
        ;mascara de bits
        AND			RegXMSB, 10000000'b
        AND			RegYMSB, 10000000'b
        AND			RegZMSB, 10000000'b
		AND			RegXLSB, 11100000'b
		AND			RegYLSB, 11000000'b
		AND			RegZLSB, 10000000'b
		;revisar transformacion
        COMPARE		RegYMSB, 00000000'b
        JUMP        Z, transformar
        ;mover
mover:
        COMPARE     RegXMSB, 00000000'b
        JUMP        Z, x_positivo
        JUMP        x_negativo
```

# Character Design 
For the creation of the character we decided to made 4 actions:
* Right movement
* Left movement, 
* Jump 
* Transformation

For the previous actions we made a state machine for the action's animations.
In the state machine we defined the frames for all animations, this was very useful to determine flags and conditions to make the frame transitions, for example if the character was looking to the right a flag called _Side_flag_ will have a value of '1', instead, if the character was looking to the left the side_flag_ will have a value of '0'. This is an example of a flag that determines which frame is going to appear. The state machine is the following:
![](https://github.com/OshkarVTec/Reto_Diseno_Logica_Programable/blob/main/Hollow_Knight_State_Machine.jpeg)

Each frame will appear on screen depending on a variable called _state_, also the frames depends on the x-axis movement, for this we implemented a value of acceleration, if the acceleration in the x-axis is greater than 0 the state will change its value, in the other case if the aceeleration is equal to 0 or lower than 0 the state will reset to a initial value depending in which side the character was looking.

For the jump we implemented a y-axis acceleration to represent a vertical movement, also there is a gravity value to reduce the y-axis acceleration.

The character transformation implements another flag called _transformation_ depending on the value of this flag tha character will have  a knight's form or a worm's form, this flag also allows the the shapeshift using the accelerometer. To implement the altern form of the worm we do the same process as the knight only changing the images for the animations.

# Stage design
The stage in the game is also very important, for the platform generation we generate a 16*8 matrix, each tile ie 80x80 pixels and has a boolean value, this value admits if the tile is available or not, if the tile is not available in that tile will appear a platform, this platform has gravity physics, its able to stop the knight's fall and allows him to jump if he is above them.

The code used to draw the platforms is the next one:
```c
 boolean place_free(int xx,int yy) {
   xx = int(floor(xx/80.0));
   yy = int(floor(yy/80.0));
   
   if ( xx > -1 && xx < level[0].length && yy > -1 && yy < level.length ) {
    if ( level[yy][xx] == 0 ) {
      return true;
    }
  }
   return false;
}  
```
With 2 nested _for_ cycles every tile is analyzed, if the tile has a '1' value in that place will appear the platform, in other case there won't be nothing. 
```c
for ( int ix = 0; ix < WIDTH; ix++ ) {
    for ( int iy = 0; iy < HEIGHT; iy++ ) {
      switch(level[iy][ix]) {
        case 1: 
          fill(color(52,73,94));
          rect(ix*80,iy*80,80,80);
      }
    }
```

# Game's objective
The goal of this game is to collect 3 masks with the knight accross the stage, the masks appear randomly, for the interaction between the knight and the mask we implemented positions values in each one, our program is based in OOP so each entity has it's own position atributes, for the mask recollection we used the next code to determine the interaction:

```c
if ((abs(p1.x - b1.x) < 79) && (abs(p1.y - b1.y) < 79)){
    counter++;
    level_Restart();
    }
```
There are 2 important things to highlight, first of all, tha counter will increment, this counter is very important, it determines the gme ending (remind that the game ends when you cllect 3 masks) when you collect a mask the stage will restart, all existing platforms will be deleted and another mask will appear randomly again, this is made by the function _level_Restart()_:

```c
void level_Restart(){
    for ( int ix = 0; ix < WIDTH; ix++ ) {
    for ( int iy = 0; iy < HEIGHT; iy++ ) {
      level[iy][ix] = 0; 
      }
    }
    b1.change_position();
  }
```

# VHDL code

The components are wired on a top-level file. The block diagram is the following.
![Block diagram](https://github.com/OshkarVTec/Reto_Diseno_Logica_Programable/blob/main/SmartSelect_20220318-085334_Samsung%20Notes.jpg)
The resulting Schematic in Vivado corresponds to the previous diagram.
![Schematic](https://github.com/OshkarVTec/Reto_Diseno_Logica_Programable/blob/main/Esquematico.jpg)
The top-level file includes all the components first, and then connects them using temporal signals and its input and output ports.
There is a multiplexor signal that selects the input depending on the required port.

```vhd
signal  in_tmp     : std_logic_vector(7 downto 0) := "00000000";
signal  port_sel   : std_logic_vector(7 downto 0) := "00000000";
signal  write_tmp  : std_logic := '0';
signal  output_spi    : std_logic_vector(7 downto 0) := "00000000";
signal  output_uart   : std_logic_vector(7 downto 0) := "00000000";
signal  out_tmp  : std_logic_vector(7 downto 0) := "00000000";
signal  mux_tmp    : std_logic_vector(7 downto 0) := "00000000";


