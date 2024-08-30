% Assume output is your WEC-Sim result structure
% And bodies are indexed as follows:
% output.bodies(1) = float
% output.bodies(2) = spar

% Extract the time vector
time = output.bodies(1).time;

% Extract data for the float (assumed to be bodies(1))
float_position = output.bodies(1).position;         % Position of the float
float_velocity = output.bodies(1).velocity;         % Velocity of the float
float_acceleration = output.bodies(1).acceleration; % Acceleration of the float

% Extract data for the spar (assumed to be bodies(2))
spar_position = output.bodies(2).position;          % Position of the spar
spar_velocity = output.bodies(2).velocity;          % Velocity of the spar
spar_acceleration = output.bodies(2).acceleration;  % Acceleration of the spar

% Combine data into a table
simulation_data = table(time, ...
    float_position(:,1), float_velocity(:,1), float_acceleration(:,1), ...
    spar_position(:,1), spar_velocity(:,1), spar_acceleration(:,1));

% Define column names for better readability
simulation_data.Properties.VariableNames = {'Time', ...
    'Float_Position', 'Float_Velocity', 'Float_Acceleration', ...
    'Spar_Position', 'Spar_Velocity', 'Spar_Acceleration'};

% Save the table to a CSV file
writetable(simulation_data, 'wec_simulation_data.csv');


% Assuming wave data is in output.waves.waveAmpTime

% Extract the time and wave height data
time = waves.waveAmpTime(:, 1);       % First column is time
wave_height = waves.waveAmpTime(:, 2); % Second column is wave height

% Combine data into a table
wave_data = table(time, wave_height);

% Define column names for better readability
wave_data.Properties.VariableNames = {'Time', 'Wave_Height'};

% Save the table to a CSV file
writetable(wave_data, 'wave_data.csv');
