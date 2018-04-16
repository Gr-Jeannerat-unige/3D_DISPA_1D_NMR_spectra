function [dist_in_hz erro_in_deg]=shap_fn3d(phase,mainlooop,main_ratio)
dist_in_hz=0;
erro_in_deg=0;
add_text='';
sw=20;
dw=1/sw;

%t=0:dw:1000;
t=0:dw:10000;
lb=1/2;
nu=0;
height=[0.99 0.9 0.5];
height=[0.99 0.9 ];
heightfirst=[ 0.5 0.1 0.02  ];
heightfirstd=[ 0.1 0.02 ];

if mainlooop==1,
    fid=(phase)*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
end
if   mainlooop==7,
    nu=0;
    nu2=1/(20*  abs(angle(phase)/(2*pi)))
b=0;
c=nu2;
a=1/(c*sqrt(2*pi));
    fid=exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb).*(a*exp(  -  ((t-b).*(t-b)) /(2*c*c)  ));
end


if   mainlooop==10,
    nu=0;
    nu2=10*angle(phase)/(2*pi);

    fid=exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(main_ratio)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
    add_text=[' ' num2str(nu2-nu,'%.1f') ' Hz'];
    dist_in_hz=nu2-nu;

end


if   mainlooop==11,
    nu=0;
    nu2=10*angle(phase)/(2*pi);

    fid=exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(-main_ratio)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
    add_text=[' ' num2str(nu2-nu,'%.1f') ' Hz'];
        dist_in_hz=nu2-nu;

end


if   mainlooop==6,
    nu=0;
    nu2=10*angle(phase)/(2*pi);

    fid=exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
    
end
if   mainlooop==8,
    nu=0;
    nu2=10*angle(phase)/(2*pi);

    fid=exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid-(1)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
end
if   mainlooop==5,
    nu=0;
    nu2=2;

    fid=angle(phase)/4*pi*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
end
if   mainlooop==9,
    nu=-4;
    nu2=-0;
    nu3=4;
    nu4=8;

    fid=angle(phase)/4*pi*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu3)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu4)).*exp(-t*2*pi*lb);
end
if   mainlooop==4,
    nu=0;
    nu2=2;

    fid=(phase)*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(1)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
end
if   mainlooop==2,
    nu=3;
    nu2=5;
    nu3=-5;

    fid=(phase)*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(phase)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb);
    fid=fid-(phase)*exp(j*2*pi*((t)*nu3)).*exp(-t*2*pi*lb);
end
if   mainlooop==3,
     nu=3;
    nu2=5;
    nu3=-5;

    fid=(phase)*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    fid=fid+(phase)*exp(j*2*pi*((t)*nu2)).*exp(-t*2*pi*lb)*exp(90*j/360*2*pi);
    fid=fid-(phase)*exp(j*2*pi*((t)*nu3)).*exp(-t*2*pi*lb);
    ;
end
other_method=1;
if other_method,
    offset=0;
    fid(1)=fid(1)/2;
else
    offset=sum(sum(abs(fid)))*(1/2*pi)*(1/sw);%%% important !!
end
%
%
%
%fid=fid-offset;


spectrum=fftshift(fft((fid)));
spectrum=spectrum-offset;
(num2str(real(spectrum(1,1))))
spectrum=spectrum;
top=max(max(abs(spectrum)));
spectrum=spectrum/top;
incsw=sw/size(t,2);

scale=-sw/2+incsw/2:incsw :sw/2-incsw/2;



where_projy=sw/2;
where_projx=-1;

% plot3(where_projy+0*scale,imag(spectrum),real(spectrum),'k-'); hold on
plot3(where_projy+0*scale,imag(spectrum),real(spectrum),'k-'); hold on
plot3(scale,1+0*imag(spectrum),real(spectrum),'k-'); hold on
plot3(scale,imag(spectrum),real(spectrum),'g-','LineWidth',2); hold on
[azg bzg]=max(abs(spectrum));
%text(scale(bzg),imag(spectrum(bzg)),real(spectrum(bzg)),[num2str( 180/pi*angle(spectrum(bzg)) ,'%.1f') 'deg.' add_text]);
text(10,imag(spectrum(bzg)),real(spectrum(bzg)),[num2str( 180/pi*angle(spectrum(bzg)) ,'%.1f') 'deg.' add_text]);
erro_in_deg=180/pi*angle(spectrum(bzg));
%plot3(scale,0*imag(spectrum),1*real(spectrum),'LineWidth',2); hold on
plot3(scale,1*imag(spectrum),-1+0*real(spectrum),'k-'); hold on
plot3(sw/2*[-1 1],[ 0 0],[ 0 0],'k-')
plot3(sw/2*[-1 1],1+[ 0 0],[ 0 0],'k-')
plot3(sw/2*[1 1],[ 1 -1],[ 0 0],'k-')
axis([ where_projy*[-1 1] -1 1 -1 1])

for loop=1:size(height,2),
    what=abs(spectrum);
    tmp=(what(1,1:size(what,2)-1)-height(1,loop)).*(what(1,2:size(what,2)-0)-height(1,loop));
    list_i= find(tmp < 0);
    [a b]=max(what);
    [a c]=max(abs(spectrum));
    list_i=[list_i b c];
    for i=list_i,
        %  plot3(scale(1,i)*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:')
        
        av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))   *0.5 + 0.5* angle(real(spectrum(1,i+1))+j*imag(spectrum(1,i+1)));
        delta=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  - angle(real(spectrum(1,i+1))+j*imag(spectrum(1,i+1)));
        %text(where_projy*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[num2str(360/(2*pi)*av_al,'%.1f') '(' num2str(360/(2*pi)*delta,'%.1f')  ')']);
        addtext=[num2str(height(1,loop)*100,'%.0f') '% '] ;
        signal_me=0;
        if i==c,
            addtext='max(abs) ';
            av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
            signal_me=1;
        end
        if i==b,
            addtext='max(real) ';
            av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
            
        end
        if i==b && i==c,
            addtext='max(real & abs) ';
            av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
            signal_me=1;
        end
        if signal_me,
            %           plot3(where_projy*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:','LineWidth',2)
        else
            %           plot3(where_projy*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:')
        end
        
        %         text(where_projy*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[addtext num2str(360/(2*pi)*av_al,'%.1f') ]);
        %          text(scale(1,i)*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[addtext num2str(360/(2*pi)*av_al,'%.1f') ]);
    end
end
plot3([sw/2 sw/2],[0 0 ],[0 1 ],'k','LineWidth',2);
plot3([sw/2 sw/2 -sw/2],[0 0 0],[1 -1 -1],'k');
plot3([-sw/2 -sw/2],[-1 1 ],-1+[0 0 ],'k');
plot3([-sw/2 sw/2 sw/2],[1 1 1],-1+[0 0 2],'k');
plot3([-sw/2 sw/2 sw/2],[1 1 -1],-1+[0 0 0],'k');
view([-24,22])
%view([-90,0])
axis([ where_projy*[-1 1] -1 1 -1 1])
if abs(dist_in_hz)>0.88 && abs(dist_in_hz)<0.89,
         print('-depsc','-tiff','-r600',[ 'Phase_error_near0.885' num2str(main_ratio)  '.eps']);%here
end
