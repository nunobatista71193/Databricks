/*==========================================================================
  Datamart motor - exportacao mensal para CSV - ANO 2026
  1 CSV por marca e mes: DATAMART_26MM_<MARCA>.csv  (204 colunas, mesma
  ordem do projeto original).
  Os 3 programas (2024, 2025, 2026) sao independentes: podem correr em paralelo.

  TABELA DE ORIGEM: deteta sozinho a MOTOR_DATAMART_COVERmmyy mais recente
  na lib PBAMTR (muda todos os meses). Para forcar uma tabela, preencher
  &fonte_manual (ex.: PBAMTR.MOTOR_DATAMART_COVER1026).
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
%global fonte;
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

/*--- COLUNAS ------------------------------------------------------------*/
%let cols =
    Desc_Company,
    Id_Policy,
    Ac_Period,
    Uw_Period,
    Desc_ClientType,
    Desc_ClientType_Fleets,
    Desc_Product,
    Desc_Segment,
    Dt_StartVigence,
    Dt_EndVigence,
    AC_Policy_Object,
    AC_Policy,
    UW_Policy_Object,
    UW_Policy,
    Val_Earn_Premium,
    Val_Exposure,
    Amt_AnnCommercialPremium,
    Num_Claim,
    Num_ClaimCover,
    Val_ClaimCover_Total,
    Amt_AnnCommercialPremium_ADV,
    Amt_AnnCommercialPremium_AE,
    Amt_AnnCommercialPremium_AEcv,
    Amt_AnnCommercialPremium_ALS,
    Amt_AnnCommercialPremium_AMD,
    Amt_AnnCommercialPremium_ASB,
    Amt_AnnCommercialPremium_AST,
    Amt_AnnCommercialPremium_ASV,
    Amt_AnnCommercialPremium_AV,
    Amt_AnnCommercialPremium_AVE,
    Amt_AnnCommercialPremium_AVP,
    Amt_AnnCommercialPremium_BAG,
    Amt_AnnCommercialPremium_CCC,
    Amt_AnnCommercialPremium_BAT,
    Amt_AnnCommercialPremium_CRO,
    Amt_AnnCommercialPremium_CRT,
    Amt_AnnCommercialPremium_DNC,
    Amt_AnnCommercialPremium_DP10,
    Amt_AnnCommercialPremium_EX,
    Amt_AnnCommercialPremium_FDN,
    Amt_AnnCommercialPremium_FRB,
    Amt_AnnCommercialPremium_IRE,
    Amt_AnnCommercialPremium_ODV,
    Amt_AnnCommercialPremium_PA,
    Amt_AnnCommercialPremium_PC,
    Amt_AnnCommercialPremium_PDU,
    Amt_AnnCommercialPremium_PF,
    Amt_AnnCommercialPremium_PMU,
    Amt_AnnCommercialPremium_PNE,
    Amt_AnnCommercialPremium_PPE,
    Amt_AnnCommercialPremium_PSR,
    Amt_AnnCommercialPremium_PT,
    Amt_AnnCommercialPremium_PTJ,
    Amt_AnnCommercialPremium_PTL,
    Amt_AnnCommercialPremium_PUE,
    Amt_AnnCommercialPremium_PV,
    Amt_AnnCommercialPremium_QDV,
    Amt_AnnCommercialPremium_QF,
    Amt_AnnCommercialPremium_QIV,
    Amt_AnnCommercialPremium_RC,
    Amt_AnnCommercialPremium_RCF,
    Amt_AnnCommercialPremium_RSP,
    Amt_AnnCommercialPremium_SAS,
    Amt_AnnCommercialPremium_SC,
    Amt_AnnCommercialPremium_STS,
    Amt_AnnCommercialPremium_VAV,
    Amt_AnnCommercialPremium_VDS,
    Amt_AnnCommercialPremium_VF,
    Amt_AnnCommercialPremium_VN,
    Amt_AnnCommercialPremium_VSA,
    Num_ClaimCover_ADV,
    Num_ClaimCover_BAG,
    Num_ClaimCover_CCC,
    Num_ClaimCover_CRO,
    Num_ClaimCover_DNC,
    Num_ClaimCover_DP10,
    Num_ClaimCover_FDN,
    Num_ClaimCover_FRB,
    Num_ClaimCover_IRE,
    Num_ClaimCover_ODV,
    Num_ClaimCover_PT,
    Num_ClaimCover_PUE,
    Num_ClaimCover_PUS,
    Num_ClaimCover_QIV,
    Num_ClaimCover_RC,
    Num_ClaimCover_VDS,
    Val_ClaimCover_ADV,
    Val_ClaimCover_BAG,
    Val_ClaimCover_CCC,
    Val_ClaimCover_CRO,
    Val_ClaimCover_DNC,
    Val_ClaimCover_DP10,
    Val_ClaimCover_FDN,
    Val_ClaimCover_FRB,
    Val_ClaimCover_IRE,
    Val_ClaimCover_ODV,
    Val_ClaimCover_PT,
    Val_ClaimCover_PUE,
    Val_ClaimCover_PUS,
    Val_ClaimCover_QIV,
    Val_ClaimCover_RC,
    Val_ClaimCover_VDS,
    Val_Claim_Total_Assistance,
    'Nº sinistros total'n,
    Num_Claim_Assistance,
    Acordos,
    Desc_ChangeType,
    Cod_Tariff,
    Cod_GroupedTariff,
    Desc_Option,
    Id_UnitRisk,
    Desc_PaymentPlan,
    Desc_PaymentType,
    Id_PolicyAge,
    Dt_PlStartEffectDate,
    Dt_PlStartEmissDate,
    Dt_PlErlyExitEffctDate,
    Dt_PlEarlyExitEmDate,
    Desc_Situation,
    Desc_NewRenewal,
    Id_PolicyHolder,
    Id_NIF_Policyholder,
    Dt_BirthPolicyHolder,
    Id_PolicyHolderAge,
    Id_ZipCodePolicyHolder,
    Desc_PolicyHolderDistrict,
    Desc_PolicyHolderTown,
    Id_CAE_PolicyHolder,
    Id_DriverAge,
    Id_DriverAgeRange,
    Dt_BirthDriver,
    Id_DayDtBirthDriver,
    Dt_YoungCondition,
    Desc_DriverSex,
    Desc_DriverMaritalStatus,
    Desc_DriverZipCode,
    Dt_DriverLicense,
    Id_DriverLicenceAge,
    Id_DriverLicenceYear,
    Id_VehicleLicense,
    Dt_VehicleLicense,
    Id_ImportedVehicle,
    Id_VehicleLicenseYear,
    Id_ConstructionYear,
    Id_VehicleAge,
    Id_VehicleAgeRange,
    Desc_VehicleType,
    Desc_VehicleTypeGroup,
    Desc_InsuranceType,
    Desc_Bodywork,
    Desc_VehicleOrigin,
    Desc_Brand,
    Desc_Model,
    Desc_Version,
    Cod_Eurotax,
    Id_Displacement,
    Id_DisplacementRange,
    Id_Potence,
    Id_Tare,
    Id_Weight,
    Id_WeightPotenceRatio,
    Id_WeightTaraRatio,
    Desc_FuelType,
    Id_Doors,
    Id_Seets,
    Val_VehicleCapital,
    Val_VehicleCapitalRange,
    Val_VehicleCapitalWithoutExtras,
    Val_Extras,
    Id_SectorActivityPolicyHolder,
    Desc_SectorActivityPolicyHolder,
    Desc_Mediator,
    Desc_MediatorName,
    Desc_ZoneRC,
    Desc_ZoneDP,
    Desc_OwnDamageClass,
    Ind_OnwDamage,
    Ind_Collision,
    Ind_Theft,
    Ind_Windscreen,
    Cod_Campaign,
    NSUPLEMENTO,
    Ind_Protocol,
    Desc_SectorActivityGroup,
    Val_New_Vehicle,
    Ind_VehicleUse,
    Cod_AgentASF,
    Desc_Mediatornetwork,
    Desc_MediatorZone,
    Desc_MediatorCounter,
    Cod_MediatorInspector,
    Desc_MediatorInspector,
    Desc_MediatorChannel,
    Desc_MediatorTypology,
    Desc_MediatorSubTypology,
    Desc_MediatorSituation,
    BonusMalusInitial,
    Desc_DriverRegiao,
    Desc_DriverZona,
    Dt_ExclusionVehicleLicense,
    Dt_InclusionVehicleLicense,
    BonusMalusRange,
    'Num_ClaimCover_Without_Credor_0€'n,
    Val_Motor_Total_Without_Credor;

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
