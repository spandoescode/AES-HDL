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

library ieee;
use ieee.std_logic_1164.all;

entity column_calculator is
	port (
		input_data : in std_logic_vector(31 downto 0);
		output_data : out std_logic_vector(31 downto 0)
	);
end column_calculator;

architecture rtl of column_calculator is
	signal temp : std_logic_vector(7 downto 0);
	signal temp0 : std_logic_vector(7 downto 0);
	signal temp1 : std_logic_vector(7 downto 0);
	signal temp2 : std_logic_vector(7 downto 0);
	signal temp3 : std_logic_vector(7 downto 0);
	signal temp0x2 : std_logic_vector(7 downto 0);
	signal temp1x2 : std_logic_vector(7 downto 0);
	signal temp2x2 : std_logic_vector(7 downto 0);
	signal temp3x2 : std_logic_vector(7 downto 0);	
begin
	temp <= input_data(31 downto 24) xor input_data(23 downto 16) xor input_data(15 downto 8) xor input_data(7 downto 0);
	temp0 <= input_data(7 downto 0) xor input_data(15 downto 8);
	temp1 <= input_data(15 downto 8) xor input_data(23 downto 16);
	temp2 <= input_data(23 downto 16) xor input_data(31 downto 24);
	temp3 <= input_data(31 downto 24) xor input_data(7 downto 0);
	gfmult_by2_inst0 : entity work.gfmult_by2
		port map(
			input_byte  => temp0,
			output_byte => temp0x2
		);
	gfmult_by2_inst1 : entity work.gfmult_by2
		port map(
			input_byte  => temp1,
			output_byte => temp1x2
		);
	gfmult_by2_inst2 : entity work.gfmult_by2
		port map(
			input_byte  => temp2,
			output_byte => temp2x2
		);
	gfmult_by2_inst3 : entity work.gfmult_by2
		port map(
			input_byte  => temp3,
			output_byte => temp3x2
		);
	output_data(7 downto 0) <= input_data(7 downto 0) xor temp0x2 xor temp;
	output_data(15 downto 8) <= input_data(15 downto 8) xor temp1x2 xor temp;
	output_data(23 downto 16) <= input_data(23 downto 16) xor temp2x2 xor temp;
	output_data(31 downto 24) <= input_data(31 downto 24) xor temp3x2 xor temp; 	
	
end architecture rtl;
