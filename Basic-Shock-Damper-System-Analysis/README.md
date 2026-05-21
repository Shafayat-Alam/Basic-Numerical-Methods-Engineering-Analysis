# Three-Mass Shock Damper System Simulation

## Overview
Numerical simulation and analysis of a three-mass spring-damper shock absorption system. The system models coupled masses connected by springs and dampers, with external forcing applied to the first mass. The simulation employs the forward Euler method to solve the equations of motion over a 300-second time period.

---

## System Configuration

### Physical Parameters

| Parameter | Symbol | Value | Units |
|-----------|--------|-------|-------|
| Mass 1 | m₁ | 108.9 | kg |
| Mass 2 | m₂ | 45.0 | kg |
| Mass 3 | m₃ | 54.4 | kg |
| Spring constant 1 | k₁ | 1.9 | N/m |
| Spring constant 2 | k₂ | 3.4 | N/m |
| Spring constant 3 | k₃ | 1.8 | N/m |
| Damping coefficient 1 | c₁ | 6.5 | N·s/m |
| Damping coefficient 3 | c₃ | 4.2 | N·s/m |

### External Forcing Functions

The system is subjected to time-varying external forces:

**Mass 1 (F₁):**
```
F₁(t) = 2·sin(2πt/20) + 8·exp(-(t-50)²/15)
```
- Sinusoidal component with 20-second period
- Gaussian pulse centered at t = 50s with width σ ≈ 3.87s

**Mass 2 & 3:**
```
F₂(t) = 0
F₃(t) = 0
```

### Initial Conditions

All masses start from rest at the origin:
- **Positions:** x₁(0) = x₂(0) = x₃(0) = 0 m
- **Velocities:** v₁(0) = v₂(0) = v₃(0) = 0 m/s

---

## Mathematical Model

### Equations of Motion

The system dynamics are governed by Newton's second law applied to each mass:

**Mass 1:**
```
f₁ = -k₁·x₁ - c₁·v₁ + F₁(t)
m₁·a₁ = f₁
```

**Mass 2:**
```
f₂ = k₁·(x₁ - x₂)
m₂·a₂ = f₂
```

**Mass 3:**
```
f₃ = k₁·(x₂ - x₃) - k₃·x₃ - c₃·v₃
m₃·a₃ = f₃
```

### Numerical Integration

The forward Euler method is used for time integration:

```
v(i) = v(i-1) + (f/m)·Δt
x(i) = x(i-1) + v(i)·Δt
```

**Simulation parameters:**
- Start time: t₀ = 0 s
- End time: T = 300 s
- Time step: Δt = 0.1 s
- Total steps: 3001 points

---

## Results

### Displacement Analysis

![Displacement vs. Time](Displacement_vs_Time.png)

The displacement plot shows:
- **Mass 1 (red):** Direct response to external forcing with damped oscillations
- **Mass 2 (green):** Larger amplitude oscillations (±4 m range)
- **Mass 3 (blue):** Similar amplitude to Mass 2 with phase lag
- Initial transient response (t < 100s) followed by steady-state periodic behavior
- System exhibits coupled dynamics with energy transfer between masses

### Velocity Analysis

![Velocity vs. Time](Velocity_vs_Time.png)

The velocity plot reveals:
- **Mass 1 (red):** Lower amplitude velocity oscillations (±0.35 m/s)
- **Mass 2 (green):** Moderate velocity variations (±0.7 m/s)
- **Mass 3 (blue):** Highest velocity amplitudes (±0.8 m/s)
- Velocity patterns indicate energy distribution through the coupled system
- Periodic steady-state behavior after initial transient

### Relative Displacement Analysis

![Relative Displacements](Relative_Displacements.png)

This plot visualizes:
- Relative motion between Mass 1 and Mass 2 (blue)
- Relative motion between Mass 2 and Mass 3 (red)
- Safe separation distance L (green dashed lines at ±3.09 m)
- Zero reference line (black dashed)

