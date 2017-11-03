#include "xgboost.h"

VALUE rb_mXgboost;

void
Init_xgboost(void)
{
  rb_mXgboost = rb_define_module("Xgboost");
  Init_xgboost_booster();
}
