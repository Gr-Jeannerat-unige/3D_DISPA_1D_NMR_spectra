%% this is a octave and matlab compatible program to 
%% create 3D DISPA representation of NMR 1D spectrum stored in the Bruker format
%% The generated file is in the .obj format. It can be converted into .stl 
%% format using other software such as Meshlab before printing

clear all

% input file name of the Bruker 1D spectrum
path_in='/Volumes/lacie_case/nmr_data/nmrge500_data/data/karla/nmr/glucose_121004/';

% spectral range to use...
from_ppm=4.40;
to_ppm=5.27;

% width of the object
total_width=20;%in cm
top_size_vertical=5;% in cm

%number of sides for the cylinder
sides=16;
diameter=0.3; %in cm


% reading spectrum
spectrum=read_data_bruker(path_in,'1','1',1);
%with of the cylinder in 

inc_in=10;%every other ... points will be used

[dell from_pt]=min(abs(spectrum.scale2-from_ppm));
[dell to_pt]=min(abs(spectrum.scale2-to_ppm));
x=spectrum.scale2(to_pt:inc_in:from_pt);
y=real(spectrum.spectrum(to_pt:inc_in:from_pt));
z=real(spectrum.spectrum_ii(to_pt:inc_in:from_pt));

%rescaling
radius=10*diameter/2;%

from_pos_mm=10*total_width/2;% in mm
incpt=2*from_pos_mm/(size(x,2)-1);

x=-from_pos_mm:incpt:from_pos_mm; %for 20 cm object
normz=sqrt(max(max(y.*y+z.*z)));
y=y/normz*top_size_vertical*10;
z=z/normz*top_size_vertical*10;

% start_end_pt=30;%from - to +...
% amplit=20;
list=[1:sides ];
list2=1+mod(list,sides);
sca=1;
y=y';
z=z';

inc_over_pt=1;

x=x(1:inc_over_pt:end);
y=y(1:inc_over_pt:end);
z=z(1:inc_over_pt:end);

%% here plot x y z
box_boudaries=[min(x) max(x);min(y) max(y);min(z) max(z)];
gen_min=min(box_boudaries(:,1));
gen_max=max(box_boudaries(:,2));
inc_distance=(gen_max-gen_min)/100;
figure(1);clf
plot(x,y)
hold on
plot(x,z,'r-');
xyz=[x; y; z];
figure(2);clf;
plot3(x,y,z);
hold on
f_id = fopen('./glu.obj','w');
fprintf(f_id,'v %.6f %.6f %.6f\n',xyz(:,1)*sca);
count=0;
for loop=2:1:size(x,2)-1
    if count>13
      %  break
    end
    v1o=xyz(:,loop)-xyz(:,loop-1);
    v2=xyz(:,loop+1)-xyz(:,loop);
    no=norm(v1o);
    v1=v1o/no;
    v2=v2/norm(v2);
    d1=cross(v1,v2);
    d1=d1/norm(d1);
    d2=cross(v1,d1);
    d2=d2/norm(d2);
    sq2=sqrt(2)/2;
    if count>0
    
        abcd = [ d1'; 0 0 0 ;-v1o';-v1o'+d1_previous'];
        b_c = norm_vec(abcd(3, :) - abcd(2, :));
        b_a_orth = get_orth_norm_vec(abcd(1, :) - abcd(2, :), b_c);
        c_d_orth = get_orth_norm_vec(abcd(4, :) - abcd(3, :), b_c);
        phi = acos(dot(b_a_orth, c_d_orth)) ; 
        sign = dot(cross(b_a_orth, c_d_orth), b_c) ; 
        
        if (sign < 0)
            phi = -phi; 
        end
       %                 disp(['Angle : ' num2str(phi/pi*180) ' norm xz ' num2str(sqrt(xyz(2,loop)*xyz(2,loop)+xyz(3,loop)*xyz(3,loop)))])

        add_phi=add_phi+phi;
      %  fm=(xyz(:,loop)+abcd')';
       % plot3(fm(:,1),fm(:,2),fm(:,3))

    else
        add_phi=0;
    end
    ser1=sin(add_phi+[0:(pi*2)/sides:2*pi-(pi*2)/sides])'*d1';
    ser2=cos(add_phi+[0:(pi*2)/sides:2*pi-(pi*2)/sides])'*d2';
    sert=ser1+ser2;
    sert=sert*radius;
    for l123=1:size(sert,1)
        colm='k-';
        
        if l123==1 colm='b-';end
        if l123==2 colm='r-';end
        if l123==3 colm='g-';end
        %  plot3(xyz(1,loop)+[0 sert(l123,1)],xyz(2,loop)+[0 sert(l123,2)],xyz(3,loop)+[0 sert(l123,3)],colm)
        cur8(:,l123)=[xyz(1,loop)+ sert(l123,1);xyz(2,loop)+ sert(l123,2);xyz(3,loop)+ sert(l123,3)];
    end
    %  plot3(xyz(1,loop)+[ sert(:,1)],xyz(2,loop)+[ sert(:,2)],xyz(3,loop)+[ sert(:,3)],colm)
    plot3(cur8(1,:),cur8(2,:),cur8(3,:),colm)
    
    
    if loop>2 && loop<=(size(x,2)-1)
        interm=cur8(:,list)*0.5+0.5*(cur8a(:,list2));
        %   plot3(interm(1,loop)+[0 sert(l123,1)],interm(2,loop)+[0 sert(l123,2)],interm(3,loop)+[0 sert(l123,3)],colm)
        colm='r-';
        
        plot3(interm(1,:),interm(2,:),interm(3,:),colm)
        fprintf(f_id,'v %.6f %.6f %.6f\n',interm*sca);count=count+1;
        
    end
    fprintf(f_id,'v %.6f %.6f %.6f\n',cur8*sca);count=count+1;
    
    disp('');
    drawnow
    
    cur8a=cur8;
    d1_previous=d1;
end
si=size(x,2);

fprintf(f_id,'v %.6f %.6f %.6f\n',xyz(:,end)*sca);
counter=1;
fprintf(f_id,'\n');
%Start tip
for lo=1:sides
    fprintf(f_id,'f %d %d %d\n',1,list(1,lo)+1,list2(1,lo)+1);
end
%central part...
for lo2=0:si-4
    for lo=1:sides
        addme=1+(2*sides)*lo2;
        fprintf(f_id,'f %d %d %d\n',list(1,lo)+addme,sides+list(1,lo)+addme,list2(1,lo)+addme);
    end
    for lo=1:sides
        addme=1+(2*sides)*lo2;
        fprintf(f_id,'f %d %d %d\n',sides+list(1,lo)+addme,sides+list2(1,lo)+addme,list2(1,lo)+addme);
    end
    for lo=1:sides
        addme=1+(2*sides)*lo2+sides;
        fprintf(f_id,'f %d %d %d\n',list2(1,lo)+addme,list(1,lo)+addme,sides+list2(1,lo)+addme);
    end
    for lo=1:sides
        addme=1+(2*sides)*lo2+sides;
        fprintf(f_id,'f %d %d %d\n',sides+list2(1,lo)+addme,list(1,lo)+addme,sides+list(1,lo)+addme);
    end
end
%end tip
for lo=1:sides
    fprintf(f_id,'f %d %d %d\n',(2*si-5)*sides+2,list2(1,lo)+1+(2*si-6)*sides,list(1,lo)+1+(2*si-6)*sides);
end
fclose(f_id);
