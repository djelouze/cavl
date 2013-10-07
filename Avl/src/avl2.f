C***********************************************************************
C    Module:  avl.f
C 
C    Copyright (C) 2002 Mark Drela, Harold Youngren
C 
C    This program is free software; you can redistribute it and/or modify
C    it under the terms of the GNU General Public License as published by
C    the Free Software Foundation; either version 2 of the License, or
C    (at your option) any later version.
C
C    This program is distributed in the hope that it will be useful,
C    but WITHOUT ANY WARRANTY; without even the implied warranty of
C    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C    GNU General Public License for more details.
C
C    You should have received a copy of the GNU General Public License
C    along with this program; if not, write to the Free Software
C    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
C***********************************************************************

 
      SUBROUTINE PLINIT
C---- Initialize plotting variables
C
      INCLUDE 'AVL.INC'
      INCLUDE 'AVLPLT.INC'
C
      REAL ORG(3)
C
C---- Plotting flag
      IDEV = 1   ! X11 window only
c     IDEV = 2   ! B&W PostScript output file only (no color)
c     IDEV = 3   ! both X11 and B&W PostScript file
c     IDEV = 4   ! Color PostScript output file only 
c     IDEV = 5   ! both X11 and Color PostScript file 
C
C---- Re-plotting flag (for hardcopy)
      IDEVH = 2    ! B&W PostScript
ccc   IDEVH = 4    ! Color PostScript
C
C---- PostScript output logical unit and file specification
ccc   IPSLU = -1  ! output to files plotNNN.ps on LU 80, with NNN = 001, 002, ...
      IPSLU = 0   ! output to file  plot.ps    on LU 80   (default case)
ccc   IPSLU = nnn ! output to file  plotNNN.ps on LU NNN
C
C---- screen fraction taken up by plot window upon opening
      SCRNFRAC = 0.70    ! Landscape
C     SCRNFRAC = -0.85   ! Portrait  specified if < 0
C
C---- Default plot size in inches
C-    (Default plot window is 11.0 x 8.5)
      SIZE = 9.0
C
C---- plot aspect ratio
      PLOTAR = 0.75
C
C---- character width/SIZE
      CH = 0.017
C
      CALL PLINITIALIZE
C
      NCOLORS = 0
C---- set up color spectrum
ccc      NCOLORS = 32
ccc      CALL COLORSPECTRUMHUES(NCOLORS,'RYGCBM')
C
C---- plot-window dimensions in inches for plot blowup calculations
C-    currently,  11.0 x 8.5  default window is hard-wired in libPlt
      XPAGE = 11.0
      YPAGE = 8.5
C
      XWIND = 11.0
      YWIND = 8.5
C
C---- page margins in inches
      XMARG = 0.0
      YMARG = 0.0
C
C---- bottom,left plot margin from edge
      PMARG = 0.15
C
      IF(IDEV.EQ.0) THEN 
        LPLOT = .FALSE.
      ENDIF
C

C---- set colors for run cases
      DO IR = 1, NRMAX
        IRCOLOR(IR) = MOD(IR-1,8) + 3
      ENDDO
C
C---- set vectors for little axes
      SLEN = 0.5
      HLEN = 0.5
C
      RHEAD = HLEN * 0.25
      NHEAD = NHAXIS
C
      ORG(1) = 0.
      ORG(2) = 0.
      ORG(3) = 0.
      DO IAX = 1, 3
        UAXDIR(1,IAX) = 0.
        UAXDIR(2,IAX) = 0.
        UAXDIR(3,IAX) = 0.
        UAXDIR(IAX,IAX) = 1.0
        CALL ARWSET(ORG,UAXDIR(1,IAX),SLEN,HLEN,RHEAD,NHEAD,
     &                  UAXARW(1,1,1,IAX),NLINAX)
      ENDDO
C
      RETURN
      END ! PLINIT



      SUBROUTINE PLPARS
      INCLUDE 'AVL.INC'
      INCLUDE 'AVLPLT.INC'
C
      IMARKSURF = 0
      DO N = 1, NSURF
        LPLTSURF(N) = .TRUE. 
      END DO
      DO N = 1, NBODY
        LPLTBODY(N) = .TRUE. 
      END DO
