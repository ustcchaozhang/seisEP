!! main subroutines to evaluate misfit and ajoint source
!! created by Yanhua O. Yuan ( yanhuay@princeton.edu)

!----------------------------------------------------------------------
subroutine misfit_adj_AD(measurement_type,d,s,NSTEP,deltat,f0,&
        tstart,tend,taper_percentage,taper_type, &
        compute_adjoint,adj,num,misfit)
    !! conventional way to do tomography, 
    !! using absolute-difference measurements of data(d) and syn (s)

    use constants
    implicit none

    ! inputs & outputs 
    character(len=2), intent(in) :: measurement_type
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    integer, intent(in) :: NSTEP
    real(kind=CUSTOM_REAL), intent(in) :: deltat,f0
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit

    ! initialization within loop of irec
    adj(1:NSTEP)=0.d0
    num=1
    misfit=0.0

    select case (measurement_type)
    case ("CC")
        if(DISPLAY_DETAILS) print*, 'CC (traveltime) misfit (s-d)'
        call CC_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            'dt',compute_adjoint,adj,num,misfit)
    case ("AM")
        if(DISPLAY_DETAILS) print*, 'AM (amplitude) misfit (s-d)'
        call CC_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            'am',compute_adjoint,adj,num,misfit)
    case ("WD")
        if(DISPLAY_DETAILS) print*, 'WD (waveform-difference) misfit (s-d)'
        call WD_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            compute_adjoint,adj,num,misfit)
    case ("ET")
        if(DISPLAY_DETAILS) print*, 'ET (envelope cc-traveltime) misfit (s-d)'
        call ET_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            compute_adjoint,adj,num,misfit)
    case ("ED")
        if(DISPLAY_DETAILS) print*, 'ED (envelope-difference) misfit (s-d)'
        call ED_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            compute_adjoint,adj,num,misfit)
    case ("EP")
        if(DISPLAY_DETAILS) print*, 'EP (exponentiated phase) misfit (s-d)'
        call EP_misfit(d,s,NSTEP,deltat,tstart,tend,taper_percentage,taper_type, &
            compute_adjoint,adj,num,misfit)
    case ("MT")
        if(DISPLAY_DETAILS) print*, 'MT (multitaper traveltime) misfit (d-s)'
        call MT_misfit(d,s,NSTEP,deltat,f0,tstart,tend,taper_percentage,taper_type, &
            'MT',compute_adjoint,adj,num,misfit)
    case ("MA")
        if(DISPLAY_DETAILS) print*, 'MA (multitaper amplitude) misfit (d-s)'
        call MT_misfit(d,s,NSTEP,deltat,f0,tstart,tend,taper_percentage,taper_type, &
            'MA',compute_adjoint,adj,num,misfit)
    case default
        print*, 'measurement_type must be among "CC"/"AM"/"WD"/"ET"/"ED"/"EP"/"MT"/"MA"/...';
        stop
    end select

end subroutine misfit_adj_AD
!------------------------------------------------------------------------
subroutine misfit_adj_DD(measurement_type,d,d_ref,s,s_ref,NSTEP,deltat,f0,&
        tstart,tend,tstart_ref,tend_ref,taper_percentage,taper_type,compute_adjoint,&
        adj,adj_ref,num,misfit)
    !! double-difference tomography, 
    !! using differential measurements of data(d) and ref data(d_ref);
    !! syn (s) and ref syn(s_ref)
    use constants
    implicit none

    ! inputs & outputs 
    character(len=2), intent(in) :: measurement_type
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s,d_ref,s_ref
    real(kind=CUSTOM_REAL), intent(in) :: deltat,f0
    integer, intent(in) :: NSTEP
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend,tstart_ref,tend_ref
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj,adj_ref

    ! initialization within loop of irec
    adj(1:NSTEP)=0.d0
    adj_ref(1:NSTEP)=0.d0
    num=1
    misfit=0.0

    select case (measurement_type)
    case ("CC")
        if(DISPLAY_DETAILS) print*, '*** Double-difference CC (traveltime) misfit'
        call CC_misfit_DD(d,d_ref,s,s_ref,NSTEP,deltat,&
            tstart,tend,tstart_ref,tend_ref,&
            taper_percentage,taper_type,&
            compute_adjoint,&
            adj,adj_ref,num,misfit)
    case ("WD")
        if(DISPLAY_DETAILS) print*, '*** Double-difference WD (waveform) misfit'
        call WD_misfit_DD(d,d_ref,s,s_ref,NSTEP,deltat,&
            tstart,tend,tstart_ref,tend_ref,&
            taper_percentage,taper_type,&
            compute_adjoint,&
            adj,adj_ref,num,misfit)
    case ("EP")
        if(DISPLAY_DETAILS) print*, '*** Double-difference EP (exponentiated) misfit'
        call EP_misfit_DD(d,d_ref,s,s_ref,NSTEP,deltat,&
            tstart,tend,tstart_ref,tend_ref,&
            taper_percentage,taper_type,&
            compute_adjoint,&
            adj,adj_ref,num,misfit)
    case ("MT")
        if(DISPLAY_DETAILS) print*, '*** Double-difference MT (multitaper) misfit'
        call MT_misfit_DD(d,d_ref,s,s_ref,NSTEP,deltat,f0,&
            tstart,tend,tstart_ref,tend_ref,&
            taper_percentage,taper_type,&
            'MT',compute_adjoint,&
            adj,adj_ref,num,misfit)
    case default
        print*, 'measurement_type must be among CC/WD/EP/MT ...';
        stop

    end select

end subroutine misfit_adj_DD
!------------------------------------------------------------------------

