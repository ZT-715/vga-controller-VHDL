### README for VGA Controller in VHDL Using Cyclone III FPGA

#### Project Overview
This project implements a VGA (Video Graphics Array) controller with a resolution of **800x600 pixels at 72 Hz** using **VHDL**. The system is programmed onto an **Altera Cyclone III FPGA (DE0 Board)** and supports RGB outputs with 4096 colors.
![alt text](https://github.com/ZT-715/vga-controller-VHDL/blob/master/Terceiro%20teste%20-%20gradiente.png?raw=true)


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

#### Final Result
The VGA controller displays a demonstration image and test patterns, validating its functionality and modular design approach.
![alt text](https://github.com/ZT-715/vga-controller-VHDL/blob/master/Segundo%20teste%20-%20barras%20coloridas.png?raw=true)
![alt text](https://github.com/ZT-715/vga-controller-VHDL/blob/master/imagem%20final.png?raw=true)

#### Next Steps
1. Refactor the `rgb` component for independent testing.
2. Complete generic parameters implementation by adding automatic calculations so the controller becomes 100% generic.
3. Modularize further to separate sync signal generation and address handling.

#### Tools and Resources
- **Quartus II 13.1** for synthesis and FPGA programming.
- **ModelSim 10.1** for simulations.
- **Cyclone III FPGA DE0 Board**.
