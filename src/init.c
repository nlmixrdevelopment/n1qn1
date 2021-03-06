#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

typedef void (*S2_fp) (int *, int *, double *, double *, double *, int *, float *, double *);
extern void n1qn1_(S2_fp simul, int n[], double x[], double f[], double g[], double var[], double eps[],
		   int mode[], int niter[], int nsim[], int imp[], double zm[], int izs[], 
		   float rzs[], double dzs[]);
void n1qn1F(S2_fp simul, int n[], double x[], double f[], double g[], double var[], double eps[],
		   int mode[], int niter[], int nsim[], int imp[], int lp[], double zm[], int izs[], 
		   float rzs[], double dzs[]) {
  n1qn1_(simul, n, x, f, g, var, eps, mode, niter, nsim, imp, zm, izs, rzs, dzs);
}

void n1qn1F2(S2_fp simul, int n[], double x[], double f[], double g[], double var[], double eps[],
		   int mode[], int niter[], int nsim[], int imp[], double zm[], int izs[], 
		   float rzs[], double dzs[]) {
  n1qn1_(simul, n, x, f, g, var, eps, mode, niter, nsim, imp, zm, izs, rzs, dzs);
}
/* .C calls */
extern SEXP n1qn1_wrap(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);


static const R_CallMethodDef CallEntries[] = {
  {"n1qn1_wrap", (DL_FUNC) &n1qn1_wrap, 13},
  {NULL, NULL, 0}
};

void R_init_n1qn1(DllInfo *dll)
{
  R_RegisterCCallable("n1qn1","n1qn1F", (DL_FUNC) n1qn1F);
  R_RegisterCCallable("n1qn1","n1qn1F2", (DL_FUNC) n1qn1F2);
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, TRUE);
  R_forceSymbols(dll,TRUE);
}
