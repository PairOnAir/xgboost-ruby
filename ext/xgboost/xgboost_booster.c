#include "xgboost_booster.h"

VALUE rb_cXgboostBooster;

static void
rb_xgboost_booster_deallocate(BoosterHandle bh)
{
  XGBoosterFree(bh);
}

static VALUE
rb_xgboost_booster_allocate(VALUE klass)
{
  BoosterHandle bh;
  XGBoosterCreate(NULL, 0, &bh);

  return Data_Wrap_Struct(klass, NULL, rb_xgboost_booster_deallocate, bh);
}

static VALUE
rb_xgboost_booster_save(VALUE self, VALUE file_name)
{
  BoosterHandle bh;

  Check_Type(file_name, T_STRING);

  Data_Get_Struct(self, BoosterHandle, bh);

  XGBoosterSaveModel(bh, StringValuePtr(file_name));

  return Qnil;
}

static VALUE
rb_xgboost_booster_load(VALUE self, VALUE file_name)
{
  BoosterHandle bh;

  Check_Type(file_name, T_STRING);

  Data_Get_Struct(self, BoosterHandle, bh);

  XGBoosterLoadModel(bh, StringValuePtr(file_name));

  return Qnil;
}

void
Init_xgboost_booster(void)
{
  rb_cXgboostBooster = rb_define_class_under(rb_mXgboost, "Booster", rb_cObject);
  rb_define_alloc_func(rb_cXgboostBooster, rb_xgboost_booster_allocate);
  rb_define_method(rb_cXgboostBooster, "save", rb_xgboost_booster_save, 1);
  rb_define_method(rb_cXgboostBooster, "load", rb_xgboost_booster_load, 1);
}