**Purpose:** Verifies that the calculated separation distance prevents contact throughout the simulation.

---

## Key Metrics

### System State at t = 5s

| Metric | Value | Description |
|--------|-------|-------------|
| **x1a** | 0.096446 m | Mass 1 position during early transient response |
| **v1a** | 0.049915 m/s | Mass 1 velocity during early transient response |

### Performance Metrics

| Metric | Value | Description |
|--------|-------|-------------|
| **L** | 3.086871 m | Minimum separation distance required between masses to prevent collision |
| **vmax** | 0.779835 m/s | Maximum velocity magnitude observed across all masses (occurs in Mass 3) |
| **dmin** | -3.086871 m | Minimum distance between Mass 1 and Mass 2 (negative indicates M2 moved left of M1) |
| **v1mean** | 0.043778 m/s | Average velocity of Mass 1 during first 10 seconds (net positive motion) |

---

## Files

```
project/
├── script.m                      # Main MATLAB simulation script
├── input.mat                     # Input data (mechanism images)
├── README.md                     # This documentation
├── Displacement_vs_Time.png      # Displacement results
├── Velocity_vs_Time.png          # Velocity results
└── Relative_Displacements.png    # Relative motion analysis
```

---

## Usage

### Running the Simulation

1. Ensure `script.m` and `input.mat` are in the same directory
2. Run in MATLAB:

```matlab
script
```

### Output

**Console:**
```
========================================
x1a (Mass 1 position at t=5s): 0.096446 m
v1a (Mass 1 velocity at t=5s): 0.049915 m/s
L (Minimum separation distance): 3.086871 m
vmax (Maximum velocity magnitude): 0.779835 m/s
dmin (Min distance between M1 and M2): -3.086871 m
v1mean (Avg velocity M1, t=0-10s): 0.043778 m/s
```

**Generated Files:**
- Three figure windows displaying the plots
- Three PNG files saved in the same directory

---

## Physical Insights

### System Behavior

1. **Energy Input:** External force F₁(t) introduces energy through Mass 1
2. **Energy Distribution:** Spring k₁ couples Mass 1 to Mass 2, distributing energy throughout the system
3. **Energy Dissipation:** Dampers c₁ and c₃ remove energy from the system, preventing runaway oscillations
4. **Steady State:** After initial transient (~100s), system reaches periodic steady-state oscillation

### Engineering Considerations

- **Damping:** System has moderate damping (c₁, c₃), providing controlled oscillation decay
- **Coupling:** Spring k₁ creates strong coupling between adjacent masses, allowing energy transfer
- **Resonance:** Sinusoidal forcing (20s period) may excite natural frequencies of the system
- **Impact:** Gaussian pulse at t=50s creates transient shock response visible in both plots
- **Safety:** Minimum 3.09 m separation required between masses to prevent collision

### Key Observations

- Mass 3 experiences the highest velocities despite no direct forcing
- Mass 2 shows largest displacement amplitudes (~±4 m)
- Mass 1 exhibits lower amplitudes due to direct damping (c₁)
- System requires ~100 seconds to reach steady-state behavior
- Negative dmin indicates masses can approach from opposite sides of equilibrium

---

## Technical Details

### Numerical Method
- **Integration:** Forward Euler (explicit, first-order accurate)
- **Stability:** Conditionally stable; Δt = 0.1s chosen for stability
- **Accuracy:** Small time step ensures reasonable accuracy for this system

### Assumptions
1. Linear springs (Hooke's law: F = kx)
2. Linear dampers (F = cv)
3. No friction between masses and ground
4. One-dimensional motion
5. No mass-to-mass contact during simulation

### Limitations
- Euler method has O(Δt) truncation error
- Does not handle mass contact/collisions
- Linear model may not capture nonlinear effects in real shock dampers

---

## Applications

This type of system is relevant to:
- Vehicle suspension design
- Seismic damping systems
- Mechanical vibration isolation
- Impact absorption mechanisms
- Multi-stage shock absorber analysis
