#include "xgboost.h"

VALUE rb_mXgboost;

VALUE rb_xgboost_this_is_c(VALUE klass)
{
  VALUE r_result = rb_int_new(42);
  return r_result;
}

void
Init_xgboost(void)
{
  rb_mXgboost = rb_define_module("Xgboost");
  rb_define_module_function(rb_mXgboost, "this_is_c", rb_xgboost_this_is_c, 0);
}
