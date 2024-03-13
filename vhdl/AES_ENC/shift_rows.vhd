-- VHDL implementation of AES
-- Copyright (C) 2019  Hosein Hadipour
--This source file may be used and distributed without  
--restriction provided that this copyright statement is not 
--removed from the file and that any derivative work contains
--the original copyright notice and the associated disclaimer.
--
--This source is distributed in the hope that it will be
--useful, but WITHOUT ANY WARRANTY; without even the implied
--warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
--PURPOSE.  See the GNU Lesser General Public License for more
--details.
--
--You should have received a copy of the GNU Lesser General
--Public License along with this source; if not, download it
--from http://www.opencores.org/lgpl.shtml
--
--*************************************************************
-- Modified for ECE6156 Lab Assignment by Spandan More

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shift_rows IS
	PORT (
		input : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
	);
END shift_rows;

ARCHITECTURE rtl OF shift_rows IS

BEGIN
	output(8 * 16 - 1 DOWNTO 8 * 15) <= input(8 * 12 - 1 DOWNTO 8 * 11);
	output(8 * 15 - 1 DOWNTO 8 * 14) <= input(8 * 7 - 1 DOWNTO 8 * 6);
	output(8 * 14 - 1 DOWNTO 8 * 13) <= input(8 * 2 - 1 DOWNTO 8 * 1);
	output(8 * 13 - 1 DOWNTO 8 * 12) <= input(8 * 13 - 1 DOWNTO 8 * 12);
	output(8 * 12 - 1 DOWNTO 8 * 11) <= input(8 * 8 - 1 DOWNTO 8 * 7);
	output(8 * 11 - 1 DOWNTO 8 * 10) <= input(8 * 3 - 1 DOWNTO 8 * 2);
	output(8 * 10 - 1 DOWNTO 8 * 9) <= input(8 * 14 - 1 DOWNTO 8 * 13);
	output(8 * 9 - 1 DOWNTO 8 * 8) <= input(8 * 9 - 1 DOWNTO 8 * 8);
	output(8 * 8 - 1 DOWNTO 8 * 7) <= input(8 * 4 - 1 DOWNTO 8 * 3);
	output(8 * 7 - 1 DOWNTO 8 * 6) <= input(8 * 15 - 1 DOWNTO 8 * 14);
	output(8 * 6 - 1 DOWNTO 8 * 5) <= input(8 * 10 - 1 DOWNTO 8 * 9);
	output(8 * 5 - 1 DOWNTO 8 * 4) <= input(8 * 5 - 1 DOWNTO 8 * 4);
	output(8 * 4 - 1 DOWNTO 8 * 3) <= input(8 * 16 - 1 DOWNTO 8 * 15);
	output(8 * 3 - 1 DOWNTO 8 * 2) <= input(8 * 11 - 1 DOWNTO 8 * 10);
	output(8 * 2 - 1 DOWNTO 8 * 1) <= input(8 * 6 - 1 DOWNTO 8 * 5);
	output(8 * 1 - 1 DOWNTO 8 * 0) <= input(8 * 1 - 1 DOWNTO 8 * 0);
END ARCHITECTURE rtl;