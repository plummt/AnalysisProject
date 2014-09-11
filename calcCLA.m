function CLA = calcCLA(Red, Green, Blue)
Sm = [-0.005701 -0.014015 0.241859]; % Scone/macula
Vm = [0.381876 0.642883 0.067544]; % Vlamda/macula (L+M cones)
M = [0.000254 0.167237 0.261462]; % Melanopsin
Vp = [0.004458 0.360213 0.189536]; % Vprime (rods)

% Model coefficients: a2, a3, k, A
C = [0.617848 3.221534 0.265128 2.309656];


CLA = zeros(size(Red));
for i1 = 1:length(Red)
    RGB = [Red(i1) Green(i1) Blue(i1)];
    Scone(i1) = sum(Sm.*RGB);
    Vmaclamda(i1) = sum(Vm.*RGB);
    Melanopsin(i1) = sum(M.*RGB);
    Vprime(i1) = sum(Vp.*RGB);
    
    if(Scone(i1) > C(3)*Vmaclamda(i1))
        CLA(i1) = Melanopsin(i1) + C(1)*(Scone(i1) - C(3)*Vmaclamda(i1)) - C(2)*683*(1 - 2.71^(-(Vprime(i1)/(683*6.5))));
    else
        CLA(i1) = Melanopsin(i1);
    end
    
    CLA(i1) = C(4)*CLA(i1);
end
CLA(CLA < 0) = 0;
end