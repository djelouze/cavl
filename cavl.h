namespace avl{
extern "C"{void appget_();}
extern "C"{void appsho_(int*, float*);}
extern "C"{void askc_(char*, char*, char*, unsigned long, unsigned long, unsigned long);}
extern "C"{void asks_(char*, char*);}
extern "C"{void defini_();}
extern "C"{void encalc_();}
extern "C"{void getarg0_(int*, char*, unsigned long);}
extern "C"{void getflt_(char*, float*, int*, bool*, unsigned long);}
extern "C"{void getint_(char*, int*, int*, bool*, unsigned long);}
extern "C"{void input_(int*, char*, unsigned int*,unsigned long);}
extern "C"{void masget_(int*, char*, unsigned int*, unsigned long);}
extern "C"{void masini_();}
extern "C"{void masput_();}
extern "C"{void massho_(int*);}
extern "C"{void mode_();}
extern "C"{void oper_();}
extern "C"{void oplset_();}
extern "C"{void parset_();}
extern "C"{void plinit_();}
extern "C"{void plpars_();}
extern "C"{void readi_();}
extern "C"{void runget_();}
extern "C"{void runini_();}
extern "C"{void strip_();}
extern "C"{void varini_();}

#define NVMAX 6000 
#define NSMAX 400 
#define NFMAX 30
#define NLMAX 500
#define NBMAX 20
#define NUMAX 6
#define NDMAX 30
#define NGMAX 20
#define NRMAX 25
#define NTMAX 5000

#define JETOT 12
#define IPTOT 30
#define ICTOT 10
#define IVTOT 5

#define ITMAX 2*NVMAX
#define IVMAX IVTOT+NDMAX
#define ICMAX ICTOT+NDMAX
#define IPMAX IPTOT 
#define JEMAX JETOT  

extern "C" {
  extern struct{
//     CHARACTER*80 FILDEF, FRNDEF, FMSDEF, FPRDEF, FEVDEF
//     CHARACTER*80 TITLE
//     CHARACTER*40 STITLE, BTITLE, RTITLE
//     CHARACTER*16 DNAME, GNAME
//     CHARACTER*12 VARNAM, CONNAM
//     CHARACTER*12 VARKEY
//     CHARACTER*3  CONKEY
//     CHARACTER*10 PARNAM
//     CHARACTER*32 PARUNCH
//     COMMON /CASE_C/
//     & FILDEF,         ! default configuration save file
//     & FRNDEF,         ! default run case save file
//     & FMSDEF,         ! default mass distribution file
//     & FPRDEF,         ! default dimensional parameter file
//     & FEVDEF,         ! default eigenvalue save file
//     & TITLE,          ! configuration title
//     & STITLE(NFMAX),  ! surface title
//     & BTITLE(NBMAX),  ! body title
//     & RTITLE(NRMAX),  ! run case title
//     & DNAME(NDMAX),   ! control variable name
//     & GNAME(NGMAX),   ! design  variable name
//     & VARNAM(IVMAX),  ! variable   name
//     & CONNAM(ICMAX),  ! constraint name
//     & VARKEY(IVMAX),  ! variable   selection key
//     & CONKEY(ICMAX),  ! constraint selection key
//     & PARNAM(IPMAX),  ! run case parameter name
//     & PARUNCH(IPMAX)  ! run case parameter unit name
  char fildef[80];
  char frndef[80];
  char fmsdef[80];
  char fprdef[80];
  char fevdef[80];
  char title[80];
  char stitle[NFMAX][40];
  char btitle[NBMAX][40];
  char rtitle[NRMAX][40];
  char dname[NDMAX][16];
  char gname[NGMAX][16];
  char varnam[IVMAX][12];
  char connam[ICMAX][12];
  char varkey[IVMAX][12];
  char conkey[ICMAX][3];
  char parnam[IPMAX][10];
  char parunch[IPMAX][32];
  
  } case_c_;
}
}