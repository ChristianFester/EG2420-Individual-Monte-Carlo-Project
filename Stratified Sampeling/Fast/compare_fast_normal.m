u = rand(29,1);
stratum = 1;
variables_fast = get_stratum_variable_fast(u,wisdom,magic,stratum);
w_fast = get_stratum_weight_fast(wisdom,magic,stratum);
stratum = "A";
variables = get_stratum_variable(u,wisdom,magic,stratum);
w = get_stratum_weight(wisdom,magic,stratum);