#include "xgboost.h"

VALUE rb_mXgboost;

VALUE rb_xgboost_this_is_c(VALUE klass)
{
  VALUE r_result = rb_int_new(42);
  return r_result;
}

VALUE rb_xgboost_add_in_c(VALUE klass, VALUE op1, VALUE op2)
{
  if (!FIXNUM_P(op1))
    rb_raise(rb_eArgError, "Argument 1 has to be of type Fixnum");

  if (!FIXNUM_P(op2))
    rb_raise(rb_eArgError, "Argument 2 has to be of type Fixnum");

  long op1_long = FIX2LONG(op1);
  long op2_long = FIX2LONG(op2);

  return LONG2FIX(op1_long + op2_long);
}

void
Init_xgboost(void)
{
  rb_mXgboost = rb_define_module("Xgboost");
  rb_define_module_function(rb_mXgboost, "this_is_c", rb_xgboost_this_is_c, 0);
  rb_define_module_function(rb_mXgboost, "add_in_c", rb_xgboost_add_in_c, 2);
}
