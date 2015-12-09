classdef MyWrapper < casadi.Callback2

    properties
      n_in
      n_out
      funandjac
      fwd
      adj
    end
    methods
        function self = MyWrapper(funandjac,n_in,n_out)
          self.funandjac = funandjac;
          self.n_in  = n_in;
          self.n_out = n_out;
          self.fwd = MyWrapperSens(self,true);
          self.adj = MyWrapperSens(self,false);
        end
        function out = nOut(self)
          out = 1;
        end
        function out = nIn(self)
          out = 1;
        end
        function out = inputShape(self,i)
          out = [self.n_in,1];
        end
        function out = outputShape(self,i)
          out = [self.n_out, 1];
        end
        function [argout] = paren(self,argin)
            [fun,~] = self.funandjac(full(argin{1}));
            
            argout{1} = fun;
        end
        function out = options(self)
            out = struct('custom_forward',self.fwd.create(), 'custom_reverse',self.adj.create());
        end
    end
    
end

