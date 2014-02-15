id = 'Control:ltiobject:TFComplex';
warning('off',id);
s = tf('s');
W1 = (1+0.05*s)/(s+0.05);
W3 = 0.2*s;
W2 = [];
%spectral factorization to find G s.t. |G(jw)|^2=|W1(jw)|^2+|W3(jw)|^2
nW1 = minreal(W1*(s+0.05));
dW1 = 1/(minreal(W1/(0.05*s+1)));
dW3 = 1;
nW3 = W3;
%nG2 is numerator of G(s)*G(-s)
nG2 = nW1*dW3*ctranspose(nW1)*ctranspose(dW3)+dW1*nW3*ctranspose(dW1)*ctranspose(nW3);
ats = zero(nG2);
%remove the symmetric zeros from G(s)G(-s)
nG = minreal(nG2/(s-ats(3))/(s-ats(4)));
dG = dW1*dW3;
G = 5*nG/dG;
P = (3*(1-0.1*s)*(s+2))/((1+0.1*s)*(s^2-2*s+2));
%for comparison
[K,CL,GAM,INFO]=mixsyn(P,W1,W2,W3/(0.0001*s+1));
%Coprime factorization
Np = 3*(1-0.1*s)*(s+2)/(1+0.1*s)/(s+1)^2;
Dp = (s^2-2*s+2)/(s+1)^2;
%Inner-outer factorization
Npi=(1-0.1*s)/(1+0.1*s);
Npo = 3*(s+2)/(s+1)^2;
Dpi = (s^2-2*s+2)/(s^2+2*s+2);
Dpo = (s^2+2*s+2)/(s+1)^2;
Q = 1/(s+2);
%Lagrange interpolation to find X
foo = @(x) (-0.3*x^2+2.4*x+6)/(0.1*x^3+1.2*x^2+2.1*x+1);
a1 = 1+1i;
a2 = 1-1i;
s1=1/foo(a1);
s2=1/foo(a2);
c0 = (s2*a2-s1*a1+s2-s1)/(a2-a1);
c1 = real(a1*s1+s1-c0*a1);
X = (c0*s+c1)/(s+1);
%Y found from Bezout identity
Y = minreal((1-Np*X)/Dp);
R1 = minreal(ctranspose(Dpi)*ctranspose(Npi)*minreal(1/ctranspose(G)*ctranspose(W1)*W1-G*Np*X));
pr1 = pole(R1);
zr1 = zero(R1);
%remove poles and zeros of R1 that are close to eachother
R1 = ((s-real(zr1(2)))*(s-zr1(5))*(s-zr1(6))*(s-real(zr1(7)))*(s-zr1(8))*(s-zr1(9)))...
    /((s-pr1(2))*(s-pr1(3))*(s-real(pr1(6)))*(s-real(pr1(7)))*(s-real(pr1(8)))*(s-real(pr1(9))));
[nR1 dR1] = tfdata(R1,'v');
R1 = tf(real(nR1),real(dR1));
R2 = minreal(1/G*W1*W3);
Q1 = minreal(Dpo*Npo*G*Q);
gmax = 5;
gmin = norm(R2,inf);
%gama(1) contains the current value of gamma, gama(2) contains the next.
gama = [0 1];
iterations = 0;
while(round(100000*gama(2))~=round(100000*gama(1)))
    newZeros = [];
    newPoles = [];
    error = false;
    gama(1) = (gmax+gmin)/2;
    Rg = 1;
    Rg2 = gama(1)^2-R2*ctranspose(R2);
    [ndum ddum] = tfdata(Rg2,'v');
    Rg2 = minreal(Rg2/(ndum(1)));
    zRg2 = zero(Rg2);
    pRg2 = pole(Rg2);
    cnt = 1;
    for i=1:length(zRg2)
        if(real(zRg2(i))>0)
            newZeros(cnt) = zRg2(i);
            cnt = cnt + 1;
        end
    end
    cnt = 1;
    for i=1:length(pRg2)
        if(real(pRg2(i))>0)
            newPoles(cnt) = pRg2(i);
            cnt = cnt + 1;
        end
    end

    for i=1:length(newZeros)
        if (i==1)
            Rg = Rg2/(s-newZeros(i));
        else
            Rg = Rg/(s-newZeros(i));
        end
    end
    Rg = Rg*(ndum(1))^2;
    for i=1:length(newPoles)
        Rg = Rg*(s-newPoles(i));
    end
    Rg = minreal(Rg);
    [nRg dRg] = tfdata(Rg,'v');
    Rg = tf(real(nRg),real(dRg));
    Q2 = minreal(Q1/Rg);
    [Rgs Rgu] = stabsep(R1/Rg);
    Q3 = minreal(Q2-Rgs);
    [numRgu denRgu] = tfdata(Rgu,'v');
    [A B C D] = tf2ss(numRgu,denRgu);
    %solve Lyapunov equations to find QU and PU
    try
        PU = lyap(-A,B*B');
        QU = lyap(-A,C'*C);
    catch err
        error = true;
        gmin = gama(1);
        gama(2) = (gmin+gmax)/2;
    end
    [a b] = eig(PU*QU);
    %finding the maximum eigenvalue and its corresponding eigenvector
    [gamasq ind] = max(max(b));
    xmax = a(:,ind);
    if(~error)
        if (gamasq<=1)
            gmax = gama(1);
            gama(2) = (gmin+gmax)/2;
        else
            gmin = gama(1);
            gama(2) = (gmin+gmax)/2;
        end
    end
    iterations = iterations + 1;
end