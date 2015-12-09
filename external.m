function [f, J] = external(x)
  disp('Calling external')
  f = sum(x,1);
  J = ones(1,size(x,1));
end
