----------------------------------------------------------------------
----                                                              ----
---- WISHBONE SPDIF IP Core                                       ----
----                                                              ----
---- This file is part of the SPDIF project                       ----
---- http://www.opencores.org/cores/spdif_interface/              ----
----                                                              ----
---- Description                                                  ----
---- SPDIF transmitter component package.                         ----
----                                                              ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Geir Drange, gedra@opencores.org                           ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2004 Authors and OPENCORES.ORG                 ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU Lesser General Public License for more  ----
---- details.                                                     ----
----                                                              ----
---- You should have received a copy of the GNU Lesser General    ----
---- Public License along with this source; if not, download it   ----
---- from http://www.opencores.org/lgpl.shtml                     ----
----                                                              ----
----------------------------------------------------------------------
--
-- CVS Revision History
--
-- $Log: not supported by cvs2svn $
-- 
--
 
library ieee;
use ieee.std_logic_1164.all; 

package tx_package is

-- type declarations
  type bus_array is array (0 to 7) of std_logic_vector(31 downto 0);

-- components
  
  component gen_control_reg 	 
    generic (DATA_WIDTH: integer;
             -- note that this vector is (0 to xx), reverse order
             ACTIVE_BIT_MASK: std_logic_vector); 
    port (
      clk: in std_logic;	 -- clock  
      rst: in std_logic; -- reset
      ctrl_wr: in std_logic; -- control register write	
      ctrl_rd: in std_logic; -- control register read
      ctrl_din: in std_logic_vector(DATA_WIDTH - 1 downto 0); 
      ctrl_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0); 
      ctrl_bits: out std_logic_vector(DATA_WIDTH - 1 downto 0)); 
  end component;

  component gen_event_reg 	 
    generic (DATA_WIDTH: integer);	
    port (
      clk: in std_logic;	 -- clock  
      rst: in std_logic; -- reset
      evt_wr: in std_logic; -- event register write	
      evt_rd: in std_logic; -- event register read
      evt_din: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- write data
      event: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- event vector
      evt_mask: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- irq mask
      evt_en: in std_logic;               -- irq enable
      evt_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0); -- read data
      evt_irq: out std_logic); -- interrupt  request
  end component;

  component dpram
    generic (DATA_WIDTH: positive;
             RAM_WIDTH: positive);
    port (
      clk: in std_logic;
      rst: in std_logic; -- reset is optional, not used here
      din: in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr_en: in std_logic;
      rd_en: in std_logic;
      wr_addr: in std_logic_vector(RAM_WIDTH - 1 downto 0);
      rd_addr: in std_logic_vector(RAM_WIDTH - 1 downto 0);
      dout: out std_logic_vector(DATA_WIDTH - 1 downto 0));
  end component;

  component tx_wb_decoder 	 
    generic (DATA_WIDTH: integer;
             ADDR_WIDTH: integer);
    port (
      wb_clk_i: in std_logic;             -- wishbone clock
      wb_rst_i: in std_logic;             -- reset signal
      wb_sel_i: in std_logic;             -- select input
      wb_stb_i: in std_logic;             -- strobe input
      wb_we_i: in std_logic;              -- write enable
      wb_cyc_i: in std_logic;             -- cycle input
      wb_bte_i: in std_logic_vector(1 downto 0);  -- burts type extension
      wb_cti_i: in std_logic_vector(2 downto 0);  -- cycle type identifier
      wb_adr_i: in std_logic_vector(ADDR_WIDTH - 1 downto 0);  -- address
      data_out: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- internal bus
      wb_ack_o: out std_logic;            -- acknowledge
      wb_dat_o: out std_logic_vector(DATA_WIDTH - 1 downto 0);  -- data out
      version_rd: out std_logic;          -- Version register read 
      config_rd: out std_logic;           -- Config register read
      config_wr: out std_logic;           -- Config register write
      chstat_rd: out std_logic;           -- Channel Status register read
      chstat_wr: out std_logic;           -- Channel Status register write
      intmask_rd: out std_logic;          -- Interrupt mask register read
      intmask_wr: out std_logic;          -- Interrupt mask register write
      intstat_rd: out std_logic;          -- Interrupt status register read
      intstat_wr: out std_logic;          -- Interrupt status register read
      mem_wr: out std_logic;              -- Sample memory write
      mem_addr: out std_logic_vector(ADDR_WIDTH - 2 downto 0); -- mem. addr.
      user_data_wr: out std_logic_vector(23 downto 0);  -- User data write
      ch_status_wr: out std_logic_vector(23 downto 0));  -- Ch. status write
  end component;
  
end tx_package;