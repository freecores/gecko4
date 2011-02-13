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

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DFF IS
   PORT ( clock  : IN  std_logic;
          D      : IN  std_logic;
	       Q      : OUT std_logic );
END DFF;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DFF_E IS
   PORT ( clock  : IN  std_logic;
          enable : IN  std_logic;
          D      : IN  std_logic;
	       Q      : OUT std_logic );
END DFF_E;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DFF_AR IS
   PORT ( clock  : IN  std_logic;
          reset  : IN  std_logic;
          D      : IN  std_logic;
	       Q      : OUT std_logic );
END DFF_AR;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DFF_BUS IS
   GENERIC ( nr_of_bits : INTEGER );
   PORT ( clock  : IN  std_logic;
          D      : IN  std_logic_vector( (nr_of_bits-1) DOWNTO 0 );
     	    Q      : OUT std_logic_vector( (nr_of_bits-1) DOWNTO 0 ));
END DFF_BUS;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DFF_E_BUS IS
   GENERIC ( nr_of_bits : INTEGER );
   PORT ( clock  : IN  std_logic;
          enable : IN  std_logic;
          D      : IN  std_logic_vector( (nr_of_bits-1) DOWNTO 0 );
	  Q      : OUT std_logic_vector( (nr_of_bits-1) DOWNTO 0 ));
END DFF_E_BUS;