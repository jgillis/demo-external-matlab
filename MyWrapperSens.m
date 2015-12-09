classdef MyWrapperSens < casadi.DerivativeGenerator2
  properties
    fwd
    original
    wrapperjac
    wrapperjacfun
  end
  methods
    function self = MyWrapperSens(original,fwd)
      self.fwd = fwd;
      self.original = original;
      self.wrapperjac = MyWrapperJac(original);
      self.wrapperjacfun = self.wrapperjac.create();
    end
    function out = paren(self,fcn,ndir)
      import casadi.*
      
      % Obtain the symbols for nominal inputs/outputs
      nominal_in  = fcn.symbolicInput();
      nominal_out = fcn.symbolicOutput();
      
      for i=1:fcn.nOut()
          nominal_out{i} = MX.sym('x',Sparsity(self.original.n_out,1));
      end
      
      der_ins = {nominal_in{:},nominal_out{:}};
      
      out = self.wrapperjacfun(nominal_in);
      J = out{1};
      
      seeds = {};
      for i=1:ndir
        if self.fwd
            symin = fcn.symbolicInput();
        else
            symin = fcn.symbolicOutput();
        end
        seeds = {seeds{:},symin{1}};
      end

      der_ins={der_ins{:},seeds{:}};
      
      seedsvec = {};
      for i=1:ndir
          seedsvec = {seedsvec{:},vec(seeds{i})};
      end
      seedsmatrix = [seedsvec{:}];
      if self.fwd
        sensmatrix = J*seedsmatrix;
      else
        sensmatrix = J'*seedsmatrix;
      end

      parts = horzsplit(sensmatrix);
      
      der_outs = {};
      for i=1:ndir
          der_outs={der_outs{:},parts{i}};
      end
      
      out = MXFunction('my_derivative', der_ins, der_outs);
    end
  end
end
  
