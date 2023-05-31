%AirfoilTools_Collect_Archive
%Jeremy Johnson
%Uploaded 5-30-2023
clear all; clear vars; clc;

database = airfoiltools_collect_archive();  % Implementation example

function [database] = airfoiltools_collect_archive()
    %INPUT:     nothing
    %OUTPUT:    Matrix of strings
    URL = 'http://airfoiltools.com/search/airfoils';
    
    urldata = string(webread(URL)); % One giant string of all html of the archive
    
    long_data = transpose(strsplit(urldata));   %turn it to matrix, space delimited i think
    
    long_airfoil = long_data(660:length(long_data)-1);  %cut out unnecessary cells
    
    database = [];
    for i = 1:length(long_airfoil)      % put all cells containing the airfoil name into database
        if contains(long_airfoil(i),'href')
            database = [database;long_airfoil(i)];
        end
    end

    for i = 1:length(database)          % Shorten the strings in database to only contain the airfoil name
        after(i) = extractAfter(database(i),'>');
        before(i) = extractBefore(after(i),'-');
    end

    database = transpose(before);       % Make database vertical for readability
    
end