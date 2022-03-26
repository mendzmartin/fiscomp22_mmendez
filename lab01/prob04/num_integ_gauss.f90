!----------------------------------------------------------
! PURPOSE
!----------------------------------------------------------
! Integración numérica.
! Puntos equiespaciados: Comparación Trapezoidal vs. Simpson
! 	programa sólo válido para la integral definida de la
!----------------------------------------------------------

program num_integ_gauss
	
	use module_presition 		! use module of presition
	use module_functions_1D		! use module of 1D functions
	use module_num_integrals 	! use module of numerical integrals
	use module_gauss 			! use module of gauss-legendre cuadrature
	use module_numerical_error 	! use module of numerical errors
	
	implicit none

	! Explicit variables declaration
	real(dp)					:: exact_integ			! valor de la integral exacta
	real(dp), dimension(1,1)	:: trapez_num_integ		! numerical integration with trapezoidal method
	real(dp), dimension(1,1) 	:: simps_13_num_integ	! numerical integration with simpson 1/3 method
	real(dp), dimension(1,1) 	:: simps_38_num_integ	! numerical integration with simpson 3/8 method
	real(dp), dimension(1,1) 	:: gauss_num_integ		! numerical integration with gauss quadrature method
	real(dp), dimension(1,1)	:: check_value
	integer(dp)					:: k					! potencia
	integer(dp) 				:: n, m 				! número de intervalos y número de puntos
	real(dp)					:: a,b					! límites de integración
	real(dp)					:: h					! paso de integración
	integer(sp) 				:: m_gauss 				! número de intervalos para usar en modulo de gauss
	integer(sp)					:: function_type 		! tipo de función a integrar
	real(dp) 					:: rel_error 			! error relativo
	real(dp) 					:: rel_error_trapez
	real(dp) 					:: rel_error_simpson13
	real(dp) 					:: rel_error_simpson38
	real(dp) 					:: rel_error_gauss
	integer(sp) 				:: istat				! integer of simple presition
	
	! Datos pedidos al usuario
	write( *, * ) 'Ingrese el limite inferior de integración (a) y presione Enter.'
	read( *, * ) a
	write( *, * ) 'Ingrese el limite superior de integración (a) y presione Enter.'
	read( *, * ) b
	write( *, *) "Ingrese un entero para la variable function_type y presione Enter."
	read(*,*) function_type
	write( *, * ) '---------------------------------------'
			
	20 format (I10, E15.6, E15.6, E15.6, E15.6, E15.6, E15.6, E15.6, E15.6, E15.6, E15.6)
	30 format (A30, E15.2)
	
	open( 10, file = './result.dat', status = 'replace', iostat = istat )
	write(*,*) 'Input/Output file. istat = ', istat
	write( *, * ) '---------------------------------------'
	write(*,*) 'check_value must be equal to zero if the integration was ok'
	
!	n = 1_dp
	
	do k = 1, 15, 1 
	
!		n = 2_dp*n
		n = 2_dp**k
		m = n + 1_dp
		h = ( b - a ) * ( 1._dp / n )
		exact_integ = -( f_1D(b,function_type) - f_1D(a,function_type) )
		m_gauss = 2_sp**k
		
		call trapez_integ ( m, a, b, h, trapez_num_integ, function_type )
		call basic_errors_num(exact_integ, trapez_num_integ(1,1), rel_error, 2)
		rel_error_trapez = rel_error*100_dp
		
		call simpson_13_integ ( m, a, b, h, simps_13_num_integ, function_type, check_value )
		write(*,30) 'check_value of simpson 1/3 = ', check_value
		call basic_errors_num(exact_integ, simps_13_num_integ(1,1), rel_error, 2)
		rel_error_simpson13 = rel_error*100_dp
		
		call simpson_38_integ ( m, a, b, h, simps_38_num_integ, function_type )
		call basic_errors_num(exact_integ, simps_38_num_integ(1,1), rel_error, 2)
		rel_error_simpson38 = rel_error*100_dp
		
		call gauss_integ ( m_gauss, 0, a, b, gauss_num_integ, function_type)
		call basic_errors_num(exact_integ, gauss_num_integ(1,1), rel_error, 2)
		rel_error_gauss = rel_error*100_dp
		
		write( 10, 20 )	n, h, exact_integ,&
						trapez_num_integ, rel_error_trapez,&
						simps_13_num_integ, rel_error_simpson13,&
						simps_38_num_integ, rel_error_simpson38,&
						gauss_num_integ, rel_error_gauss
	end do
	
	close (10)
	
	return
end program num_integ_gauss


!----------------------------------------------------------
! REFERENCES
!----------------------------------------------------------
!
!
!
!----------------------------------------------------------

!----------------------------------------------------------
! COMPILATION RUL
!----------------------------------------------------------
! gfortran -o num_integ_gauss ../../modules/module_presition.f90 ../../modules/module_functions_1D.f90 ../../modules/module_gauss.f90 ../../modules/module_num_integrals.f90 ../../modules/module_numerical_error.f90 num_integ_gauss.f90 && ./num_integ_gauss
!----------------------------------------------------------
