-------------------------------------------------------------------
-- Name        : de0_lite.vhd
-- Author      : 
-- Version     : 0.1
-- Copyright   : Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Projeto base DE10-Lite
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de0_lite is
	port(
		---------- CLOCK ----------
		ADC_CLK_10      : in    std_logic;
		MAX10_CLK1_50   : in    std_logic;
		MAX10_CLK2_50   : in    std_logic;
		----------- SDRAM ------------
		DRAM_ADDR       : out   std_logic_vector(12 downto 0);
		DRAM_BA         : out   std_logic_vector(1 downto 0);
		DRAM_CAS_N      : out   std_logic;
		DRAM_CKE        : out   std_logic;
		DRAM_CLK        : out   std_logic;
		DRAM_CS_N       : out   std_logic;
		DRAM_DQ         : inout std_logic_vector(15 downto 0);
		DRAM_LDQM       : out   std_logic;
		DRAM_RAS_N      : out   std_logic;
		DRAM_UDQM       : out   std_logic;
		DRAM_WE_N       : out   std_logic;
		----------- SEG7 ------------
		HEX0            : out   std_logic_vector(7 downto 0);
		HEX1            : out   std_logic_vector(7 downto 0);
		HEX2            : out   std_logic_vector(7 downto 0);
		HEX3            : out   std_logic_vector(7 downto 0);
		HEX4            : out   std_logic_vector(7 downto 0);
		HEX5            : out   std_logic_vector(7 downto 0);
		----------- KEY ------------
		KEY             : in    std_logic_vector(1 downto 0);
		----------- LED ------------
		LEDR            : out   std_logic_vector(9 downto 0);
		----------- SW ------------
		SW              : in    std_logic_vector(9 downto 0);
		----------- VGA ------------
		VGA_B           : out   std_logic_vector(3 downto 0);
		VGA_G           : out   std_logic_vector(3 downto 0);
		VGA_HS          : out   std_logic;
		VGA_R           : out   std_logic_vector(3 downto 0);
		VGA_VS          : out   std_logic;
		----------- Accelerometer ------------
		GSENSOR_CS_N    : out   std_logic;
		GSENSOR_INT     : in    std_logic_vector(2 downto 1);
		GSENSOR_SCLK    : out   std_logic;
		GSENSOR_SDI     : inout std_logic;
		GSENSOR_SDO     : inout std_logic;
		----------- Arduino ------------
		ARDUINO_IO      : inout std_logic_vector(15 downto 0);
		ARDUINO_RESET_N : inout std_logic
	);
end entity;

architecture RTL of de0_lite is
	signal clk    : std_logic;
	signal locked : std_logic;
	signal clk_1k : std_logic;

begin
	-- @brief Connections
	pll : entity work.pll
		port map(
			areset => SW(9),            --! @details If SW(9) is OFF (default), pll clock is ON
			inclk0 => ADC_CLK_10,
			c0     => clk_1k,
			locked => locked
		);
	lcd : entity work.lcd_hd44780
		port map(
			clk            => clk_1k,
			--
			lcd_data(7)    => ARDUINO_IO(0),
			lcd_data(6)    => ARDUINO_IO(1),
			lcd_data(5)    => ARDUINO_IO(2),
			lcd_data(4)    => ARDUINO_IO(3),
			lcd_data(3)    => ARDUINO_IO(4),
			lcd_data(2)    => ARDUINO_IO(5),
			lcd_data(1)    => ARDUINO_IO(6),
			lcd_data(0)    => ARDUINO_IO(7),
			--
			lcd_rs         => ARDUINO_IO(9),
			lcd_e          => ARDUINO_IO(8),
			--
			rst            => SW(9),
			lcd_init       => SW(0),
			lcd_write_char => SW(1),
			lcd_clear      => SW(2),
			lcd_goto_l1    => SW(3),
			lcd_goto_l2    => SW(4),
			lcd_is_busy    => LEDR(8)
		);
	-- @brief Inputs

	-- @brief Board outputs
	LEDR(9) <= clk_1k;
	-- All 7-seg displays off
	HEX0    <= (others => '1');
	HEX1    <= (others => '1');
	HEX2    <= (others => '1');
	HEX3    <= (others => '1');
	HEX4    <= (others => '1');
	HEX5    <= (others => '1');

end architecture RTL;

