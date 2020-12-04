library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity LCD_display is
		port(
		reset: in std_logic;
		clock:in std_logic;
		DA_LCD,CLK_LCD,RST_LCD,DC_LCD,BL_LCD :out std_logic;--wire for LCD
		data_LCD_1 : in integer range 0 to 9;
		data_LCD_2 : in integer range 0 to 9;
		data_LCD_3 : in integer range 0 to 9
		);
end LCD_display;
architecture behavioral of LCD_display is
constant LCDW : integer := 132;
constant LCDH : integer :=162;
constant red : std_logic_vector(15 downto 0):= "1111100000000000";
constant green: std_logic_vector(15 downto 0):= "0000011111100000";
constant blue : std_logic_vector(15 downto 0):= "0000000000011111";
constant black : std_logic_vector(15 downto 0):= "0000000000000000";
constant white : std_logic_vector(15 downto 0):= "1111111111111111";
constant yellow : std_logic_vector(15 downto 0):= "1111111111100000";
constant high : std_logic:= '1';
constant low: std_logic:='0';
constant init_depth : integer := 73;


constant ram1_1 : std_logic_vector(0 to 11):="000000000011";
constant ram1_2 : std_logic_vector(0 to 11):="000000000011";
constant ram1_3 : std_logic_vector(0 to 11):="000000000011";
constant ram1_4 : std_logic_vector(0 to 11):="000000000011";
constant ram1_5 : std_logic_vector(0 to 11):="000000000011";
constant ram1_6 : std_logic_vector(0 to 11):="000000000011";
constant ram1_7 : std_logic_vector(0 to 11):="000000000011";
constant ram1_8 : std_logic_vector(0 to 11):="000000000011";
constant ram1_9 : std_logic_vector(0 to 11):="000000000011";
constant ram1_10 : std_logic_vector(0 to 11):="000000000011";
constant ram1_11 : std_logic_vector(0 to 11):="000000000011";
constant ram1_12 : std_logic_vector(0 to 11):="000000000011";

constant ram0_1 : std_logic_vector(0 to 11):= "011111111110";
constant ram0_2 : std_logic_vector(0 to 11):= "011111111110";
constant ram0_3 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_4 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_5 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_6 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_7 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_8 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_9 : std_logic_vector(0 to 11):= "011000000110";
constant ram0_10 : std_logic_vector(0 to 11):="011000000110";
constant ram0_11 : std_logic_vector(0 to 11):="011111111110";
constant ram0_12 : std_logic_vector(0 to 11):="011111111110";

constant ram2_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram2_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram2_3 : std_logic_vector(0 to 11):= "000000000011";
constant ram2_4 : std_logic_vector(0 to 11):= "000000000011";
constant ram2_5 : std_logic_vector(0 to 11):= "000000000011";
constant ram2_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram2_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram2_8 : std_logic_vector(0 to 11):= "110000000000";
constant ram2_9 : std_logic_vector(0 to 11):= "110000000000";
constant ram2_10 : std_logic_vector(0 to 11):="110000000000";
constant ram2_11 : std_logic_vector(0 to 11):="111111111111";
constant ram2_12 : std_logic_vector(0 to 11):="111111111111";

constant ram3_1 : std_logic_vector(0 to 11):="111111111111";
constant ram3_2 : std_logic_vector(0 to 11):="111111111111";
constant ram3_3 : std_logic_vector(0 to 11):="000000000011";
constant ram3_4 : std_logic_vector(0 to 11):="000000000011";
constant ram3_5 : std_logic_vector(0 to 11):="000000000011";
constant ram3_6 : std_logic_vector(0 to 11):="111111111111";
constant ram3_7 : std_logic_vector(0 to 11):="111111111111";
constant ram3_8 : std_logic_vector(0 to 11):="000000000011";
constant ram3_9 : std_logic_vector(0 to 11):="000000000011";
constant ram3_10 : std_logic_vector(0 to 11):="000000000011";
constant ram3_11 : std_logic_vector(0 to 11):="111111111111";
constant ram3_12 : std_logic_vector(0 to 11):="111111111111";

constant ram4_1 : std_logic_vector(0 to 11):= "110000000011";
constant ram4_2 : std_logic_vector(0 to 11):= "110000000011";
constant ram4_3 : std_logic_vector(0 to 11):= "110000000011";
constant ram4_4 : std_logic_vector(0 to 11):= "110000000011";
constant ram4_5 : std_logic_vector(0 to 11):= "110000000011";
constant ram4_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram4_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram4_8 : std_logic_vector(0 to 11):= "000000000011";
constant ram4_9 : std_logic_vector(0 to 11):= "000000000011";
constant ram4_10 : std_logic_vector(0 to 11):="000000000011";
constant ram4_11 : std_logic_vector(0 to 11):="000000000011";
constant ram4_12 : std_logic_vector(0 to 11):="000000000011";


