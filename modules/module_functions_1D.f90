module module_functions_1D
	
	use module_presition

	implicit none
	
	contains
	
	function f_1D(x,function_type)
		! Data dictionary: declare calling parameter types & definitions
		real(dp), intent(in) 	:: x 				! function variable
		integer(sp), intent(in) :: function_type 	! function_type
		real(dp) 				:: f_1D 				! function expresion
		
		select case(function_type)
			case(1)
				f_1D = exp(x) 	! increasing exponential
			case(2)
				f_1D = exp(-x)	! decreasing exponential
			case(3)
				f_1D = exp(-(x*x*0.5_dp))
			case default
				write(*,*) 'Invalid function type'
		end select
	end function f_1D
	
	function f_1D_HO(m,k,x_0,v_0,t,function_type)
		real(dp), intent(in) :: x 					! displacement variable
		real(dp), intent(in) :: m 					! inertial mass
		real(dp), intent(in) :: k 					! spring constant
		real(dp), intent(in) :: x_0 				! initial condition of displacement
		real(dp), intent(in) :: v_0 				! initial condition of velocity (dx/dt)
		real(dp), intent(in) :: t 					! time variable
		integer(sp), intent(in) :: function_type 	! wich function do you want (position or velocity?)
		
		real(dp) :: omega 	! angular frecuency
		real(dp) :: phi 	! condition of initial phase
		real(dp) :: a 		! amplitude
		
		! logical desitions to speed up the execution
		
		if (m == k) then
			omega = 1_dp
			if (abs(x_0) == abs(v_0)) then
				a = abs(x_0)*sqrt(2_dp)
				if (x_0 /= v_0) then
					phi = atan(1_dp)
				else
					phi = -atan(1_dp)
				end if
			else
				a = sqrt((x_0)**2 + (v_0)**2)
				phi = atan(-v_0*(1_dp/x_0)))
			end if
		else
			omega 	= sqrt(k*(1_dp/m))
			if (abs(x_0) == abs(v_0)) then
				a = abs(x_0*(1_dp/omega))*sqrt(omega**2+1_dp)
				if x_0 /= v_0 then
					phi = atan(1_dp/omega)
				else
					phi = -atan(1_dp/omega)
				end if
			else
				a = sqrt((x_0)**2 + (v_0*(1_dp/omega))**2)
				phi = atan(-v_0*(1_dp/(omega*x_0)))
			end if
		end if
		
		select case(function_type)
			case(1)
				f_1D_HO = a*cos(omega*t+phi) 				! position
			case(2)
				f_1D_HO = -omega*a*sin(omega*t+phi) 		! velocity
			case(3)
				f_1D_HO = -(omega**2)*a*cos(omega*t+phi) 	! acceleration
			case default
				write(*,*) 'Invalid function type'
		end select
		
	end function f_1D_HO
	
	function f_1D_02(x,a,p,c,function_type)
		! Data dictionary: declare calling parameter types & definitions
		real(dp), intent(in) 	:: x,a,p,c			! function variable
		integer(sp), intent(in) :: function_type 	! function_type
		real(dp) 				:: f_1D_02			! function expresion
		
		select case(function_type)
			case(1)
				f_1D_02 = a*(x**p)+c
			case default
				write(*,*) 'Invalid function type'
		end select
	end function f_1D_02
	
end module module_functions_1D
