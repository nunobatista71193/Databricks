/*==========================================================================
  Datamart motor - exportacao mensal para CSV - ANO 2026
  1 CSV por marca e mes: DATAMART_26MM_<MARCA>.csv  (204 colunas, mesma
  ordem do projeto original).
  Os programas de cada ano sao independentes: podem correr em paralelo.

  TABELA DE ORIGEM: deteta sozinho a MOTOR_DATAMART_COVERmmyy mais recente
  na lib PBAMTR (muda todos os meses). Para forcar uma tabela, preencher
  &fonte_manual (ex.: PBAMTR.MOTOR_DATAMART_COVER1026).

  NOTA: este ficheiro so tem caracteres ASCII (evita erros de codificacao no
  EG). Os nomes de colunas com acentos/euro sao lidos do dicionario da tabela.
==========================================================================*/

options validvarname=any;

/*--- PARAMETROS ---------------------------------------------------------*/
%let ano          = 2026;
%let outdir       = E:\Export;
%let mes_ini      = 1;
%let mes_fim      = 12;
%let fonte_manual = ;

%let marca1 = SD;   %let empresa1 = Seguro Direct;
%let marca2 = AGS;  %let empresa2 = Ageas Seguros;
%let marca3 = OCS;  %let empresa3 = Ocidental Seguros;
%let n_marcas = 3;

/*--- TABELA DE ORIGEM (a mais recente) ----------------------------------*/
%global fonte cols;
%macro escolhe_fonte;
  %if %length(&fonte_manual) %then %let fonte = &fonte_manual;
  %else %do;
    proc sql noprint outobs=1;
      select cats('PBAMTR.', memname) into :fonte trimmed
      from dictionary.tables
      where libname = 'PBAMTR' and memtype = 'DATA'
        and prxmatch('/^MOTOR_DATAMART_COVER\d{4}$/', strip(memname))
      order by input(cats(substr(memname, length(memname)-1, 2),
                          substr(memname, length(memname)-3, 2)), 4.) desc;
    quit;
  %end;
  %put NOTE: Tabela de origem = &fonte;
%mend escolhe_fonte;
%escolhe_fonte

/*--- COLUNAS A EXPORTAR (ordem do projeto) -------------------------------
  1.o caracter: 0 = nome exato; 1 = nome com acento/euro (o simbolo esta
  substituido por _ e e procurado por padrao no dicionario).              */
data work._pedido;
  length esp 8 nome $64;
  seq = _n_;
  input esp 1. nome $char64.;