!----------------------------------------------------------------------
!---------------subroutines for misfit_adjoint-------------------------
!-----------------------------------------------------------------------
subroutine WD_misfit(d,s,npts,deltat,tstart,tend,taper_percentage,taper_type,compute_adjoint,&
        adj,num,misfit)
    !! waveform difference between d and s

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj

    ! index 
    integer :: i

    ! error
    real(kind=CUSTOM_REAL) :: const, err_WD

    ! window
    integer :: nlen
    integer :: i_tstart, i_tend
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) ::  adj_tw

    !! window
    nlen=floor((tend-tstart)/deltat)+1
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)
    num=nlen

    !! WD misfit
    const=1.0
    err_WD=1.0
    if(NORMALIZE) then
        const = sqrt(sum(d_tw(1:nlen)**2)*deltat)
        err_WD=err_WD*const
        num=1
    endif
    do i=1,nlen 
    write(IOUT,*) (s_tw(i)-d_tw(i))*sqrt(deltat)/err_WD
    enddo
    misfit=0.5*sum((s_tw(1:nlen)-d_tw(1:nlen))**2*deltat)/err_WD**2

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries : ',i_tstart,i_tend
        print*, 'time window length : ', nlen
        open(1,file=trim(output_dir)//'/dat_syn',status='unknown')
        open(2,file=trim(output_dir)//'/dat_syn_win',status='unknown')
        do  i = i_tstart,i_tend
        write(1,'(I5,2e15.5)') i, d(i),s(i)
        enddo
        do  i = 1,nlen
        write(2,'(I5,2e15.5)') i, d_tw(i),s_tw(i)
        enddo
        close(1)
        close(2)
    endif

    !! WD adjoint
    if(COMPUTE_ADJOINT) then
        adj_tw(1:nlen) =  (s_tw(1:nlen)-d_tw(1:nlen))/err_WD**2

        ! reverse window and taper again 
        adj(i_tstart:i_tend)=tas(1:nlen)*adj_tw(1:nlen)
        deallocate(tas)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj_WD_win',status='unknown')
            do  i =  i_tstart,i_tend
            write(1,'(I5,e15.5)') i,adj(i)
            enddo
            close(1)
        endif

    endif

end subroutine WD_misfit
!-----------------------------------------------------------------------
subroutine CC_misfit(d,s,npts,deltat,tstart,tend,taper_percentage,taper_type,&
        misfit_type,compute_adjoint,&
        adj,num,misfit)
    !! CC traveltime shift between d and s

    use constants
    implicit none 

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    character(len=2), intent(in) :: misfit_type
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj

    ! index
    integer :: i

    ! window
    integer :: nlen
    integer :: i_tstart, i_tend
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw 

    ! cc 
    integer :: ishift
    real(kind=CUSTOM_REAL) :: tshift, dlnA, cc_max
    real(kind=CUSTOM_REAL) :: err_dt_cc,err_dlnA_cc

    ! error
    real(kind=CUSTOM_REAL) :: const, err_CC, err_AM

    ! adjoint
    real(kind=CUSTOM_REAL) :: Mtr
    real(kind=CUSTOM_REAL), dimension(npts) :: s_tw_vel, adj_tw 

    !! window
    nlen=floor((tend-tstart)/deltat)+1 
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)

    !! CC misfit
    call xcorr_calc(d_tw,s_tw,npts,1,nlen,ishift,dlnA,cc_max) ! T(d-s)

    !! cc_error
    const=1.0
    err_CC=1.0
    err_AM=1.0
    err_dt_cc=1.0
    err_dlnA_cc=1.0
    if(USE_ERROR_CC) call cc_error(d_tw,s_tw,npts,deltat,nlen,ishift,dlnA,&
        err_dt_cc,err_dlnA_cc)
    if(NORMALIZE) then
        ! arrival time estimated from peak of waves
        const=(i_tstart+MAXLOC(abs(d_tw),1))*deltat
    endif
    err_CC=err_dt_cc*const
    err_AM=err_dlnA_CC
    if(misfit_type=='dt') then 
        tshift = ishift*deltat  
        write(IOUT,*) tshift/err_CC
        misfit=0.5*(tshift/err_CC)**2
    elseif(misfit_type=='am') then
        write(IOUT,*) dlnA/err_AM
        misfit=0.5*(dlnA/err_AM)**2
    endif
    num=1

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries : ',i_tstart,i_tend
        print*, 'time window length (sample /  second) : ', nlen, nlen*deltat
        print*, 'cc ishift/tshift/dlnA of d-s : ', ishift,tshift,dlnA
        open(1,file=trim(output_dir)//'/dat_syn_win',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,2e15.5)') i, d_tw(i),s_tw(i)
        enddo
        close(1)
    endif

    !! cc adjoint
    if(COMPUTE_ADJOINT) then
        if(misfit_type=='dt') then
            ! computer velocity 
            call compute_vel(s_tw,npts,deltat,nlen,s_tw_vel)
            ! constant on the bottom 
            Mtr=-sum(s_tw_vel(1:nlen)*s_tw_vel(1:nlen))*deltat
            ! adjoint source
            adj_tw(1:nlen)=-1.0*tshift*s_tw_vel(1:nlen)/Mtr/err_CC**2 
        elseif(misfit_type=='am') then 
            ! constant on the bottom
            Mtr=sum(s_tw(1:nlen)*s_tw(1:nlen))*deltat 
            ! adjoint source
            adj_tw(1:nlen)=-1.0*dlnA*s_tw(1:nlen)/Mtr/err_AM**2
        endif

        ! reverse window and taper again 
        adj(i_tstart:i_tend)=tas(1:nlen)*adj_tw(1:nlen)
        deallocate(tas)

        if( DISPLAY_DETAILS) then
            if(misfit_type=='dt') then
                open(1,file=trim(output_dir)//'/adj_CC_win',status='unknown')
            elseif(misfit_type=='am') then
                open(1,file=trim(output_dir)//'/adj_AM_win',status='unknown')
            endif
            do  i =  i_tstart,i_tend
            write(1,'(I5,e15.5)') i,adj(i)
            enddo
            close(1)
        endif

    endif

end subroutine CC_misfit
! -----------------------------------------------------------------------
subroutine ET_misfit(d,s,npts,deltat,tstart,tend,taper_percentage,taper_type,compute_adjoint,&
        adj,num,misfit)
    !! Envelope time shift between d and s

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    integer, intent(in) :: npts
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit

    ! window
    integer :: nlen
    integer :: i_tstart, i_tend
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw

    ! index
    integer :: i

    ! error    
    real(kind=CUSTOM_REAL) :: const, err_ET

    ! hilbert transformation
    real(kind=CUSTOM_REAL) :: epslon
    real(kind=CUSTOM_REAL), dimension(npts) :: E_d,E_s,E_ratio,hilbt_ratio,hilbt_d,hilbt_s

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) :: adj_tw
    real(kind=CUSTOM_REAL), dimension(npts) :: seism_vel
    real(kind=CUSTOM_REAL) :: Mtr

    ! cc 
    integer :: ishift
    real(kind=CUSTOM_REAL) :: tshift, dlnA, cc_max

    !! window
    nlen=floor((tend-tstart)/deltat)+1
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)

    !! Envelope time_shift misfit
    ! initialization 
    E_s(:) = 0.0
    E_d(:) = 0.0
    E_ratio(:) = 0.0
    hilbt_ratio (:) = 0.0
    hilbt_d(:) = 0.0
    hilbt_s(:) = 0.0

    ! hilbert transform of d
    hilbt_d(1:nlen) = d_tw(1:nlen)
    call hilbert(hilbt_d,nlen)
    ! envelope
    E_d(1:nlen) = sqrt(d_tw(1:nlen)**2+hilbt_d(1:nlen)**2)

    ! hilbert transform of s
    hilbt_s(1:nlen) = s_tw(1:nlen)
    call hilbert(hilbt_s,nlen)
    ! envelope
    E_s(1:nlen) = sqrt(s_tw(1:nlen)**2+hilbt_s(1:nlen)**2)

    ! ET misfit
    call xcorr_calc(E_s,E_d,nlen,1,nlen,ishift,dlnA,cc_max) ! T(Es-Ed)
    const=1.0
    err_ET=1.0
    if(NORMALIZE) then
        ! arrival time estimated from peak of envelopes
        const=(i_tstart+MAXLOC(abs(E_d),1))*deltat
        err_ET=err_ET*const
    endif

    tshift = ishift*deltat
    write(IOUT,*) tshift/err_ET
    num=1
    misfit=0.5*(tshift/err_ET)**2

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries : ',i_tstart,i_tend
        print*, 'time window length (sample /  second) : ', nlen, nlen*deltat
        print*, 'cc ishift/tshift/dlnA of Es-Ed : ', ishift,tshift,dlnA
        open(1,file=trim(output_dir)//'/dat_syn_win',status='unknown')
        open(2,file=trim(output_dir)//'/dat_syn_env',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,2e15.5)') i, d_tw(i),s_tw(i)
        write(2,'(I5,2e15.5)') i, E_d(i),E_s(i)
        enddo
        close(1)
        close(2)
    endif

    !! Envelope time_shift adjoint
    if(COMPUTE_ADJOINT) then

        ! computer velocity 
        call compute_vel(E_s,npts,deltat,nlen,seism_vel)

        ! constant factor
        Mtr=-sum(seism_vel(1:nlen)*seism_vel(1:nlen))*deltat

        ! E_ratio
        epslon=wtr_env*maxval(E_s)
        E_ratio(1:nlen) =  tshift /Mtr*seism_vel(1:nlen)/(E_s(1:nlen)+epslon)

        ! hilbert transform for E_ratio*hilbt
        hilbt_ratio=E_ratio * hilbt_s
        call hilbert(hilbt_ratio,nlen)

        ! adjoint source
        adj_tw(1:nlen)=E_ratio(1:nlen)*s_tw(1:nlen)-hilbt_ratio(1:nlen)
        adj_tw(1:nlen)=adj_tw(1:nlen)/err_ET**2

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/E_ratio',status='unknown')
            print*
            print*, 'water level for E_ratio is : ', epslon
            do  i = 1,nlen
            write(1,'(I5,2e15.5)') i,E_ratio(i),hilbt_ratio(i)
            enddo
            close(1)
        endif

        ! reverse window and taper again 
        adj(i_tstart:i_tend)=tas(1:nlen)*adj_tw(1:nlen)
        deallocate(tas)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj_ET_win',status='unknown')
            do  i = i_tstart,i_tend
            write(1,'(I5,e15.5)') i,adj(i)
            enddo
            close(1)
        endif

    endif

end subroutine ET_misfit
!-----------------------------------------------------------------------
subroutine ED_misfit(d,s,npts,deltat,tstart,tend,taper_percentage,taper_type,compute_adjoint,&
        adj,num,misfit)
    !! Envelope difference between d and s

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    integer, intent(in) :: npts
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit

    ! index 
    integer :: i

    ! error 
    real(kind=CUSTOM_REAL) :: const, err_ED

    ! window
    integer :: nlen
    integer :: i_tstart, i_tend
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw

    ! hilbert transformation
    real(kind=CUSTOM_REAL) :: epslon
    real(kind=CUSTOM_REAL), dimension(npts) :: E_d,E_s,E_ratio,hilbt_ratio,hilbt_d,hilbt_s

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) :: adj_tw

    !! window
    nlen=floor((tend-tstart)/deltat)+1
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)

    !! Envelope difference misfit
    ! initialization 
    E_s(:) = 0.0
    E_d(:) = 0.0
    E_ratio(:) = 0.0
    hilbt_ratio (:) = 0.0
    hilbt_d(:) = 0.0
    hilbt_s(:) = 0.0

    ! hilbert transform of d
    hilbt_d(1:nlen) = d_tw(1:nlen)
    call hilbert(hilbt_d,nlen)
    ! envelope
    E_d(1:nlen) = sqrt(d_tw(1:nlen)**2+hilbt_d(1:nlen)**2)

    ! hilbert for s
    hilbt_s(1:nlen) = s_tw(1:nlen)
    call hilbert(hilbt_s,nlen)
    ! envelope
    E_s(1:nlen) = sqrt(s_tw(1:nlen)**2+hilbt_s(1:nlen)**2) 

    ! ED misfit
    const=1.0
    err_ED=1.0
    if(NORMALIZE) then
        const = sqrt(sum(E_d(1:nlen)**2)*deltat)
        err_ED=err_ED*const
    endif

    do i=1,nlen
    write(IOUT,*) (E_s(i)-E_d(i))*sqrt(deltat)/err_ED
    enddo
    num=nlen
    misfit=0.5*sum((E_s(1:nlen)-E_d(1:nlen))**2*deltat)/err_ED**2

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries : ',i_tstart,i_tend
        print*, 'time window length : ', nlen
        open(1,file=trim(output_dir)//'/dat_env',status='unknown')
        open(2,file=trim(output_dir)//'/syn_env',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,2e15.5)') i, d_tw(i),E_d(i)
        write(2,'(I5,2e15.5)') i, s_tw(i),E_s(i)
        enddo
        close(1)
        close(2)
    endif

    !! Envelope difference adjoint
    if(COMPUTE_ADJOINT) then

        ! E_ratio
        epslon=wtr_env*maxval(E_s)
        E_ratio(1:nlen)=(E_s(1:nlen)-E_d(1:nlen))/(E_s(1:nlen)+epslon)

        ! hilbert transform for E_ratio*hilbt
        hilbt_ratio=E_ratio * hilbt_s
        call hilbert(hilbt_ratio,nlen)

        ! adjoint source
        adj_tw(1:nlen)=E_ratio(1:nlen)*s_tw(1:nlen)-hilbt_ratio(1:nlen)
        adj_tw(1:nlen)=adj_tw(1:nlen)/err_ED**2

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/E_ratio',status='unknown')
            print*
            print*, 'water level for E_ratio is : ', epslon
            do  i = 1,nlen
            write(1,'(I5,2e15.5)') i,E_ratio(i),hilbt_ratio(i)
            enddo
            close(1)
        endif

        ! reverse window and taper again 
        adj(i_tstart:i_tend)=tas(1:nlen)*adj_tw(1:nlen)
        deallocate(tas)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj_ED_win',status='unknown')
            do  i = i_tstart,i_tend
            write(1,'(I5,e15.5)') i,adj(i)
            enddo
            close(1)
        endif

    endif

end subroutine ED_misfit
!-----------------------------------------------------------------------
subroutine EP_misfit(d,s,npts,deltat,tstart,tend,taper_percentage,taper_type,compute_adjoint,&
        adj,num,misfit)
    !! Exponentiated phase difference between d and s (need to be fixed)

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    integer, intent(in) :: npts
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit

    ! index 
    integer :: i

    ! window
    integer :: nlen
    integer :: i_tstart, i_tend
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw

    ! hilbert transformation
    !real(kind=CUSTOM_REAL) :: wtr_d, wtr_s
    real(kind=CUSTOM_REAL), dimension(npts) :: E_d_wtr,E_s_wtr
    real(kind=CUSTOM_REAL), dimension(npts) :: E_d,E_s,E_ratio,hilbt_ratio
    real(kind=CUSTOM_REAL), dimension(npts) :: hilbt_d, hilbt_s, real_diff, imag_diff

    ! error
    real(kind=CUSTOM_REAL) :: const, err_EP

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) :: adj_tw

    !! window
    nlen=floor((tend-tstart)/deltat)+1
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)

    !! exponentiated phase misfit
    ! initialization 
    real_diff(:) = 0.0
    imag_diff(:) = 0.0
    E_d(:) = 0.0
    E_s(:) = 0.0 
    E_ratio(:) = 0.0
    hilbt_ratio (:) = 0.0
    hilbt_d(:)=0.0
    hilbt_s(:)=0.0

    !! hilbert for obs
    hilbt_d(1:nlen)=d_tw(1:nlen)
    call hilbert(hilbt_d,nlen)
    E_d(1:nlen)=sqrt(hilbt_d(1:nlen)**2+d_tw(1:nlen)**2)

    !! hilbert for syn
    hilbt_s(1:nlen)=s_tw(1:nlen)
    call hilbert(hilbt_s,nlen)
    E_s(1:nlen)=sqrt(hilbt_s(1:nlen)**2+s_tw(1:nlen)**2)

    !! removing amplitude info 
    E_d_wtr = E_d + wtr_env*maxval(E_d)
    E_s_wtr = E_s + wtr_env*maxval(E_s)
    !E_d_wtr = E_d + exp(-E_d/maxval(E_d)/wtr_env)*maxval(E_d)
    !E_s_wtr = E_s + exp(-E_s/maxval(E_s)/wtr_env)*maxval(E_s)

    !! diff for real & imag part
    real_diff(1:nlen)=s_tw(1:nlen)/E_s_wtr(1:nlen) - d_tw(1:nlen)/E_d_wtr(1:nlen) 
    imag_diff(1:nlen)=hilbt_s(1:nlen)/E_s_wtr(1:nlen) - hilbt_d(1:nlen)/E_d_wtr(1:nlen)
    num=nlen
    ! EP misfit
    const=1.0
    err_EP=1.0
    if(NORMALIZE) then
        const = sqrt(sum((d_tw(1:nlen)/(E_d_wtr(1:nlen)))**2)*deltat + &
            sum((hilbt_d(1:nlen)/(E_d_wtr(1:nlen)))**2)*deltat)
        err_EP=err_EP*const
        num=1
    endif
    do i=1,nlen
    write(IOUT,*) real_diff(i)*sqrt(deltat)/err_EP
    write(IOUT,*) imag_diff(i)*sqrt(deltat)/err_EP
    enddo
    misfit=0.5*sum(real_diff(1:nlen)**2*deltat)/err_EP**2 + &
        0.5*sum(imag_diff(1:nlen)**2*deltat)/err_EP**2

    if(DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries : ',i_tstart,i_tend
        print*, 'time window length : ', nlen
        open(1,file=trim(output_dir)//'/dat_env',status='unknown')
        open(2,file=trim(output_dir)//'/syn_env',status='unknown')
        open(3,file=trim(output_dir)//'/phi_dat_syn',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,2e15.5)') i, d_tw(i),E_d(i)
        write(2,'(I5,2e15.5)') i, s_tw(i),E_s(i)
        write(3,'(I5,2e15.5)') i, real_diff(i), imag_diff(i)
        enddo
        close(1)
        close(2)
        close(3)
    endif

    !! exponentiated phase adjoint
    if(COMPUTE_ADJOINT) then
        ! both real and imaginary
        E_ratio = (real_diff*hilbt_s**2 - imag_diff*s_tw*hilbt_s) /(E_s_wtr)**3
        hilbt_ratio = (real_diff*s_tw*hilbt_s-imag_diff*s_tw**2)/(E_s_wtr)**3
        ! hilbert transform for hilbt_ratio
        call hilbert(hilbt_ratio,nlen)

        ! adjoint source
        adj_tw(1:nlen)=(E_ratio(1:nlen) + hilbt_ratio(1:nlen))/err_EP**2

        ! reverse window and taper again 
        adj(i_tstart:i_tend)=tas(1:nlen)*adj_tw(1:nlen)
        deallocate(tas)

        if(DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj_EP_win',status='unknown')
            do  i = i_tstart,i_tend
            write(1,'(I5,3e15.5)') i,d(i),s(i),adj(i)
            enddo
            close(1)
        endif

    endif

end subroutine EP_misfit
!-----------------------------------------------------------------------
subroutine MT_misfit(d,s,npts,deltat,f0,tstart,tend,taper_percentage,taper_type,&
        misfit_type,compute_adjoint,&
        adj,num,misfit)
    !! MT between d and s (d-s) 

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d,s
    integer, intent(in) :: npts
    real(kind=CUSTOM_REAL), intent(in) :: deltat,f0
    real(kind=CUSTOM_REAL), intent(in) :: tstart,tend
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    character(len=2), intent(in) :: misfit_type

    ! index
    integer :: i,j

    ! window
    integer :: nlen, nlen_d
    integer :: i_tstart, i_tend
    integer :: i_tstart_d, i_tend_d
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas
    real(kind=CUSTOM_REAL), dimension(npts) :: d_tw,s_tw,d_tw_cc

    ! cc 
    integer :: ishift
    real(kind=CUSTOM_REAL) :: tshift, dlnA, cc_max
    real(kind=CUSTOM_REAL) :: err_dt_cc,err_dlnA_cc

    ! FFT parameters
    real(kind=CUSTOM_REAL), dimension(NPT) :: wvec,fvec
    real(kind=CUSTOM_REAL) :: df,df_new,dw

    !! multitaper
    logical :: is_mtm
    integer :: i_fstart, i_fend
    real(kind=SIZE_DOUBLE), dimension(NPT) :: ey1,ey2
    integer :: ictaper
    real(kind=CUSTOM_REAL), dimension(NPT) :: dtau_w, dlnA_w,err_dtau_mt,err_dlnA_mt
    complex(CUSTOM_REAL), dimension(NPT) :: trans_func

    ! misfit & adjoint
    real(kind=CUSTOM_REAL) :: misfit_p, misfit_q
    real(kind=CUSTOM_REAL), dimension(npts) :: adj_p_tw,adj_q_tw

    is_mtm = .true. 
    !! window
    nlen=floor((tend-tstart)/deltat)+1
    if(nlen<1 .or. nlen>npts) print*,'nlen'
    i_tstart=max(floor(tstart / deltat), 1)
    i_tend = min(i_tstart+nlen-1, npts)
    nlen=i_tend - i_tstart + 1
    allocate(tas(nlen))
    call window_taper(nlen,taper_percentage,taper_type,tas)
    s_tw(1:nlen)=tas(1:nlen)*s(i_tstart:i_tend)
    d_tw(1:nlen)=tas(1:nlen)*d(i_tstart:i_tend)

    !! cc correction
    call xcorr_calc(d_tw,s_tw,npts,1,nlen,ishift,dlnA,cc_max) ! T(d-s)
    tshift= ishift*deltat

    !! cc_error
    err_dt_cc=1.0
    err_dlnA_cc=1.0
    if(USE_ERROR_CC)  call cc_error(d_tw,s_tw,npts,deltat,nlen,ishift,dlnA,&
        err_dt_cc,err_dlnA_cc)

    ! correction for d to align with s
    i_tstart_d = max(i_tstart+ishift, 1)
    i_tend_d = min(i_tend+ishift, npts)
    nlen_d = i_tend_d - i_tstart_d + 1
    if(nlen_d == nlen) then 
        d_tw_cc(1:nlen)=tas(1:nlen)*d(i_tstart_d:i_tend_d)*exp(-dlnA)
    else
        d_tw_cc=d_tw
        tshift=0.0
        dlnA=0.0
    endif

    if( DISPLAY_DETAILS) then
        print*
        print*, 'xcorr_cal: d-s'
        print*, 'xcorr_calc: calculated ishift/tshift = ', ishift,tshift
        print*, 'xcorr_calc: calculated dlnA = ',dlnA
        print*, 'xcorr_calc: cc_max ',cc_max
        open(1,file=trim(output_dir)//'/dat_syn_datcc',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,3f15.5)') i, d_tw(i),s_tw(i),d_tw_cc(i)
        enddo
        close(1)
    endif

    ! update
    d_tw = d_tw_cc

    !! MT misfit
    !-----------------------------------------------------------------------------
    !  set up FFT for the frequency domain
    !----------------------------------------------------------------------------- 
    df = 1./(NPT*deltat)
    dw = TWOPI * df
    ! calculate frequency spacing of sampling points
    df_new = 1.0 / (nlen*deltat)
    ! assemble omega vector (NPT is the FFT length)
    wvec(:) = 0.
    do j = 1,NPT
    if(j > NPT/2+1) then
        wvec(j) = dw*(j-NPT-1)   ! negative frequencies in second half
    else
        wvec(j) = dw*(j-1)       ! positive frequencies in first half
    endif
    enddo
    fvec = wvec / TWOPI

    !!   find the relaible frequency limit
    call frequency_limit(s_tw,nlen,deltat,f0/2.5,f0*2.5,i_fstart,i_fend)
    if(i_fstart>=i_fend) is_mtm = .false.

    if( DISPLAY_DETAILS) then
        print*
        print*, 'find the spectral boundaries for reliable measurement'
        print*, 'min, max time limits : ',i_tstart, i_tend, nlen
        print*, 'min, max frequency limits : ', i_fstart, i_fend
        print*, 'frequency interval df= ', df, ' dw=', dw
        print*, 'effective bandwidth (Hz) : ',fvec(i_fstart), fvec(i_fend), fvec(i_fend)-fvec(i_fstart)
        print*, 'half time-bandwidth product : ', NW
        print*, 'number of tapers : ',ntaper
        print*, 'resolution of multitaper (Hz) : ', NW/(nlen*deltat)
        print*, 'number of segments of frequency bandwidth : ', ceiling((fvec(i_fend)-fvec(i_fstart))*nlen*deltat/NW)
        print*, 'is_mtm : ', is_mtm
    endif

    !! MT measurement
    if (is_mtm) then  
        ! calculate the tapers
        allocate(tapers(NPT,ntaper))
        call staper(nlen, dble(NW), ntaper, tapers, NPT, ey1, ey2)

        if( DISPLAY_DETAILS) then
            do ictaper=1,ntaper
            write(filename,'(i1)') ictaper
            open(1,file=trim(output_dir)//'/'//'taper_t_'//trim(adjustl(filename)),status='unknown')
            do i = 1,nlen
            write(1,'(f15.2,E15.5)') (i-1)*deltat,tapers(i,ictaper)
            ! write(1,'(f15.2,<ntaper>e15.5)') (i-1)*deltat,tapers(i,1:ntaper)
            enddo
            close(1)
            enddo
        endif

        !! mt phase and ampplitude measurement 
        call mt_measure(d_tw,s_tw,npts,deltat,nlen,tshift,dlnA,i_fstart,i_fend,&
            wvec,&
            trans_func,dtau_w,dlnA_w,err_dtau_mt,err_dlnA_mt) !d-s

        !! misfit & adjoint 
        call mt_adj(s_tw,npts,deltat,nlen,df,i_fstart,i_fend,dtau_w,dlnA_w,&
            err_dt_cc,err_dlnA_cc,&
            err_dtau_mt,err_dlnA_mt, &
            COMPUTE_ADJOINT, &
            adj_p_tw,adj_q_tw, misfit_p, misfit_q)

        if(misfit_type=='MT') then 
            ! MT misfit
            do i=i_fstart,i_fend
            write(IOUT,*) dtau_w(i)*sqrt(df)
            enddo
            misfit=misfit_p
        elseif(misfit_type=='MA') then
            ! MA misfit
            do i=i_fstart,i_fend
            write(IOUT,*) dlnA_w(i)*sqrt(df)
            misfit=misfit_q
            enddo
        endif
        num=i_fend-i_fstart+1

        if(DISPLAY_DETAILS) then
            !! write into file 
            open(1,file=trim(output_dir)//'/dtau_mtm',status='unknown')
            open(2,file=trim(output_dir)//'/dlnA_mtm',status='unknown')
            do  i = i_fstart,i_fend
            write(1,'(3e15.5)') fvec(i),dtau_w(i),tshift !err_dtau_mt(i)
            write(2,'(3e15.5)') fvec(i),dlnA_w(i),dlnA !err_dlnA_mt(i)
            enddo
            close(1)
            close(2)
        endif

        !! MT adjoint
        if(COMPUTE_ADJOINT) then
            ! inverse window and taper again 
            if(misfit_type=='MT') then
                adj(i_tstart:i_tend)=tas(1:nlen)*adj_p_tw(1:nlen)
            elseif(misfit_type=='MA') then
                adj(i_tstart:i_tend)=tas(1:nlen)*adj_q_tw(1:nlen)
            endif
            deallocate(tas)

            if( DISPLAY_DETAILS) then
                open(1,file=trim(output_dir)//'/adj_MT_win',status='unknown')
                do  i =  i_tstart,i_tend
                write(1,'(I5,e15.5)') i,adj(i)
                enddo
                close(1)
                close(2)
            endif

        endif ! COMPUTE_ADJOINT
        deallocate(tapers)

    else ! CC adj
        if(DISPLAY_DETAILS) print*, 'CC (traveltime) misfit (s-d)'
        call CC_misfit(d,s,npts,deltat,f0,tstart,tend,taper_percentage,taper_type, &
            misfit_type,compute_adjoint,adj,num,misfit)
    endif

end subroutine MT_misfit
! -----------------------------------------------------------------------
subroutine CC_misfit_DD(d1,d2,s1,s2,npts,deltat,&
        tstart1,tend1,tstart2,tend2,&
        taper_percentage,taper_type,&
        compute_adjoint,&
        adj1,adj2,num,misfit)
    !! CC traveltime double difference

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d1,d2,s1,s2
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart1,tend1,tstart2,tend2
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    logical, intent(in) :: compute_adjoint
    real(kind=CUSTOM_REAL) :: cc_max_syn,cc_max_obs
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj1,adj2

    ! index
    integer :: i

    ! window
    integer :: nlen1,nlen2,nlen
    integer :: i_tstart1,i_tend1,i_tstart2,i_tend2
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas1,tas2
    real(kind=CUSTOM_REAL), dimension(npts) :: d1_tw,d2_tw,s1_tw,s2_tw
    ! cc 
    integer :: ishift_obs,ishift_syn
    real(kind=CUSTOM_REAL) :: tshift_obs,tshift_syn
    real(kind=CUSTOM_REAL) :: dlnA_obs,dlnA_syn
    real(kind=CUSTOM_REAL) :: ddtshift_cc,ddlnA_cc
    real(kind=CUSTOM_REAL) :: const, err_DD_CC

    ! adjoint
    real(kind=CUSTOM_REAL) :: Mtr
    real(kind=CUSTOM_REAL), dimension(npts) :: s1_tw_cc,s2_tw_cc
    real(kind=CUSTOM_REAL), dimension(npts) :: s1_tw_vel,s1_tw_cc_vel,s2_tw_cc_vel
    real(kind=CUSTOM_REAL), dimension(npts) :: adj1_tw,adj2_tw

    !! window
    nlen1=floor((tend1-tstart1)/deltat)+1
    if(nlen1<1 .or. nlen1>npts) then
        print*,'check nlen1 ',nlen1
        stop
    endif
    i_tstart1=max(floor(tstart1 / deltat), 1)
    i_tend1 = min(i_tstart1+nlen1-1, npts)
    nlen1=i_tend1-i_tstart1+1
    allocate(tas1(nlen1))
    call window_taper(nlen1,taper_percentage,taper_type,tas1)
    s1_tw(1:nlen1)=tas1(1:nlen1)*s1(i_tstart1:i_tend1)
    d1_tw(1:nlen1)=tas1(1:nlen1)*d1(i_tstart1:i_tend1)

    nlen2=floor((tend2-tstart2)/deltat)+1
    if(nlen2<1 .or. nlen2>npts) then
        print*,'check nlen2 ',nlen2
        stop
    endif
    i_tstart2=max(floor(tstart2 / deltat), 1)
    i_tend2 = min(i_tstart2+nlen2-1, npts)
    nlen2=i_tend2-i_tstart2+1
    allocate(tas2(nlen2))
    call window_taper(nlen2,taper_percentage,taper_type,tas2)
    s2_tw(1:nlen2)=tas2(1:nlen2)*s2(i_tstart2:i_tend2)
    d2_tw(1:nlen2)=tas2(1:nlen2)*d2(i_tstart2:i_tend2)

    nlen=max(nlen1,nlen2)

    !! DD cc-misfit
    call xcorr_calc(d1_tw,d2_tw,npts,1,nlen,ishift_obs,dlnA_obs,cc_max_obs) ! T(d1-d2)
    tshift_obs= ishift_obs*deltat
    call xcorr_calc(s1_tw,s2_tw,npts,1,nlen,ishift_syn,dlnA_syn,cc_max_syn) ! T(s1-s2)
    tshift_syn= ishift_syn*deltat
    !! double-difference cc-measurement 
    ddtshift_cc = tshift_syn - tshift_obs
    ddlnA_cc = dlnA_syn - dlnA_obs
    ! DD CC misfit
    const=1.0            
    err_DD_CC=1.0
    if(NORMALIZE) then                                
        const = abs(tshift_obs)
        err_DD_CC=err_DD_CC*const
    endif

    write(IOUT,*) ddtshift_cc/err_DD_CC
    num=1
    misfit=0.5*(ddtshift_cc/err_DD_CC)**2

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries for d1/s1: ',i_tstart1,i_tend1
        print*, 'time window length for d1/s1 : ', nlen1
        print*, 'time window boundaries for d2/s2: ',i_tstart2,i_tend2
        print*, 'time window length for d2/s2 : ', nlen2
        print*, 'cc ishift/tsfhit/dlnA (d1-d2): ', ishift_obs,tshift_obs,dlnA_obs
        print*, 'cc ishift/tshift/dlnA (s1-s2): ', ishift_syn,tshift_syn,dlnA_syn
        print*, 'cc double-difference ddtshift/ddlnA of (s1-s2)-(d1-d2): ', ddtshift_cc,ddlnA_cc
        print*, 'cc_max_obs, cc_max_syn : ',cc_max_obs, cc_max_syn 
        print*
        open(1,file=trim(output_dir)//'/dat_syn_win',status='unknown')
        open(2,file=trim(output_dir)//'/dat_syn_ref_win',status='unknown')
        do  i = 1,nlen1
        write(1,'(I5,2e15.5)') i, d1_tw(i),s1_tw(i)
        enddo
        do i =1,nlen2
        write(2,'(I5,2e15.5)') i, d2_tw(i),s2_tw(i)
        enddo
        close(1)
        close(2)
    endif

    !!DD cc-adjoint
    if(COMPUTE_ADJOINT) then
        ! initialization 
        adj1_tw(:) = 0.0
        adj2_tw(:) = 0.0
        adj1(1:npts) = 0.0 
        adj2(1:npts) = 0.0

        ! cc-shift s2
        call cc_window(s2_tw,npts,1,nlen,ishift_syn,0.0,s2_tw_cc)
        !call cc_window(s2,npts,i_tstart2,i_tend2,ishift_syn,0.0,s2_tw_cc)
        !s2_tw_cc(1:nlen)=tas2(1:nlen2)*s2_tw_cc(1:nlen2)

        ! inverse cc-shift s1
        call cc_window(s1_tw,npts,1,nlen,-ishift_syn,0.0,s1_tw_cc)
        !call cc_window(s1,npts,i_tstart1,i_tend1,-ishift_syn,0.0,s1_tw_cc)
        !s1_tw_cc(1:nlen)=tas1(1:nlen1)*s1_tw_cc(1:nlen1)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/syn1_cc',status='unknown')
            open(2,file=trim(output_dir)//'/syn2_cc',status='unknown')
            do  i = 1,nlen
            write(1,'(I5,3e15.5)') i,s2_tw(i),s1_tw(i),s1_tw_cc(i)
            write(2,'(I5,3e15.5)') i,s1_tw(i),s2_tw(i),s2_tw_cc(i)
            enddo
            close(1)
            close(2)
        endif

        ! computer velocity 
        call compute_vel(s1_tw,npts,deltat,nlen,s1_tw_vel)
        call compute_vel(s1_tw_cc,npts,deltat,nlen,s1_tw_cc_vel)
        call compute_vel(s2_tw_cc,npts,deltat,nlen,s2_tw_cc_vel)

        ! constant on the bottom 
        Mtr=-sum(s1_tw_vel(1:nlen)*s2_tw_cc_vel(1:nlen))*deltat

        ! adjoint source
        adj1_tw(1:nlen)= +ddtshift_cc * s2_tw_cc_vel(1:nlen)/Mtr/err_DD_CC**2
        adj2_tw(1:nlen)= -ddtshift_cc * s1_tw_cc_vel(1:nlen)/Mtr/err_DD_CC**2

        ! reverse window and taper again 
        adj1(i_tstart1:i_tend1)=tas1(1:nlen1)*adj1_tw(1:nlen1)
        adj2(i_tstart2:i_tend2)=tas2(1:nlen2)*adj2_tw(1:nlen2)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj1_CC_win',status='unknown')
            open(2,file=trim(output_dir)//'/adj2_CC_win',status='unknown')
            do  i =  i_tstart1,i_tend1
            write(1,*) i,adj1(i)
            enddo
            do  i =  i_tstart2,i_tend2
            write(2,*) i,adj2(i)
            enddo
            close(1)
            close(2)
        endif

    endif
    deallocate(tas1,tas2)

end subroutine CC_misfit_DD
!-----------------------------------------------------------------------
subroutine WD_misfit_DD(d1,d2,s1,s2,npts,deltat,&
        tstart1,tend1,tstart2,tend2,&
        taper_percentage,taper_type,&
        compute_adjoint,&
        adj1,adj2,num,misfit)
    !! WD double difference

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d1,d2,s1,s2
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart1,tend1,tstart2,tend2
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj1,adj2

    ! index
    integer :: i
    real(kind=CUSTOM_REAL) :: const, err_DD_WD

    ! window
    integer :: nlen1,nlen2,nlen
    integer :: i_tstart1,i_tend1,i_tstart2,i_tend2
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas1,tas2
    real(kind=CUSTOM_REAL), dimension(npts) :: d1_tw,d2_tw,s1_tw,s2_tw

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) :: adj1_tw,adj2_tw

    !! window
    nlen1=floor((tend1-tstart1)/deltat)+1
    if(nlen1<1 .or. nlen1>npts) then
        print*,'check nlen1 ',nlen1
        stop
    endif
    i_tstart1=max(floor(tstart1 / deltat), 1)
    i_tend1 = min(i_tstart1+nlen1-1, npts)
    nlen1=i_tend1-i_tstart1+1
    allocate(tas1(nlen1))
    call window_taper(nlen1,taper_percentage,taper_type,tas1)
    s1_tw(1:nlen1)=tas1(1:nlen1)*s1(i_tstart1:i_tend1)
    d1_tw(1:nlen1)=tas1(1:nlen1)*d1(i_tstart1:i_tend1)

    nlen2=floor((tend2-tstart2)/deltat)+1
    if(nlen2<1 .or. nlen2>npts) then
        print*,'check nlen2 ',nlen2
        stop
    endif
    i_tstart2=max(floor(tstart2 / deltat), 1)
    i_tend2 = min(i_tstart2+nlen2-1, npts)
    nlen2=i_tend2-i_tstart2+1
    allocate(tas2(nlen2))
    call window_taper(nlen2,taper_percentage,taper_type,tas2)
    s2_tw(1:nlen2)=tas2(1:nlen2)*s2(i_tstart2:i_tend2)
    d2_tw(1:nlen2)=tas2(1:nlen2)*d2(i_tstart2:i_tend2)

    nlen=max(nlen1,nlen2)

    ! DD WD misfit
    const=1.0            
    err_DD_WD=1.0
    if(NORMALIZE) then                                
        const = sqrt(sum((d1_tw(1:nlen)-d2_tw(1:nlen))**2)*deltat)
        err_DD_WD=err_DD_WD*const
    endif
    do i=1,nlen
    write(IOUT,*) ((s1_tw(i)-s2_tw(i)) - (d1_tw(i)-d2_tw(i)))*sqrt(deltat)/err_DD_WD
    enddo
    num=nlen
    misfit=0.5*sum(((s1_tw(1:nlen)-s2_tw(1:nlen)) - (d1_tw(1:nlen)-d2_tw(1:nlen)))**2*deltat)/err_DD_WD**2

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries for d1/s1: ',i_tstart1,i_tend1
        print*, 'time window length for d1/s1 : ', nlen1
        print*, 'time window boundaries for d2/s2: ',i_tstart2,i_tend2
        print*, 'time window length for d2/s2 : ', nlen2
    endif

    !!DD WD adjoint
    if(COMPUTE_ADJOINT) then
        ! initialization 
        adj1_tw(:) = 0.0
        adj2_tw(:) = 0.0
        adj1(1:npts) = 0.0
        adj2(1:npts) = 0.0

        ! adjoint source
        adj1_tw(1:nlen)= ( (s1_tw(1:nlen)-s2_tw(1:nlen)) -(d1_tw(1:nlen)-d2_tw(1:nlen)) )/err_DD_WD**2
        adj2_tw(1:nlen)=  - adj1_tw(1:nlen)

        ! reverse window and taper again 
        adj1(i_tstart1:i_tend1)=tas1(1:nlen1)*adj1_tw(1:nlen1)
        adj2(i_tstart2:i_tend2)=tas2(1:nlen2)*adj2_tw(1:nlen2)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj1_WD_win',status='unknown')
            open(2,file=trim(output_dir)//'/adj2_WD_win',status='unknown')
            do  i =  i_tstart1,i_tend1
            write(1,*) i,adj1(i)
            enddo
            do  i =  i_tstart2,i_tend2
            write(2,*) i,adj2(i)
            enddo
            close(1)
            close(2)
        endif

    endif
    deallocate(tas1,tas2)

end subroutine WD_misfit_DD
!----------------------------------------------------------------------
subroutine EP_misfit_DD(d1,d2,s1,s2,npts,deltat,&
        tstart1,tend1,tstart2,tend2,&
        taper_percentage,taper_type,&
        compute_adjoint,&
        adj1,adj2,num,misfit)
    !! exponentiated phase double-difference

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d1,d2,s1,s2
    real(kind=CUSTOM_REAL), intent(in) :: deltat
    real(kind=CUSTOM_REAL), intent(in) :: tstart1,tend1,tstart2,tend2
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj1,adj2

    ! index
    integer :: i
    real(kind=CUSTOM_REAL) :: const, err_DD_EP

    ! window
    integer :: nlen1,nlen2,nlen
    integer :: i_tstart1,i_tend1,i_tstart2,i_tend2
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas1,tas2
    real(kind=CUSTOM_REAL), dimension(npts) :: d1_tw,d2_tw,s1_tw,s2_tw

    ! adjoint
    real(kind=CUSTOM_REAL), dimension(npts) :: adj1_tw,adj2_tw

    ! for hilbert transformation
    real(kind=CUSTOM_REAL) :: wtr_d1, wtr_s1, wtr_d2, wtr_s2
    real(kind=CUSTOM_REAL), dimension(npts) :: E_d1,E_s1,E_d2,E_s2
    real(kind=CUSTOM_REAL), dimension(npts) :: E_ratio,hilbt_ratio
    real(kind=CUSTOM_REAL), dimension(npts) :: hilbt_d1, hilbt_s1,hilbt_d2, hilbt_s2
    real(kind=CUSTOM_REAL), dimension(npts) :: real_ddiff, imag_ddiff

    !! window
    nlen1=floor((tend1-tstart1)/deltat)+1
    if(nlen1<1 .or. nlen1>npts) then
        print*,'check nlen1 ',nlen1
        stop
    endif
    i_tstart1=max(floor(tstart1 / deltat), 1)
    i_tend1 = min(i_tstart1+nlen1-1, npts)
    nlen1=i_tend1-i_tstart1+1
    allocate(tas1(nlen1))
    call window_taper(nlen1,taper_percentage,taper_type,tas1)
    s1_tw(1:nlen1)=tas1(1:nlen1)*s1(i_tstart1:i_tend1)
    d1_tw(1:nlen1)=tas1(1:nlen1)*d1(i_tstart1:i_tend1)

    nlen2=floor((tend2-tstart2)/deltat)+1
    if(nlen2<1 .or. nlen2>npts) then
        print*,'check nlen2 ',nlen2
        stop
    endif
    i_tstart2=max(floor(tstart2 / deltat), 1)
    i_tend2 = min(i_tstart2+nlen2-1, npts)
    nlen2=i_tend2-i_tstart2+1
    allocate(tas2(nlen2))
    call window_taper(nlen2,taper_percentage,taper_type,tas2)
    s2_tw(1:nlen2)=tas2(1:nlen2)*s2(i_tstart2:i_tend2)
    d2_tw(1:nlen2)=tas2(1:nlen2)*d2(i_tstart2:i_tend2)

    nlen=max(nlen1,nlen2)

    ! initialization 
    real_ddiff(:) = 0.0
    imag_ddiff(:) = 0.0
    E_d1(:) = 0.0
    E_s1(:) = 0.0
    E_d2(:) = 0.0
    E_s2(:) = 0.0
    hilbt_d1(:)=0.0
    hilbt_s1(:)=0.0
    hilbt_d2(:)=0.0
    hilbt_s2(:)=0.0

    !! hilbert for obs1
    hilbt_d1(1:nlen)=d1_tw(1:nlen)
    call hilbert(hilbt_d1,nlen)
    E_d1(1:nlen)=sqrt(hilbt_d1(1:nlen)**2+d1_tw(1:nlen)**2)

    !! hilbert for syn1
    hilbt_s1(1:nlen)=s1_tw(1:nlen)
    call hilbert(hilbt_s1,nlen)
    E_s1(1:nlen)=sqrt(hilbt_s1(1:nlen)**2+s1_tw(1:nlen)**2)

    !! hilbert for obs2
    hilbt_d2(1:nlen)=d2_tw(1:nlen)
    call hilbert(hilbt_d2,nlen)
    E_d2(1:nlen)=sqrt(hilbt_d2(1:nlen)**2+d2_tw(1:nlen)**2)

    !! hilbert for syn2
    hilbt_s2(1:nlen)=s2_tw(1:nlen)
    call hilbert(hilbt_s2,nlen)
    E_s2(1:nlen)=sqrt(hilbt_s2(1:nlen)**2+s2_tw(1:nlen)**2)

    !! removing amplitude info 
    wtr_d1=wtr_env*maxval(E_d1)
    wtr_s1=wtr_env*maxval(E_s1)
    wtr_d2=wtr_env*maxval(E_d2)
    wtr_s2=wtr_env*maxval(E_s2)


    !! double diff for real & imag part
    real_ddiff(1:nlen) = (s1_tw(1:nlen)/(E_s1(1:nlen)+wtr_s1) - s2_tw(1:nlen)/(E_s2(1:nlen)+wtr_s2)) &
        - (d1_tw(1:nlen)/(E_d1(1:nlen)+wtr_d1) - d2_tw(1:nlen)/(E_d2(1:nlen)+wtr_d2)) 
    imag_ddiff(1:nlen) = (hilbt_s1(1:nlen)/(E_s1(1:nlen)+wtr_s1) - hilbt_s2(1:nlen)/(E_s2(1:nlen)+wtr_s2)) &
        - (hilbt_d1(1:nlen)/(E_d1(1:nlen)+wtr_d1) - hilbt_d2(1:nlen)/(E_d2(1:nlen)+wtr_d2))
    ! DD EP misfit
    const=1.0
    err_DD_EP=1.0
    if(NORMALIZE) then
        const = sqrt(sum((d1_tw(1:nlen)/(E_d1(1:nlen)+wtr_d1) & 
            - d2_tw(1:nlen)/(E_d2(1:nlen)+wtr_d2))**2)*deltat + &
            sum((hilbt_d1(1:nlen)/(E_d1(1:nlen)+wtr_d1) &
            - hilbt_d2(1:nlen)/(E_d2(1:nlen)+wtr_d2))**2)*deltat)
        err_DD_EP=err_DD_EP*const
    endif
    do i=1,nlen
    write(IOUT,*) real_ddiff(i)*sqrt(deltat)/err_DD_EP
    write(IOUT,*) imag_ddiff(i)*sqrt(deltat)/err_DD_EP
    enddo
    num=nlen
    misfit=0.5*sum(real_ddiff(1:nlen)**2*deltat)/err_DD_EP**2 + &
        0.5*sum(imag_ddiff(1:nlen)**2*deltat)/err_DD_EP**2

    !! DD exponentiated phase adjoint
    if(COMPUTE_ADJOINT) then
        ! initialization 
        adj1_tw(:) = 0.0
        adj2_tw(:) = 0.0
        adj1(1:npts) = 0.0
        adj2(1:npts) = 0.0
        !! adjoint source1
        E_ratio(:) = 0.0
        hilbt_ratio (:) = 0.0
        E_ratio = (real_ddiff * hilbt_s1**2 - imag_ddiff*s1_tw*hilbt_s1)/(E_s1+wtr_s1)**3
        hilbt_ratio = (real_ddiff*s1_tw*hilbt_s1-imag_ddiff*s1_tw**2)/(E_s1+wtr_s1)**3
        ! hilbert transform for hilbt_ratio
        call hilbert(hilbt_ratio,nlen)
        ! adjoint source
        adj1_tw(1:nlen)=E_ratio(1:nlen) + hilbt_ratio(1:nlen)
        adj1_tw(1:nlen)=adj1_tw(1:nlen)/err_DD_EP**2

        !! adjoint source2
        E_ratio(:) = 0.0
        hilbt_ratio (:) = 0.0
        E_ratio = -(real_ddiff * hilbt_s2**2 - imag_ddiff*s2_tw*hilbt_s2)/(E_s2+wtr_s2)**3
        hilbt_ratio = -(real_ddiff*s2_tw*hilbt_s2-imag_ddiff*s2_tw**2)/(E_s2+wtr_s2)**3
        ! hilbert transform for hilbt_ratio
        call hilbert(hilbt_ratio,nlen)
        ! adjoint source
        adj2_tw(1:nlen)=E_ratio(1:nlen) + hilbt_ratio(1:nlen)
        adj2_tw(1:nlen)=adj2_tw(1:nlen)/err_DD_EP**2

        ! reverse window and taper again 
        adj1(i_tstart1:i_tend1)=tas1(1:nlen1)*adj1_tw(1:nlen1)
        adj2(i_tstart2:i_tend2)=tas2(1:nlen2)*adj2_tw(1:nlen2)

        if( DISPLAY_DETAILS) then
            open(1,file=trim(output_dir)//'/adj1_EP_win',status='unknown')
            open(2,file=trim(output_dir)//'/adj2_EP_win',status='unknown')
            do  i =  i_tstart1,i_tend1
            write(1,*) i,adj1(i)
            enddo
            do  i =  i_tstart2,i_tend2
            write(2,*) i,adj2(i)
            enddo
            close(1)
            close(2)
        endif

    endif
    deallocate(tas1,tas2)

end subroutine EP_misfit_DD
!----------------------------------------------------------------------
subroutine MT_misfit_DD(d1,d2,s1,s2,npts,deltat,f0,&
        tstart1,tend1,tstart2,tend2,&
        taper_percentage,taper_type,&
        misfit_type,compute_adjoint,&
        adj1,adj2,num,misfit)
    !! multitaper double-difference adjoint 

    use constants
    implicit none

    ! inputs & outputs 
    real(kind=CUSTOM_REAL), dimension(*), intent(in) :: d1,d2,s1,s2
    real(kind=CUSTOM_REAL), intent(in) :: deltat,f0
    real(kind=CUSTOM_REAL), intent(in) :: tstart1,tend1,tstart2,tend2
    real(kind=CUSTOM_REAL), intent(in) :: taper_percentage
    character(len=4), intent(in) :: taper_type
    integer, intent(in) :: npts
    character(len=2), intent(in) :: misfit_type
    logical, intent(in) :: compute_adjoint
    integer, intent(out) :: num
    real(kind=CUSTOM_REAL), intent(out),optional :: misfit
    real(kind=CUSTOM_REAL), dimension(*),intent(out),optional :: adj1,adj2

    ! index
    integer :: i,j

    ! window
    integer :: nlen1,nlen2,nlen, nlen_d
    integer :: i_tstart1,i_tend1,i_tstart2,i_tend2
    integer :: i_tstart_d,i_tend_d
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: tas1,tas2
    real(kind=CUSTOM_REAL), dimension(npts) :: d1_tw,d2_tw,s1_tw,s2_tw
    ! cc
    real(kind=CUSTOM_REAL) :: cc_max_syn,cc_max_obs 
    integer :: ishift_obs,ishift_syn
    real(kind=CUSTOM_REAL) :: tshift_obs,tshift_syn
    real(kind=CUSTOM_REAL) :: dlnA_obs,dlnA_syn
    real(kind=CUSTOM_REAL) :: ddtshift_cc,ddlnA_cc
    real(kind=CUSTOM_REAL) :: err_dt_cc_obs=1.0,err_dt_cc_syn=1.0
    real(kind=CUSTOM_REAL) :: err_dlnA_cc_obs=1.0,err_dlnA_cc_syn=1.0
    real(kind=CUSTOM_REAL), dimension(npts) :: d2_tw_cc,s2_tw_cc
    real(kind=CUSTOM_REAL), dimension(npts) :: d1_tw_cc,s1_tw_cc

    ! FFT parameters
    real(kind=CUSTOM_REAL), dimension(NPT) :: wvec,fvec
    real(kind=CUSTOM_REAL) :: df,df_new,dw

    !! multitaper
    logical :: is_mtm
    integer :: i_fstart1, i_fend1,i_fstart2, i_fend2,i_fstart, i_fend
    real(kind=SIZE_DOUBLE), dimension(NPT) :: ey1,ey2
    integer :: ictaper
    real(kind=CUSTOM_REAL), dimension(NPT) :: dtau_w_obs,dtau_w_syn
    real(kind=CUSTOM_REAL), dimension(NPT) :: dlnA_w_obs, dlnA_w_syn
    real(kind=CUSTOM_REAL), dimension(NPT) :: ddtau_w, ddlnA_w
    real(kind=CUSTOM_REAL), dimension(NPT) :: err_dtau_mt_obs,err_dtau_mt_syn
    real(kind=CUSTOM_REAL), dimension(NPT) :: err_dlnA_mt_obs, err_dlnA_mt_syn
    complex*16, dimension(NPT) :: trans_func_obs,trans_func_syn

    ! misfit & adjoint
    real(kind=CUSTOM_REAL) :: misfit_p, misfit_q
    real(kind=CUSTOM_REAL), dimension(npts) :: fp1_tw,fp2_tw,fq1_tw,fq2_tw

    is_mtm = .true.
    !! window
    nlen1=floor((tend1-tstart1)/deltat)+1
    if(nlen1<=1 .or. nlen1>npts) then
        print*,'check nlen1 ',nlen1
        stop
    endif
    i_tstart1=max(floor(tstart1 / deltat), 1)
    i_tend1 = min(i_tstart1+nlen1-1, npts)
    nlen1=i_tend1-i_tstart1+1
    allocate(tas1(nlen1))
    call window_taper(nlen1,taper_percentage,taper_type,tas1)
    s1_tw(1:nlen1)=tas1(1:nlen1)*s1(i_tstart1:i_tend1)
    d1_tw(1:nlen1)=tas1(1:nlen1)*d1(i_tstart1:i_tend1)

    nlen2=floor((tend2-tstart2)/deltat)+1
    if(nlen2<=1 .or. nlen2>npts) then
        print*,'check nlen2 ',nlen2
        stop
    endif
    i_tstart2=max(floor(tstart2 / deltat), 1)
    i_tend2 = min(i_tstart2+nlen2-1, npts)
    nlen2=i_tend2-i_tstart2+1
    allocate(tas2(nlen2))
    call window_taper(nlen2,taper_percentage,taper_type,tas2)
    s2_tw(1:nlen2)=tas2(1:nlen2)*s2(i_tstart2:i_tend2)
    d2_tw(1:nlen2)=tas2(1:nlen2)*d2(i_tstart2:i_tend2)

    nlen=max(nlen1,nlen2)

    !! cc correction
    call xcorr_calc(d1_tw,d2_tw,npts,1,nlen,ishift_obs,dlnA_obs,cc_max_obs)
    tshift_obs= ishift_obs*deltat 
    call xcorr_calc(s1_tw,s2_tw,npts,1,nlen,ishift_syn,dlnA_syn,cc_max_syn) 
    tshift_syn= ishift_syn*deltat
    !! double-difference cc-measurement 
    ddtshift_cc = tshift_syn - tshift_obs
    ddlnA_cc = dlnA_syn - dlnA_obs

    ! cc error 
    err_dt_cc_obs=1.0            
    err_dlnA_cc_obs=1.0
    err_dt_cc_syn=1.0
    err_dlnA_cc_syn=1.0
    if(USE_ERROR_CC) then
        call cc_error(d1_tw,d2_tw,npts,deltat,nlen,ishift_obs,dlnA_obs,err_dt_cc_obs,err_dlnA_cc_obs)
        call cc_error(s1_tw,s2_tw,npts,deltat,nlen,ishift_syn,dlnA_syn,err_dt_cc_syn,err_dlnA_cc_syn)
    endif

    ! correction for d1 to align with d2
    i_tstart_d = max(i_tstart1+ishift_obs, 1)
    i_tend_d = min(i_tend1+ishift_obs, npts)
    nlen_d = i_tend_d - i_tstart_d + 1
    if(nlen_d == nlen1) then
        d1_tw_cc(1:nlen1)=tas1(1:nlen1)*d1(i_tstart_d:i_tend_d)*exp(-dlnA_obs)
    else
        d1_tw_cc=d1_tw
        tshift_obs=0.0
        dlnA_obs=0.0
    endif

    ! correction for s1 to align with s2
    i_tstart_d = max(i_tstart1+ishift_syn, 1)
    i_tend_d = min(i_tend1+ishift_syn, npts)
    nlen_d = i_tend_d - i_tstart_d + 1
    if(nlen_d == nlen1) then
        s1_tw_cc(1:nlen1)=tas1(1:nlen1)*s1(i_tstart_d:i_tend_d)*exp(-dlnA_syn)
    else
        s1_tw_cc=s1_tw
        tshift_syn=0.0
        dlnA_syn=0.0
    endif

    if( DISPLAY_DETAILS) then
        print*
        print*, 'time-domain winodw'
        print*, 'time window boundaries for d1/s1: ',i_tstart1,i_tend1
        print*, 'time window length for d1/s1 : ', nlen1
        print*, 'time window boundaries for d2/s2: ',i_tstart2,i_tend2
        print*, 'time window length for d2/s2 : ', nlen2
        print*, 'combined window length nlen = ',nlen
        print*, 'cc ishift/tshift/dlnA of (d1-d2): ', ishift_obs,tshift_obs,dlnA_obs
        print*, 'cc ishift/tshift/dlnA of (s1-s2): ', ishift_syn,tshift_syn,dlnA_syn
        print*, 'cc double-difference ddtshift/ddlnA of (s1-s2)-(d1-d2): ' &
            ,ddtshift_cc, ddlnA_cc
        print* 
        open(1,file=trim(output_dir)//'/dat_datcc',status='unknown')
        open(2,file=trim(output_dir)//'/syn_syncc',status='unknown')
        do  i = 1,nlen
        write(1,'(I5,3e15.5)') i, d1_tw(i),d2_tw(i),d1_tw_cc(i)
        write(2,'(I5,3e15.5)') i, s1_tw(i),s2_tw(i),s1_tw_cc(i)
        enddo
        close(1)
        close(2)
    endif

    ! update
    d1_tw = d1_tw_cc
    s1_tw = s1_tw_cc
    i_tstart1 = i_tstart_d
    i_tend1 = i_tend_d

    !! DD multitaper-misfit
    !-----------------------------------------------------------------------------
    !  set up FFT for the frequency domain
    !----------------------------------------------------------------------------- 
    df = 1./(NPT*deltat)
    dw = TWOPI * df
    ! calculate frequency spacing of sampling points
    df_new = 1.0 / (nlen*deltat)
    ! assemble omega vector (NPT is the FFT length)
    wvec(:) = 0.
    do j = 1,NPT
    if(j > NPT/2+1) then
        wvec(j) = dw*(j-NPT-1)   ! negative frequencies in second half
    else
        wvec(j) = dw*(j-1)       ! positive frequencies in first half
    endif
    enddo
    fvec = wvec / TWOPI

    !!   find the relaible frequency limit
    call frequency_limit(s1_tw,nlen,deltat,f0/2.5,f0*2.5,i_fstart1,i_fend1)
    call frequency_limit(s2_tw,nlen,deltat,f0/2.5,f0*2.5,i_fstart2,i_fend2)
    i_fend = min(i_fend1,i_fend2)
    i_fstart = max(i_fstart1,i_fstart2)
    if(i_fstart>=i_fend)  is_mtm = .false.

    if( DISPLAY_DETAILS) then
        print*,  'NPT/df/dw/df_new :', NPT,df,dw,df_new  
        print*
        print*, 'find the spectral boundaries for reliable measurement'
        print*, 'min, max frequency limit for 1 : ',i_fstart1,i_fend1,fvec(i_fstart1),fvec(i_fend1)
        print*, 'min, max frequency limit for 2 : ',i_fstart2,i_fend2,fvec(i_fstart2),fvec(i_fend2)
        print*, 'effective bandwidth (Hz) : ',i_fstart,i_fend,fvec(i_fend)-fvec(i_fstart)
        print*, 'half time-bandwidth product : ', NW
        print*, 'number of tapers : ',ntaper
        print*, 'resolution of multitaper (Hz) : ', NW/(nlen*deltat)
        print*, 'number of segments of frequency bandwidth : ', ceiling((fvec(i_fend)-fvec(i_fstart))/(NW/(nlen*deltat)))
        print*, 'is_mtm : ', is_mtm
    endif

    !!  MT_DD measurement
    if(is_mtm) then  
        ! calculate the tapers
        allocate(tapers(NPT,ntaper))
        call staper(nlen, dble(NW), ntaper, tapers, NPT, ey1, ey2)

        if( DISPLAY_DETAILS) then
            do ictaper=1,ntaper
            write(filename,'(i1)') ictaper
            open(1,file=trim(output_dir)//'/'//'taper_t_'//trim(adjustl(filename)),status='unknown')
            do i = 1,nlen
            write(1,'(f15.2,E15.5)') (i-1)*deltat,tapers(i,ictaper)
            ! write(1,'(f15.2,<ntaper>e15.5)') (i-1)*deltat,tapers(i,1:ntaper)
            enddo
            close(1)
            enddo
        endif

        !! mt phase and ampplitude measurement 
        call mt_measure(d1_tw,d2_tw,npts,deltat,nlen,tshift_obs,dlnA_obs,i_fstart,i_fend,&
            wvec,&
            trans_func_obs,dtau_w_obs,dlnA_w_obs,err_dtau_mt_obs,err_dlnA_mt_obs)
        call mt_measure(s1_tw,s2_tw,npts,deltat,nlen,tshift_syn,dlnA_syn,i_fstart,i_fend,&
            wvec,&
            trans_func_syn,dtau_w_syn,dlnA_w_syn,err_dtau_mt_syn,err_dlnA_mt_syn)
        ! double-difference measurement 
        ddtau_w = dtau_w_syn-dtau_w_obs
        ddlnA_w = dlnA_w_syn-dlnA_w_obs

        ! misfit & adj
        call mt_adj_DD(s1_tw,s2_tw, NPTS,deltat,nlen,df,i_fstart,i_fend,ddtau_w,ddlnA_w,&
            err_dt_cc_obs,err_dt_cc_syn,err_dlnA_cc_obs,err_dlnA_cc_syn, &
            err_dtau_mt_obs,err_dtau_mt_syn,err_dlnA_mt_obs,err_dlnA_mt_syn, &
            compute_adjoint,&        
            fp1_tw,fp2_tw,fq1_tw,fq2_tw,misfit_p,misfit_q)

        ! MT misfit
        if(misfit_type=='MT') then
            ! MT misfit
            do i=i_fstart,i_fend
            write(IOUT,*) ddtau_w(i)*sqrt(dw)
            enddo
            misfit=misfit_p
        elseif(misfit_type=='MA') then
            ! MA misfit
            do i=i_fstart,i_fend
            write(IOUT,*) ddlnA_w(i)*sqrt(dw)
            enddo
            misfit=misfit_q
        endif
        num=i_fend-i_fstart+1

        if(DISPLAY_DETAILS) then
            !! write into file 
            open(1,file=trim(output_dir)//'/trans_func_obs',status='unknown')
            open(2,file=trim(output_dir)//'/trans_func_syn',status='unknown')
            open(3,file=trim(output_dir)//'/data_dtau',status='unknown')
            open(4,file=trim(output_dir)//'/syn_dtau',status='unknown')
            open(5,file=trim(output_dir)//'/ddtau_mtm',status='unknown')
            open(6,file=trim(output_dir)//'/ddlnA_mtm',status='unknown')
            open(7,file=trim(output_dir)//'/err_dtau_dlnA_mtm',status='unknown')
            do  i = i_fstart,i_fend
            write(1,'(f15.5,e15.5)') fvec(i),abs(trans_func_obs(i))
            write(2,'(f15.5,e15.5)') fvec(i),abs(trans_func_syn(i))
            write(3,'(f15.5,e15.5)') fvec(i),dtau_w_obs(i)
            write(4,'(f15.5,e15.5)') fvec(i),dtau_w_syn(i)
            write(5,'(f15.5,2e15.5)') fvec(i),ddtau_w(i),ddtshift_cc
            write(6,'(f15.5,2e15.5)') fvec(i),ddlnA_w(i),ddlnA_cc
            write(7,'(f15.5,2e15.5)') fvec(i),err_dtau_mt_obs(i)*err_dtau_mt_syn(i), &
                err_dlnA_mt_obs(i)*err_dlnA_mt_syn(i)
            enddo
            close(1)
            close(2)
            close(3)
            close(4)
            close(5)
            close(6)
            close(7)
        endif

        !!DD cc-adjoint
        if(COMPUTE_ADJOINT) then
            ! initialization 
            adj1(1:npts) = 0.0
            adj2(1:npts) = 0.0

            ! adjoint source
            fp1_tw(1:nlen)= fp1_tw(1:nlen) * cc_max_obs *cc_max_obs
            fp2_tw(1:nlen)= fp2_tw(1:nlen) * cc_max_obs *cc_max_obs
            fq1_tw(1:nlen)= fq1_tw(1:nlen) * cc_max_obs *cc_max_obs
            fq2_tw(1:nlen)= fq2_tw(1:nlen) * cc_max_obs *cc_max_obs

            ! reverse window and taper again 
            if(misfit_type=='MT') then
                ! reverse window and taper again
                adj1(i_tstart1:i_tend1)=tas1(1:nlen1)*fp1_tw(1:nlen1)
                adj2(i_tstart2:i_tend2)=tas2(1:nlen2)*fp2_tw(1:nlen2)

            elseif(misfit_type=='MA') then
                ! reverse window and taper again 
                adj1(i_tstart1:i_tend1)=tas1(1:nlen1)*fq1_tw(1:nlen1)
                adj2(i_tstart2:i_tend2)=tas2(1:nlen2)*fq2_tw(1:nlen2)
            endif

            if( DISPLAY_DETAILS) then
                open(1,file=trim(output_dir)//'/adj1_MT_win',status='unknown')
                open(2,file=trim(output_dir)//'/adj2_MT_win',status='unknown')
                do  i =  i_tstart1,i_tend1
                write(1,*) i,adj1(i)
                enddo
                do  i =  i_tstart2,i_tend2
                write(2,*) i,adj2(i)
                enddo
                close(1)
                close(2)
            endif

        endif ! compute_adjoint
        deallocate(tapers)

    else ! DD CC adj
        print*, '*** Double-difference CC (traveltime) misfit'
        call CC_misfit_DD(d1,d2,s1,s2,npts,deltat,&
            tstart1,tend1,tstart2,tend2,&
            taper_percentage,taper_type,&
            compute_adjoint,&
            adj1,adj2,num,misfit)
    endif

    deallocate(tas1,tas2)
end subroutine MT_misfit_DD
!-----------------------------------------------------------------------
