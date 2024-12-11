### README for VGA Controller in VHDL Using Cyclone III FPGA

#### Project Overview
This project implements a VGA (Video Graphics Array) controller with a resolution of **800x600 pixels at 72 Hz** using **VHDL**. The system is programmed onto an **Altera Cyclone III FPGA (DE0 Board)** and supports RGB outputs with 4096 colors.

#### Implementation Highlights
- Designed using **Register Transfer Level (RTL)** methodology.
- Developed and synthesized in **Quartus II 13.1**.
- Utilized **ModelSim** for testbench validation and waveform analysis.

#### Features
1. **VGA Signal Generation**:
   - Outputs vertical and horizontal sync signals (`vsync`, `hsync`).
   - RGB signal generation for solid colors, test patterns, and images.
2. **Custom Image Display**:
   - Displays a 50x37 pixel image stored in ROM.
   - Includes an address mapping mechanism to scale lower-resolution images.
3. **Modular Design**:
   - Generic components (`gen_counter`, `gen_sync`) for reusability.
   - Parameters for timing and resolution configuration.
4. **Development and Testing**:
   - Functional simulations in ModelSim.
   - Signal validation with an oscilloscope.
   - On-board testing with VGA monitors.

#### Next Steps
1. Refactor the `rgb` component for independent testing.
2. Use constant-based configuration instead of extensive generic parameters.
3. Modularize further to separate sync signal generation and address handling.

#### Final Output
The VGA controller displays a demonstration image and test patterns, validating its functionality and modular design approach.

#### Tools and Resources
- **Quartus II 13.1** for synthesis and FPGA programming.
- **ModelSim 10.1** for simulations.
- **Cyclone III FPGA DE0 Board** for hardware validation.
