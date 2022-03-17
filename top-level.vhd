--Este archivo es el top-level del reto. Se leen datos de un acelerometro a traves de SPI. Se envian datos a traves de UART.
--Se imprimen salidas en los LEDs y en un diplay de 7 segmentos
--Oskar Adolfo Villa Lopez A01275287
--Diego Garcia Rueda	A01735217
--13 de marzo de 2022
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

	 
entity top_level is
    Port(
	clock : in std_logic;
	reset : in std_logic;
	rx : in std_logic;
	tx : out std_logic;
	display : out std_logic_vector(6 downto 0);
	control : out std_logic;
    leds : out std_logic_vector(7 downto 0);
    SCLK : buffer std_logic;                      
    SS_N : buffer std_logic_vector(0 DOWNTO 0);  
    MOSI : out std_logic;
    MISO : in std_logic
    );
end top_level;

architecture Behavioral of top_level is

component modulo_uart is
    Port ( 
                     CLK : in STD_LOGIC;
                     RST : in STD_LOGIC;
                     --pines de comunicación con PicoBlaze
                 PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
              INPUT_PORT : in STD_LOGIC_VECTOR (7 downto 0);
             OUTPUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
            WRITE_STROBE : in STD_LOGIC;
                      --pines de comunicación serial
                      TX : out STD_LOGIC;
                      RX : in STD_LOGIC
                      );
end component;

component puerto_7segmentos is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           WRITE_STROBE : in STD_LOGIC;
           SEGMENTOS : out STD_LOGIC_VECTOR (6 downto 0);
           CONTROL : out STD_LOGIC);
end component;

component embedded_kcpsm6 is
  port (                   
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                           --interrupt : in std_logic;
                       --interrupt_ack : out std_logic;
                           --    sleep : in std_logic;
                                 clk : in std_logic;
                                 rst : in std_logic);
end component;

component registro_puerto_entrada is
	 generic(
				n : integer := 8			--ancho del registro
	 );
    Port ( 
			  CLK  : in  STD_LOGIC;
              RST  : in  STD_LOGIC;
                D  : in  STD_LOGIC_VECTOR(n-1 downto 0);
                Q  : out STD_LOGIC_VECTOR(n-1 downto 0)
          );
end component;


component modulo_spi is 
        Port (  CLK : in STD_LOGIC;
                RST : in STD_LOGIC;
                PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
                OUTPUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
                MISO : in  STD_LOGIC;                     
                SCLK : buffer STD_LOGIC;                      
                SS_N : buffer STD_LOGIC_VECTOR(0 DOWNTO 0);  
                MOSI : out    STD_LOGIC);
end component;

component puerto_salida_leds is
    Port ( 
				         CLK : in STD_LOGIC;
				         RST : in STD_LOGIC;
				      SALIDA : out STD_LOGIC_VECTOR(7 downto 0);
			  --pines de comunicación con PicoBlaze
				WRITE_STROBE : 	in std_logic;
				     PORT_ID : 	in	std_logic_vector(7 downto 0);
				  INPUT_PORT : 	in std_logic_vector(7 downto 0)
				);
end component;


signal  in_tmp     : std_logic_vector(7 downto 0) := "00000000";
signal  port_sel   : std_logic_vector(7 downto 0) := "00000000";
signal  write_tmp  : std_logic := '0';
signal  output_spi    : std_logic_vector(7 downto 0) := "00000000";
signal  output_uart   : std_logic_vector(7 downto 0) := "00000000";
signal  out_tmp  : std_logic_vector(7 downto 0) := "00000000";
signal  mux_tmp    : std_logic_vector(7 downto 0) := "00000000";



									  
begin
    picoblaze: embedded_kcpsm6 port map(in_port => in_tmp, out_port => out_tmp, port_id => port_sel, write_strobe => write_tmp, clk => clock, rst => reset);
    mux_tmp <= output_spi when (port_sel(6) = '1') else
                output_uart when (port_sel(4) = '1') else
                (others => '0');
	uart : modulo_uart port map(CLK => clock, RST => reset, PORT_ID => port_sel, INPUT_PORT => out_tmp,OUTPUT_PORT => output_uart, WRITE_STROBE => write_tmp, TX => tx, RX => rx);
    spi : modulo_spi port map(CLK => clock, RST => reset, PORT_ID => port_sel, OUTPUT_PORT => output_spi, MISO => MISO, SCLK => SCLK, SS_N => SS_N, MOSI => MOSI);
	disp : puerto_7segmentos port map(CLK => clock, RST => reset, PORT_ID => port_sel, INPUT_PORT => out_tmp, WRITE_STROBE => write_tmp, SEGMENTOS => display, CONTROL => control);
	salida_leds : puerto_salida_leds port map (CLK => clock, RST => reset, SALIDA => leds, WRITE_STROBE => write_tmp, PORT_ID => port_sel, INPUT_PORT => out_tmp);
	registro: registro_puerto_entrada port map (CLK => clock, RST => reset, D => mux_tmp, Q => in_tmp);
    
end Behavioral;