C
C---- Scaling factors for velocity and pressure
      CPFAC = MIN(0.4*CREF,0.1*BREF)  / CREF
      ENFAC = MIN(0.3*CREF,0.06*BREF) / CREF
      HNFAC = MIN(CREF,0.5*BREF)      / CREF
C
C---- initialize observer position angles and perspective 1/distance
      AZIMOB = -45.0
      ELEVOB =  20.0
      TILTOB =   0.
      ROBINV = 0.
C
C---- slo-mo factor
      SLOMOF = 1.0
C
C---- eigenmode animation integration time step
      DTIMED = 0.025
C
C---- movie-dump frame time step
      DTMOVIE = 0.05
C
C---- max length of movie
      TMOVIE = 10.0
C
C...Flags 
      LABEL_BODY = .FALSE.
      LABEL_SURF = .FALSE.
      LABEL_STRP = .FALSE.
      LABEL_VRTX = .FALSE.
      LWAKEPLT   = .FALSE.
      LHINGEPLT  = .FALSE.
      LLOADPLT   = .FALSE.
      LCNTLPTS   = .FALSE.
      LNRMLPLT   = .FALSE.
      LAXESPLT   = .TRUE.
      LRREFPLT   = .TRUE.
      LCLPERPLT  = .TRUE.
      LDWASHPLT  = .TRUE.
      LLABSURF   = .FALSE.
      LCAMBER    = .FALSE.
      LCHORDLINE = .TRUE.
      LBOUNDLEG  = .TRUE.
C
C---- Initially assume nothing hidden
      LHID = .TRUE.
C
C---- Initially assume no reverse color output
      LCREV = .FALSE.
C
C---- flags to plot parameter values above eigenmode map
      DO IP = 1, IPTOT
        LPPAR(IP) = .FALSE.
      ENDDO

      LPPAR(IPALFA) = .TRUE.
      LPPAR(IPBETA) = .TRUE.
c      LPPAR(IPROTX) = .TRUE.
c      LPPAR(IPROTY) = .TRUE.
c      LPPAR(IPROTZ) = .TRUE.
      LPPAR(IPCL  ) = .TRUE.
      LPPAR(IPCD0 ) = .TRUE.

      LPPAR(IPPHI ) = .TRUE.
c      LPPAR(IPTHE ) = .TRUE.
c      LPPAR(IPPSI ) = .TRUE.

c      LPPAR(IPMACH) = .TRUE.
      LPPAR(IPVEE ) = .TRUE.
      LPPAR(IPRHO ) = .TRUE.
c      LPPAR(IPGEE ) = .TRUE.

      LPPAR(IPRAD ) = .TRUE.
c      LPPAR(IPFAC ) = .TRUE.

      LPPAR(IPXCG ) = .TRUE.
c      LPPAR(IPYCG ) = .TRUE.
      LPPAR(IPZCG ) = .TRUE.

      LPPAR(IPMASS) = .TRUE.
c      LPPAR(IPIXX ) = .TRUE.
c      LPPAR(IPIYY ) = .TRUE.
c      LPPAR(IPIZZ ) = .TRUE.
c      LPPAR(IPIXY ) = .TRUE.
c      LPPAR(IPIYZ ) = .TRUE.
c      LPPAR(IPIZX ) = .TRUE.

c      LPPAR(IPCLA ) = .TRUE.
c      LPPAR(IPCLU ) = .TRUE.
c      LPPAR(IPCMA ) = .TRUE.
c      LPPAR(IPCMU ) = .TRUE.

      RETURN
      END ! PLPARS



      SUBROUTINE DEFINI
      INCLUDE 'AVL.INC'
C
C---- flag for forces in standard NASA stability axes (as in Etkin)
      LNASA_SA  = .TRUE.
C
C---- flag for rotations defined in stability axes or body axes
      LSA_RATES = .TRUE.
C
      LPTOT   = .TRUE.
      LPSURF  = .FALSE.
      LPSTRP  = .FALSE.
      LPELE   = .FALSE.
      LPHINGE = .FALSE.
      LPDERIV = .FALSE.
C
      LGEO  = .FALSE.
      LENC  = .FALSE.
C
      LAIC  = .FALSE.
      LSRD  = .FALSE.
      LVEL  = .FALSE.
      LSOL  = .FALSE.
      LSEN  = .FALSE.
C
      LVISC    = .TRUE.
      LBFORCE  = .TRUE.
      LTRFORCE = .TRUE.
