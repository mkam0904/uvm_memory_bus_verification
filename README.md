# uvm_memory_bus_verification

# I developed a reusable UVM verification environment for a memory-mapped bus with a 64-word memory slave. The environment includes a master agent, randomized and directed sequences, a transaction-level scoreboard with an independent reference memory model, and request/response handling. The testbench uses clocking blocks and modports for synchronized bus access, with reset-aware transaction handling. I structured the environment to support future slave-agent, functional coverage, and register-model integration.

uvm-memory-bus-verification/
│
├── rtl/
│   ├── bus_slave.sv
│   └── bus_master.sv
│
├── tb/
│   ├── interface/
│   │   └── bus_if.sv
│   │
│   ├── transactions/
│   │   └── bus_item.sv
│   │
│   ├── agents/
│   │   ├── master/
│   │   │   ├── bus_master_driver.sv
│   │   │   ├── bus_master_monitor.sv
│   │   │   ├── bus_master_sequencer.sv
│   │   │   └── bus_master_agent.sv
│   │   │
│   │   └── slave/
│   │       ├── bus_slave_driver.sv
│   │       ├── bus_slave_monitor.sv
│   │       ├── bus_slave_sequencer.sv
│   │       └── bus_slave_agent.sv
│   │
│   ├── sequences/
│   │   ├── bus_base_seq.sv
│   │   ├── bus_write_seq.sv
│   │   └── bus_read_seq.sv
│   │
│   ├── scoreboard/
│   │   ├── bus_reference_model.sv
│   │   └── bus_scoreboard.sv
│   │
│   ├── coverage/
│   │   └── bus_coverage.sv
│   │
│   ├── ral/
│   │   ├── bus_reg_model.sv
│   │   └── bus_reg_adapter.sv
│   │
│   ├── env/
│   │   └── bus_env.sv
│   │
│   ├── tests/
│   │   ├── bus_base_test.sv
│   │   └── bus_random_test.sv
│   │
│   ├── bus_tb_pkg.sv
│   └── tb_top.sv
│
├── sim/
│   ├── files.f
│   └── run.sh
│
├── docs/
│   ├── bus_protocol.md
│   └── memory_map.md
│
├── .gitignore
└── README.md


// Commands to create virtual env 
# Navigate to your project
cd C:\Users\doshi\dev\uvm\uvm_memory_bus_verification
# Create the environment
conda create -n uvm_verification python=3.11 -y
# Activate it
conda activate uvm_verification
# Verify
conda env list
python --version


# Initial repo setup, staging the starter files and pushing the first commit to origin/main.
# 1. Check your current Git status
git status
# 2. Stage your new project files
git add .
# 3. Verify which files are staged
git status
# 4. Commit your changes
git commit -m "Initialize UVM verification project"
# 5. Push your changes to GitHub
git push origin main
# 6. Verify that your repository is up to date
git status