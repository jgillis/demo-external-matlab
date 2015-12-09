import casadi.*

x = MX.sym('x',10);

% Convert an external function to CasADi function form
ef = ExteralFunAndJac(@external,10,2);

% Call that function symbolically
out = ef({x});
ef_x = out{1};

% Contruct an objective with the function call embedded
f = x(1)^2;
f = f + ef_x(1);
f = ef_x(1);

f = f^4;

g = []; % No constraints

nlp = MXFunction('nlp',nlpIn('x',x),nlpOut('f',f,'g',g));

opts = struct;
opts.hessian_approximation = 'limited-memory';
solver = NlpSolver('solver','ipopt',nlp,opts);

solver_in = struct;
solver_in.x0 = ones(10,1);

solver(solver_in);
