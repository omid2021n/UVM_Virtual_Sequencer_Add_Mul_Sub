`include "uvm_macros.svh"
 import uvm_pkg::*;

//                                            add env

class add_transaction extends uvm_sequence_item;
  `uvm_object_utils(add_transaction)
  
  rand logic [3:0] add_in1,add_in2;
       logic clk, rst;
       logic [4:0] add_out;
  
  function new(string name = "add_transaction");
    super.new(name);
  endfunction

endclass : add_transaction

//                                            ADD  SEQ

class add_sequence extends uvm_sequence#(add_transaction);
  `uvm_object_utils(add_sequence)
  
  add_transaction tr;

  function new(string name = "add_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        `uvm_do(tr)
      end
  endtask
  
endclass  
//                                           ADD  Drv
  
  
  
class add_driver extends uvm_driver #(add_transaction);
  `uvm_component_utils(add_driver)
  
  virtual add_if aif;
  add_transaction tr;
  
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = add_transaction::type_id::create("tr");
      
   if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif)) 
      `uvm_error("drv","Unable to access Interface");
  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    forever
     begin
     
            seq_item_port.get(tr);
            `uvm_info("ADD_DRV", $sformatf(" add_in1:%0d add_in2:%0d ",tr.add_in1,tr.add_in2), UVM_NONE);
            aif.rst     <= 1'b0;
            aif.add_in1 <= tr.add_in1;
            aif.add_in2 <= tr.add_in2;
            repeat(3) @(posedge aif.clk);      
    end
  endtask

  
endclass
     

//                      ADD  Mon                  
class add_mon  extends uvm_monitor;
`uvm_component_utils(add_mon)

