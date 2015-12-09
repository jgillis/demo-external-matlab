function ef = ExteralFunAndJac(funandjac,n_in,n_out)
  wrapper = MyWrapper(funandjac,n_in,n_out);
  ef = wrapper.create();
end