C
      LMWAIT = .FALSE.
C
      MATSYM = 0
      NITMAX = 20
C
      SAXFR = 0.25  ! x/c location of spanwise axis for Vperp definition
C
      VRCORE = 0.25   ! vortex core radius / vortex span
      SRCORE = 0.75   ! source core radius / body radius
C
C---- dafault basic units
      UNITL = 1.
      UNITM = 1.
      UNITT = 1.
      UNCHL = 'Lunit'
      UNCHM = 'Munit'
      UNCHT = 'Tunit'
      NUL = 5
      NUM = 5
      NUT = 5
C
C---- set corresponding derived units
      CALL UNITSET
C
C---- default air density and grav. accel.
      RHO0 = 1.0
      GEE0 = 1.0
C
C---- no eigenvalue reference data yet
      FEVDEF = ' '
      DO IR = 1, NRMAX
        NEIGENDAT(IR) = 0
      ENDDO
C
C---- no run cases defined yet
      NRUN = 0
      IRUN = 1
C
C---- number of valid time levels stored
      NTLEV = 0
C
C---- default time step, and number of time steps to take
      DELTAT = 0.0
      NTSTEPS = 0
C
      RETURN
      END ! DEFINI



      SUBROUTINE PARSET
      INCLUDE 'AVL.INC'
C
C---- variable names
      VARNAM(IVALFA) = 'alpha '
      VARNAM(IVBETA) = 'beta  '
      VARNAM(IVROTX) = 'pb/2V '
      VARNAM(IVROTY) = 'qc/2V '
      VARNAM(IVROTZ) = 'rb/2V '
C
C---- variable selection keys
      VARKEY(IVALFA) = 'A lpha'
      VARKEY(IVBETA) = 'B eta'
      VARKEY(IVROTX) = 'R oll  rate'
      VARKEY(IVROTY) = 'P itch rate'
      VARKEY(IVROTZ) = 'Y aw   rate'
C
C---- constraint names
CCC                     123456789012
      CONNAM(ICALFA) = 'alpha '
      CONNAM(ICBETA) = 'beta  '
      CONNAM(ICROTX) = 'pb/2V '
      CONNAM(ICROTY) = 'qc/2V '
      CONNAM(ICROTZ) = 'rb/2V '
      CONNAM(ICCL  ) = 'CL    '
      CONNAM(ICCY  ) = 'CY    '
      CONNAM(ICMOMX) = 'Cl roll mom'
      CONNAM(ICMOMY) = 'Cm pitchmom'
      CONNAM(ICMOMZ) = 'Cn yaw  mom'
C
C---- constraint selection keys
      CONKEY(ICALFA) = 'A '
      CONKEY(ICBETA) = 'B '
      CONKEY(ICROTX) = 'R '
      CONKEY(ICROTY) = 'P '
      CONKEY(ICROTZ) = 'Y '
      CONKEY(ICCL  ) = 'C '
      CONKEY(ICCY  ) = 'S '
      CONKEY(ICMOMX) = 'RM'
      CONKEY(ICMOMY) = 'PM'
      CONKEY(ICMOMZ) = 'YM'
C
C------------------------------------------------------------------------
      IZERO = ICHAR('0')
C
C---- add control variables, direct constraints
      DO N = 1, NCONTROL
        ITEN = N/10
        IONE = N - 10*ITEN
C
C------ assign slots in variable ond constraint lists
        IV = IVTOT + N
        IC = ICTOT + N
        VARNAM(IV) = DNAME(N)
        CONNAM(IC) = DNAME(N)
        IF(ITEN.EQ.0) THEN
         VARKEY(IV) = 'D' // CHAR(IZERO+IONE) // ' '
     &             // ' ' // DNAME(N)(1:8)
         CONKEY(IC) = 'D' // CHAR(IZERO+IONE)
        ELSE
         VARKEY(IV) = 'D' // CHAR(IZERO+ITEN) // CHAR(IZERO+IONE)
     &             // ' ' // DNAME(N)(1:8)
         CONKEY(IC) = 'D' // CHAR(IZERO+ITEN) // CHAR(IZERO+IONE)
        ENDIF
C
        LCONDEF(N) = .TRUE.
      ENDDO
