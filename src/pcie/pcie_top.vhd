library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.all;

entity pcie_top is
   port (
   inclk_125            : IN std_logic;
   pcie_perstn          : IN std_logic;
   pcie_refclk          : IN std_logic;
   pcie_rx              : IN std_logic_vector(3 DOWNTO 0);
   pcie_tx              : OUT std_logic_vector(3 DOWNTO 0);
   user_led             : OUT std_logic_vector(3 DOWNTO 0);
   pcie_bus_clk         : OUT std_LOGIC;
   tx_fifo32_aclr       : in std_logic;
   tx_fifo32_wrclk      : in std_LOGIC;
   tx_fifo32_wr         : in std_LOGIC;
   tx_fifo32_data       : in std_LOGIC_vector(63 downto 0);
   tx_fifo32_wusedw     : out std_LOGIC_vector(11 downto 0);
   tx_fifo32_wfull      : out std_logic;
   rx_fifo32_wfull      : in std_logic;
   rx_fifo32_wr         : out std_logic;
   rx_fifo32_data       : out std_logic_vector(31 downto 0);
   rx_fifo32_reset_req  : out std_logic;
   --FIFO8 interfaces
   exfifo_clk           : in std_logic;
   exfifo_of_d          : in std_logic_vector(7 downto 0);
   exfifo_of_wrfull     : out std_logic;
   exfifo_of_wr         : in std_logic;		
   exfifo_if_d          : out std_logic_vector(7 downto 0);
   exfifo_if_rdempty    : out std_logic;
   exfifo_if_rd         : in std_logic;
	stream_rx_en			: in std_logic;
   read_32_open         : out std_logic
	 
	 
	 );
end pcie_top;
  
architecture sample_arch of pcie_top is

   component xillybus
      port (
         clk_125 						: IN std_logic;
         clk_50 						: IN std_logic;
         reconfig_clk_locked 		: IN std_logic;
         pcie_perstn 				: IN std_logic;
         pcie_refclk 				: IN std_logic;
         pcie_rx 						: IN std_logic_vector(3 DOWNTO 0);
         bus_clk 						: OUT std_logic;
         pcie_tx 						: OUT std_logic_vector(3 DOWNTO 0);
         quiesce 						: OUT std_logic;
         user_led 					: OUT std_logic_vector(3 DOWNTO 0);
         user_r_mem_8_rden 		: OUT std_logic;
         user_r_mem_8_empty 		: IN std_logic;
         user_r_mem_8_data 		: IN std_logic_vector(7 DOWNTO 0);
         user_r_mem_8_eof 			: IN std_logic;
         user_r_mem_8_open 		: OUT std_logic;
         user_w_mem_8_wren 		: OUT std_logic;
         user_w_mem_8_full 		: IN std_logic;
         user_w_mem_8_data 		: OUT std_logic_vector(7 DOWNTO 0);
         user_w_mem_8_open 		: OUT std_logic;
         user_mem_8_addr 			: OUT std_logic_vector(4 DOWNTO 0);
         user_mem_8_addr_update 	: OUT std_logic;
         user_r_read_32_rden 		: OUT std_logic;
         user_r_read_32_empty 	: IN std_logic;
         user_r_read_32_data		: IN std_logic_vector(31 DOWNTO 0);
         user_r_read_32_eof 		: IN std_logic;
         user_r_read_32_open 		: OUT std_logic;
         user_r_read_8_rden 		: OUT std_logic;
         user_r_read_8_empty 		: IN std_logic;
         user_r_read_8_data 		: IN std_logic_vector(7 DOWNTO 0);
         user_r_read_8_eof 		: IN std_logic;
         user_r_read_8_open 		: OUT std_logic;
         user_w_write_32_wren 	: OUT std_logic;
         user_w_write_32_full 	: IN std_logic;
         user_w_write_32_data 	: OUT std_logic_vector(31 DOWNTO 0);
         user_w_write_32_open 	: OUT std_logic;
         user_w_write_8_wren 		: OUT std_logic;
         user_w_write_8_full 		: IN std_logic;
         user_w_write_8_data 		: OUT std_logic_vector(7 DOWNTO 0);
         user_w_write_8_open 		: OUT std_logic);
  end component;

  COMPONENT altpll
    GENERIC (
      bandwidth_type				: STRING;
      clk0_divide_by				: NATURAL;
      clk0_duty_cycle			: NATURAL;
      clk0_multiply_by			: NATURAL;
      clk0_phase_shift			: STRING;
		clk1_divide_by				: NATURAL;
      clk1_duty_cycle			: NATURAL;
      clk1_multiply_by			: NATURAL;
      clk1_phase_shift			: STRING;
      inclk0_input_frequency	: NATURAL;
      intended_device_family	: STRING;
      lpm_hint						: STRING;
      lpm_type						: STRING;
      operation_mode				: STRING;
      pll_type						: STRING;
      port_activeclock			: STRING;
      port_areset					: STRING;
      port_clkbad0				: STRING;
      port_clkbad1				: STRING;
      port_clkloss				: STRING;
      port_clkswitch				: STRING;
      port_configupdate			: STRING;
      port_fbin					: STRING;
      port_fbout					: STRING;
      port_inclk0					: STRING;
      port_inclk1					: STRING;
      port_locked					: STRING;
      port_pfdena					: STRING;
      port_phasecounterselect	: STRING;
      port_phasedone				: STRING;
      port_phasestep				: STRING;
      port_phaseupdown			: STRING;
      port_pllena					: STRING;
      port_scanaclr				: STRING;
      port_scanclk				: STRING;
      port_scanclkena			: STRING;
      port_scandata				: STRING;
      port_scandataout			: STRING;
      port_scandone				: STRING;
      port_scanread				: STRING;
      port_scanwrite				: STRING;
      port_clk0					: STRING;
      port_clk1					: STRING;
      port_clk2					: STRING;
      port_clk3					: STRING;
      port_clk4					: STRING;
      port_clk5					: STRING;
      port_clk6					: STRING;
      port_clk7					: STRING;
      port_clk8					: STRING;
      port_clk9					: STRING;
      port_clkena0				: STRING;
      port_clkena1				: STRING;
      port_clkena2				: STRING;
      port_clkena3				: STRING;
      port_clkena4				: STRING;
      port_clkena5				: STRING;
      self_reset_on_loss_lock	: STRING;
      using_fbmimicbidir_port	: STRING;
      width_clock					: NATURAL
      );
    PORT (
      areset	: IN STD_LOGIC ;
      clk		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
      inclk		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      locked	: OUT STD_LOGIC 
      );
  END COMPONENT;
  
  
  COMPONENT fifo_8b IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty	: OUT STD_LOGIC ;
		wrfull	: OUT STD_LOGIC 
	);
