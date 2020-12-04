library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_data_types.all;
 
entity ADC_I2C is
port( 
	clk_in:in std_logic;
	rst_n_in:in std_logic;
	scl_out:out std_logic;
	sda_out:inout std_logic;
	adc_done:out std_logic;
	--I2C读取的数据
	adc_data:inout std_logic_vector(7 downto 0);
	din:out std_logic;		--data stream to 595
	sck:out std_logic;		--595 shift clock
	rck:out std_logic;		--595 output pulse
	DA_LCD :out std_logic;
	DC_LCD :out std_logic;
	CLK_LCD :out std_logic;
	RST_LCD :out std_logic;
	BL_LCD :out std_logic;
	mode_key:in std_logic
);
end entity;

architecture ADC_arch of ADC_I2C is
--常量定义
constant CNT_NUM: integer:= 15;
constant IDLE: integer:= 0;
constant MAIN: integer:= 1;
constant START: integer:= 2;
constant WRITING: integer:= 3;
constant READING: integer:= 4;
constant STOP: integer:= 5;
--信号定义
signal clk_400khz: std_logic;
signal cnt_400khz: integer range 0 to 31;

signal adc_data_r: std_logic_vector(7 downto 0);
signal scl_out_r: std_logic;
signal sda_out_r: std_logic;
signal cnt: integer range 0 to 7;
signal cnt_main: integer range 0 to 15;
signal data_wr: std_logic_vector(7 downto 0);
signal cnt_start: integer range 0 to 7;
signal cnt_write: integer range 0 to 7;
signal cnt_read: integer range 0 to 31;
signal cnt_stop: integer range 0 to 7;
signal state: integer range 0 to 7;
signal Voltage:integer range 0 to 3300;

 -----------------------Signals Declaration-------------------

 ---------------------End Signals Declaration-----------------	
 ------------------Constant Table Declaration---------------
 type TwoDim_Array_Int is array(natural range <>) of integer;		--define 2D array
 
 constant digit5:TwoDim_Array_Int(0 to 1):=(10,11);
 
 type TwoDim_Array is array(natural range <>) of std_logic_vector(7 downto 0);		--define 2D array

 constant enDig:TwoDim_Array(0 to 6):=(		--enable each digit
 "01111111","10111111","11011111",
 "11101111","11110111","11111011",
 "11111111");

 constant segmentdecode:TwoDim_Array(0 to 16):=(		--decoder fot each num, 16 is off
 "11111100","01100000","11011010","11110010",
 "01100110","10110110","10111110","11100000",
 "11111110","11110110","11101110","00111110",
 "10011100","01111010","10011110","10001110",
 "00000000");

 constant segmentdecode_dp:TwoDim_Array(0 to 16):=(		--decoder fot each num, 16 is off, lighten the digit point
 "11111101","01100001","11011011","11110011",
 "01100111","10110111","10111111","11100001",
 "11111111","11110111","11101111","00111111",
 "10011101","01111011","10011111","10001111",
 "00000000");

 signal shift_clock_cnt:integer:=0;		--counter
 signal shift_clock:std_logic:='1';
 signal shift_clock_ls:std_logic;
 signal shift_cnt:integer range 0 to 15;
 signal parallout:std_logic;		--parallel out pulse
 signal mode: integer;
 signal codeP: integer range 0 to 5;  --indicate which part of ctrl code is being sent
 signal codeP0: std_logic_vector(15 downto 0);
 signal codeP1: std_logic_vector(15 downto 0);
 signal codeP2: std_logic_vector(15 downto 0);
 signal codeP3: std_logic_vector(15 downto 0);
 signal codeP4: std_logic_vector(15 downto 0);
 signal codeP5: std_logic_vector(15 downto 0);
 --signal box: std_logic_vector(17 downto 0);
 signal DataOut: integer_number (2 downto 0);--0-255
 signal DataV: integer_number(3 downto 0);--0-3300
 signal tmp: integer range 0 to 99999:=0;
 signal temp: integer_number(3 downto 0);
 signal da,db,dc,dd,de:std_logic_vector(3 downto 0);
 signal de3,de2,de1,de0: std_logic;
 signal de3_1,de2_1,de1_1,de0_1: integer;

 signal dd3,dd2,dd1,dd0: std_logic;
 signal dd3_1,dd2_1,dd1_1,dd0_1: integer;
 signal dc3,dc2,dc1,dc0: std_logic;
 signal dc3_1,dc2_1,dc1_1,dc0_1: integer;

 signal db3,db2,db1,db0: std_logic;
 signal db3_1,db2_1,db1_1,db0_1: integer;
 signal da3,da2,da1,da0: std_logic;
 signal da3_1,da2_1,da1_1,da0_1: integer;
 signal ctrlcode595: std_logic_vector(95 downto 0);
 
  --component for mode controller
 component ModeCtrller is
 port(
	clk:in std_logic;
	rst:in std_logic;
	
	modekey:in std_logic;
	
	mode:out integer
 );
 end component ModeCtrller;
 
 component LCD_display is
		port(
		reset: in std_logic;
		clock:in std_logic;
		DA_LCD,CLK_LCD,RST_LCD,DC_LCD,BL_LCD :out std_logic;--wire for LCD
		data_LCD_1 : in integer range 0 to 9;
		data_LCD_2 : in integer range 0 to 9;
		data_LCD_3 : in integer range 0 to 9
		);
