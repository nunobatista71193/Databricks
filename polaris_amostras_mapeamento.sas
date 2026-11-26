/*==========================================================================
  Projeto : Polaris - Fontes Datamart v2
  Objetivo: Listar as COLUNAS de cada tabela a mapear, com valores de exemplo.
  Saida   : work.MAPEAMENTO_CAMPOS  (1 linha por coluna de cada tabela)
              tabela | accao | ordem | campo_origem | tipo | tamanho | format
              label | exemplo_1 ... exemplo_N | campo_polaris | descricao ...
            work.LOG_EXTRACAO       (tabelas encontradas / nao encontradas)
==========================================================================*/

/*---------------------------------------------------------------------------
  1. PARAMETROS  (ajustar)
---------------------------------------------------------------------------*/
%let nobs        = 5;     /* n.o de linhas de exemplo por tabela (exemplo_1..exemplo_N) */
%let ultima_data = ;      /* preencher se usar APOLICES_AUTO_&ultima_data */

/* Libnames - descomentar/ajustar se ainda nao estiverem atribuidas */
/*
libname ODS      '/caminho/ods';
libname ods_sem  '/caminho/ods_sem';
libname GTNVAUTO '/caminho/gtnvauto';
libname SGD      '/caminho/sgd';
*/

/*---------------------------------------------------------------------------
  2. LISTA DE TABELAS (input: Acao = Mapear / Analisar)
---------------------------------------------------------------------------*/
data work._lista;
  length lib $32 tab $64 accao $10;
  infile datalines dlm=' ' truncover;
  input lib $ tab $ accao $;
  tab = tranwrd(tab, '&ultima_data', "&ultima_data");
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

proc sql;
  create table work._log
    (lib char(32), tab char(64), accao char(10), estado char(20), nlinhas num, ncampos num);
quit;

/*---------------------------------------------------------------------------
  3. MACRO: colunas + valores de exemplo de UMA tabela
---------------------------------------------------------------------------*/
%macro extrai(lib=, tab=, accao=);

  %local existe nl nc;
  %let existe = 0;
  %if %sysfunc(exist(&lib..&tab))             %then %let existe = 1;
  %else %if %sysfunc(exist(&lib..&tab, VIEW)) %then %let existe = 1;

  %if &existe = 0 %then %do;
    %put WARNING: Tabela &lib..&tab nao encontrada.;
    proc sql;
      insert into work._log
      set lib="&lib", tab="&tab", accao="&accao", estado="NAO ENCONTRADA", nlinhas=., ncampos=.;
    quit;
    %return;
  %end;

  /* a) estrutura (colunas) */
  proc contents data=&lib..&tab
       out=work._c(keep=varnum name type length format label nobs) noprint;
  run;

  proc sql noprint;
    select max(nobs), count(*) into :nl trimmed, :nc trimmed from work._c;
    insert into work._log
    set lib="&lib", tab="&tab", accao="&accao", estado="OK", nlinhas=&nl, ncampos=&nc;
  quit;

  data work._c;
    length tabela $70 accao $10 tipo $4;
    set work._c;
    tabela = "&lib..&tab";
    accao  = "&accao";
    tipo   = ifc(type = 1, 'NUM', 'CHAR');
    rename varnum=ordem name=campo_origem length=tamanho;
    drop type nobs;
  run;

  proc append base=work._estrutura data=work._c force; run;

  /* b) valores de exemplo: 1 registo por (linha, coluna) */
  data work._v;
    length _tabela_ $70 _campo_ $64 _valor_ $200 _linha_ 8 _nm_ $64;
    set &lib..&tab(obs=&nobs);
    _tabela_ = "&lib..&tab";
    _linha_  = _n_;
    _nm_     = ' ';
    do until (_nm_ = ' ');
      call vnext(_nm_);
      if _nm_ ne ' ' and upcase(_nm_) not in
         ('_N_','_ERROR_','_TABELA_','_CAMPO_','_VALOR_','_LINHA_','_NM_') then do;
        _campo_ = _nm_;
        _valor_ = strip(vvaluex(_nm_));
        output;
      end;
    end;
    keep _tabela_ _campo_ _valor_ _linha_;
  run;

  proc append base=work._valores data=work._v force; run;

%mend extrai;

/*---------------------------------------------------------------------------
  4. EXECUCAO
---------------------------------------------------------------------------*/
proc datasets lib=work nolist nowarn;
  delete _estrutura _valores;
quit;

data _null_;
  set work._lista;
  call execute(cats('%nrstr(%extrai)(lib=', lib, ', tab=', tab, ', accao=', accao, ')'));
run;

/*---------------------------------------------------------------------------
  5. TABELA FINAL: colunas + exemplos + colunas vazias para o mapeamento
---------------------------------------------------------------------------*/
proc sort data=work._valores; by _tabela_ _campo_ _linha_; run;

proc transpose data=work._valores out=work._t(drop=_name_) prefix=exemplo_;
  by _tabela_ _campo_;
  id _linha_;
  var _valor_;
run;

proc sort data=work._estrutura; by tabela campo_origem; run;
proc sort data=work._t(rename=(_tabela_=tabela _campo_=campo_origem)) out=work._t; by tabela campo_origem; run;

data work.mapeamento_campos;
  length tabela $70 accao $10 ordem 8 campo_origem $64 tipo $4 tamanho 8
         format $32 label $256 exemplo_1-exemplo_&nobs $200
         campo_polaris $64 descricao $200 regra_transformacao $200 comentario $200;
  merge work._estrutura work._t;
  by tabela campo_origem;
run;

proc sort data=work.mapeamento_campos; by tabela ordem; run;

data work.log_extracao;
  set work._log;
run;

/* limpeza dos intermedios */
proc datasets lib=work nolist nowarn;
  delete _lista _log _c _v _valores _estrutura _t;
quit;