C
C---- default design-variable flags, names
      DO N = 1, NDESIGN
        LDESDEF(N) = .TRUE.
      ENDDO
C
C---- total number of variables, constraints
      NVTOT = IVTOT + NCONTROL
      NCTOT = ICTOT + NCONTROL
C
C---- run-case parameter names
      PARNAM(IPALFA) = 'alpha    '
      PARNAM(IPBETA) = 'beta     '
      PARNAM(IPROTX) = 'pb/2V    '
      PARNAM(IPROTY) = 'qc/2V    '
      PARNAM(IPROTZ) = 'rb/2V    '
      PARNAM(IPCL )  = 'CL       '
      PARNAM(IPCD0)  = 'CDo      '
      PARNAM(IPPHI)  = 'bank     '
      PARNAM(IPTHE)  = 'elevation'
      PARNAM(IPPSI)  = 'heading  '
      PARNAM(IPMACH) = 'Mach     '
      PARNAM(IPVEE)  = 'velocity '
      PARNAM(IPRHO)  = 'density  '
      PARNAM(IPGEE)  = 'grav.acc.'
      PARNAM(IPRAD)  = 'turn_rad.'
      PARNAM(IPFAC)  = 'load_fac.'
      PARNAM(IPXCG)  = 'X_cg     '
      PARNAM(IPYCG)  = 'Y_cg     '
      PARNAM(IPZCG)  = 'Z_cg     '
      PARNAM(IPMASS) = 'mass     '
      PARNAM(IPIXX)  = 'Ixx      '
      PARNAM(IPIYY)  = 'Iyy      '
      PARNAM(IPIZZ)  = 'Izz      '
      PARNAM(IPIXY)  = 'Ixy      '
      PARNAM(IPIYZ)  = 'Iyz      '
      PARNAM(IPIZX)  = 'Izx      '
      PARNAM(IPCLA)  = 'visc CL_a'
      PARNAM(IPCLU)  = 'visc CL_u'
      PARNAM(IPCMA)  = 'visc CM_a'
      PARNAM(IPCMU)  = 'visc CM_u'
C
C---- total number of parameters
      NPTOT = IPTOT
C
C---- set default parameter unit names
      CALL PARNSET
C
      RETURN
      END ! PARSET



      SUBROUTINE PARNSET
      INCLUDE 'AVL.INC'
C
C---- set parameter unit name
      DO IP = 1, IPTOT
        PARUNCH(IP) = ' '
      ENDDO
C
      PARUNCH(IPALFA) = 'deg'
      PARUNCH(IPBETA) = 'deg'
      PARUNCH(IPPHI)  = 'deg'
      PARUNCH(IPTHE)  = 'deg'
      PARUNCH(IPPSI)  = 'deg'
      PARUNCH(IPVEE)  = UNCHV
      PARUNCH(IPRHO)  = UNCHD
      PARUNCH(IPGEE)  = UNCHA
      PARUNCH(IPRAD)  = UNCHL
      PARUNCH(IPXCG)  = UNCHL
      PARUNCH(IPYCG)  = UNCHL
      PARUNCH(IPZCG)  = UNCHL
      PARUNCH(IPMASS) = UNCHM
      PARUNCH(IPIXX)  = UNCHI
      PARUNCH(IPIYY)  = UNCHI
      PARUNCH(IPIZZ)  = UNCHI
      PARUNCH(IPIXY)  = UNCHI
      PARUNCH(IPIYZ)  = UNCHI
      PARUNCH(IPIZX)  = UNCHI
C
      RETURN
      END ! PARNSET



      SUBROUTINE VARINI
      INCLUDE 'AVL.INC'
C
C---- initialize state
      ALFA = 0.
      BETA = 0.
      WROT(1) = 0.
      WROT(2) = 0.
      WROT(3) = 0.
C
      DO N = 1, NCONTROL
        DELCON(N) = 0.0
      ENDDO
C
      DO N = 1, NDESIGN
        DELDES(N) = 0.0
      ENDDO
      LSOL = .FALSE.
C
      RETURN
      END ! VARINI



      SUBROUTINE RUNINI
      INCLUDE 'AVL.INC'
C
      WRITE(*,*)
      WRITE(*,*) 'Initializing run cases...'
C
C---- go over all run cases
      DO IR = 1, NRMAX
