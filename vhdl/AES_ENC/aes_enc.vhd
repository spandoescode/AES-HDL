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

ENTITY aes_enc IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		plaintext : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		ciphertext : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
		done : OUT STD_LOGIC
	);
END aes_enc;

ARCHITECTURE behavioral OF aes_enc IS
	SIGNAL reg_input : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL reg_output : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL subbox_input : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL subbox_output : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL shiftrows_output : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL mixcol_output : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL feedback : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL round_key : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL round_const : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL sel : STD_LOGIC;
BEGIN
	reg_input <= plaintext WHEN rst = '0' ELSE
		feedback;
	reg_inst : ENTITY work.reg
		GENERIC MAP(
			size => 128
		)
		PORT MAP(
			clk => clk,
			d => reg_input,
			q => reg_output
		);
	-- Encryption body
	add_round_key_inst : ENTITY work.add_round_key
		PORT MAP(
			input1 => reg_output,
			input2 => round_key,
			output => subbox_input
		);
	sub_byte_inst : ENTITY work.sub_byte
		PORT MAP(
			input_data => subbox_input,
			output_data => subbox_output

		);
	shift_rows_inst : ENTITY work.shift_rows
		PORT MAP(
			input => subbox_output,
			output => shiftrows_output
		);
	mix_columns_inst : ENTITY work.mix_columns
		PORT MAP(
			input_data => shiftrows_output,
			output_data => mixcol_output
		);
	feedback <= mixcol_output WHEN sel = '0' ELSE
		shiftrows_output;
	ciphertext <= subbox_input;
	-- Controller
	controller_inst : ENTITY work.controller
		PORT MAP(
			clk => clk,
			rst => rst,
			rconst => round_const,
			is_final_round => sel,
			done => done
		);
	-- Keyschedule
	key_schedule_inst : ENTITY work.key_schedule
		PORT MAP(
			clk => clk,
			rst => rst,
			key => key,
			round_const => round_const,
			round_key => round_key
		);
END ARCHITECTURE behavioral;