END COMPONENT;


component fpga_outfifo IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdempty	: OUT STD_LOGIC ;
		rdusedw	: OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
		wrfull	: OUT STD_LOGIC ;
		wrusedw	: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;
  

--  type demo_mem is array(0 TO 31) of std_logic_vector(7 DOWNTO 0);
--  signal demoarray : demo_mem;
  
   signal bus_clk :  std_logic;
   signal quiesce : std_logic;
   
   signal reset_8 : std_logic;
   signal reset_32: std_logic;

   signal ram_addr : integer range 0 to 31;
   
   signal user_r_mem_8_rden 		:  std_logic;
   signal user_r_mem_8_empty 		:  std_logic;
   signal user_r_mem_8_data 		:  std_logic_vector(7 DOWNTO 0);
   signal user_r_mem_8_eof 			:  std_logic;
   signal user_r_mem_8_open 		:  std_logic;
   signal user_w_mem_8_wren 		:  std_logic;
   signal user_w_mem_8_full 		:  std_logic;
   signal user_w_mem_8_data 		:  std_logic_vector(7 DOWNTO 0);
   signal user_w_mem_8_open 		:  std_logic;
   signal user_mem_8_addr 			:  std_logic_vector(4 DOWNTO 0);
   signal user_mem_8_addr_update 	:  std_logic;
   signal user_r_read_32_rden 		:  std_logic;
   signal user_r_read_32_empty 	:  std_logic;
   signal user_r_read_32_rdusedw	:  std_logic_vector(12 downto 0);
   signal user_r_read_32_data 		:  std_logic_vector(31 DOWNTO 0);
   signal user_r_read_32_eof 		:  std_logic;
   signal user_r_read_32_open 		:  std_logic;
   signal user_r_read_32_cnt		:  unsigned(15 downto 0);
   signal user_r_read_8_rden 		:  std_logic;
   signal user_r_read_8_empty 		:  std_logic;
   signal user_r_read_8_data 		:  std_logic_vector(7 DOWNTO 0);
   signal user_r_read_8_eof 		:  std_logic;
   signal user_r_read_8_open 		:  std_logic;
   signal user_w_write_32_wren 	:  std_logic;
   signal user_w_write_32_full 	:  std_logic;
   signal user_w_write_32_data 	:  std_logic_vector(31 DOWNTO 0);
   signal user_w_write_32_open 	:  std_logic;
   signal user_w_write_8_wren 		:  std_logic;
   signal user_w_write_8_full 		:  std_logic;
   signal user_w_write_8_data 		:  std_logic_vector(7 DOWNTO 0);
   signal user_w_write_8_open 		:  std_logic;

   signal pll_areset 					:  std_logic;
   signal noclock 						:  std_logic;
   signal reconfig_clk_locked 		:  std_logic;
   signal out_clocks 					:  std_logic_vector(9 DOWNTO 0);
   signal in_clocks 					:  std_logic_vector(1 DOWNTO 0);
   signal clk_50 						: std_logic;
   signal clk_125 						: std_logic;
  
   signal clr_rx_fifo					: std_logic;
   
   signal pct_rdy						: std_logic;

   type array_type is array (0 to 15) of std_logic_vector(31 downto 0);
   type array_type2 is array (0 to 7) of std_logic_vector(11 downto 0);
  
   signal fpga_outfifo_q			: std_logic_vector(31 downto 0);
   signal fpga_outfifo_empty		: std_logic;
   signal fpga_outfifo_empty_gen : std_logic;

   signal stream_rx_en_sync      : std_logic;
	signal stream_rx_en_reg0		: std_logic;
	signal stream_rx_en_reg1		: std_logic;
	signal stream_rx_en_reg2		: std_logic;
  