C------ index of default constraint for each variable
        ICON(IVALFA,IR) = ICALFA
        ICON(IVBETA,IR) = ICBETA
        ICON(IVROTX,IR) = ICROTX
        ICON(IVROTY,IR) = ICROTY
        ICON(IVROTZ,IR) = ICROTZ
C
C------ default constraint values
        DO IC = 1, ICTOT
          CONVAL(IC,IR) = 0.
        ENDDO
C
C------ default run case titles
        RTITLE(IR) = ' -unnamed- '
C
C------ default dimensional run case parameters
        DO IP = 1, NPTOT
          PARVAL(IP,IR) = 0.
        ENDDO
        PARVAL(IPGEE,IR) = GEE0
        PARVAL(IPRHO,IR) = RHO0
C
C------ default CG location is the input reference location
        PARVAL(IPXCG,IR) = XYZREF0(1)
        PARVAL(IPYCG,IR) = XYZREF0(2)
        PARVAL(IPZCG,IR) = XYZREF0(3)
C
        PARVAL(IPMASS,IR) = RMASS0
        PARVAL(IPIXX,IR) = RINER0(1,1)
        PARVAL(IPIYY,IR) = RINER0(2,2)
        PARVAL(IPIZZ,IR) = RINER0(3,3)
        PARVAL(IPIXY,IR) = RINER0(1,2)
        PARVAL(IPIYZ,IR) = RINER0(2,3)
        PARVAL(IPIZX,IR) = RINER0(3,1)
C
        PARVAL(IPCD0,IR) = CDREF0
C
        PARVAL(IPCLA,IR) = DCL_A0
        PARVAL(IPCLU,IR) = DCL_U0
        PARVAL(IPCMA,IR) = DCM_A0
        PARVAL(IPCMU,IR) = DCM_U0
C
        ITRIM(IR) = 0
        NEIGEN(IR) = 0
      ENDDO
C
C---- add control variables, direct constraints
      DO N = 1, NDMAX
        IV = IVTOT + N
        IC = ICTOT + N
        DO IR = 1, NRMAX
          ICON(IV,IR) = IC
          CONVAL(IC,IR) = 0.
        ENDDO
      ENDDO
C
C---- default number of run cases
      IRUN = 1
      NRUN = 1
C
C---- all run cases are targets for eigenmode calculation
      IRUNE = 0
C
C---- first run case is default for time march initial state
      IRUNT = 1
C
      RETURN
      END ! RUNINI



      SUBROUTINE RUNGET(LU,FNAME,ERROR)
C-------------------------------------------------
C     Reads run case file into run case arrays
C-------------------------------------------------
      INCLUDE 'AVL.INC'
      CHARACTER*(*) FNAME
      LOGICAL ERROR
C
      CHARACTER*80 LINE
      CHARACTER*12 VARN, CONN
      CHARACTER*8  PARN
C
      OPEN(LU,FILE=FNAME,STATUS='OLD',ERR=90)
      ILINE = 0
C
      IR = 0
C
C==============================================================
C---- start line-reading loop
 10   CONTINUE
C
      READ(LU,1000,END=50) LINE
 1000 FORMAT(A)
      ILINE = ILINE + 1
C
      KCOL = INDEX(LINE,':' )
      KARR = INDEX(LINE,'->')
      KEQU = INDEX(LINE,'=' )
      IF(KCOL.NE.0) THEN
C----- start of new run case
       READ(LINE(KCOL-3:KCOL-1),*,ERR=80) IR
C
       IF(IR.LT.1 .OR. IR.GT.NRMAX) THEN
        WRITE(*,*) 'RUNGET:  Run case array limit NRMAX exceeded:', IR
        IR = 0
        GO TO 10
       ENDIF
C
       NRUN = MAX(NRUN,IR)
C
       RTITLE(IR) = LINE(KCOL+1:80)
       CALL STRIP(RTITLE(IR),NRT)
C
      ELSEIF(IR.EQ.0) THEN
C----- keep ignoring lines if valid run case index is not set
       GO TO 10
C
      ELSEIF(KARR.NE.0 .AND. KEQU.NE.0) THEN
C----- variable/constraint declaration line
       VARN = LINE(1:KARR-1)
       CONN = LINE(KARR+2:KEQU-1)
       CALL STRIP(VARN,NVARN)
       CALL STRIP(CONN,NCONN)