constant ram5_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram5_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram5_3 : std_logic_vector(0 to 11):= "110000000000";
constant ram5_4 : std_logic_vector(0 to 11):= "110000000000";
constant ram5_5 : std_logic_vector(0 to 11):= "110000000000";
constant ram5_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram5_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram5_8 : std_logic_vector(0 to 11):= "000000000011";
constant ram5_9 : std_logic_vector(0 to 11):= "000000000011";
constant ram5_10 : std_logic_vector(0 to 11):="000000000011";
constant ram5_11 : std_logic_vector(0 to 11):="111111111111";
constant ram5_12 : std_logic_vector(0 to 11):="111111111111";

constant ram6_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram6_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram6_3 : std_logic_vector(0 to 11):= "110000000000";
constant ram6_4 : std_logic_vector(0 to 11):= "110000000000";
constant ram6_5 : std_logic_vector(0 to 11):= "110000000000";
constant ram6_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram6_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram6_8 : std_logic_vector(0 to 11):= "110000000011";
constant ram6_9 : std_logic_vector(0 to 11):= "110000000011";
constant ram6_10 : std_logic_vector(0 to 11):="110000000011";
constant ram6_11 : std_logic_vector(0 to 11):="111111111111";
constant ram6_12 : std_logic_vector(0 to 11):="111111111111";


constant ram7_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram7_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram7_3 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_4 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_5 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_6 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_7 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_8 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_9 : std_logic_vector(0 to 11):= "000000000011";
constant ram7_10 : std_logic_vector(0 to 11):="000000000011";
constant ram7_11 : std_logic_vector(0 to 11):="000000000011";
constant ram7_12 : std_logic_vector(0 to 11):="000000000011";

constant ram8_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram8_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram8_3 : std_logic_vector(0 to 11):= "110000000011";
constant ram8_4 : std_logic_vector(0 to 11):= "110000000011";
constant ram8_5 : std_logic_vector(0 to 11):= "110000000011";
constant ram8_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram8_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram8_8 : std_logic_vector(0 to 11):= "110000000011";
constant ram8_9 : std_logic_vector(0 to 11):= "110000000011";
constant ram8_10 : std_logic_vector(0 to 11):="110000000011";
constant ram8_11 : std_logic_vector(0 to 11):="111111111111";
constant ram8_12 : std_logic_vector(0 to 11):="111111111111";

constant ram9_1 : std_logic_vector(0 to 11):= "111111111111";
constant ram9_2 : std_logic_vector(0 to 11):= "111111111111";
constant ram9_3 : std_logic_vector(0 to 11):= "110000000011";
constant ram9_4 : std_logic_vector(0 to 11):= "110000000011";
constant ram9_5 : std_logic_vector(0 to 11):= "110000000011";
constant ram9_6 : std_logic_vector(0 to 11):= "111111111111";
constant ram9_7 : std_logic_vector(0 to 11):= "111111111111";
constant ram9_8 : std_logic_vector(0 to 11):= "000000000011";
constant ram9_9 : std_logic_vector(0 to 11):= "000000000011";
constant ram9_10 : std_logic_vector(0 to 11):="000000000011";
constant ram9_11 : std_logic_vector(0 to 11):="111111111111";
constant ram9_12 : std_logic_vector(0 to 11):="111111111111";


type LCD_state is (idle,main,init,scan,write,delay);
begin

