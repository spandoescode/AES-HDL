-- VHDL implementation of AES
-- Copyright (C) 2019  Hosein Hadipour
-- This source file may be used and distributed without  
-- restriction provided that this copyright statement is not 
-- removed from the file and that any derivative work contains
-- the original copyright notice and the associated disclaimer.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE.  See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from http://www.opencores.org/lgpl.shtml
--
--*************************************************************
-- Modified for ECE6156 Lab Assignment by Spandan More

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY test_enc IS
END test_enc;

ARCHITECTURE behavior OF test_enc IS

	FUNCTION to_string (a : STD_LOGIC_VECTOR) RETURN STRING IS
		VARIABLE b : STRING (1 TO a'length) := (OTHERS => NUL);
		VARIABLE stri : INTEGER := 1;
	BEGIN
		FOR i IN a'RANGE LOOP
			b(stri) := STD_LOGIC'image(a((i)))(2);
			stri := stri + 1;
		END LOOP;
		RETURN b;
	END FUNCTION;

	COMPONENT aes_enc
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			plaintext : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			ciphertext : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			done : OUT STD_LOGIC
		);
	END COMPONENT aes_enc;
	-- Input signals
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL rst : STD_LOGIC := '0';
	SIGNAL plaintext : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL key : STD_LOGIC_VECTOR(127 DOWNTO 0);

	-- Output signals
	SIGNAL done : STD_LOGIC;
	SIGNAL ciphertext : STD_LOGIC_VECTOR(127 DOWNTO 0);

	-- Clock period definition
	CONSTANT clk_period : TIME := 10 ns;

BEGIN
	enc_inst : aes_enc
	PORT MAP(
		clk => clk,
		rst => rst,
		key => key,
		plaintext => plaintext,
		ciphertext => ciphertext,
		done => done
	);
	-- clock process definitions
	clk_process : PROCESS IS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
	END PROCESS clk_process;

	-- Simulation process
	sim_proc : PROCESS IS

		-- File Handling
		FILE f_pt : text OPEN read_mode IS "/home/span/Work/Acads/ECE6156/Lab 2/lab2/vhdl/AES_ENC/pt_hex_r.txt";
		FILE f_key : text OPEN read_mode IS "/home/span/Work/Acads/ECE6156/Lab 2/lab2/vhdl/AES_ENC/key_hex_r.txt";
		FILE f_ct : text OPEN read_mode IS "/home/span/Work/Acads/ECE6156/Lab 2/lab2/vhdl/AES_ENC/ct_r.txt";

		VARIABLE v_pt_line : line;
		VARIABLE v_key_line : line;
		VARIABLE v_ct_line : line;

		VARIABLE v_pt : STD_LOGIC_VECTOR(127 DOWNTO 0);
		VARIABLE v_k : STD_LOGIC_VECTOR(127 DOWNTO 0);
		VARIABLE v_ct : STD_LOGIC_VECTOR(127 DOWNTO 0);
	BEGIN

		-- For each key 
		WHILE NOT (endfile(f_key)) LOOP

			WHILE NOT (endfile(f_pt)) LOOP
				-- Read the plaintext
				readline(f_pt, v_pt_line);
				hread(v_pt_line, v_pt);

				-- Read the key 
				readline(f_key, v_key_line);
				hread(v_key_line, v_k);

				-- Read the correct ciphertext
				readline(f_ct, v_ct_line);
				hread(v_ct_line, v_ct);

				-- Pass variables to the module 
				plaintext <= v_pt;
				key <= v_k;
				rst <= '0';

				-- Hold reset state for one cycle		
				WAIT FOR clk_period * 1;
				rst <= '1';
				WAIT UNTIL done = '1';
				WAIT FOR clk_period/2;

				IF (ciphertext = v_ct) THEN
					REPORT "---------- Passed ----------";
						ELSE
						REPORT "---------- Failed ----------";
					END IF;
					REPORT "---------- Output must be: -------";
						REPORT to_string(v_ct);
				END LOOP;

			END LOOP;

			-- Close the files
			file_close(f_key);
			file_close(f_pt);
			file_close(f_ct);

			WAIT;

		END PROCESS sim_proc;
	END ARCHITECTURE behavior;