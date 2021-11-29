addpath 'Control Variant'\
addpath 'Importance Sampeling'\
addpath 'Stratified Sampeling'\
addpath 'Simpel Sampeling'\
addpath 'Complementary Random Numbers'\

global print;
print = 0;

simulations = 100;
samples_per_simulation = 500;

mages = struct;
mages(1).wisdom = 70;
mages(1).magical_strength = 30;

mages(2).wisdom = 50;
mages(2).magical_strength = 50;

mages(3).wisdom = 40;
mages(3).magical_strength = 60;