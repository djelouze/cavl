#include "cavl.h"

#include <iostream>
#include <string>



int main( int argc, char** argv )
{
  
  avl::defini_();
  avl::masini_();
  avl::plinit_();
  int luinp=4;
  unsigned int error;
  std::cerr << argv[1] << " " << std::string(argv[1]).length() << std::endl;
  avl::input_(&luinp, argv[1], &error,std::string(argv[1]).length());
  avl::parset_();
  avl::encalc_();
  avl::varini_();
  int lumas;
  avl::masget_(&lumas, argv[2], &error, std::string(argv[2]).length());
  if( error )
  {
    avl::masini_();
  }
  else
  {
    int lu = 6;
    avl::massho_(&lu);
    avl::appget_();
    float rho;
    avl::appsho_(&lu, &rho);
  }
  
  avl::runini_();
  //avl::oper_();
  
  std::cerr << avl::case_c_.varnam[0] << std::endl;
  //askc_("a","b","c");
  return( 0 );
}
