# 3D_DISPA_1D_NMR_spectra

To the glory of 

![](./eq.pgn)


Octave/Matlab program to enjoy a 3D representation of a complex Lorentzian.
```
t=-100:0.1:100;
com=1./(1+i*t);
plot3(t,imag(com),real(com));
```
