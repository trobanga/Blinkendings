-- Generator : SpinalHDL v0.10.13    git head : 14af3dec3a4b5d86a8d9ac3876db9e562cd32727
-- Date      : 16/07/2017, 16:21:23
-- Component : Blinkendings

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;

-- #spinalBegin userLibrary
-- #spinalEnd userLibrary


entity Blinkendings_tb is
end Blinkendings_tb;

architecture arch of Blinkendings_tb is
  signal io_CLOCK_50_B5B : std_logic;
  signal io_CLOCK_50_B6A : std_logic;
  signal io_CLOCK_50_B7A : std_logic;
  signal io_CLOCK_50_B8A : std_logic;
  signal io_CLOCK_125_p : std_logic;
  signal io_CPU_RESET_n : std_logic;
  signal io_KEY : unsigned(3 downto 0);
  signal io_LEDG : unsigned(7 downto 0);
  signal io_LEDR : unsigned(9 downto 0);
  -- #spinalBegin userDeclarations
  -- #spinalEnd userDeclarations
begin
  -- #spinalBegin userLogics
  -- #spinalEnd userLogics
  uut : entity work.Blinkendings
    port map (
      io_CLOCK_50_B5B =>  io_CLOCK_50_B5B,
      io_CLOCK_50_B6A =>  io_CLOCK_50_B6A,
      io_CLOCK_50_B7A =>  io_CLOCK_50_B7A,
      io_CLOCK_50_B8A =>  io_CLOCK_50_B8A,
      io_CLOCK_125_p =>  io_CLOCK_125_p,
      io_CPU_RESET_n =>  io_CPU_RESET_n,
      io_KEY =>  io_KEY,
      io_LEDG =>  io_LEDG,
      io_LEDR =>  io_LEDR 
    );
end arch;
