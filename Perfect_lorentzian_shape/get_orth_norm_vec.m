function ovec = get_orth_norm_vec(vec, vref)
    temp = vec - vref * dot(vec, vref);
    ovec = norm_vec(temp);
end