datalines;
0Desc_Company
0Id_Policy
0Ac_Period
0Uw_Period
0Desc_ClientType
0Desc_ClientType_Fleets
0Desc_Product
0Desc_Segment
0Dt_StartVigence
0Dt_EndVigence
0AC_Policy_Object
0AC_Policy
0UW_Policy_Object
0UW_Policy
0Val_Earn_Premium
0Val_Exposure
0Amt_AnnCommercialPremium
0Num_Claim
0Num_ClaimCover
0Val_ClaimCover_Total
0Amt_AnnCommercialPremium_ADV
0Amt_AnnCommercialPremium_AE
0Amt_AnnCommercialPremium_AEcv
0Amt_AnnCommercialPremium_ALS
0Amt_AnnCommercialPremium_AMD
0Amt_AnnCommercialPremium_ASB
0Amt_AnnCommercialPremium_AST
0Amt_AnnCommercialPremium_ASV
0Amt_AnnCommercialPremium_AV
0Amt_AnnCommercialPremium_AVE
0Amt_AnnCommercialPremium_AVP
0Amt_AnnCommercialPremium_BAG
0Amt_AnnCommercialPremium_CCC
0Amt_AnnCommercialPremium_BAT
0Amt_AnnCommercialPremium_CRO
0Amt_AnnCommercialPremium_CRT
0Amt_AnnCommercialPremium_DNC
0Amt_AnnCommercialPremium_DP10
0Amt_AnnCommercialPremium_EX
0Amt_AnnCommercialPremium_FDN
0Amt_AnnCommercialPremium_FRB
0Amt_AnnCommercialPremium_IRE
0Amt_AnnCommercialPremium_ODV
0Amt_AnnCommercialPremium_PA
0Amt_AnnCommercialPremium_PC
0Amt_AnnCommercialPremium_PDU
0Amt_AnnCommercialPremium_PF
0Amt_AnnCommercialPremium_PMU
0Amt_AnnCommercialPremium_PNE
0Amt_AnnCommercialPremium_PPE
0Amt_AnnCommercialPremium_PSR
0Amt_AnnCommercialPremium_PT
0Amt_AnnCommercialPremium_PTJ
0Amt_AnnCommercialPremium_PTL
0Amt_AnnCommercialPremium_PUE
0Amt_AnnCommercialPremium_PV
0Amt_AnnCommercialPremium_QDV
0Amt_AnnCommercialPremium_QF
0Amt_AnnCommercialPremium_QIV
0Amt_AnnCommercialPremium_RC
0Amt_AnnCommercialPremium_RCF
0Amt_AnnCommercialPremium_RSP
0Amt_AnnCommercialPremium_SAS
0Amt_AnnCommercialPremium_SC
0Amt_AnnCommercialPremium_STS
0Amt_AnnCommercialPremium_VAV
0Amt_AnnCommercialPremium_VDS
0Amt_AnnCommercialPremium_VF
0Amt_AnnCommercialPremium_VN
0Amt_AnnCommercialPremium_VSA
0Num_ClaimCover_ADV
0Num_ClaimCover_BAG
0Num_ClaimCover_CCC
0Num_ClaimCover_CRO
0Num_ClaimCover_DNC
0Num_ClaimCover_DP10
0Num_ClaimCover_FDN
0Num_ClaimCover_FRB
0Num_ClaimCover_IRE
0Num_ClaimCover_ODV
0Num_ClaimCover_PT
0Num_ClaimCover_PUE
0Num_ClaimCover_PUS
0Num_ClaimCover_QIV
0Num_ClaimCover_RC
0Num_ClaimCover_VDS
0Val_ClaimCover_ADV
0Val_ClaimCover_BAG
0Val_ClaimCover_CCC
0Val_ClaimCover_CRO
0Val_ClaimCover_DNC
0Val_ClaimCover_DP10
0Val_ClaimCover_FDN
0Val_ClaimCover_FRB
0Val_ClaimCover_IRE
0Val_ClaimCover_ODV
0Val_ClaimCover_PT
0Val_ClaimCover_PUE
0Val_ClaimCover_PUS
0Val_ClaimCover_QIV
0Val_ClaimCover_RC
0Val_ClaimCover_VDS
0Val_Claim_Total_Assistance
1N_ sinistros total
0Num_Claim_Assistance
0Acordos
0Desc_ChangeType
0Cod_Tariff
0Cod_GroupedTariff
0Desc_Option
0Id_UnitRisk
0Desc_PaymentPlan
0Desc_PaymentType
0Id_PolicyAge
0Dt_PlStartEffectDate
0Dt_PlStartEmissDate
0Dt_PlErlyExitEffctDate
0Dt_PlEarlyExitEmDate
0Desc_Situation
0Desc_NewRenewal
0Id_PolicyHolder
0Id_NIF_Policyholder
0Dt_BirthPolicyHolder
0Id_PolicyHolderAge
0Id_ZipCodePolicyHolder
0Desc_PolicyHolderDistrict
0Desc_PolicyHolderTown
0Id_CAE_PolicyHolder
0Id_DriverAge
0Id_DriverAgeRange
0Dt_BirthDriver
0Id_DayDtBirthDriver
0Dt_YoungCondition
0Desc_DriverSex
0Desc_DriverMaritalStatus
0Desc_DriverZipCode
0Dt_DriverLicense
0Id_DriverLicenceAge
0Id_DriverLicenceYear
0Id_VehicleLicense
0Dt_VehicleLicense
0Id_ImportedVehicle
0Id_VehicleLicenseYear
0Id_ConstructionYear
0Id_VehicleAge
0Id_VehicleAgeRange
0Desc_VehicleType
0Desc_VehicleTypeGroup
0Desc_InsuranceType
0Desc_Bodywork
0Desc_VehicleOrigin
0Desc_Brand
0Desc_Model
0Desc_Version
0Cod_Eurotax
0Id_Displacement
0Id_DisplacementRange
0Id_Potence
0Id_Tare
0Id_Weight
0Id_WeightPotenceRatio
0Id_WeightTaraRatio
0Desc_FuelType
0Id_Doors
0Id_Seets
0Val_VehicleCapital
0Val_VehicleCapitalRange
0Val_VehicleCapitalWithoutExtras
0Val_Extras
0Id_SectorActivityPolicyHolder
0Desc_SectorActivityPolicyHolder
0Desc_Mediator
0Desc_MediatorName
0Desc_ZoneRC
0Desc_ZoneDP
0Desc_OwnDamageClass
0Ind_OnwDamage
0Ind_Collision
0Ind_Theft
0Ind_Windscreen
0Cod_Campaign
0NSUPLEMENTO
0Ind_Protocol
0Desc_SectorActivityGroup
0Val_New_Vehicle
0Ind_VehicleUse
0Cod_AgentASF
0Desc_Mediatornetwork
0Desc_MediatorZone
0Desc_MediatorCounter
0Cod_MediatorInspector
0Desc_MediatorInspector
0Desc_MediatorChannel
0Desc_MediatorTypology
0Desc_MediatorSubTypology
0Desc_MediatorSituation
0BonusMalusInitial
0Desc_DriverRegiao
0Desc_DriverZona
0Dt_ExclusionVehicleLicense
0Dt_InclusionVehicleLicense
0BonusMalusRange
1Num_ClaimCover_Without_Credor_0_
0Val_Motor_Total_Without_Credor
;
run;

