--------------------------------------------------------------------------------
--            _   _            __   ____                                      --
--           / / | |          / _| |  __|                                     --
--           | |_| |  _   _  / /   | |_                                       --
--           |  _  | | | | | | |   |  _|                                      --
--           | | | | | |_| | \ \_  | |__                                      --
--           |_| |_| \_____|  \__| |____| microLab                            --
--                                                                            --
--           Bern University of Applied Sciences (BFH)                        --
--           Quellgasse 21                                                    --
--           Room HG 4.33                                                     --
--           2501 Biel/Bienne                                                 --
--           Switzerland                                                      --
--                                                                            --
--           http://www.microlab.ch                                           --
--------------------------------------------------------------------------------
--   GECKO4com
--  
--   2010/2011 Dr. Theo Kluter
--  
--   This VHDL code is free code: you can redistribute it and/or modify
--   it under the terms of the GNU General Public License as published by
--   the Free Software Foundation, either version 3 of the License, or
--   (at your option) any later version.
--  
--   This VHDL code is distributed in the hope that it will be useful,
--   but WITHOUT ANY WARRANTY; without even the implied warranty of
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--   GNU General Public License for more details. 
--   You should have received a copy of the GNU General Public License
--   along with these sources.  If not, see <http://www.gnu.org/licenses/>.
--

-- The unisim library is used for simulation of the xilinx specific components
-- For generic usage please use:
-- LIBRARY work;
-- USE work.xilinx_generic.all;
-- And use the xilinx generic package found in the xilinx generic module
LIBRARY unisim;
USE unisim.all;

ARCHITECTURE xilinx OF fifo_2kb_ef IS

   COMPONENT RAMB16_S9_S9
      GENERIC ( WRITE_MODE_A : string := "READ_FIRST";
                WRITE_MODE_B : string := "READ_FIRST" );
      PORT (  DOA   : OUT std_logic_vector( 7 DOWNTO 0);
              ADDRA : IN  std_logic_vector(10 DOWNTO 0);
              DIA   : IN  std_logic_vector( 7 DOWNTO 0);
              ENA   : IN  std_ulogic;
              WEA   : IN  std_ulogic;
              DOPA  : OUT std_logic_vector(0 DOWNTO 0);
              CLKA  : IN  std_ulogic;
              DIPA  : IN  std_logic_vector(0 DOWNTO 0);
              SSRA  : IN  std_ulogic;
              DOPB  : OUT std_logic_vector(0 DOWNTO 0);
              CLKB  : IN  std_ulogic;
              DIPB  : IN  std_logic_vector(0 DOWNTO 0);
              SSRB  : IN  std_ulogic;
              DOB   : OUT std_logic_vector( 7 DOWNTO 0);
              ADDRB : IN  std_logic_vector(10 DOWNTO 0);
              DIB   : IN  std_logic_vector( 7 DOWNTO 0);
              ENB   : IN  std_ulogic;
              WEB   : IN  std_ulogic );
   END COMPONENT;
   
   CONSTANT c_threshold_full : std_logic_vector(11 DOWNTO 0 ) := X"7BF";
   CONSTANT c_threshold_high : std_logic_vector(11 DOWNTO 0 ) := X"5FF";
   
   SIGNAL s_write_address_reg  : std_logic_vector(10 DOWNTO 0 );
   SIGNAL s_write_address_next : std_logic_vector(10 DOWNTO 0 );
   SIGNAL s_read_address_reg   : std_logic_vector(10 DOWNTO 0 );
   SIGNAL s_read_address_next  : std_logic_vector(10 DOWNTO 0 );
   SIGNAL s_nr_of_bytes_reg    : std_logic_vector(11 DOWNTO 0 );
   SIGNAL s_full               : std_logic;
   SIGNAL s_empty              : std_logic;
   SIGNAL s_execute_push       : std_logic;
   SIGNAL s_execute_pop        : std_logic;
   SIGNAL s_n_clock            : std_logic;
   SIGNAL s_current_threshold  : std_logic_vector(11 DOWNTO 0);
   
BEGIN
-- Assign outputs
   fifo_full   <= s_full;
   fifo_empty  <= s_empty;
   early_full  <= '1' WHEN unsigned(s_nr_of_bytes_reg) >
                           unsigned(s_current_threshold) ELSE '0';

-- Assign control signals
   s_read_address_next    <= unsigned(s_read_address_reg) + 1;
   s_write_address_next   <= unsigned(s_write_address_reg) + 1;
   s_execute_push         <= push AND NOT(s_full);
   s_execute_pop          <= pop  AND NOT(s_empty);
   s_n_clock              <= NOT(clock);
   s_current_threshold    <= c_threshold_full WHEN high_speed = '0' ELSE
                             c_threshold_high;
   s_full                 <= s_nr_of_bytes_reg(11);
   s_empty                <= '1' WHEN s_nr_of_bytes_reg = "000000000000" ELSE '0';

-- define processes
   make_read_address_reg : PROCESS( clock , reset , s_execute_pop ,
                                    s_read_address_next )
   BEGIN
      IF (clock'event AND (clock = '1')) THEN
         IF (reset = '1') THEN s_read_address_reg <= (OTHERS => '0');
         ELSIF (s_execute_pop = '1') THEN 
            s_read_address_reg <= s_read_address_next;
         END IF;
      END IF;
   END PROCESS make_read_address_reg;
   
   make_write_address_reg : PROCESS( clock , reset , s_execute_push ,
                                     s_write_address_next )
   BEGIN
      IF (clock'event AND (clock = '1')) THEN
         IF (reset = '1') THEN s_write_address_reg <= (OTHERS => '0');
         ELSIF (s_execute_push = '1') THEN
            s_write_address_reg <= s_write_address_next;
         END IF;
      END IF;
   END PROCESS make_write_address_reg;
   
   make_nr_of_bytes_reg : PROCESS( clock , reset , s_execute_push ,
                                   s_execute_pop )
   BEGIN
      IF (clock'event AND (clock = '1')) THEN
         IF (reset = '1') THEN s_nr_of_bytes_reg <= (OTHERS => '0');
         ELSIF (s_execute_push = '1' AND
                s_execute_pop = '0') THEN
            s_nr_of_bytes_reg <= unsigned(s_nr_of_bytes_reg) + 1;
         ELSIF (s_execute_push = '0' AND
                s_execute_pop = '1') THEN
            s_nr_of_bytes_reg <= unsigned(s_nr_of_bytes_reg) - 1;
         END IF;
      END IF;
   END PROCESS make_nr_of_bytes_reg;
   
-- map components
   ram  : RAMB16_S9_S9
          GENERIC MAP ( WRITE_MODE_A => "READ_FIRST",
                        WRITE_MODE_B => "READ_FIRST" )
          PORT MAP (  DOA   => OPEN,
                      ADDRA => s_write_address_reg,
                      DIA   => push_data,
                      ENA   => s_execute_push,
                      WEA   => s_execute_push,
                      DOPA  => OPEN,
                      CLKA  => clock,
                      DIPA(0)=> push_last,
                      SSRA  => '0',
                      DOPB(0)=> pop_last,
                      CLKB  => s_n_clock,
                      DIPB  => "0",
                      SSRB  => '0',
                      DOB   => pop_data,
                      ADDRB => s_read_address_reg,
                      DIB   => X"00",
                      ENB   => '1',
                      WEB   => '0' );

END xilinx;
