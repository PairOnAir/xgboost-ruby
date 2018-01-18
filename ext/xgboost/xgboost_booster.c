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
rb_xgboost_booster_load(VALUE self, VALUE file_name)
{
  BoosterHandle bh;

  Check_Type(file_name, T_STRING);

  Data_Get_Struct(self, BoosterHandle, bh);

  XGBoosterLoadModel(bh, StringValuePtr(file_name));

  return Qnil;
}

static VALUE
rb_xgboost_booster_predict(VALUE self, VALUE matrix)
{
  BoosterHandle bh;

  Check_Type(matrix, T_ARRAY);

  Data_Get_Struct(self, BoosterHandle, bh);

  // TODO: improve error checking
  // TODO: Decide if we want to fail in case the array is empty

  int is_array_of_arrays = RB_TYPE_P(RARRAY_AREF(matrix, 0), T_ARRAY);

  if (!is_array_of_arrays)
    matrix = rb_ary_new_from_values(1, &matrix);

  long nrows = RARRAY_LEN(matrix);
  long ncols = RARRAY_LEN(RARRAY_AREF(matrix, 0));
  float* c_matrix = calloc(ncols * nrows, sizeof(float));

  for (long i = 0; i < nrows; i++) {
    VALUE row = RARRAY_AREF(matrix, i);

    // TODO make sure dimensions check out
    for (long j = 0; j < ncols; j++)
      c_matrix[i * ncols + j] = NUM2DBL(RARRAY_AREF(row, j));
  }

  DMatrixHandle dmatrix;

  XGDMatrixCreateFromMat(c_matrix, nrows, ncols, 0, &dmatrix);

  const float *preds;
  unsigned long long pred_len;

  XGBoosterPredict(bh, dmatrix, 0, 0, &pred_len, &preds);

  XGDMatrixFree(dmatrix);
  free(c_matrix);

  VALUE result = rb_ary_new();

  for (unsigned long long i = 0; i < pred_len; i++)
    rb_ary_push(result, DBL2NUM(preds[i]));

  if (is_array_of_arrays)
    return result;
  else
    return RARRAY_AREF(result, 0);
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

void
Init_xgboost_booster(void)
{
  rb_cXgboostBooster = rb_define_class_under(rb_mXgboost, "Booster", rb_cObject);
  rb_define_alloc_func(rb_cXgboostBooster, rb_xgboost_booster_allocate);
  rb_define_method(rb_cXgboostBooster, "load", rb_xgboost_booster_load, 1);
  rb_define_method(rb_cXgboostBooster, "predict", rb_xgboost_booster_predict, 1);
  rb_define_method(rb_cXgboostBooster, "save", rb_xgboost_booster_save, 1);
}
