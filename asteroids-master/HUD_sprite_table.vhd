library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity HUD_sprite_table is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end HUD_sprite_table;

architecture arch of HUD_sprite_table is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=8;
   signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   
   constant ROM: rom_type:=(
   -- code x00
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00010000", -- 4    *
   "00111000", -- 5   ***
   "00111000", -- 6   ***
   "01111100", -- 7  *****
   "01111100", -- 8  *****
   "11111110", -- 9 *******
   "11111110", -- a *******
   "10000001", -- b *     *
   "10000001", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
     -- code x01
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "01111000", -- 5  ****
   "00001100", -- 6     **
   "01111100", -- 7  *****
   "11001100", -- 8 **  **
   "11001100", -- 9 **  **
   "11001100", -- a **  **
   "01110110", -- b  *** **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x02
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "01111100", -- 5  *****
   "11000110", -- 6 **   **
   "11111110", -- 7 *******
   "11000000", -- 8 **
   "11000000", -- 9 **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x03
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "01110110", -- 5  *** **
   "11001100", -- 6 **  **
   "11001100", -- 7 **  **
   "11001100", -- 8 **  **
   "11001100", -- 9 **  **
   "11001100", -- a **  **
   "01111100", -- b  *****
   "00001100", -- c     **
   "11001100", -- d **  **
   "01111000", -- e  ****
   "00000000", -- f
   -- code x04
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "11100110", -- 5 ***  **
   "11111111", -- 6 ********
   "11011011", -- 7 ** ** **
   "11011011", -- 8 ** ** **
   "11011011", -- 9 ** ** **
   "11011011", -- a ** ** **
   "11011011", -- b ** ** **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x05
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "01111100", -- 5  *****
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x06
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "11011100", -- 5 ** ***
   "01110110", -- 6  *** **
   "01100110", -- 7  **  **
   "01100000", -- 8  **
   "01100000", -- 9  **
   "01100000", -- a  **
   "11110000", -- b ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x07
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "11000011", -- 5 **    **
   "11000011", -- 6 **    **
   "11000011", -- 7 **    **
   "11000011", -- 8 **    **
   "01100110", -- 9  **  **
   "00111100", -- a   ****
   "00011000", -- b    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x08
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11001110", -- 5 **  ***
   "11011110", -- 6 ** ****
   "11110110", -- 7 **** **
   "11100110", -- 8 ***  **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x09
   "00000000", -- 0
   "00000000", -- 1
   "00011000", -- 2
   "00111000", -- 3
   "01111000", -- 4    **
   "00011000", -- 5   ***
   "00011000", -- 6  ****
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "01111110", -- b    **
   "00000000", -- c    **
   "00000000", -- d  ******
   "00000000", -- e
   "00000000", -- f
   -- code x0a
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "00000110", -- 4      **
   "00001100", -- 5     **
   "00011000", -- 6    **
   "00110000", -- 7   **
   "01100000", -- 8  **
   "11000000", -- 9 **
   "11000110", -- a **   **
   "11111110", -- b *******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x0b
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "00000110", -- 4      **
   "00000110", -- 5      **
   "00111100", -- 6   ****
   "00000110", -- 7      **
   "00000110", -- 8      **
   "00000110", -- 9      **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x0c
   "00000000", -- 0
   "00000000", -- 1
   "00001100", -- 2     **
   "00011100", -- 3    ***
   "00111100", -- 4   ****
   "01101100", -- 5  ** **
   "11001100", -- 6 **  **
   "11111110", -- 7 *******
   "00001100", -- 8     **
   "00001100", -- 9     **
   "00001100", -- a     **
   "00011110", -- b    ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x0d
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "11000000", -- 3 **
   "11000000", -- 4 **
   "11000000", -- 5 **
   "11111100", -- 6 ******
   "00000110", -- 7      **
   "00000110", -- 8      **
   "00000110", -- 9      **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x0e
   "00000000", -- 0
   "00000000", -- 1
   "00111000", -- 2   ***
   "01100000", -- 3  **
   "11000000", -- 4 **
   "11000000", -- 5 **
   "11111100", -- 6 ******
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x0f
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "11000110", -- 3 **   **
   "00000110", -- 4      **
   "00000110", -- 5      **
   "00001100", -- 6     **
   "00011000", -- 7    **
   "00110000", -- 8   **
   "00110000", -- 9   **
   "00110000", -- a   **
   "00110000", -- b   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x10
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "01111100", -- 6  *****
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x11
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "01111110", -- 6  ******
   "00000110", -- 7      **
   "00000110", -- 8      **
   "00000110", -- 9      **
   "00001100", -- a     **
   "01111000", -- b  ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x12
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x13
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x14
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x15
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x16
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x17
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x18
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x19
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x1a
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x1b
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x1c
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x1d
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x1e
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
      -- code x1f
   "00000000", -- 0
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5 
   "00000000", -- 6 
   "00000000", -- 7 
   "00000000", -- 8 
   "00000000", -- 9 
   "11111111", -- a 
   "11111111", -- b 
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000"  -- f
      );
      
begin
   -- addr register to infer block RAM
   process (clk)
   begin
      if (clk'event and clk = '1') then
        addr_reg <= addr;
      end if;
   end process;
   data <= ROM(to_integer(unsigned(addr_reg)));
end arch;