uvm_analysis_port#(add_transaction) send;
add_transaction tr;
virtual add_if aif;

    function new(input string inst = "add_mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = add_transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif))
        `uvm_error("MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge aif.clk);
      if(aif.rst)
        begin
          tr.rst = 1'b1;
          send.write(tr);
        end
      else
         begin
           @(posedge aif.clk);
           @(posedge aif.clk);
            tr.rst         = 1'b0;
            tr.add_in1     = aif.add_in1;
            tr.add_in2     = aif.add_in2;
            tr.add_out     = aif.add_out;
            send.write(tr);
         end
    
    
    end
   endtask 

endclass




      
 //                                               ADD  Agent
 class add_agent extends uvm_agent;
`uvm_component_utils(add_agent)
  


function new(input string inst = "add_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction

   add_driver d;
   uvm_sequencer #(add_transaction) a_seqr;
   add_mon m;


virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m = add_mon::type_id::create("m",this);
   d = add_driver::type_id::create("d",this);
   a_seqr = uvm_sequencer #(add_transaction)::type_id::create("a_seqr", this);

endfunction

virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  d.seq_item_port.connect(a_seqr.seq_item_export);
endfunction

endclass 
  
     
     

/////////////////////////////////////completion of adder env

//                                       Mul  Transaction

class mul_transaction extends uvm_sequence_item;
  `uvm_object_utils(mul_transaction)
  
  rand logic [3:0] mul_in1,mul_in2;
       logic clk, rst;
  logic [7:0] mul_out;
  
  function new(string name = "mul_transaction");
    super.new(name);
  endfunction

endclass : mul_transaction

////                              MUL  SEQ

class mul_sequence extends uvm_sequence#(mul_transaction);
  `uvm_object_utils(mul_sequence)
  
  mul_transaction tr;

  function new(string name = "mul_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        `uvm_do(tr)
      end
  endtask
  
endclass  
////                                      MUL  DRV             
  
  
  
class mul_driver extends uvm_driver #(mul_transaction);
  `uvm_component_utils(mul_driver)
  
  virtual mul_if mif;
  mul_transaction tr;
  
  
  function new(input string path = "mul_driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = mul_transaction::type_id::create("tr");
      
   if(!uvm_config_db#(virtual mul_if)::get(this,"","mif",mif)) 
     `uvm_error("mul_driver","Unable to access Interface");
  endfunction
  
  

  
  
  virtual task run_phase(uvm_phase phase);
       forever
          begin
     
            seq_item_port.get(tr);            
           `uvm_info("MUL_DRV", $sformatf(" mul_in1:%0d mul_in2:%0d ",tr.mul_in1,tr.mul_in2), UVM_NONE);
            mif.rst     <= 1'b0;
            mif.mul_in1 <= tr.mul_in1;
            mif.mul_in2 <= tr.mul_in2;
            repeat(3) @(posedge mif.clk);
        end
  endtask

  
endclass
     
///                                       MUL_MON
     
 class mul_mon extends uvm_monitor;
`uvm_component_utils(mul_mon)

uvm_analysis_port#(mul_transaction) send;
mul_transaction tr;
virtual mul_if mif;

    function new(input string inst = "mul_mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = mul_transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual mul_if)::get(this,"","mif",mif))//uvm_test_top.env.agent.drv.aif
        `uvm_error("MUL_MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge mif.clk);
      if(mif.rst)
        begin
          tr.rst = 1'b1;
          send.write(tr);
        end
      else
         begin
           @(posedge mif.clk);
           @(posedge mif.clk);
            tr.rst         = 1'b0;
            tr.mul_in1     = mif.mul_in1;
            tr.mul_in2     = mif.mul_in2;
            tr.mul_out     = mif.mul_out;
            send.write(tr);
         end
    
    
    end
   endtask 

endclass
////                                             MUL  AGENT
 class mul_agent extends uvm_agent;
`uvm_component_utils(mul_agent)
  


function new(input string inst = "mul_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction

   mul_driver d;
   uvm_sequencer #(mul_transaction) m_seqr;
   mul_mon m; 



virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m = mul_mon::type_id::create("m",this);
   d = mul_driver::type_id::create("d",this);
   m_seqr =  uvm_sequencer #(mul_transaction)::type_id::create("m_seqr", this);

endfunction

virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  d.seq_item_port.connect(m_seqr.seq_item_export);
endfunction

endclass 

/////////////////////////////////////completion of MUL

//                                       SUB Transaction

class sub_transaction extends uvm_sequence_item;
  `uvm_object_utils(sub_transaction)
  
  rand logic [3:0] sub_in1,sub_in2;
       logic clk, rst;
  logic [4:0] sub_out;
  
  function new(string name = "mul_transaction");
    super.new(name);
  endfunction

endclass : sub_transaction

////                              SUB  SEQ

class sub_sequence extends uvm_sequence#(sub_transaction);
  `uvm_object_utils(sub_sequence)
  
  sub_transaction tr;

  function new(string name = "sub_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        `uvm_do(tr)
      end
  endtask
  
endclass  
////                                      SUB  DRV             
  
  
  
class sub_driver extends uvm_driver #(sub_transaction);
  `uvm_component_utils(sub_driver)
  
  virtual sub_if sif;
  sub_transaction tr;
  
  
  function new(input string path = "sub_driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = sub_transaction::type_id::create("tr");
      
   if(!uvm_config_db#(virtual sub_if)::get(this,"","sif",sif)) 
     `uvm_error("sub_driver","Unable to access Interface");
  endfunction
  
  

  
  
  virtual task run_phase(uvm_phase phase);
       forever
          begin
     
            seq_item_port.get(tr);            
            `uvm_info("SUB_DRV", $sformatf(" sub_in1:%0d sub_in2:%0d ",tr.sub_in1,tr.sub_in2), UVM_NONE);
            sif.rst     <= 1'b0;
            sif.sub_in1 <= tr.sub_in1;
            sif.sub_in2 <= tr.sub_in2;
            repeat(3) @(posedge sif.clk);
        end
  endtask

  
endclass
     
///                                       SUB MON
     
 class sub_mon extends uvm_monitor;
   `uvm_component_utils(sub_mon)

   uvm_analysis_port#(sub_transaction) send;
   sub_transaction tr;
   virtual sub_if sif;

   function new(input string inst = "sub_mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = sub_transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual sub_if)::get(this,"","sif",sif))//uvm_test_top.env.agent.drv.aif
        `uvm_error("SUB_MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge sif.clk);
      if(sif.rst)
        begin
          tr.rst = 1'b1;
          send.write(tr);
        end
      else
         begin
           @(posedge sif.clk);
           @(posedge sif.clk);
            tr.rst         = 1'b0;
            tr.sub_in1     = sif.sub_in1;
            tr.sub_in2     = sif.sub_in2;
            tr.sub_out     = sif.sub_out;
            send.write(tr);
         end
    
    
    end
   endtask 

endclass
////                                             SUB  AGENT
 class sub_agent extends uvm_agent;
   `uvm_component_utils(sub_agent)
  


   function new(input string inst = "sub_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction

   sub_driver d;
   uvm_sequencer #(sub_transaction) s_seqr;
   sub_mon m; 



virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m = sub_mon::type_id::create("m",this);
   d = sub_driver::type_id::create("d",this);
  s_seqr =  uvm_sequencer #(sub_transaction)::type_id::create("s_seqr", this);

endfunction

virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  d.seq_item_port.connect(s_seqr.seq_item_export);
endfunction

endclass 
 
 
///                                    SCO
    
    `uvm_analysis_imp_decl(_add)
    `uvm_analysis_imp_decl(_mul)     
    `uvm_analysis_imp_decl(_sub)     

    
    
    
 class sco extends uvm_scoreboard;
`uvm_component_utils(sco)

   uvm_analysis_imp_add#(add_transaction,sco) recva;
   uvm_analysis_imp_mul#(mul_transaction,sco) recvm;
   uvm_analysis_imp_sub#(sub_transaction,sco) recvs;

   add_transaction atr;
   mul_transaction mtr;
   sub_transaction str;

   



    function new(input string inst = "mul_sco", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      recva = new("recva", this);
      recvm = new("recvm", this);
      recvs = new("recvs", this);

      atr = add_transaction::type_id::create("atr");
      mtr = mul_transaction::type_id::create("mtr");
      str = sub_transaction::type_id::create("str");

    endfunction
    
    
		virtual function void write_mul(mul_transaction tr);
      mtr = tr;
            if (mtr.mul_in1 >= 0 && mtr.mul_in2 >= 0)
            begin
              if(mtr.mul_out == mtr.mul_in1 * mtr.mul_in2) begin 
                `uvm_info("MUL_SCO", $sformatf("TEST PASSED : MOUT:%0d MIN1:%0d MIN2:%0d",mtr.mul_out, mtr.mul_in1, mtr.mul_in2), UVM_NONE)
                $display("=======================================================");
              end
                else
               `uvm_info("MUL_SCO", $sformatf("TEST FAILED : MOUT:%0d MIN1:%0d MIN2:%0d",mtr.mul_out, mtr.mul_in1, mtr.mul_in2), UVM_NONE) 
            end  
               else
                  return;
  endfunction
   
   
		virtual function void write_add(add_transaction tr);
     atr = tr;
     if(atr.add_in1 >= 0 && atr.add_in2 >= 0)
           begin
             if(atr.add_out == atr.add_in1 + atr.add_in2)  begin 
               `uvm_info("ADD_SCO", $sformatf("TEST PASSED : AOUT:%0d AIN1:%0d AIN2:%0d",atr.add_out, atr.add_in1, atr.add_in2), UVM_NONE)
              $display("=======================================================");

             end
               else
                   `uvm_error("ADD_SCO" , "TEST FAILED") 
           end
     else 
          return;
                   
  endfunction

   
             virtual function void write_sub(sub_transaction tr);
     str = tr;
               if(str.sub_in1 >= 0 && str.sub_in2 >= 0)
           begin
             if(str.sub_out ==  $signed(str.sub_in1) - $signed(str.sub_in2))  begin 
               `uvm_info("SUB_SCO", $sformatf("TEST PASSED : SOUT:%0d SIN1:%0d SIN2:%0d",str.sub_out, str.sub_in1, str.sub_in2), UVM_NONE)
              $display("=======================================================");

             end
               else     
             `uvm_error("SUB_SCO","TEST FAILED") 
                 end
              else
          return;
                   
  endfunction

endclass  

       
//                                        VS            
    
  class vsequencer extends uvm_sequencer;
   `uvm_component_utils(vsequencer)

    uvm_sequencer #(add_transaction) VA;
    uvm_sequencer #(mul_transaction) VM;
    uvm_sequencer #(sub_transaction) VS;

    
 
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
  
  //                                   Top VS


class top_vseq_base extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(top_vseq_base)

   
  
    vsequencer vseqr;




function new(string name = "top_vseq_base");
  super.new(name);
endfunction
  
  
task body();  
 
  if(!$cast(vseqr, m_sequencer)) begin
    `uvm_error(get_full_name(), "Virtual sequencer pointer cast failed");
  end 
  
  
  
endtask: body

  
endclass: top_vseq_base


//                                        ADD  Gen
      
 class add_gen extends top_vseq_base;
   `uvm_object_utils(add_gen)
   
   
     add_sequence aseq;
   

   function new(string name="add_gen");
        super.new(name);
    endfunction


    virtual task body();
      aseq =  add_sequence::type_id::create("aseq");
      super.body();
      aseq.start(vseqr.VA);
    endtask
  
   
endclass       
      
      
      
//                                      Mul  Gen     
     
 class mul_gen extends top_vseq_base;
   `uvm_object_utils(mul_gen)
   

     mul_sequence mseq;
   

    function new(string name="mul_gen");
        super.new(name);
    endfunction
  

    virtual task body();
      mseq =  mul_sequence::type_id::create("mseq");
      super.body();
      mseq.start(vseqr.VM);
    endtask
   
endclass
             
//                                    Sub   Gen 
             
     
 class sub_gen extends top_vseq_base;
   `uvm_object_utils(sub_gen)
   

     sub_sequence sseq;
   

   function new(string name="sub_gen");
        super.new(name);
    endfunction
  

    virtual task body();
      sseq =  sub_sequence::type_id::create("sseq");
      super.body();
      sseq.start(vseqr.VS);
    endtask
   
endclass               
      

                
///                                              Env
                 
class env extends uvm_env;
`uvm_component_utils(env)

function new(input string inst = "env", uvm_component c);
super.new(inst,c);
endfunction

  add_agent   aa;
  mul_agent   ma;
  sub_agent   sa;

  vsequencer  vseqr;
  sco s;
  
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  aa = add_agent::type_id::create("aa",this);
  ma = mul_agent::type_id::create("ma", this);
  sa = sub_agent::type_id::create("sa", this);

  vseqr = vsequencer::type_id::create("vseqr", this);
  s   = sco::type_id::create("s", this);
  
endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    vseqr.VA = aa.a_seqr;
    vseqr.VM = ma.m_seqr;
    vseqr.VS = sa.s_seqr;

    aa.m.send.connect(s.recva);
    ma.m.send.connect(s.recvm);
    sa.m.send.connect(s.recvs);

endfunction: connect_phase
  
  
endclass                 
                 
 ///                                         Test           
                 
class test extends uvm_test;
`uvm_component_utils(test)

function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
  
 env e; 
 add_gen agen;
 mul_gen mgen;
 sub_gen sgen; 
  
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
    e       = env::type_id::create("env",this);
    agen     = add_gen::type_id::create("agen");
    mgen     = mul_gen::type_id::create("mgen");
    sgen     = sub_gen::type_id::create("sgen");

   endfunction
  
                 
  virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
  
   // Proper use of virtual sequencer
    fork
     begin
       `uvm_info("TEST", "Starting ADD Generator", UVM_MEDIUM)
       agen.start(e.vseqr);  // waits for sequence to finish
        `uvm_info("TEST", "Finished ADD Generator", UVM_MEDIUM)
      end
      begin
       #20; // start MUL after small delay
       `uvm_info("TEST", "Starting MUL Generator", UVM_MEDIUM)
        mgen.start(e.vseqr);
       `uvm_info("TEST", "Finished MUL Generator", UVM_MEDIUM)
      end
      begin
        #20; // start SUB after small delay
        `uvm_info("TEST", "Starting SUB Generator", UVM_MEDIUM)
        sgen.start(e.vseqr);
        `uvm_info("TEST", "Finished SUB Generator", UVM_MEDIUM)
      end
    join 

phase.drop_objection(this);
endtask
  
endclass               
          
///                                             TestBench
     
 module tb;
  
   add_if aif();
   mul_if mif();
   sub_if sif();
  
   top dut (
            aif.add_in1, aif.add_in2,
            mif.mul_in1, mif.mul_in2,
            sif.sub_in1,sif.sub_in2,
            aif.clk, aif.rst,
            aif.add_out, mif.mul_out, sif.sub_out 
           );
  
  
  initial begin
    aif.clk <= 0;
  end

  always #10 aif.clk <= ~aif.clk;
  assign mif.clk = aif.clk;
  assign sif.clk = aif.clk;

  
  
  initial begin
    uvm_config_db#(virtual add_if)::set(null, "*", "aif", aif);
    uvm_config_db#(virtual mul_if)::set(null, "*", "mif", mif);
    uvm_config_db#(virtual sub_if)::set(null, "*", "sif", sif);

    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  
endmodule    
     
     
  
