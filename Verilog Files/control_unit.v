module controlUnit (
    input clk, rst,
    output [1:0] mem_data_sel,
    input branch_taken,
    input interrupt,
    output ack,
    input load_use,
    input[4:0] opCode,
    output[4:0] aluOp,
    output [1:0] aluSrc,
    output RegWR, MemR, MemWR, ldm, Mem_to_Reg, stack , branch,
    output[1:0] pc_sel,
    output pop_pc1, pop_pc2, pop_ccr, fetch_pc_enable,
    output freeze_cu, call, rti, ret,
    output portR, portWR, flush, ldm_value, flush_fetch
  );
  wire flush_call, flush_ret;
  wire pc_to_stack1, pc_to_stack2, ccr_to_stack;
  wire MemWR_call, MemWR_int, MemWR_cu,
       MemR_rti, MemR_ret, MemR_cu,
       stack_int, stack_call, stack_cu, stack_rti, stack_ret,
       pc_to_stack1_call, pc_to_stack1_int, pc_to_stack2_call, pc_to_stack2_int,
       ccr_to_stack_int,
       pop_pc1_ret, pop_pc1_rti, pop_pc2_ret, pop_pc2_rti,
       pop_ccr_rti,
       freeze_pc_int, freeze_pc_rti, freeze_pc_ret, freeze_pc,
       freeze_cu_int, freeze_cu_rti, freeze_cu_ret, freeze_cu_ldm;
       
  wire [1:0] pc_sel_int, pc_sel_call, pc_sel_ret, pc_sel_rti;

  assign branch = rst == 1'b1 ? 'b0 : opCode[4] && ~opCode[3] && opCode[2];

  assign aluSrc = rst == 1'b1 ? 'b0 : {(opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]), (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && ~opCode[0])};

  assign flush = flush_ret;
  assign flush_fetch = branch_taken | flush_call;

  assign ldm = rst == 1'b1 ? 'b0 : (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]);

  assign aluOp = rst == 1'b1 ? 'b0 : opCode;

  assign MemR_cu = rst == 1'b1 ? 'b0 : (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]) || (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign MemWR_cu = rst == 1'b1 ? 'b0 : (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]);
  assign RegWR = rst == 1'b1 ? 'b0 : (opCode == 5'b00011 || opCode == 5'b00100 || opCode == 5'b00101 || opCode == 5'b01000 || (opCode[4] == 1'b0 && opCode[3] == 1'b1) || opCode == 5'b10000 || opCode == 5'b10001 || opCode == 5'b10010); //(~opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign Mem_to_Reg = rst == 1'b1 ? 'b0 : (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign stack_cu = rst == 1'b1 ? 'b0 : (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && opCode[0]);

  assign portR = rst == 1'b1 ? 'b0 : (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && opCode[0]);
  assign portWR = rst == 1'b1 ? 'b0 : (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && ~opCode[0]);

  assign call = rst == 1'b1 ? 'b0 : (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]);
  assign rti = rst == 1'b1 ? 'b0 : (opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign ret = rst == 1'b1 ? 'b0 : (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]);
  
  assign MemR = rst == 1'b1 ? 'b0 :  MemR_cu | MemR_rti | MemR_ret;
  assign MemWR = rst == 1'b1 ? 'b0 : MemWR_cu | MemWR_int | MemWR_call;
  assign stack = rst == 1'b1 ? 'b0 : stack_cu | stack_rti | stack_ret | stack_int | stack_call;
  assign pc_to_stack1 = rst == 1'b1 ? 'b0 : pc_to_stack1_int | pc_to_stack1_call;
  assign pc_to_stack2 = rst == 1'b1 ? 'b0 : pc_to_stack2_int | pc_to_stack2_call;
  assign ccr_to_stack = rst == 1'b1 ? 'b0 : ccr_to_stack_int;
  assign pop_pc1 = rst == 1'b1 ? 'b0 : pop_pc1_rti | pop_pc1_ret;
  assign pop_pc2 = rst == 1'b1 ? 'b0 : pop_pc2_rti | pop_pc2_ret;
  assign pop_ccr = rst == 1'b1 ? 'b0 : pop_ccr_rti;
  assign freeze_cu = rst == 1'b1 ? 'b0 : load_use | freeze_cu_int | freeze_cu_ret | freeze_cu_rti | freeze_cu_ldm;
  assign freeze_pc = rst == 1'b1 ? 'b0 : freeze_pc_int | freeze_pc_ret | freeze_pc_rti;

  assign fetch_pc_enable = freeze_pc == 1'b1 ? 1'b0 : 1'b1;
  assign mem_data_sel = (rst == 1'b1) ? 'b0 : (pc_to_stack1 == 1'b1) ? 2'b01 : (pc_to_stack2 == 1'b1) ? 2'b10 : (ccr_to_stack == 1'b1) ? 2'b11 : 2'b0;
  assign pc_sel = rst == 1'b1 ? 'b0 : pc_sel_int | pc_sel_call | pc_sel_ret | pc_sel_rti | {1'b0 , rst} | {branch_taken, branch_taken};

  ldmSM 
    ldmSM_dut (
      .clk (clk ),
      .rst (rst ),
      .ldm (ldm ),
      .freeze_cu  ( freeze_cu_ldm),
      .ldm_value (ldm_value)
    );




  callSM
    callSM_dut (
      .call (call ),
      .clk (clk ),
      .rst (rst ),
      .pc_to_stack1 (pc_to_stack1_call ),
      .pc_to_stack2 (pc_to_stack2_call ),
      .stack (stack_call ),
      .MemWR (MemWR_call ),
      .pc_sel (pc_sel_call ),
      .flush(flush_call)
    );

  retSM
    retSM_dut (
      .ret (ret),
      .clk (clk),
      .rst (rst),
      .pop_pc1 (pop_pc1_ret),
      .pop_pc2 (pop_pc2_ret),
      .stack (stack_ret),
      .MemR (MemR_ret),
      .freeze_pc (freeze_pc_ret),
      .freeze_cu  ( freeze_cu_ret),
      .pc_sel (pc_sel_ret),
      .flush (flush_ret)
    );

  intSM
    intSM_dut (
      .interrupt (interrupt ),
      .clk (clk ),
      .rst (rst ),
      .ldm (ldm ),
      .load_use (load_use ),
      .ccr_to_stack (ccr_to_stack_int ),
      .pc_to_stack1 (pc_to_stack1_int ),
      .pc_to_stack2 (pc_to_stack2_int ),
      .stack (stack_int ),
      .MemWR (MemWR_int ),
      .freeze_pc (freeze_pc_int ),
      .freeze_cu  ( freeze_cu_int),
      .pc_sel (pc_sel_int),
      .branch_taken(branch_taken),
      .ack(ack)
    );

  rtiSM
    rtiSM_dut (
      .rti (rti ),
      .clk (clk ),
      .rst (rst ),
      .pop_ccr (pop_ccr_rti ),
      .pop_pc1 (pop_pc1_rti ),
      .pop_pc2 (pop_pc2_rti ),
      .stack (stack_rti ),
      .MemR (MemR_rti ),
      .freeze_pc (freeze_pc_rti ),
      .freeze_cu  ( freeze_cu_rti),
      .pc_sel (pc_sel_rti)
    );

endmodule

//F D E M WB 
//  F F D E M WB

module ldmSM (
  input clk, rst, ldm,
  output reg freeze_cu, ldm_value
);
reg     [1:0] current_state, next_state;
parameter idle_state = 0, freeze_cu_state = 1;
reg trigger = 1'b0;

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    current_state = idle_state;
    trigger = 1'b1;

  end
  if(clk)
  begin
    current_state = next_state;
    trigger = 1'b0;

  end
end

always @ (current_state, ldm)
begin
  next_state = idle_state;
  case(current_state)
    idle_state:
    begin
      freeze_cu = 1'b0;
      ldm_value = 1'b0;
      if(ldm)
      begin
        next_state = freeze_cu_state;
        freeze_cu = 1'b1;
      end
    end
    freeze_cu_state:
    begin
      freeze_cu = 1'b0;
      ldm_value = 1'b1;
      next_state = idle_state;
    end
    default:
    begin
      next_state = idle_state;
    end
  endcase

end


endmodule

module callSM ( 
  input call, clk, rst,
  output reg pc_to_stack1, pc_to_stack2, stack, MemWR,
  output reg [1:0] pc_sel,
  output reg flush
                );
  reg     [1:0] current_state, next_state;
  // push pc from decode not from pc itself
  // code
  // calling
  // code     --> pc to be pushed before going to the procedure
  //we don't have to push ccr

  reg trigger = 1'b0;

  parameter idle_state = 0, push_pc1 = 1, push_pc2 = 2;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
      trigger = 1'b1;

    end
    if(clk)
    begin
      current_state = next_state;
      trigger = 1'b0;

    end
  end

  always @ (current_state, call)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        MemWR = 1'b0;
        stack = 1'b0;
        pc_to_stack2 = 1'b0;
        pc_to_stack1 = 1'b0;
        flush = 1'b0;
        if(call)
        begin
          pc_sel = 2'b11;
          MemWR = 1'b1;
          stack = 1'b1;
          pc_to_stack1 = 1'b1;  
          next_state = push_pc2;
          end
      end
      push_pc2:
      begin
        pc_sel = 2'b0;
        next_state = idle_state;
        pc_to_stack1 = 1'b0;  
        pc_to_stack2 = 1'b1;
        flush = 1'b1;
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end


endmodule


module retSM (
    input ret, clk, rst,
    output reg pop_pc1, pop_pc2, stack, MemR, freeze_pc, freeze_cu, flush,
    output reg [1:0] pc_sel
  );
  reg     [1:0] current_state, next_state;
  reg trigger = 1'b0;
  parameter idle_state = 2, pop_pc1_state = 3, wait0 = 0, wait1= 1;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = wait0;
      trigger = 1'b1;

    end
    if(clk)
    begin
      current_state = next_state;
      trigger = 1'b0;

    end
  end

  always @ (current_state, ret)
  begin
    next_state = idle_state;
    case(current_state)
      wait0:
      begin
        pc_sel = 2'b0;
        freeze_cu = 1'b0;
        freeze_pc = 1'b0;
        MemR = 1'b0;
        stack = 1'b0;
        pop_pc2 = 1'b0;
        pop_pc1 = 1'b0;
        flush = 1'b0;
        if(ret)begin
          next_state = wait1;
        end
        else begin
          next_state = wait0;
        end
      end
      wait1:
      begin
        next_state = idle_state;
      end
      idle_state:
      begin
          freeze_cu = 1'b1;
          freeze_pc = 1'b1; 
          next_state = pop_pc1_state;
          MemR = 1'b1;
          stack = 1'b1;  
          pop_pc2 = 1'b1;
      end
      pop_pc1_state:
      begin
        pop_pc2 = 1'b0;
        pop_pc1 = 1'b1;
        // flush = 1'b1;
        next_state = wait0;
      end
      default:
      begin
        next_state = wait0;
      end
    endcase

  end




endmodule


module intSM (
    input interrupt, branch_taken,
    output reg ack,
    input clk, rst, ldm, load_use,
    output reg ccr_to_stack , pc_to_stack1, pc_to_stack2, stack, MemWR, freeze_pc, freeze_cu,
    output reg [1:0] pc_sel
  );
  reg     [3:0] current_state, next_state, prev_state;
  parameter idle_state = 0, wait_1 = 1, wait_2_ldm_load_use = 2, freezePc = 3, freezePc_cu = 4, wait_3 = 5, wait_4 = 6, push_pc1 = 7, push_pc2 = 8, push_ccr = 9, refreeze_pc_state_1 = 10, refreeze_pc_state_2 = 11;
  reg trigger = 1'b0;
  //assign interrupt = ack == 1'b1 ? 1'b0 : interrupt;


  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
      prev_state = idle_state;
    end
    if(clk)
    begin
      current_state = next_state;
    end
  end

  always @ (current_state, interrupt)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        freeze_pc = 0;
        freeze_cu = 0;
        stack = 0;
        MemWR = 0;
        ack = 1'b0;   //modified
        ccr_to_stack = 0;
        pc_to_stack1 = 0;
        pc_to_stack2 = 0;
        if(interrupt == 1)
        begin
          next_state = wait_1;
        end
        else
        begin
          ack = 1'b0;
          next_state = idle_state;
        end
      end
      wait_1:
      begin
        ack = 1'b1;
        if(ldm || load_use)
        begin
          next_state = wait_2_ldm_load_use;
        end
        else
        begin
          if(~branch_taken)
            freeze_pc = 1'b1;
          next_state = freezePc;
        end
      end
      wait_2_ldm_load_use:
        next_state = freezePc;
      freezePc:
      begin
        freeze_pc = 1'b1;
        next_state = freezePc_cu;
      end
      freezePc_cu:
      begin
        ack = 0;
        freeze_cu = 1'b1;
        next_state = wait_3;
      end
      wait_3:
      begin
        next_state = wait_4;
      end
      wait_4:
      begin
        next_state = push_pc1;
      end
      push_pc1:
      begin
        next_state = push_pc2;
        pc_to_stack1 = 1;
        stack = 1;
        MemWR = 1;
      end
      push_pc2:
      begin
        next_state = push_ccr;
        pc_to_stack1 = 0;
        pc_to_stack2 = 1;
      end
      push_ccr:
      begin
        next_state = refreeze_pc_state_1;
        ccr_to_stack = 1;
        //freeze_pc = 1'b0;   //modified
        pc_sel = 2'b10;
      end
      refreeze_pc_state_1:
      begin
        next_state = idle_state;
      end
      refreeze_pc_state_2:
      begin
        
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end


endmodule


module rtiSM (
    input rti, clk, rst,
    output reg pop_ccr , pop_pc1, pop_pc2, stack, MemR, freeze_pc, freeze_cu,
    output reg [1:0] pc_sel
  );

  reg     [1:0] current_state, next_state;
  reg trigger = 1'b0;

  parameter idle_state = 0, pop_ccr_state = 1, pop_pc2_state = 2, pop_pc1_state = 3;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
      trigger = 1'b1;

    end
    if(clk)
    begin
      current_state = next_state;
      trigger = 1'b0;

    end
  end

  always @ (current_state, rti)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        pop_ccr = 1'b0;
        freeze_cu = 1'b0;
        freeze_pc = 1'b0;
        MemR = 1'b0;
        stack = 1'b0;
        pop_pc2 = 1'b0;
        pop_pc1 = 1'b0;
        if(rti)
        begin
          next_state = pop_ccr_state;
          pc_sel = 2'b11;
        end
      end
      pop_ccr_state:
      begin
        next_state = pop_pc2_state;
        freeze_cu = 1'b1;
        freeze_pc = 1'b1;
        MemR = 1'b1;
        stack = 1'b1;
        pop_ccr = 1'b1;
        //pc_sel = 2'b11;
      end
      pop_pc2_state:
      begin
        next_state = pop_pc1_state;
        pop_ccr = 1'b0;
        pop_pc1 = 1'b1;

      end
      pop_pc1_state:
      begin
        next_state = idle_state;
        pop_pc1 = 1'b0;
        pop_pc2 = 1'b1;    
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end


endmodule
