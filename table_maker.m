%% create yourself a table of all values from xfoil without breaking a sweat.

function [output_array] = table_maker(airfoil_names, xfoil_output)
    if (length(airfoil_names) ~= length(xfoil_output))
        ME = MException('table_maker:arrayLengthMismatch', ...
            'Expected the length of both inputs to be equal!');

        throw(ME);
    end

    output_array = {};

    for i = 1:length(airfoil_names)
        foil_data = xfoil_output{i};

        foil_table = array2table(foil_data, 'VariableNames', ...
            ["alpha", "Cl", "Cd"]);

        output_array{end + 1} = struct('name', airfoil_names{i}, ...
            'data', foil_table);
    end
end


