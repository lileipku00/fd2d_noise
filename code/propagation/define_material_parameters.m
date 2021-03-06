function [mu,rho] = define_material_parameters(nx,nz,model_type,make_plots)

%==========================================================================
% generate material parameters mu [N/m^2] and rho [kg/m^3]
%
% input: grid points of the velocity and density field in x-direction (nx) and z-direction (nz)
%        model_type
%        for "stand-alone" it is convenient to use make_plots as 'yes'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define make_plots if not specified
if( nargin < 4 )
    make_plots = 'no';
end


if (model_type==1)
    
    rho = 3000.0*ones(nx,nz);
    mu = 4.8e10*ones(nx,nz);
    
    
elseif (model_type==2)
    
    rho = 3000.0*ones(nx,nz);
    mu = 4.8e10*ones(nx,nz);
    
    % rho(98:102,123:127) = rho(98:102,123:127) + 2000.0;
    % mu(140:160,140:160) = mu(140:160,140:160) + 2.0e10;
    
    x_sourcem = 2.0e5;
    z_sourcem = 2.0e5;
    x_width = 0.4e5;
    
    [Lx,Lz,nx,nz,~,~,~,~] = input_parameters();
    [X,Z,~,~,~,~] = define_computational_domain(Lx,Lz,nx,nz);
    mu = mu - 8.0e9 * ( exp( -( (X-x_sourcem).^2 + (Z-z_sourcem).^2 ) / (x_width)^2 ) );
    
    
elseif (model_type==3)
    
    rho = 3000.0*ones(nx,nz);
    mu = 2.8e10*ones(nx,nz);
    
    rho(1:round(nx/2),:) = rho(1:round(nx/2),:) + 200.0;
    mu(1:round(nx/2),:) = mu(1:round(nx/2),:) + 3.5e10;
    
    
elseif (model_type==4)
    
    rho = 3000.0*ones(nx,nz);
    mu = 2.8e10*ones(nx,nz);
    
    rho(1:round(nx/2),:) = rho(1:round(nx/2),:) + 200.0;
    mu(1:round(nx/2),:) = mu(1:round(nx/2),:) + 3.5e10;
    
    rho(98:102,123:127)=rho(98:102,123:127)+2000.0;
    
    
elseif (model_type==5)
    
    rho = 3000.0*ones(nx,nz);
    mu = 2.0e10*ones(nx,nz);
    
    for k = 100:150
        mu(:,k) = mu(:,k) + (k-100)*10.0e8;
    end
    for k = 151:nz
        mu(:,k) = mu(:,150);
    end
   
    
elseif (model_type==6)
    
    rho = 3000.0*ones(nx,nz);
    mu = 2.0e10*ones(nx,nz);
    
    for k = 100:150
        mu(:,k) = mu(:,k) + (k-100)*10.0e8;
    end
    for k = 151:nz
        mu(:,k) = mu(:,150);
    end
    
    rho(98:102,123:127) = rho(98:102,123:127) + 2000.0;
    
    
elseif (model_type==7)
    
    rho = 3000.0*ones(nx,nz);
    mu = ones(nx,nz);
    mu(1:330,:) = 3.675e10;
    mu(331:end,:) = 2.7e10;

    
elseif (model_type==999)
    
    rho = 3000.0*ones(nx,nz);
    mu = 4.8e10*ones(nx,nz);
    
    x_sourcem = [1.15e6 1.45e6];
    z_sourcem = [1.0e6 1.0e6];
    x_width = [1.1e5 1.1e5];
    z_width = [2.5e5 2.5e5];
    
    [Lx,Lz,nx,nz] = input_parameters();
    [X,Z] = define_computational_domain(Lx,Lz,nx,nz);
    
    % first structure: 4.0e9
    % structure_2: 2.0e9
    % structure_3: 1.0e9
    for i=1:size(x_sourcem,2)
        mu = mu + (-1)^i * 4.0e9 * exp( -( (X-x_sourcem(i)).^2 ) / x_width(i)^2 )' .* exp( -( (Z-z_sourcem(i)).^2 ) / z_width(i)^2 )' ;
    end
    
    if( strcmp(make_plots,'yes') )
        figure(1)
        clf
        mesh(X,Z,sqrt(mu./rho)')
        disp([ num2str( (max(max(sqrt(mu./rho)))-4000)/4000 * 100) ' % perturbation'])
        shading interp
        axis square
        colorbar
        cm = cbrewer('div','RdBu',100,'PCHIP');
        colormap(cm)
    end
    
    
elseif (strcmp(model_type,'picture') )
    
    rho = 3000.0 * ones(nx,nz); 
    A = imread('../models/rand_3.png');
    mu = 4.8e10 + 5.0e9 * flipud( abs((double(A(:,:,1))-255)/max(max(abs(double(A(:,:,1))-255)))) )';
    mu = mu - 5.0e9 * flipud( abs((double(A(:,:,2))-255)/max(max(abs(double(A(:,:,2))-255)))) )';
    
    [Lx,Lz,nx,nz] = input_parameters();
    [X,Z] = define_computational_domain(Lx,Lz,nx,nz);
    
    if( strcmp(make_plots,'yes') )
        figure(1)
        clf
        pcolor(X,Z,sqrt(mu./rho)')
        disp([ num2str( (max(max(sqrt(mu./rho)))-4000)/4000 * 100) ' % perturbation'])
        shading interp
        axis square
        colorbar
        cm = cbrewer('div','RdBu',100,'PCHIP');
        colormap(cm)
    end
   
    
else

    load(['models/mu_' str(model_type)]);
    load(['models/rho_' str(model_type)]);
    
end