/*--- Constroi a lista de colunas a partir do dicionario da tabela -------*/
%macro monta_cols;
  %local lib tab nfalta;
  %let lib = %upcase(%scan(&fonte, 1, .));
  %let tab = %upcase(%scan(&fonte, 2, .));

  proc sql noprint;
    create table work._colmap as
    select p.seq, p.nome as pedido, d.name
    from work._pedido p
         left join dictionary.columns d
         on d.libname = "&lib" and d.memname = "&tab"
            and ( (p.esp = 0 and upcase(strip(d.name)) = upcase(strip(p.nome)))
               or (p.esp = 1 and upcase(d.name) like upcase(strip(p.nome))) )
    order by p.seq;

    select count(*) into :nfalta trimmed from work._colmap where name is null;
    select cats('"', strip(name), '"n') into :cols separated by ', '
      from work._colmap where name is not null;
  quit;

  %if &nfalta > 0 %then %do;
    %put WARNING: &nfalta coluna(s) pedida(s) nao existem em &fonte (ver work._colmap, name vazio).;
  %end;
%mend monta_cols;
%monta_cols

/*--- EXPORTACAO ---------------------------------------------------------*/
%macro exporta(marca, empresa, mes);
  %local mm periodo ficheiro linhas rc;
  %let mm       = %sysfunc(putn(&mes, z2.));
  %let periodo  = &ano.&mm;
  %let ficheiro = &outdir\DATAMART_%substr(&ano,3,2)&mm._&marca..csv;

  proc sql;
    create view work.v_&marca as
    select &cols
    from &fonte
    where Desc_Company = "&empresa" and Ac_Period = "&periodo";
  quit;

  proc export data=work.v_&marca
              outfile="&ficheiro"
              dbms=csv replace;
  run;

  /* mes sem dados: o CSV fica so com cabecalho -> apagar e avisar */
  %let linhas = 0;
  data _null_;
    infile "&ficheiro" obs=2 lrecl=32767 truncover;
    input;
    n + 1;
    call symputx('linhas', n);
  run;
  %if &linhas < 2 %then %do;
    filename _del "&ficheiro";
    %let rc = %sysfunc(fdelete(_del));
    filename _del clear;
    %put WARNING: &periodo &marca sem dados - ficheiro nao criado.;
  %end;
  %else %put NOTE: &periodo &marca exportado -> &ficheiro;

  proc datasets lib=work nolist nowarn; delete v_&marca / memtype=view; quit;
%mend exporta;

%macro corre;
  %local i m;
  %do m = &mes_ini %to &mes_fim;
    %do i = 1 %to &n_marcas;
      %exporta(&&marca&i, &&empresa&i, &m)
    %end;
  %end;
%mend corre;

%corre