process (clock)
variable data_reg: std_logic_vector(8 downto 0);
variable cnt_main,cnt_scan :integer range 0 to 7;
variable cnt_write :integer range 0 to 31;
variable cnt_delay,num_delay,cnt,cnt_init : integer range 0 to 65535;
variable state,state_back:LCD_state:= idle;
variable high_word: std_logic;
variable x_cnt,y_cnt:integer range 0 to 255;
variable data_r:std_logic_vector(131 downto 0):=(others=>'0');
begin
 if (clock'event and clock = '1')then 
	if (reset = '0') then 
		x_cnt := 0;
		y_cnt := 0;
		cnt_main := 0;
		cnt_scan:=0;
		cnt_write := 0;
		cnt_init := 0;
		cnt_delay := 0;
		num_delay := 50;
		high_word :='1';
		BL_LCD <= low;
		state := IDLE;
		state_back := IDLE;
	else
		case state is
			when IDLE =>
				x_cnt := 0;
				y_cnt := 0;
				cnt_main := 0;
				cnt_scan:=0;
				cnt_write := 0;
				cnt_init := 0;
				cnt_delay := 0;
				num_delay := 50;
				high_word :='1';
				BL_LCD <= low;
				state := main;
				state_back := main;
			when main=>
				case cnt_main is
					when 0=> cnt_main:=1;state:=init;
					when 1=> cnt_main:=2;state:= scan;
					when 2=> cnt_main:=1;
					when others => state := IDLE;
				end case;
			when init=>
				case cnt_init is 
					when 0=> RST_LCD <= '0';cnt_init:= cnt_init + 1;
					when 1=> num_delay := 3000;state:=delay;state_back:=init;cnt_init := cnt_init + 1;
					when 2=> RST_LCD <= '1';cnt_init := cnt_init + 1;
					when 3=> num_delay := 3000;state:= delay;state_back:= init;cnt_init := cnt_init + 1;
					when 4=> if (cnt >= init_depth) then 
									cnt := 0;
									cnt_init := cnt_init + 1;
							  else 
									case cnt is
										when 0 => data_reg := "000010001";num_delay := 50000;cnt:=cnt + 1;state := write ;state_back := init;
										when 1 => data_reg := "010110001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 2 => data_reg := "100000101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 3 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 4 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 5 => data_reg := "010110010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 6 => data_reg := "100000101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 7 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 8 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 9 => data_reg := "010110011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 10 => data_reg := "100000101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 11 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 12 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 13 => data_reg := "100000101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 14 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 15 => data_reg := "100111100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 16 => data_reg := "010110100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 17 => data_reg := "100000011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 18 => data_reg := "011000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 19 => data_reg := "100101000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 20 => data_reg := "100001000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 21 => data_reg := "100000100";num_delay := 50 ;cnt:=cnt + 1;state := write ;state_back := init;
										when 22 => data_reg := "011000001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 23 => data_reg := "111000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 24 => data_reg := "011000010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 25 => data_reg := "100001101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 26 => data_reg := "100000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 27=> data_reg := "011000011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 28 => data_reg := "110001101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 29 => data_reg := "100101010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 30 => data_reg := "011010100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 31 => data_reg := "110001101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 32 => data_reg := "111101110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 33 => data_reg := "000011010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 34 => data_reg := "000110110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 35 => data_reg := "111000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 36 => data_reg := "011100000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 37 => data_reg := "100000100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 38 => data_reg := "100100010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 39 => data_reg := "100000111";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 40 => data_reg := "100001010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 41 => data_reg := "100101110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 42 => data_reg := "100110000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 43 => data_reg := "100100101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 44=> data_reg := "100101010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 45 => data_reg := "100101000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 46 => data_reg := "100100110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 47 => data_reg := "100101110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 48 => data_reg := "100111010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 49 => data_reg := "100000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 50 => data_reg := "100000001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 51 => data_reg := "100000011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 52 => data_reg := "100010011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 53 => data_reg := "011100001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 54 => data_reg := "100000100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 55 => data_reg := "100010110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 56 => data_reg := "100000110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 57 => data_reg := "100001101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 58 => data_reg := "100101101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 59 => data_reg := "100100110";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 60 => data_reg := "100100011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 61 => data_reg := "100100111";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 62 => data_reg := "100100111";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 63 => data_reg := "100100101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 64 => data_reg := "100101101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 65 => data_reg := "100111011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 66 => data_reg := "100000000";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 67 => data_reg := "100000001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 68 => data_reg := "100000100";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 69 => data_reg := "100010011";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 70 => data_reg := "000111010";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 71 => data_reg := "100000101";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when 72 => data_reg := "000101001";num_delay := 50;cnt:=cnt + 1;state := write ;state_back := init;
										when others => state  :=  IDLE;
									end case;
								end if;
					when 5=> cnt_init := 0;state := main ;
					when others => state := idle;
					end case;
				when scan =>
						case cnt_scan is 
							when 0 => 
								if (cnt >=11) then
									cnt:=0;
									cnt_scan := cnt_scan + 1;
								else 	
									case cnt is
										when 0 => data_reg := "000101010";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 1 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 2 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 3 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 4 => data_reg := "110000011";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 5 => data_reg := "000101011";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 6 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 7 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 8 => data_reg := "100000000";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 9 => data_reg := "110100001";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when 10 => data_reg :="000101100";cnt :=cnt + 1;num_delay := 50; state := write;state_back := scan;
										when others => state  := IDLE;
									end case;
								end if;
							when 1 => 
								if (x_cnt <= 0) then 
									x_cnt := LCDW;
									if (y_cnt >= LCDH) then 
										y_cnt := 0;
										cnt_scan := cnt_scan + 1;
									else 
										y_cnt := y_cnt + 1;
										cnt_scan := 1;
									end if;
								else 
								    										
							case data_LCD_1 is
							 when 0=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(121 downto 110):=ram0_1;
										  when 2=> data_r(121 downto 110):=ram0_2;
										  when 3=> data_r(121 downto 110):=ram0_3;
										  when 4=> data_r(121 downto 110):=ram0_4;
										  when 5=> data_r(121 downto 110):=ram0_5;
										  when 6=> data_r(121 downto 110):=ram0_6;
										  when 7=> data_r(121 downto 110):=ram0_7;
										  when 8=> data_r(121 downto 110):=ram0_8;
										  when 9=> data_r(121 downto 110):=ram0_9;
										  when 10=> data_r(121 downto 110):=ram0_10;
										  when 11=> data_r(121 downto 110):=ram0_11;
										  when 12=> data_r(121 downto 110):=ram0_12;
										  when others=> data_r:=(others=>'0');
									end case;
						     when 1=>	
                                   
								    case y_cnt is
									      when 0=> data_r:=(others=>'0');
										  when 1=> data_r(121 downto 110):=ram1_1;
										  when 2=> data_r(121 downto 110):=ram1_2;
										  when 3=> data_r(121 downto 110):=ram1_3;
										  when 4=> data_r(121 downto 110):=ram1_4;
										  when 5=> data_r(121 downto 110):=ram1_5;
										  when 6=> data_r(121 downto 110):=ram1_6;
										  when 7=> data_r(121 downto 110):=ram1_7;
										  when 8=> data_r(121 downto 110):=ram1_8;
										  when 9=> data_r(121 downto 110):=ram1_9;
										  when 10=> data_r(121 downto 110):=ram1_10;
										  when 11=> data_r(121 downto 110):=ram1_11;
										  when 12=> data_r(121 downto 110):=ram1_12;
										  when others=> data_r:=(others=>'0');
								   end case;
								   
								    when 2=>	
                                   
								    case y_cnt is
									      when 0=> data_r:=(others=>'0');
										  when 1=> data_r(121 downto 110):=ram2_1;
										  when 2=> data_r(121 downto 110):=ram2_2;
										  when 3=> data_r(121 downto 110):=ram2_3;
										  when 4=> data_r(121 downto 110):=ram2_4;
										  when 5=> data_r(121 downto 110):=ram2_5;
										  when 6=> data_r(121 downto 110):=ram2_6;
										  when 7=> data_r(121 downto 110):=ram2_7;
										  when 8=> data_r(121 downto 110):=ram2_8;
										  when 9=> data_r(121 downto 110):=ram2_9;
										  when 10=> data_r(121 downto 110):=ram2_10;
										  when 11=> data_r(121 downto 110):=ram2_11;
										  when 12=> data_r(121 downto 110):=ram2_12;
										  when others=> data_r:=(others=>'0');
								   end case;
								   
								    when 3=>	
                                   
								    case y_cnt is
									      when 0=> data_r:=(others=>'0');
										  when 1=> data_r(121 downto 110):=ram3_1;
										  when 2=> data_r(121 downto 110):=ram3_2;
										  when 3=> data_r(121 downto 110):=ram3_3;
										  when 4=> data_r(121 downto 110):=ram3_4;
										  when 5=> data_r(121 downto 110):=ram3_5;
										  when 6=> data_r(121 downto 110):=ram3_6;
										  when 7=> data_r(121 downto 110):=ram3_7;
										  when 8=> data_r(121 downto 110):=ram3_8;
										  when 9=> data_r(121 downto 110):=ram3_9;
										  when 10=> data_r(121 downto 110):=ram3_10;
										  when 11=> data_r(121 downto 110):=ram3_11;
										  when 12=> data_r(121 downto 110):=ram3_12;
										  when others=> data_r:=(others=>'0');
								   end case;
						    end case;
							
							case data_LCD_2 is
							
							when 0=>

								    case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram0_1;
										  when 2=> data_r(102 downto 91):=ram0_2;
										  when 3=> data_r(102 downto 91):=ram0_3;
										  when 4=> data_r(102 downto 91):=ram0_4;
										  when 5=> data_r(102 downto 91):=ram0_5;
										  when 6=> data_r(102 downto 91):=ram0_6;
										  when 7=> data_r(102 downto 91):=ram0_7;
										  when 8=> data_r(102 downto 91):=ram0_8;
										  when 9=> data_r(102 downto 91):=ram0_9;
										  when 10=> data_r(102 downto 91):=ram0_10;
										  when 11=> data_r(102 downto 91):=ram0_11;
										  when 12=> data_r(102 downto 91):=ram0_12;
										  when others=> data_r:=(others=>'0');
									end case;
									
							when 1=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram1_1;
										  when 2=> data_r(102 downto 91):=ram1_2;
										  when 3=> data_r(102 downto 91):=ram1_3;
										  when 4=> data_r(102 downto 91):=ram1_4;
										  when 5=> data_r(102 downto 91):=ram1_5;
										  when 6=> data_r(102 downto 91):=ram1_6;
										  when 7=> data_r(102 downto 91):=ram1_7;
										  when 8=> data_r(102 downto 91):=ram1_8;
										  when 9=> data_r(102 downto 91):=ram1_9;
										  when 10=> data_r(102 downto 91):=ram1_10;
										  when 11=> data_r(102 downto 91):=ram1_11;
										  when 12=> data_r(102 downto 91):=ram1_12;
										  when others=> data_r:=(others=>'0');
									end case;
							when 2=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram2_1;
										  when 2=> data_r(102 downto 91):=ram2_2;
										  when 3=> data_r(102 downto 91):=ram2_3;
										  when 4=> data_r(102 downto 91):=ram2_4;
										  when 5=> data_r(102 downto 91):=ram2_5;
										  when 6=> data_r(102 downto 91):=ram2_6;
										  when 7=> data_r(102 downto 91):=ram2_7;
										  when 8=> data_r(102 downto 91):=ram2_8;
										  when 9=> data_r(102 downto 91):=ram2_9;
										  when 10=> data_r(102 downto 91):=ram2_10;
										  when 11=> data_r(102 downto 91):=ram2_11;
										  when 12=> data_r(102 downto 91):=ram2_12;
										  when others=> data_r:=(others=>'0');
									end case;		
                            when 3=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram3_1;
										  when 2=> data_r(102 downto 91):=ram3_2;
										  when 3=> data_r(102 downto 91):=ram3_3;
										  when 4=> data_r(102 downto 91):=ram3_4;
										  when 5=> data_r(102 downto 91):=ram3_5;
										  when 6=> data_r(102 downto 91):=ram3_6;
										  when 7=> data_r(102 downto 91):=ram3_7;
										  when 8=> data_r(102 downto 91):=ram3_8;
										  when 9=> data_r(102 downto 91):=ram3_9;
										  when 10=> data_r(102 downto 91):=ram3_10;
										  when 11=> data_r(102 downto 91):=ram3_11;
										  when 12=> data_r(102 downto 91):=ram3_12;
										  when others=> data_r:=(others=>'0');
									end case;										
                            when 4=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram4_1;
										  when 2=> data_r(102 downto 91):=ram4_2;
										  when 3=> data_r(102 downto 91):=ram4_3;
										  when 4=> data_r(102 downto 91):=ram4_4;
										  when 5=> data_r(102 downto 91):=ram4_5;
										  when 6=> data_r(102 downto 91):=ram4_6;
										  when 7=> data_r(102 downto 91):=ram4_7;
										  when 8=> data_r(102 downto 91):=ram4_8;
										  when 9=> data_r(102 downto 91):=ram4_9;
										  when 10=> data_r(102 downto 91):=ram4_10;
										  when 11=> data_r(102 downto 91):=ram4_11;
										  when 12=> data_r(102 downto 91):=ram4_12;
										  when others=> data_r:=(others=>'0');
									end case;																			
						    when 5=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram5_1;
										  when 2=> data_r(102 downto 91):=ram5_2;
										  when 3=> data_r(102 downto 91):=ram5_3;
										  when 4=> data_r(102 downto 91):=ram5_4;
										  when 5=> data_r(102 downto 91):=ram5_5;
										  when 6=> data_r(102 downto 91):=ram5_6;
										  when 7=> data_r(102 downto 91):=ram5_7;
										  when 8=> data_r(102 downto 91):=ram5_8;
										  when 9=> data_r(102 downto 91):=ram5_9;
										  when 10=> data_r(102 downto 91):=ram5_10;
										  when 11=> data_r(102 downto 91):=ram5_11;
										  when 12=> data_r(102 downto 91):=ram5_12;
										  when others=> data_r:=(others=>'0');
									end case;		
when 6=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram6_1;
										  when 2=> data_r(102 downto 91):=ram6_2;
										  when 3=> data_r(102 downto 91):=ram6_3;
										  when 4=> data_r(102 downto 91):=ram6_4;
										  when 5=> data_r(102 downto 91):=ram6_5;
										  when 6=> data_r(102 downto 91):=ram6_6;
										  when 7=> data_r(102 downto 91):=ram6_7;
										  when 8=> data_r(102 downto 91):=ram6_8;
										  when 9=> data_r(102 downto 91):=ram6_9;
										  when 10=> data_r(102 downto 91):=ram6_10;
										  when 11=> data_r(102 downto 91):=ram6_11;
										  when 12=> data_r(102 downto 91):=ram6_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 7=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram7_1;
										  when 2=> data_r(102 downto 91):=ram7_2;
										  when 3=> data_r(102 downto 91):=ram7_3;
										  when 4=> data_r(102 downto 91):=ram7_4;
										  when 5=> data_r(102 downto 91):=ram7_5;
										  when 6=> data_r(102 downto 91):=ram7_6;
										  when 7=> data_r(102 downto 91):=ram7_7;
										  when 8=> data_r(102 downto 91):=ram7_8;
										  when 9=> data_r(102 downto 91):=ram7_9;
										  when 10=> data_r(102 downto 91):=ram7_10;
										  when 11=> data_r(102 downto 91):=ram7_11;
										  when 12=> data_r(102 downto 91):=ram7_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 8=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram8_1;
										  when 2=> data_r(102 downto 91):=ram8_2;
										  when 3=> data_r(102 downto 91):=ram8_3;
										  when 4=> data_r(102 downto 91):=ram8_4;
										  when 5=> data_r(102 downto 91):=ram8_5;
										  when 6=> data_r(102 downto 91):=ram8_6;
										  when 7=> data_r(102 downto 91):=ram8_7;
										  when 8=> data_r(102 downto 91):=ram8_8;
										  when 9=> data_r(102 downto 91):=ram8_9;
										  when 10=> data_r(102 downto 91):=ram8_10;
										  when 11=> data_r(102 downto 91):=ram8_11;
										  when 12=> data_r(102 downto 91):=ram8_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 9=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(102 downto 91):=ram9_1;
										  when 2=> data_r(102 downto 91):=ram9_2;
										  when 3=> data_r(102 downto 91):=ram9_3;
										  when 4=> data_r(102 downto 91):=ram9_4;
										  when 5=> data_r(102 downto 91):=ram9_5;
										  when 6=> data_r(102 downto 91):=ram9_6;
										  when 7=> data_r(102 downto 91):=ram9_7;
										  when 8=> data_r(102 downto 91):=ram9_8;
										  when 9=> data_r(102 downto 91):=ram9_9;
										  when 10=> data_r(102 downto 91):=ram9_10;
										  when 11=> data_r(102 downto 91):=ram9_11;
										  when 12=> data_r(102 downto 91):=ram9_12;
										  when others=> data_r:=(others=>'0');
									end case;
end case;						
                case data_LCD_3 is
							
							when 0=>

								    case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram0_1;
										  when 2=> data_r(89 downto 78):=ram0_2;
										  when 3=> data_r(89 downto 78):=ram0_3;
										  when 4=> data_r(89 downto 78):=ram0_4;
										  when 5=> data_r(89 downto 78):=ram0_5;
										  when 6=> data_r(89 downto 78):=ram0_6;
										  when 7=> data_r(89 downto 78):=ram0_7;
										  when 8=> data_r(89 downto 78):=ram0_8;
										  when 9=> data_r(89 downto 78):=ram0_9;
										  when 10=> data_r(89 downto 78):=ram0_10;
										  when 11=> data_r(89 downto 78):=ram0_11;
										  when 12=> data_r(89 downto 78):=ram0_12;
										  when others=> data_r:=(others=>'0');
									end case;
									
							when 1=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram1_1;
										  when 2=> data_r(89 downto 78):=ram1_2;
										  when 3=> data_r(89 downto 78):=ram1_3;
										  when 4=> data_r(89 downto 78):=ram1_4;
										  when 5=> data_r(89 downto 78):=ram1_5;
										  when 6=> data_r(89 downto 78):=ram1_6;
										  when 7=> data_r(89 downto 78):=ram1_7;
										  when 8=> data_r(89 downto 78):=ram1_8;
										  when 9=> data_r(89 downto 78):=ram1_9;
										  when 10=> data_r(89 downto 78):=ram1_10;
										  when 11=> data_r(89 downto 78):=ram1_11;
										  when 12=> data_r(89 downto 78):=ram1_12;
										  when others=> data_r:=(others=>'0');
									end case;
							when 2=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram2_1;
										  when 2=> data_r(89 downto 78):=ram2_2;
										  when 3=> data_r(89 downto 78):=ram2_3;
										  when 4=> data_r(89 downto 78):=ram2_4;
										  when 5=> data_r(89 downto 78):=ram2_5;
										  when 6=> data_r(89 downto 78):=ram2_6;
										  when 7=> data_r(89 downto 78):=ram2_7;
										  when 8=> data_r(89 downto 78):=ram2_8;
										  when 9=> data_r(89 downto 78):=ram2_9;
										  when 10=> data_r(89 downto 78):=ram2_10;
										  when 11=> data_r(89 downto 78):=ram2_11;
										  when 12=> data_r(89 downto 78):=ram2_12;
										  when others=> data_r:=(others=>'0');
									end case;		
                            when 3=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram3_1;
										  when 2=> data_r(89 downto 78):=ram3_2;
										  when 3=> data_r(89 downto 78):=ram3_3;
										  when 4=> data_r(89 downto 78):=ram3_4;
										  when 5=> data_r(89 downto 78):=ram3_5;
										  when 6=> data_r(89 downto 78):=ram3_6;
										  when 7=> data_r(89 downto 78):=ram3_7;
										  when 8=> data_r(89 downto 78):=ram3_8;
										  when 9=> data_r(89 downto 78):=ram3_9;
										  when 10=> data_r(89 downto 78):=ram3_10;
										  when 11=> data_r(89 downto 78):=ram3_11;
										  when 12=> data_r(89 downto 78):=ram3_12;
										  when others=> data_r:=(others=>'0');
									end case;										
                            when 4=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram4_1;
										  when 2=> data_r(89 downto 78):=ram4_2;
										  when 3=> data_r(89 downto 78):=ram4_3;
										  when 4=> data_r(89 downto 78):=ram4_4;
										  when 5=> data_r(89 downto 78):=ram4_5;
										  when 6=> data_r(89 downto 78):=ram4_6;
										  when 7=> data_r(89 downto 78):=ram4_7;
										  when 8=> data_r(89 downto 78):=ram4_8;
										  when 9=> data_r(89 downto 78):=ram4_9;
										  when 10=> data_r(89 downto 78):=ram4_10;
										  when 11=> data_r(89 downto 78):=ram4_11;
										  when 12=> data_r(89 downto 78):=ram4_12;
										  when others=> data_r:=(others=>'0');
									end case;																			
						    when 5=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram5_1;
										  when 2=> data_r(89 downto 78):=ram5_2;
										  when 3=> data_r(89 downto 78):=ram5_3;
										  when 4=> data_r(89 downto 78):=ram5_4;
										  when 5=> data_r(89 downto 78):=ram5_5;
										  when 6=> data_r(89 downto 78):=ram5_6;
										  when 7=> data_r(89 downto 78):=ram5_7;
										  when 8=> data_r(89 downto 78):=ram5_8;
										  when 9=> data_r(89 downto 78):=ram5_9;
										  when 10=> data_r(89 downto 78):=ram5_10;
										  when 11=> data_r(89 downto 78):=ram5_11;
										  when 12=> data_r(89 downto 78):=ram5_12;
										  when others=> data_r:=(others=>'0');
									end case;		
when 6=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram6_1;
										  when 2=> data_r(89 downto 78):=ram6_2;
										  when 3=> data_r(89 downto 78):=ram6_3;
										  when 4=> data_r(89 downto 78):=ram6_4;
										  when 5=> data_r(89 downto 78):=ram6_5;
										  when 6=> data_r(89 downto 78):=ram6_6;
										  when 7=> data_r(89 downto 78):=ram6_7;
										  when 8=> data_r(89 downto 78):=ram6_8;
										  when 9=> data_r(89 downto 78):=ram6_9;
										  when 10=> data_r(89 downto 78):=ram6_10;
										  when 11=> data_r(89 downto 78):=ram6_11;
										  when 12=> data_r(89 downto 78):=ram6_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 7=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram7_1;
										  when 2=> data_r(89 downto 78):=ram7_2;
										  when 3=> data_r(89 downto 78):=ram7_3;
										  when 4=> data_r(89 downto 78):=ram7_4;
										  when 5=> data_r(89 downto 78):=ram7_5;
										  when 6=> data_r(89 downto 78):=ram7_6;
										  when 7=> data_r(89 downto 78):=ram7_7;
										  when 8=> data_r(89 downto 78):=ram7_8;
										  when 9=> data_r(89 downto 78):=ram7_9;
										  when 10=> data_r(89 downto 78):=ram7_10;
										  when 11=> data_r(89 downto 78):=ram7_11;
										  when 12=> data_r(89 downto 78):=ram7_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 8=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram8_1;
										  when 2=> data_r(89 downto 78):=ram8_2;
										  when 3=> data_r(89 downto 78):=ram8_3;
										  when 4=> data_r(89 downto 78):=ram8_4;
										  when 5=> data_r(89 downto 78):=ram8_5;
										  when 6=> data_r(89 downto 78):=ram8_6;
										  when 7=> data_r(89 downto 78):=ram8_7;
										  when 8=> data_r(89 downto 78):=ram8_8;
										  when 9=> data_r(89 downto 78):=ram8_9;
										  when 10=> data_r(89 downto 78):=ram8_10;
										  when 11=> data_r(89 downto 78):=ram8_11;
										  when 12=> data_r(89 downto 78):=ram8_12;
										  when others=> data_r:=(others=>'0');
									end case;			
when 9=>

								     case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(89 downto 78):=ram9_1;
										  when 2=> data_r(89 downto 78):=ram9_2;
										  when 3=> data_r(89 downto 78):=ram9_3;
										  when 4=> data_r(89 downto 78):=ram9_4;
										  when 5=> data_r(89 downto 78):=ram9_5;
										  when 6=> data_r(89 downto 78):=ram9_6;
										  when 7=> data_r(89 downto 78):=ram9_7;
										  when 8=> data_r(89 downto 78):=ram9_8;
										  when 9=> data_r(89 downto 78):=ram9_9;
										  when 10=> data_r(89 downto 78):=ram9_10;
										  when 11=> data_r(89 downto 78):=ram9_11;
										  when 12=> data_r(89 downto 78):=ram9_12;
										  when others=> data_r:=(others=>'0');
									end case;
end case;			
                             case y_cnt is
										  when 0=> data_r:=(others=>'0');
										  when 1=> data_r(107 downto 105):="000"; data_r(75 downto 60):="1110000000000111"; 
										  when 2=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0111000000001110"; 
										  when 3=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0111000000001110"; 
										  when 4=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0011100000011100"; 
										  when 5=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0011100000011100"; 
										  when 6=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0001110000111000"; 
										  when 7=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0001110000111000"; 
										  when 8=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0000111001110000"; 
										  when 9=> data_r(107 downto 105):="000"; data_r(75 downto 60):="0000111001110000"; 
										  when 10=> data_r(107 downto 105):="111";data_r(75 downto 60):="0000011001100000"; 
										  when 11=> data_r(107 downto 105):="111";data_r(75 downto 60):="0000001111000000"; 
										  when 12=> data_r(107 downto 105):="111";data_r(75 downto 60):="0000001111000000"; 
										  
										  when others=> data_r:=(others=>'0');
									end case;

									if (high_word = '1') then 
										if (data_r(x_cnt) = '1')then
											data_reg := '1'& yellow(15 downto 8);
										else 
											data_reg :='1'& black(15 downto 8);
										end if;
									else 
										if (data_r(x_cnt) = '1')then
											data_reg := '1'&yellow(7 downto 0);
										else 
											data_reg :='1'& black(7 downto 0);
										end if;
										x_cnt := x_cnt - 1;	
									end if;
										high_word := not high_word;
										num_delay := 50;
										state := write ;
										state_back := scan;
								end if;
							when 2 =>
									cnt_scan := 0;
									BL_LCD <= high;
									state := main;
							when others =>
									state := IDLE;
							end case;
				when write =>
					if (cnt_write>= 18) then 
						cnt_write := 0;
					else 
						cnt_write := cnt_write + 1;
						case cnt_write is 
							when 1 => DC_LCD <= data_reg(8);
							when 2 => CLK_LCD <= low;DA_LCD<= data_reg(7);
							when 3 => CLK_LCD <= high;
							when 4 => CLK_LCD <= low;DA_LCD <=data_reg(6);
							when 5 => CLK_LCD <= high;
							when 6 => CLK_LCD <= low;DA_LCD <=data_reg(5);
							when 7 => CLK_LCD <= high;
							when 8 => CLK_LCD <= low;DA_LCD<= data_reg(4);
							when 9 => CLK_LCD <= high;
							when 10 => CLK_LCD <= low;DA_LCD <=data_reg(3);
							when 11 => CLK_LCD <= high;
							when 12 => CLK_LCD <= low;DA_LCD <=data_reg(2);
							when 13 => CLK_LCD <= high;
							when 14 => CLK_LCD <= low;DA_LCD <=data_reg(1);
							when 15 => CLK_LCD <= high;
							when 16 => CLK_LCD <= low;DA_LCD <=data_reg(0);
							when 17 => CLK_LCD <= high;
							when 18 => CLK_LCD <= low;state := delay;
							when others => state :=  IDLE;	
						end case;					end if;
				when delay =>
					if (cnt_delay >= num_delay) then
						cnt_delay := 0;
						state := state_back;
					else 
						cnt_delay := cnt_delay + 1;
					end if;
				when others => state := IDLE;
			end case;
	end if;
end if;
end process;

end behavioral;