end  component LCD_display;

begin
MC:ModeCtrller PORT MAP (clk_in,rst_n_in,mode_key,mode);
process(clk_in,rst_n_in)

begin
	
	if (clk_in'event and clk_in = '1') then
		if (cnt_400khz >= CNT_NUM - 1) then
			cnt_400khz <= 0;
			clk_400khz <= not clk_400khz;
		else
			cnt_400khz <= cnt_400khz + 1;
		end if;
	end if;
end process;

process(clk_400khz,rst_n_in)
    variable bcd: std_logic_vector (11 downto 0) ;
	variable binx : std_logic_vector (7 downto 0) ;
begin
	if (clk_400khz'event and clk_400khz = '1') then
		if (rst_n_in = '0') then
			scl_out_r <= '1';
			sda_out_r <= '1';
			cnt <= 0;
            cnt_main <= 0;
            cnt_start <= 0;
            cnt_write <= 0;
            cnt_read <= 0;
            cnt_stop <= 0;
			adc_done <= '0';
			adc_data <= x"00";
            state <= IDLE;
		else
			case(state) is
				when IDLE =>
					scl_out_r <= '1';
					sda_out_r <= '1';
					cnt <= 0;
					cnt_main <= 0;
					cnt_start <= 0;
					cnt_write <= 0;
					cnt_read <= 0;
					cnt_stop <= 0;
					adc_done <= '0';
					state <= MAIN;
				when MAIN =>
					if(cnt_main >= 6) then
						cnt_main <= 6;  --对MAIN中的子状态执行控制cnt_main
					else 
						cnt_main <= cnt_main + 1;
					end if;
					case(cnt_main) is
						when 0 => state <= START; 	--I2C通信时序中的START
						when 1 => data_wr <= x"90"; state <= WRITING; 	--A0,A1,A2都接了GND，写地址为8'h90
						when 2 => data_wr <= x"00"; state <= WRITING; 	--control byte为8'h00，采用4通道ADC中的通道0
						when 3 => state <= STOP;	--I2C通信时序中的START
						when 4 => state <= START; 	--I2C通信时序中的STOP
						when 5 => data_wr <= x"91"; state <= WRITING; 	--A0 A1 A2都接了GND，读地址为8'h91
						when 6 => state <= READING; adc_done <= '0'; --读取ADC的采样数据
						when 7 => state <= STOP; adc_done <= '1'; 	--I2C通信时序中的STOP，读取完成标志
						when 8 => state <= MAIN; 	--预留状态，不执行
						when others => state <= IDLE;	--如果程序失控，进入IDLE自复位状态
					end case;
				when START =>   --I2C通信时序中的起始START
					if(cnt_start >= 5) then
						cnt_start <= 0;	--对START中的子状态执行控制cnt_start
					else 
						cnt_start <= cnt_start + 1;
					end if;
					case(cnt_start) is
						when 0 => sda_out_r <= '1'; scl_out_r <= '1';	--将SCL和SDA拉高，保持4.7us以上
						when 1 => sda_out_r <= '1'; scl_out_r <= '1'; 	--clk_400khz每个周期2.5us，需要两个周期
						when 2 => sda_out_r <= '0'; 	--SDA拉低到SCL拉低，保持4.0us以上
						when 3 => sda_out_r <= '0'; 	--clk_400khz每个周期2.5us，需要两个周期
						when 4 => scl_out_r <= '0'; 	--SCL拉低，保持4.7us以上
						when 5 => scl_out_r <= '0'; state <= MAIN; 	--clk_400khz每个周期2.5us，需要两个周期，返回MAIN
						when others => state <= IDLE;	--如果程序失控，进入IDLE自复位状态
					end case;
				when WRITING =>
					if(cnt <= 6) then	--共需要发送8bit的数据，这里控制循环的次数
						if(cnt_write >= 3) then
							cnt_write <= 0; 
							cnt <= cnt + 1; 
						else 
							cnt_write <= cnt_write + 1; 
							cnt <= cnt; 
						end if;
					else 
						if(cnt_write >= 7) then 
							cnt_write <= 0; 
							cnt <= 0; 	--两个变量都恢复初值
						else 
							cnt_write <= cnt_write + 1; 
							cnt <= cnt; 
						end if;
					end if;
					case(cnt_write) is
						--按照I2C的时序传输数据
						when 0 => scl_out_r <= '0'; sda_out_r <= data_wr(7-cnt); 	--SCL拉低，并控制SDA输出对应的位
						when 1 => scl_out_r <= '1'; 	--SCL拉高，保持4.0us以上
						when 2 => scl_out_r <= '1'; 	--clk_400khz每个周期2.5us，需要两个周期
						when 3 => scl_out_r <= '0'; 	--SCL拉低，准备发送下1bit的数据
					    --获取从设备的响应信号并判断
						when 4 => sda_out_r <= 'Z'; 	--释放SDA线，准备接收从设备的响应信号
						when 5 => scl_out_r <= '1'; 	--SCL拉高，保持4.0us以上
						when 6 => 
							if(sda_out = '1') then 
								state <= IDLE; 
							else 
								state <= state; 
							end if; 	--获取从设备的响应信号并判断
						when 7 => scl_out_r <= '0'; state <= MAIN; 	--SCL拉低，返回MAIN状态
						when others => state <= IDLE;	--如果程序失控，进入IDLE自复位状态
					end case;
				when READING =>  --I2C通信时序中的读操作READ和返回ACK的操作
					if(cnt <= 6) then	--共需要接收8bit的数据，这里控制循环的次数
						if(cnt_read >= 3) then
							cnt_read <= 0; 
							cnt <= cnt + 1; 
						else 
							cnt_read <= cnt_read + 1; 
							cnt <= cnt; 
						end if;
					else 
						if(cnt_read >= 7) then
							cnt_read <= 0; 
							cnt <= 0; 	--两个变量都恢复初值
						else 
							cnt_read <= cnt_read + 1;
							cnt <= cnt; 
						end if;
					end if;
					case(cnt_read) is
						--按照I2C的时序接收数据
						when 0 => scl_out_r <= '0'; sda_out_r <= 'Z'; 	--SCL拉低，释放SDA线，准备接收从设备数据
						when 1 => scl_out_r <= '1'; 	--SCL拉高，保持4.0us以上
						when 2 => adc_data_r(7-cnt) <= sda_out; 	--读取从设备返回的数据
						when 3 => scl_out_r <= '0'; 	--SCL拉低，准备接收下1bit的数据
						--向从设备发送响应信号
						when 4 => sda_out_r <= '0'; adc_done <= '1'; adc_data <= adc_data_r; 	--发送响应信号，将前面接收的数据锁存
						when 5 => scl_out_r <= '1'; 	--SCL拉高，保持4.0us以上
						when 6 => scl_out_r <= '1'; adc_done <= '0'; 	--SCL拉高，保持4.0us以上
						when 7 => scl_out_r <= '0'; state <= MAIN; 	--SCL拉低，返回MAIN状态
						when others => state <= IDLE;	--如果程序失控，进入IDLE自复位状态
					end case;
				when STOP => --I2C通信时序中的结束STOP
					if(cnt_stop >= 5) then
						cnt_stop <= 0;	--对STOP中的子状态执行控制cnt_stop
					else 
						cnt_stop <= cnt_stop + 1;
					end if;
					case(cnt_stop) is
						when 0 => sda_out_r <= '0'; 	--SDA拉低，准备STOP
						when 1 => sda_out_r <= '0'; 	--SDA拉低，准备STOP
						when 2 => scl_out_r <= '1'; 	--SCL提前SDA拉高4.0us
						when 3 => scl_out_r <= '1'; 	--SCL提前SDA拉高4.0us
						when 4 => sda_out_r <= '1'; 	--SDA拉高
						when 5 => sda_out_r <= '1'; state <= MAIN; 	--完成STOP操作，返回MAIN状态
						when others => state <= IDLE;	--如果程序失控，进入IDLE自复位状态
					end case;
				when others => state <= IDLE;
			end case;
		end if;
	end if;
	
-----------------bin2bcd------------------------
    bcd:= (others => '0') ;
	binx:= adc_data(7 downto 0) ;
    for i in binx'range loop
        if bcd(3 downto 0) > "0100" then
          bcd(3 downto 0):=bcd(3 downto 0)+"0011"; 
        end if ;
        if bcd(7 downto 4) > "0100" then
           bcd(7 downto 4):=bcd(7 downto 4)+"0011";    
        end if ;
        bcd := bcd(10 downto 0) & binx(7) ; 
        binx := binx(6 downto 0) & '0' ; 
    end loop ;

    DataOut(2) <= conv_integer(bcd(11 downto 8));                     		--输出 BCD 码
	DataOut(1) <= conv_integer(bcd(7  downto 4));
    DataOut(0) <= conv_integer(bcd(3  downto 0));
----------------bcd2Vol-----------------------------
	Voltage<=DataOut(2)*1300+DataOut(1)*130+DataOut(0)*10;
    if(clk_in'event and clk_in='1') then
	    if(tmp<Voltage) then
				
			if(da=9 and db=9 and dc=9 and dd=9 and de=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				de<="0000";
				tmp<=0;
				
			elsif(da=9 and db=9 and dc=9 and dd=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				de<=de+1;
				tmp<=tmp+1;
			
			elsif(da=9 and db=9 and dc=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<=dd+1;
				tmp<=tmp+1;
				
			elsif(da=9 and db=9 ) then
			    da<="0000";
				db<="0000";
				dc<= dc+1;
				
				tmp<=tmp+1;
			elsif(da=9) then
			    da<="0000";
				db<= db+1;
				
				tmp<=tmp+1;
			else
			    da<=da+1;
				tmp<=tmp+1;
			end if;
		else
		    tmp<=0;
			 dd3<=dd(3);
			 dd3_1<=conv_integer(dd3);
			 dd2<=dd(2);
			 dd2_1<=conv_integer(dd2);
			 dd1<=dd(1);
			 dd1_1<=conv_integer(dd1);
			 dd0<=dd(0);
			 dd0_1<=conv_integer(dd0);
		     DataV(3)<=(dd3_1*8+dd2_1*4+dd1_1*2+dd0_1);
			 
			 dc3<=dc(3);
			 dc3_1<=conv_integer(dc3);
			 dc2<=dc(2);
			 dc2_1<=conv_integer(dc2);
			 dc1<=dc(1);
			 dc1_1<=conv_integer(dc1);
			 dc0<=dc(0);
			 dc0_1<=conv_integer(dc0);
		     DataV(2)<=(dc3_1*8+dc2_1*4+dc1_1*2+dc0_1);
			 
			 db3<=db(3);
			 db3_1<=conv_integer(db3);
			 db2<=db(2);
			 db2_1<=conv_integer(db2);
			 db1<=db(1);
			 db1_1<=conv_integer(db1);
			 db0<=db(0);
			 db0_1<=conv_integer(db0);
		     DataV(1)<=(db3_1*8+db2_1*4+db1_1*2+db0_1);
			 
			 da3<=da(3);
			 da3_1<=conv_integer(da3);
			 da2<=da(2);
			 da2_1<=conv_integer(da2);
			 da1<=da(1);
			 da1_1<=conv_integer(da1);
			 da0<=da(0);
			 da0_1<=conv_integer(da0);
		     DataV(0)<=(da3_1*8+da2_1*4+da1_1*2+da0_1);

			 da<="0000";
		     db<="0000";
			 dc<="0000";
		     dd<="0000";
			 de<="0000";

		     end if;
	    end if;
	--utilize mode controller
		temp(0)<=0;
		temp(1)<=0;		
		temp(2)<=0;
		temp(3)<=0;		
		if (mode=0) then
			temp(2 downto 0)<=DataOut;
			ctrlcode595(39 downto 32)<=segmentdecode(temp(3));
			ctrlcode595(47 downto 40)<=enDig(1);
-------------weird-------------------------------
		else	
			temp<=DataV;
			ctrlcode595(39 downto 32)<=segmentdecode_dp(temp(3));
			ctrlcode595(47 downto 40)<=enDig(1);--for segment3
		end if;
		--Get all code and combine them into a series code as ctrlcode595
		
		--for segment1
		ctrlcode595(7 downto 0)<=segmentdecode(16);
		ctrlcode595(15 downto 8)<=enDig(0);--1
		
		--for segment3
		ctrlcode595(23 downto 16)<=segmentdecode(temp(2));
		ctrlcode595(31 downto 24)<=enDig(2);
-------------weird-------------------------------
		
		--for segment4
		ctrlcode595(55 downto 48)<=segmentdecode(temp(1));
		ctrlcode595(63 downto 56)<=enDig(3);--4
		
		--for segment5
		ctrlcode595(71 downto 64)<=segmentdecode(temp(0));
		ctrlcode595(79 downto 72)<=enDig(4);--5
		
		--for segment6
		ctrlcode595(87 downto 80)<=segmentdecode(digit5(mode));
		ctrlcode595(95 downto 88)<=enDig(5);--6
		
		
			--divide ctrl code into 6 parts
	codeP0 <= ctrlcode595(15 downto 0);
	codeP1 <= ctrlcode595(31 downto 16);
	codeP2 <= ctrlcode595(47 downto 32);
	codeP3 <= ctrlcode595(63 downto 48);
	codeP4 <= ctrlcode595(79 downto 64);
	codeP5 <= ctrlcode595(95 downto 80);
 end process;
 ----This process divides 12MHz clock into 1MHz, using as data shift clock
	process(clk_in,rst_n_in)
	begin
		if (rst_n_in='0') then	--asynchronous reset
			shift_clock_cnt<=0;
			shift_clock<='1';
		elsif (rising_edge(clk_in)) then
			shift_clock_cnt<=shift_clock_cnt+1;
			if (shift_clock_cnt=2) then
				shift_clock<=not shift_clock;					
				shift_clock_cnt<=0;	
			end if;
		end if;	
	end process;
	sck<=shift_clock;

	----This process record last state of shift clock
	process(clk_in)
	begin
		if(rising_edge(clk_in)) then
			shift_clock_ls<=shift_clock;
		end if;
	end process;
	
	----This process counts the times of shift at rising edge of shift_clk
	----When shift_cnt is n, it means we have already shift n digits to 595
	process(clk_in,rst_n_in)
	begin
		if (rst_n_in='0') then
			shift_cnt<=0;
		elsif (rising_edge(clk_in)) then
			if (shift_clock='1' and shift_clock_ls='0') then
				if (shift_cnt=15) then
					shift_cnt<=0;
				else
					shift_cnt<=shift_cnt+1;
				end if;
			end if;
		end if;
	end process;
	
	----This process parallely outputs data when shift_cnt=0
	----Because if shift_cnt is reset to 0, it means we have already shift 16 digits to 595
	----and it is time to output them.
	process(shift_cnt,rst_n_in)
	begin
		if (rst_n_in='0') then
			parallout<='1';
		elsif (shift_cnt=0) then
			parallout<='1';	--send data
		else
			parallout<='0';
		end if;
	end process;
	rck<=parallout;
	
	----This process writes a digit to din at falling edge of shift_clk
	----and the rising edge right after it will actually shift the certain digit into 595
	----then the counting process above will count a shift
	process(clk_in,rst_n_in)
	begin
		if (rst_n_in='0') then
			din<='0';
		elsif (rising_edge(clk_in)) then
			if (shift_clock='0' and shift_clock_ls='1') then
				case codeP is
					when 0=> din<=codeP0(shift_cnt);
					when 1=> din<=codeP1(shift_cnt);
					when 2=> din<=codeP2(shift_cnt);
					when 3=> din<=codeP3(shift_cnt);
					when 4=> din<=codeP4(shift_cnt);
					when 5=> din<=codeP5(shift_cnt);
					when others=> null;
				end case;
				if (shift_cnt=15) then	--finish one part, begin next part
					if (codeP=5) then
						codeP<=0;
					else
						codeP<=codeP+1;
					end if;
				end if;
			end if;
		end if;
end process;

 LC:LCD_display PORT MAP (rst_n_in,clk_in,DA_LCD,CLK_LCD,RST_LCD,DC_LCD,BL_LCD,temp(3),temp(2),temp(1));
	
	scl_out <= scl_out_r;
    sda_out <= sda_out_r;

end ADC_arch;