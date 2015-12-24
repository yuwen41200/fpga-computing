// This file is part of the Xillybus project.

`timescale 1ns / 10ps

module xillybus(PCIE_TX0_P, PCIE_TX0_N, PCIE_RX0_P, PCIE_RX0_N, PCIE_REFCLK_P,
  PCIE_REFCLK_N, PCIE_PERST_B_LS, bus_clk, quiesce, GPIO_LED,
  user_r_read_32_rden, user_r_read_32_data, user_r_read_32_empty,
  user_r_read_32_eof, user_r_read_32_open, user_w_write_32_wren,
  user_w_write_32_data, user_w_write_32_full, user_w_write_32_open,
  user_r_read_8_rden, user_r_read_8_data, user_r_read_8_empty,
  user_r_read_8_eof, user_r_read_8_open, user_w_write_8_wren,
  user_w_write_8_data, user_w_write_8_full, user_w_write_8_open,
  user_r_mem_8_rden, user_r_mem_8_data, user_r_mem_8_empty, user_r_mem_8_eof,
  user_r_mem_8_open, user_w_mem_8_wren, user_w_mem_8_data, user_w_mem_8_full,
  user_w_mem_8_open, user_mem_8_addr, user_mem_8_addr_update);

  input  PCIE_RX0_P;
  input  PCIE_RX0_N;
  input  PCIE_REFCLK_P;
  input  PCIE_REFCLK_N;
  input  PCIE_PERST_B_LS;
  input [31:0] user_r_read_32_data;
  input  user_r_read_32_empty;
  input  user_r_read_32_eof;
  input  user_w_write_32_full;
  input [7:0] user_r_read_8_data;
  input  user_r_read_8_empty;
  input  user_r_read_8_eof;
  input  user_w_write_8_full;
  input [7:0] user_r_mem_8_data;
  input  user_r_mem_8_empty;
  input  user_r_mem_8_eof;
  input  user_w_mem_8_full;
  output  PCIE_TX0_P;
  output  PCIE_TX0_N;
  output  bus_clk;
  output  quiesce;
  output [3:0] GPIO_LED;
  output  user_r_read_32_rden;
  output  user_r_read_32_open;
  output  user_w_write_32_wren;
  output [31:0] user_w_write_32_data;
  output  user_w_write_32_open;
  output  user_r_read_8_rden;
  output  user_r_read_8_open;
  output  user_w_write_8_wren;
  output [7:0] user_w_write_8_data;
  output  user_w_write_8_open;
  output  user_r_mem_8_rden;
  output  user_r_mem_8_open;
  output  user_w_mem_8_wren;
  output [7:0] user_w_mem_8_data;
  output  user_w_mem_8_open;
  output [4:0] user_mem_8_addr;
  output  user_mem_8_addr_update;
  wire  trn_reset_n;
  wire [63:0] trn_td;
  wire  trn_tsof_n;
  wire  trn_teof_n;
  wire  trn_tsrc_rdy_n;
  wire  trn_tdst_rdy_n;
  wire [7:0] trn_trem_n;
  wire [63:0] trn_rd;
  wire  trn_rsof_n;
  wire  trn_reof_n;
  wire  trn_rsrc_rdy_n;
  wire  trn_rdst_rdy_n;
  wire  trn_rerrfwd_n;
  wire  trn_rnp_ok_n;
  wire [7:0] trn_rrem_n;
  wire [6:0] trn_rbar_hit_n;
  wire  cfg_interrupt_n;
  wire  cfg_interrupt_rdy_n;
  wire [7:0] cfg_bus_number;
  wire [4:0] cfg_device_number;
  wire [2:0] cfg_function_number;
  wire [15:0] cfg_dcommand;
  wire [15:0] cfg_lcommand;
  wire [15:0] cfg_dstatus;
  wire  pcie_ref_clk;

   // This perl snippet turns the input/output ports to wires, so only
   // those that really connect something become real ports (input/output
   // keywords are used to create global variables)

   IBUFDS pcieclk_ibuf (.O(pcie_ref_clk), .I(PCIE_REFCLK_P), .IB(PCIE_REFCLK_N));

   pcie_v5 pcie 
     (
      .pci_exp_txp( PCIE_TX0_P ),
      .pci_exp_txn( PCIE_TX0_N ),
      .pci_exp_rxp( PCIE_RX0_P ),
      .pci_exp_rxn( PCIE_RX0_N ),

      .sys_clk(pcie_ref_clk),
      .sys_reset_n( PCIE_PERST_B_LS ),
      
      .refclkout( ),

      .trn_clk(bus_clk),
      .trn_reset_n(trn_reset_n), // Toggles 4 ns before bus_clk
      .trn_lnk_up_n( ),

      .trn_td( trn_td ),
      .trn_trem_n( trn_trem_n ),
      .trn_tsof_n( trn_tsof_n ),
      .trn_teof_n( trn_teof_n ),
      .trn_tsrc_rdy_n( trn_tsrc_rdy_n ),
      .trn_tsrc_dsc_n(1'b1),
      .trn_tdst_rdy_n( trn_tdst_rdy_n ),
      .trn_tdst_dsc_n( ),     // Always tied high anyhow
      .trn_terrfwd_n( 1'b1 ), // Ignored anyhow
      .trn_tbuf_av(  ),       // Not used

      .trn_rd( trn_rd ),
      .trn_rrem_n( trn_rrem_n ),
      .trn_rsof_n( trn_rsof_n ),
      .trn_reof_n( trn_reof_n ),
      .trn_rsrc_rdy_n( trn_rsrc_rdy_n ),
      .trn_rsrc_dsc_n( ), // Always tied high anyhow
      .trn_rdst_rdy_n( trn_rdst_rdy_n ),
      .trn_rerrfwd_n( trn_rerrfwd_n ),
      .trn_rnp_ok_n( trn_rnp_ok_n ),
      .trn_rbar_hit_n( trn_rbar_hit_n ),
      .trn_rfc_nph_av(  ),
      .trn_rfc_npd_av(  ),
      .trn_rfc_ph_av( ),
      .trn_rfc_pd_av( ),
      .trn_rcpl_streaming_n(1'b1), // No streaming transmission

      .cfg_di( 32'd0 ),
      .cfg_byte_en_n( 4'hf ),
      .cfg_dwaddr( 10'd0 ),
      .cfg_wr_en_n( 1'b1 ),
      .cfg_rd_en_n( 1'b1 ),

      .cfg_err_cor_n(1'b1),
      .cfg_err_ur_n(1'b1),
      .cfg_err_cpl_rdy_n(),
      .cfg_err_ecrc_n(1'b1),
      .cfg_err_cpl_timeout_n(1'b1),
      .cfg_err_cpl_abort_n(1'b1),
      .cfg_err_cpl_unexpect_n(1'b1),
      .cfg_err_posted_n(1'b1),
      .cfg_err_tlp_cpl_header(1'b1),
      .cfg_err_locked_n(1'b1),

      .cfg_interrupt_n( cfg_interrupt_n ),
      .cfg_interrupt_rdy_n( cfg_interrupt_rdy_n ),

      .cfg_interrupt_assert_n(1'b1),
      .cfg_interrupt_di(8'd0), // Single MSI anyhow
      .cfg_interrupt_do(),
      .cfg_interrupt_mmenable(),
      .cfg_interrupt_msienable(),
      .cfg_to_turnoff_n( ),
      .cfg_pm_wake_n(1'b1),
      .cfg_pcie_link_state_n( ),
      .cfg_trn_pending_n(1'b1),

      .cfg_bus_number( cfg_bus_number ),
      .cfg_device_number( cfg_device_number ),
      .cfg_function_number( cfg_function_number ),
      .cfg_status(  ),
      .cfg_command( ),
      .cfg_dstatus( cfg_dstatus ),
      .cfg_dcommand( cfg_dcommand ),
      .cfg_lstatus(  ),
      .cfg_lcommand( cfg_lcommand ),
      .cfg_dsn(64'd0),

       // The following is used for simulation only.  Setting
       // the following core input to 1 will result in a fast
       // train simulation to happen.  This bit should not be set
       // during synthesis or the core may not operate properly.
       `ifdef SIMULATION
       .fast_train_simulation_only(1'b1)
       `else
       .fast_train_simulation_only(1'b0)
       `endif

);

  xillybus_core  xillybus_core_ins(.trn_reset_n_w(trn_reset_n),
    .quiesce_w(quiesce), .GPIO_LED_w(GPIO_LED), .trn_td_w(trn_td),
    .trn_tsof_n_w(trn_tsof_n), .trn_teof_n_w(trn_teof_n),
    .trn_tsrc_rdy_n_w(trn_tsrc_rdy_n), .trn_tdst_rdy_n_w(trn_tdst_rdy_n),
    .trn_trem_n_w(trn_trem_n), .trn_rd_w(trn_rd), .trn_rsof_n_w(trn_rsof_n),
    .trn_reof_n_w(trn_reof_n), .trn_rsrc_rdy_n_w(trn_rsrc_rdy_n),
    .trn_rdst_rdy_n_w(trn_rdst_rdy_n), .trn_rerrfwd_n_w(trn_rerrfwd_n),
    .trn_rnp_ok_n_w(trn_rnp_ok_n), .trn_rrem_n_w(trn_rrem_n),
    .trn_rbar_hit_n_w(trn_rbar_hit_n), .cfg_interrupt_n_w(cfg_interrupt_n),
    .cfg_interrupt_rdy_n_w(cfg_interrupt_rdy_n), .cfg_bus_number_w(cfg_bus_number),
    .cfg_device_number_w(cfg_device_number), .cfg_function_number_w(cfg_function_number),
    .cfg_dcommand_w(cfg_dcommand), .cfg_lcommand_w(cfg_lcommand),
    .cfg_dstatus_w(cfg_dstatus), .user_r_read_32_rden_w(user_r_read_32_rden),
    .user_r_read_32_data_w(user_r_read_32_data), .user_r_read_32_empty_w(user_r_read_32_empty),
    .user_r_read_32_eof_w(user_r_read_32_eof), .user_r_read_32_open_w(user_r_read_32_open),
    .user_w_write_32_wren_w(user_w_write_32_wren),
    .user_w_write_32_data_w(user_w_write_32_data),
    .user_w_write_32_full_w(user_w_write_32_full),
    .user_w_write_32_open_w(user_w_write_32_open),
    .user_r_read_8_rden_w(user_r_read_8_rden), .user_r_read_8_data_w(user_r_read_8_data),
    .user_r_read_8_empty_w(user_r_read_8_empty), .user_r_read_8_eof_w(user_r_read_8_eof),
    .user_r_read_8_open_w(user_r_read_8_open), .user_w_write_8_wren_w(user_w_write_8_wren),
    .user_w_write_8_data_w(user_w_write_8_data), .user_w_write_8_full_w(user_w_write_8_full),
    .user_w_write_8_open_w(user_w_write_8_open), .user_r_mem_8_rden_w(user_r_mem_8_rden),
    .user_r_mem_8_data_w(user_r_mem_8_data), .user_r_mem_8_empty_w(user_r_mem_8_empty),
    .user_r_mem_8_eof_w(user_r_mem_8_eof), .user_r_mem_8_open_w(user_r_mem_8_open),
    .user_w_mem_8_wren_w(user_w_mem_8_wren), .user_w_mem_8_data_w(user_w_mem_8_data),
    .user_w_mem_8_full_w(user_w_mem_8_full), .user_w_mem_8_open_w(user_w_mem_8_open),
    .bus_clk_w(bus_clk), .user_mem_8_addr_w(user_mem_8_addr),
    .user_mem_8_addr_update_w(user_mem_8_addr_update));

endmodule
