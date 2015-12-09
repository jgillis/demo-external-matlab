classdef MyWrapperJac < casadi.Callback2

    properties
      original
    end
    methods
        function self = MyWrapperJac(original)
          self.original = original;
        end
        function out = nOut(self)
          out = 2;
        end
        function out = nIn(self)
          out = 1;
        end
        function out = inputShape(self,i)
          out = [self.original.n_in,1];
        end
        function out = outputShape(self,i)
          out = [self.original.n_out, self.original.n_in];
          if i==2
            out = [self.original.n_out, 1];
          end
        end
        function [argout] = paren(self,argin)
            disp('fun+jac requested')
            [fun,J] = self.original.funandjac(full(argin{1}));
            argout{1} = J;
            argout{2} = fun;
        end
    end
    
end

