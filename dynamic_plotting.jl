using Dates
using Plots
using Printf  # Import the Printf module to use @sprintf

function plot_bus_data(sol, bus_number, var, sim_config; wave_df::DataFrame, plot_wave::Bool=true, Sbase_kW=10, save_to_file::Bool=false, run::String, output_dir::String="./plots")
    # Time vector from the simulation solution
    time_vector = sol.dqsol.t
    
    # Extract the data for the specified bus and variable
    data = [sol(t, "bus$bus_number", Symbol(var)) for t in time_vector]

    # Determine the appropriate transformation and label based on the variable
    if var == "i"
        data = abs.(data)  # Use the magnitude of the current
        ylabel_text = "Current Magnitude (A)"
    elseif var == "ω"
        data = real.(data)  # Ensure data is real for ω
        ylabel_text = "Frequency - ω [p.u.]"
    elseif var == "p" || var == "q"
        ylabel_text = "Active Power - p [p.u]"
    elseif var == "v"
        data = real.(data)  # Ensure data is real for voltage
        ylabel_text = "Voltage - |v| [p.u.]"
    else
        data = real.(data)  # Default to the real part for other complex variables
        ylabel_text = var
    end

    # Remove NaNs or missing values
    valid_indices = .!isnan.(data)
    time_vector = time_vector[valid_indices]
    data = data[valid_indices]

    # Define a formatter for y-axis labels to avoid scientific notation
    yformatter = x -> @sprintf("%.5f", x)

    marker = 1.5
    line_width = 1
    size = (1000, 200)

    # Create the primary plot, with specific y-limits for frequency and custom formatter
    if var == "ω"
        p1 = plot(time_vector, data, 
                  label = "$var (Bus $bus_number)", 
                  color = :blue, 
                  marker = (:circle, marker),  # Increase marker size
                  #linewidth = line_width,  # Decrease line width
                  xlabel = "Time (sec)", 
                  ylabel = ylabel_text,
                  title = "Bus $bus_number - $var",
                  legend = :topleft,
                  grid = :on,
                  size= size,
                  left_margin = 10Plots.mm,
                  right_margin = 10Plots.mm,
                  bottom_margin = 10Plots.mm,
                  top_margin = 10Plots.mm,
                  ylim=(-0.0004, 0.0004),
                  yticks = :auto,
                  yformatter = yformatter)
    else
        p1 = plot(time_vector, data, 
                  label = "$var (Bus $bus_number)", 
                  color = :blue, 
                  marker = (:circle, marker),  # Increase marker size
                  linewidth = line_width,  # Decrease line width
                  xlabel = "Time (sec)", 
                  ylabel = ylabel_text,
                  title = "Bus $bus_number - $var",
                  legend = :topleft,
                  grid = :on,
                  size=size,
                  left_margin = 10Plots.mm,
                  right_margin = 10Plots.mm,
                  bottom_margin = 10Plots.mm,
                  top_margin = 10Plots.mm,
                  yformatter = yformatter)
    end

    if plot_wave
        # Filter wave data within the time range
        filtered_wave_df = filter(row -> row.Time >= minimum(time_vector) && row.Time <= maximum(time_vector), wave_df)

        # Create the secondary plot with a shared x-axis
        p2 = twinx()
        plot!(p2, filtered_wave_df.Time, filtered_wave_df.Wave_Height, 
              label = "Wave Height", 
              color = :green, 
              ylabel = "Wave Height (m)",
              legend = :topright,
              grid = :on)
    end

    # Save the plot to a file if requested
    if save_to_file
        if !isdir(output_dir)
            mkpath(output_dir)  # Create the directory if it doesn't exist
        end
        savefig(p1, joinpath(output_dir, "$run-bus_$bus_number-$var.png"))
    else
        display(p1)  # Display the combined plot
    end
end