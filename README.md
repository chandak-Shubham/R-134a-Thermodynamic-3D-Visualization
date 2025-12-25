# R-134a-Thermodynamic-3D-Visualization

This project focuses on generating and visualizing the **3D pressure–specific volume–temperature (P–v–T) surface** of the refrigerant **R-134a** near the liquid–vapor saturation dome, and using it to understand practical refrigeration systems.

The project was completed as part of the **ES 211 – Thermodynamics** course at **IIT Gandhinagar**.

---

## Core Features

### 1. Thermodynamic Data Generation
- Generated P–v–T data for R-134a using the **Cantera** real-fluid library. 

### 2. 3D Visualization
- MATLAB-based visualization of the liquid–vapor dome.  
- Clear identification of phase regions and critical point behavior.  

### 3. CSV to STL Conversion
- Converted thermodynamic point-cloud data into a 3D surface mesh using Python.  
- Generated a high-resolution STL model of the P–v–T surface.  

### 4. Mesh Processing and 3D Printing
- Mesh repair, simplification, and enclosure using **Blender**.  
- Fabricated a physical 3D model using PLA filament.  

### 5. Refrigeration Cycle Analysis
- Studied the vapor-compression refrigeration cycle using R-134a.  
- Calculated system performance parameters including **COP (~3.9)**.  

---

## Tech Stack

- **MATLAB**  
- **Python**  
- **Cantera**  
- **Blender**  
- **3D Printing**  

---

## Getting Started

### Prerequisites
- MATLAB (with Cantera configured)  
- Python   
- Blender  

### Usage
1. Run the MATLAB script to generate P–v–T data  
2. Convert CSV data to STL using the Python notebook  
3. Process the STL file in Blender  
4. Slice and 3D print the model  

---

## Repository Files

- `generate_r134a_pvt_data.m` – Thermodynamic data generation  
- `csv_to_stl_conversion.ipynb` – CSV to STL conversion  
- `r134a_pvt_surface_stl_file.zip` – Printable STL file  
- `r134a_pvt_surface.gcode` – 3D printer G-code  
- `final_Project_report.pdf` – Detailed project report  

---

## Course Information

- **Course:** ES 211 – Thermodynamics  
- **Institute:** Indian Institute of Technology Gandhinagar  
- **Supervisor:** Prof. Atul Bhargav  

---

## Acknowledgements

Thanks to **Prof. Atul Bhargav** for his guidance and support throughout the project.