begin

sync_reg0 : entity work.sync_reg 
port map(bus_clk, '1', stream_rx_en, stream_rx_en_sync);


-- ----------------------------------------------------------------------------
--For synchronising enable signal to bus_clk
-- ----------------------------------------------------------------------------	
	process(bus_clk, clr_rx_fifo)
	begin
		if clr_rx_fifo='1' then 
			stream_rx_en_reg0<='0';
			stream_rx_en_reg1<='0';
			stream_rx_en_reg2<='0';
		elsif (bus_clk'event and bus_clk='1') then
			stream_rx_en_reg0<=stream_rx_en_sync;
			stream_rx_en_reg1<=stream_rx_en_reg0;
			stream_rx_en_reg2<=stream_rx_en_reg1;
		end if;
	end process;


	--pcie bus clock for user needs
	pcie_bus_clk <= bus_clk;


-- ----------------------------------------------------------------------------
-- PLL inst for Xillybus 
-- ----------------------------------------------------------------------------	
  	clkpll : altpll
	GENERIC MAP (
		bandwidth_type 			=> "AUTO",
		clk0_divide_by 			=> 1,
		clk0_duty_cycle 			=> 50,
		clk0_multiply_by 			=> 1,
		clk0_phase_shift 			=> "0",
		clk1_divide_by 			=> 5,
		clk1_duty_cycle 			=> 50,
		clk1_multiply_by 			=> 2,
		clk1_phase_shift 			=> "0",
		inclk0_input_frequency 	=> 8000,
		intended_device_family 	=> "Cyclone IV",
		lpm_hint 					=> "CBX_MODULE_PREFIX=pll_vhdl",
		lpm_type 					=> "altpll",
		operation_mode 			=> "NO_COMPENSATION",
		pll_type 					=> "AUTO",
		port_activeclock 			=> "PORT_UNUSED",
		port_areset 				=> "PORT_USED",
		port_clkbad0 				=> "PORT_UNUSED",
		port_clkbad1 				=> "PORT_UNUSED",
		port_clkloss 				=> "PORT_UNUSED",
		port_clkswitch 			=> "PORT_UNUSED",
		port_configupdate 		=> "PORT_UNUSED",
		port_fbin 					=> "PORT_UNUSED",
		port_fbout 					=> "PORT_UNUSED",
		port_inclk0 				=> "PORT_USED",
		port_inclk1 				=> "PORT_UNUSED",
		port_locked 				=> "PORT_USED",
		port_pfdena 				=> "PORT_UNUSED",
		port_phasecounterselect => "PORT_UNUSED",
		port_phasedone 			=> "PORT_UNUSED",
		port_phasestep 			=> "PORT_UNUSED",
		port_phaseupdown 			=> "PORT_UNUSED",
		port_pllena 				=> "PORT_UNUSED",
		port_scanaclr 				=> "PORT_UNUSED",
		port_scanclk 				=> "PORT_UNUSED",
		port_scanclkena 			=> "PORT_UNUSED",
		port_scandata 				=> "PORT_UNUSED",
		port_scandataout 			=> "PORT_UNUSED",
		port_scandone 				=> "PORT_UNUSED",
		port_scanread 				=> "PORT_UNUSED",
		port_scanwrite 			=> "PORT_UNUSED",
		port_clk0 					=> "PORT_USED",
		port_clk1 					=> "PORT_UNUSED",
		port_clk2 					=> "PORT_UNUSED",
		port_clk3 					=> "PORT_UNUSED",
		port_clk4 					=> "PORT_UNUSED",
		port_clk5 					=> "PORT_UNUSED",
		port_clk6 					=> "PORT_UNUSED",
		port_clk7					=> "PORT_UNUSED",
		port_clk8 					=> "PORT_UNUSED",
		port_clk9 					=> "PORT_UNUSED",
		port_clkena0 				=> "PORT_UNUSED",
		port_clkena1 				=> "PORT_UNUSED",
		port_clkena2 				=> "PORT_UNUSED",
		port_clkena3 				=> "PORT_UNUSED",
		port_clkena4 				=> "PORT_UNUSED",
		port_clkena5 				=> "PORT_UNUSED",
		self_reset_on_loss_lock => "OFF",
		using_fbmimicbidir_port => "OFF",
		width_clock 				=> 10
	)
	PORT MAP (
		areset => pll_areset,
		inclk => in_clocks,
		locked => reconfig_clk_locked,
		clk => out_clocks
	);

  pll_areset 	<= '0';
  noclock 		<= '0';
  in_clocks 	<= noclock & inclk_125;
  clk_125 		<= out_clocks(0);
  clk_50 		<= out_clocks(1);
  
-- ----------------------------------------------------------------------------
-- Xillybus inst 
-- ----------------------------------------------------------------------------      
  xillybus_inst : xillybus
    port map (
      -- Ports related to /dev/xillybus_mem_8
      -- FPGA to CPU signals:
      user_r_mem_8_rden 		=> user_r_mem_8_rden,
      user_r_mem_8_empty 		=> user_r_mem_8_empty,
      user_r_mem_8_data 		=> user_r_mem_8_data,
      user_r_mem_8_eof			=> user_r_mem_8_eof,
      user_r_mem_8_open 		=> user_r_mem_8_open,
      -- CPU to FPGA signals:
      user_w_mem_8_wren 		=> user_w_mem_8_wren,
      user_w_mem_8_full 		=> user_w_mem_8_full,
      user_w_mem_8_data 		=> user_w_mem_8_data,
      user_w_mem_8_open 		=> user_w_mem_8_open,
      -- Address signals:
      user_mem_8_addr 			=> user_mem_8_addr,
      user_mem_8_addr_update 	=> user_mem_8_addr_update,

      -- Ports related to /dev/xillybus_read_32
      -- FPGA to CPU signals:
      user_r_read_32_rden 		=> user_r_read_32_rden,
      user_r_read_32_empty 	=> user_r_read_32_empty,
      user_r_read_32_data 		=> user_r_read_32_data,
      user_r_read_32_eof 		=> user_r_read_32_eof,
      user_r_read_32_open 		=> user_r_read_32_open,

      -- Ports related to /dev/xillybus_read_8
      -- FPGA to CPU signals:
      user_r_read_8_rden 		=> user_r_read_8_rden,
      user_r_read_8_empty 		=> user_r_read_8_empty,
      user_r_read_8_data 		=> user_r_read_8_data,
      user_r_read_8_eof 		=> user_r_read_8_eof,
      user_r_read_8_open 		=> user_r_read_8_open,

      -- Ports related to /dev/xillybus_write_32
      -- CPU to FPGA signals:
      user_w_write_32_wren 	=> user_w_write_32_wren,
      user_w_write_32_full 	=> user_w_write_32_full,
      user_w_write_32_data 	=> user_w_write_32_data,
      user_w_write_32_open 	=> user_w_write_32_open,

      -- Ports related to /dev/xillybus_write_8
      -- CPU to FPGA signals:
      user_w_write_8_wren 		=> user_w_write_8_wren,
      user_w_write_8_full		=> user_w_write_8_full,
      user_w_write_8_data 		=> user_w_write_8_data,
      user_w_write_8_open 		=> user_w_write_8_open,

      -- General signals
      clk_125 						=> clk_125,
      clk_50 						=> clk_50,
      reconfig_clk_locked 		=> reconfig_clk_locked,
      pcie_perstn 				=> pcie_perstn,
      pcie_refclk 				=> pcie_refclk,
      pcie_rx 						=> pcie_rx,
      bus_clk 						=> bus_clk,
      pcie_tx 						=> pcie_tx,
      quiesce 						=> quiesce,
      user_led 					=> user_led
      );
 

-- ----------------------------------------------------------------------------
--  A simple inferred RAM for Xillybus
-- ---------------------------------------------------------------------------- 
  ram_addr <= conv_integer(user_mem_8_addr);
  
--  process (bus_clk)
--  begin
--    if (bus_clk'event and bus_clk = '1') then
--      if (user_w_mem_8_wren = '1') then 
--        demoarray(ram_addr) <= user_w_mem_8_data;
--      end if;
--      if (user_r_mem_8_rden = '1') then
--        user_r_mem_8_data <= demoarray(ram_addr);
--      end if;
--    end if;
--  end process;

  user_r_mem_8_empty <= '0';
  user_r_mem_8_eof 	<= '0';
  user_w_mem_8_full 	<= '0';

	

	rx_fifo32_wr			<= user_w_write_32_wren;
	rx_fifo32_data			<= user_w_write_32_data;
	rx_fifo32_reset_req	<= not user_w_write_32_open;

   read_32_open         <= user_r_read_32_open;

	
	
-- ----------------------------------------------------------------------------
-- 32 - bit data path
-- ----------------------------------------------------------------------------
	fpga_outfifo_inst : fpga_outfifo PORT MAP (
		aclr		=> clr_rx_fifo, 
		data	 	=> tx_fifo32_data,
		rdclk	 	=> bus_clk,
		rdreq	 	=> user_r_read_32_rden,
		wrclk	 	=> tx_fifo32_wrclk,
		wrreq	 	=> tx_fifo32_wr,
		q	 		=> fpga_outfifo_q,--user_r_read_32_data,
		rdempty	=> fpga_outfifo_empty,
		rdusedw	=> user_r_read_32_rdusedw, 
		wrfull	=> open,
		wrusedw	=> tx_fifo32_wusedw
	);

  
    reset_32 		<= not (user_w_write_32_open or user_r_read_32_open);
	 clr_rx_fifo 	<= not user_r_read_32_open;
	 

--user_r_read_32_eof <= '0';

-- ----------------------------------------------------------------------------
-- 32b data path eof generation
-- ----------------------------------------------------------------------------
process (bus_clk)
	begin 
		if (bus_clk'event and bus_clk='1') then 
			if user_r_read_32_rden = '1' and stream_rx_en_reg1='0' then 
				user_r_read_32_eof <= '1';
			elsif (stream_rx_en_reg2='1' and stream_rx_en_reg1='0') and user_r_read_32_empty='1' then 
				user_r_read_32_eof <= '1';
			else 
				user_r_read_32_eof <= '0';
			end if;
		end if;
	end process;
  
-- ----------------------------------------------------------------------------
-- 8 - bit data path. 
-- ----------------------------------------------------------------------------
	--dual port FIFO
	fifo_8b_fpga2pc : fifo_8b PORT MAP (
		aclr	 	=> reset_8,
		data	 	=> exfifo_of_d,
		rdclk	 	=> bus_clk,
		rdreq	 	=> user_r_read_8_rden,
		wrclk	 	=> exfifo_clk,
		wrreq	 	=> exfifo_of_wr,
		q	 		=> user_r_read_8_data,
		rdempty	=> user_r_read_8_empty,
		wrfull	=> exfifo_of_wrfull
	);
	
	fifo_8b_pc2fpga : fifo_8b PORT MAP (
		aclr	 	=> reset_8,
		data	 	=> user_w_write_8_data,
		rdclk	 	=> exfifo_clk,
		rdreq	 	=> exfifo_if_rd,
		wrclk	 	=> bus_clk,
		wrreq	 	=> user_w_write_8_wren,
		q	 		=> exfifo_if_d,
		rdempty	=> exfifo_if_rdempty,
		wrfull	=> user_w_write_8_full
	); 
	

user_r_read_32_empty    <=fpga_outfifo_empty;
	
user_w_write_32_full    <=rx_fifo32_wfull;
	
user_r_read_32_data     <=fpga_outfifo_q;
	
reset_8                 <= not (user_w_write_8_open or user_r_read_8_open);

user_r_read_8_eof       <= '0';
  
end sample_arch;
