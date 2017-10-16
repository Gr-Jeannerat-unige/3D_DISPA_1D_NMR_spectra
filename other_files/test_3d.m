%% 3d print prepaparation
clear all
radius=1;
start_end_pt=30;%from - to +...
amplit=20;
sides=16;
list=[1:sides ];
list2=1+mod(list,sides);


x=-start_end_pt:0.005:start_end_pt;
comp=1./(1+1i*x);
z=amplit*real(comp);
y=amplit*imag(comp);




xx=x(1:end-1)-x(2:end);
yy=y(1:end-1)-y(2:end);
zz=z(1:end-1)-z(2:end);
speed=sqrt(zz.*zz+yy.*yy+xx.*xx);
%speed=sqrt(zz.*zz+yy.*yy);
%speed=speed./abs(xx);
%inc=abs(xx)./speed;
inc=1./speed;
tot=sum(sum(inc));
inc=inc/tot;%zero to 1
sii=size(inc,2);
%inc=inc*sii/(sii-2);
%x=2*start_end_pt*inc-start_end_pt;
x(1,1)=-start_end_pt;
for lo=2:size(x,2)
    x(1,lo)=x(1,lo-1)+inc(1,lo-1)*(2*start_end_pt);
end
x=x(1:100:end)
comp=1./(1+1i*x);

z=amplit*real(comp);
y=amplit*imag(comp);
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
plot3(x,y,z);hold on
f_id = fopen('./nmr_signal.obj','w');
fprintf(f_id,'v %.6f %.6f %.6f\n',xyz(:,1));
count=0;
for loop=2:1:size(x,2)-1
    
    v1=xyz(:,loop)-xyz(:,loop-1);
    v2=xyz(:,loop+1)-xyz(:,loop);
    v1=v1/norm(v1);
    v2=v2/norm(v2);
    d1=cross(v1,v2);
    d1=d1/norm(d1);
    %  d2=cross((v1+v2)/2,d1);
    d2=cross(v1,d1);
    d2=d2/norm(d2);
    sq2=sqrt(2)/2;
    ser1=[sq2 1  sq2  0 -sq2 -1 -sq2 0]'*d1';
    ser1=[sin(0:(pi*2)/sides:2*pi-(pi*2)/sides)]'*d1';
    ser2=[cos(0:(pi*2)/sides:2*pi-(pi*2)/sides)]'*d2';
    
    % ser2=[sq2 0 -sq2 -1 -sq2  0  sq2 1]'*d2';
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
        fprintf(f_id,'v %.6f %.6f %.6f\n',interm);count=count+1;
        
    end
    fprintf(f_id,'v %.6f %.6f %.6f\n',cur8);count=count+1;
    
    disp('');
    drawnow
    
    cur8a=cur8;
end
si=size(x,2);

fprintf(f_id,'v %.6f %.6f %.6f\n',xyz(:,end));
counter=1;
fprintf(f_id,'\n');
%first
for lo=1:sides
    fprintf(f_id,'f %d %d %d\n',1,list(1,lo)+1,list2(1,lo)+1);
end
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
%last
for lo=1:sides
   fprintf(f_id,'f %d %d %d\n',(2*si-5)*sides+2,list2(1,lo)+1+(2*si-6)*sides,list(1,lo)+1+(2*si-6)*sides);
end
fclose(f_id);

