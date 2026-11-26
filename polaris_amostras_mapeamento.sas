/*==========================================================================
  Projeto : Polaris - Fontes Datamart v2
  Objetivo: Extrair amostra de linhas + estrutura (campos) de cada tabela
            marcada como "Mapear" / "Analisar" no ficheiro de fontes,
            para depois mapear os campos.
  Saidas  : 1) amostras_tabelas.xlsx   -> 1 folha por tabela (n linhas)
            2) estrutura_campos.xlsx   -> todos os campos de todas as tabelas
                                          (com colunas vazias para mapeamento)
            3) work.log_extracao       -> tabelas OK / nao encontradas
==========================================================================*/

/*---------------------------------------------------------------------------
  1. PARAMETROS  (ajustar)
---------------------------------------------------------------------------*/
%let outdir = /caminho/para/output;   /* pasta de saida (Windows: C:\temp\polaris) */
%let nobs   = 10;                     /* n.o de linhas por tabela */
%let ultima_data = ;                  /* preencher se usar APOLICES_AUTO_&ultima_data */

/* Libnames - descomentar/ajustar se ainda nao estiverem atribuidas na sessao */
/*
libname ODS      '/caminho/ods';
libname ods_sem  '/caminho/ods_sem';
libname GTNVAUTO '/caminho/gtnvauto';
libname SGD      '/caminho/sgd';
*/

/*---------------------------------------------------------------------------
  2. LISTA DE TABELAS  (Acao = Mapear / Analisar)
---------------------------------------------------------------------------*/
data work.lista_tabelas;
  length lib $32 tab $64 accao $10 sheet $31;
  infile datalines dlm=' ' truncover;
  input lib $ tab $ accao $;
  tab   = tranwrd(tab, '&ultima_data', "&ultima_data");
  sheet = cats(put(_n_, z2.), '_', substr(tab, 1, min(28, length(tab))));
datalines;
ODS sup_historico Mapear
ODS cuerpoliza Mapear
ODS HIS_CUERPOLIZA Mapear
ODS HIS_AUT_CUERPOLIZA Mapear
ODS aut_m002 Mapear
ODS HIS_AUT_CUER_CICLO Mapear
ODS HIS_CUERPOLIZA_COMUN Mapear
ODS aut_veiculos Mapear
ODS HIS_AUT_CUER_CICLO_EXT Mapear
ODS STD_SIMULATION Mapear
ODS HIS_AUT_M002_DES_AGRAV Mapear
ODS aut_num_sinistros Mapear
ODS coberturas Mapear
ODS aut_fr_cuer_ciclo Mapear
ODS aut_extras_apolice Mapear
ODS aut_fr_m002 Mapear
ods_sem AUT_AXA_CUERPOLIZA_ATRIBUTOS Mapear
ods_sem HIS_AUT_SD_DES_AGRAV Mapear
ods_sem AUT_M002 Mapear
GTNVAUTO APOLICES_AUTO_&ultima_data Analisar
SGD CLUSTERS Analisar
;
run;

/*---------------------------------------------------------------------------
  3. MACRO DE EXTRACAO
---------------------------------------------------------------------------*/
%macro extrai(lib=, tab=, sheet=, accao=);

  %local existe;
  %let existe = 0;
  %if %sysfunc(exist(&lib..&tab))          %then %let existe = 1;
  %else %if %sysfunc(exist(&lib..&tab, VIEW)) %then %let existe = 1;

  %if &existe = 0 %then %do;
    %put WARNING: Tabela &lib..&tab nao encontrada.;
    proc sql;
      insert into work.log_extracao
      set lib="&lib", tab="&tab", accao="&accao", estado="NAO ENCONTRADA", nlinhas=., ncampos=.;
    quit;
    %return;
  %end;

  /* estrutura dos campos */
  proc contents data=&lib..&tab out=work._c(keep=memname varnum name type length format formatl label nobs) noprint;
  run;

  data work._c;
    length tabela $70 accao $10 tipo $4;
    set work._c;
    tabela = "&lib..&tab";
    accao  = "&accao";
    tipo   = ifc(type = 1, 'NUM', 'CHAR');
    drop type memname;
  run;

  proc append base=work.estrutura data=work._c force; run;

  /* log */
  proc sql noprint;
    select max(nobs), count(*) into :nl trimmed, :nc trimmed from work._c;
    insert into work.log_extracao
    set lib="&lib", tab="&tab", accao="&accao", estado="OK", nlinhas=&nl, ncampos=&nc;
  quit;

  /* amostra -> 1 folha por tabela */
  ods excel options(sheet_name="&sheet");
  proc print data=&lib..&tab(obs=&nobs) noobs;
  run;

%mend extrai;

/*---------------------------------------------------------------------------
  4. EXECUCAO
---------------------------------------------------------------------------*/
proc sql;
  create table work.log_extracao
    (lib char(32), tab char(64), accao char(10), estado char(20), nlinhas num, ncampos num);
quit;

proc datasets lib=work nolist; delete estrutura; quit;

ods excel file="&outdir/amostras_tabelas.xlsx";
options nodate nonumber;

data _null_;
  set work.lista_tabelas;
  call execute(cats('%nrstr(%extrai)(lib=', lib, ', tab=', tab,
                    ', sheet=', sheet, ', accao=', accao, ')'));
run;

ods excel close;

/*---------------------------------------------------------------------------
  5. FICHEIRO DE ESTRUTURA (template para o mapeamento)
---------------------------------------------------------------------------*/
data work.estrutura_mapeamento;
  length campo_polaris $64 descricao $200 regra_transformacao $200 comentario $200;
  set work.estrutura;
  call missing(campo_polaris, descricao, regra_transformacao, comentario);
  rename name=campo_origem varnum=ordem formatl=format_len;
run;

proc sort data=work.estrutura_mapeamento;
  by tabela ordem;
run;

ods excel file="&outdir/estrutura_campos.xlsx" options(sheet_name="Campos");
proc print data=work.estrutura_mapeamento noobs;
  var tabela accao ordem campo_origem tipo length format format_len label nobs
      campo_polaris descricao regra_transformacao comentario;
run;
ods excel options(sheet_name="Log");
proc print data=work.log_extracao noobs; run;
ods excel close;

/* resumo no output */
title "Resumo da extracao";
proc print data=work.log_extracao noobs; run;
title;
