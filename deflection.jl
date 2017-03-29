#!/bin/julia/

## Formulas To Calculate Values
#Formula to Calculate Moment of Inertia
MoI(b,h)=(1/12)*b*h^3
#Formula to calculate max deltalection
delta(F,L,E,I)=F*L^3/(E*3I)
#Forumula to calucate max Stress
S(M,I,c)=(M*c)/(I)
#Forumula to calculate the Natural frequency omegao
omega(y)=.5/sqrt(y)
#Forumula to calculate Strain
epsilon(M,c,I,E) = (M*c)/(I*E)

g=9.81; # m/s^2
#Plate Dimensions
#PexiGlas Plate
width=.204
base=.102;
t=.005;
rhopg=1.18*1000;#Density of PexiGlas in kg/m^3
Wp=base*width*t*rhopg; # weight of the PexiGlas plate

#Suspended Portion of Force Plate

#Youngs Modulus and Yield Strngths of different Materials
Names=["Digital ABS","Rigid Opeque", "Brass"];
YoungsMod=[2.6e9,2e9, 97.6e9];
Sy=[55e6,50e6,135e6];
rhomat=[1.17,1.17,8.7]*1e3;

# Dimensions to iterate over
l=linspace(0.5e-3,3e-2);
w=l;
h=linspace(160e-6,.5e-2);
f=open("dims.csv","w");
write(f,"Material Name, Length, Width, Thickness,Max Displacement,Natural Frequency,Max Strain\n")
for i=1:length(l)
  L=l[i]
  W=L
  for k=1:length(h)
    H=h[k]
    c=H/2;
    I=MoI(W,H);
      for x=1:length(YoungsMod)
        E=YoungsMod[x]
        Syield=Sy[x]
        rho=rhomat[x]
        Name=Names[x]
        Pmat=base*width*H*W/2*rho+Wp/4
        deltao=delta(Pmat,L,E,I)
        omegan=omega(deltao)
        if omegan>100
          P=Pmat+4.9;
          deltamax=delta(P,L,E,I)
          Smax=S(P*L/2,I,H/2)
          strain=epsilon(P*L/2,H/2,I,E)
          if Smax<Syield
            write(f,"$Name,$L,$W,$H,$deltamax,$omegan,$strain\n")
          end
        end
      end
    end
  end
close(f)
