library ieee;
use ieee.std_logic_1164.all;

package alu is
  component alu is
    generic (
      N : positive
    );
    port (
      a : in std_logic_vector(N downto 0);
      b : in std_logic_vector(N downto 0);
      op_sel : in std_logic_vector(1 downto 0);
      c : out std_logic_vector(N*2-1 downto 0)
    );
  end component;
end package;