C
       DO IV = 1, NVTOT
         IF(INDEX(VARNAM(IV),VARN(1:NVARN)).NE.0) GO TO 20
       ENDDO
       WRITE(*,*) 'Ignoring unrecognized variable: ', VARN(1:NVARN)
       GO TO 10
C
 20    CONTINUE
       DO IC = 1, NCTOT
         IF(INDEX(CONNAM(IC),CONN(1:NCONN)).NE.0) GO TO 25
       ENDDO
       WRITE(*,*) 'Ignoring unrecognized constraint: ', CONN(1:NCONN)
       GO TO 10
C
 25    CONTINUE
       READ(LINE(KEQU+1:80),*,ERR=80) CONV
C
       ICON(IV,IR) = IC
       CONVAL(IC,IR) = CONV
C
      ELSEIF(KARR.EQ.0 .AND. KEQU.NE.0) THEN
C----- run case parameter data line
       PARN = LINE(1:KEQU-1)
       CALL STRIP(PARN,NPARN)
       DO IP = 1, NPTOT
         IF(INDEX(PARNAM(IP),PARN(1:NPARN)).NE.0) GO TO 30
       ENDDO
       WRITE(*,*) 'Ignoring unrecognized parameter: ', PARN(1:NPARN)
       GO TO 10
C
 30    CONTINUE
       READ(LINE(KEQU+1:80),*,ERR=80) PARV
C
       PARVAL(IP,IR) = PARV
C
      ENDIF
C
C---- keep reading lines
      GO TO 10
C
C==============================================================
C
 50   CONTINUE
      CLOSE(LU)
      ERROR = .FALSE.
      RETURN
C
 80   CONTINUE
      CALL STRIP(FNAME,NFN)
      CALL STRIP(LINE ,NLI)
      WRITE(*,8000) FNAME(1:NFN), ILINE, LINE(1:NLI)
 8000 FORMAT(/' Run case file  ',A,'  read error on line', I4,':',A)
      CLOSE(LU)
      ERROR = .TRUE.
      NRUN = 0
      RETURN
C
 90   CONTINUE
      CALL STRIP(FNAME,NFN)
      WRITE(*,9000) FNAME(1:NFN)
 9000 FORMAT(/' Run case file  ',A,'  open error')
      ERROR = .TRUE.
      RETURN
      END ! RUNGET



      SUBROUTINE RUNSAV(LU)
      INCLUDE 'AVL.INC'
C
      DO IR = 1, NRUN
        WRITE(LU,1010) IR, RTITLE(IR)
        DO IV = 1, NVTOT
          IC = ICON(IV,IR)
          WRITE(LU,1050) VARNAM(IV), CONNAM(IC), CONVAL(IC,IR)
        ENDDO
C
        WRITE(LU,*)
C
        DO IP = 1, NPTOT
          WRITE(LU,1080) PARNAM(IP), PARVAL(IP,IR), PARUNCH(IP)
        ENDDO
      ENDDO
C
 1010 FORMAT(/' ---------------------------------------------'
     &       /' Run case', I3,':  ', A /)
 1050 FORMAT(1X,A,' ->  ', A, '=', G14.6, 1X, A)
 1080 FORMAT(1X,A,'=', G14.6, 1X, A)
C
      RETURN
      END ! RUNSAV



      LOGICAL FUNCTION LOWRIT(FNAME)
      CHARACTER*(*) FNAME
C
      CHARACTER*1 ANS
 1000 FORMAT(A)
C
      K = INDEX(FNAME,' ')
C
      WRITE(*,*) 'File  ', FNAME(1:K), ' exists.  Overwrite?  Y'
      READ (*,1000) ANS
      LOWRIT = INDEX('Nn',ANS) .EQ. 0
C
      RETURN
      END


      SUBROUTINE AOCFIL(FNAME,IFILE)
      CHARACTER*(*) FNAME
C
      CHARACTER*1 ANS
 1000 FORMAT(A)
C
      K = INDEX(FNAME,' ')
C
      WRITE(*,*) 'File  ', FNAME(1:K), 
     &     ' exists.  Append, Overwrite, or Cancel?  A'
      READ (*,1000) ANS
      IFILE = INDEX('AOC',ANS) + INDEX('aoc',ANS)
C
      IF(IFILE.EQ.0) IFILE = 1
C
      RETURN
      END

