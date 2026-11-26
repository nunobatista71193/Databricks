/*==========================================================================
  Datamart motor - exportacao mensal para CSV - ANO 2025
  1 CSV por marca e mes: DATAMART_25MM_<MARCA>.csv  (593 colunas, mesma
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
%let ano          = 2025;
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
0I_No_Exposure
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
0Amt_AnnCommPremium_Wo_Assistance
0Amt_AnnGreenLttCharge
0Amt_AnnNetCommercialPremium
0Amt_AnnTotalPremium
0Val_Reimbursment
0Val_Payments
0Val_Reserves
0Num_Claim
0Num_ClaimCover
0Num_ClaimCover_IBNR
0Num_Closed_Claim
0Num_Attritional_Claim
1Num_Cost_0__Claim
1Num_Cost_0__without_Expert_Claim
0Num_Natural_Event_Claim
0Num_Large_Claim
1Num_Cost_Without_Credor_0_
0Num_Claim_without_Expert_Cost
0Num_Motor_BodyInjury_Claim
0Num_Motor_IDS_Credor_Claim
0Num_Motor_IDS_Devedor_Claim
0Num_IDS_Credor_ClaimCover
0Num_Claim_0_IDSC
0Num_Claim_IDSC_non_0
0Num_Claim_0_non_IDSC
0Num_Motor_Traditional_Claim
1Num_Cost_0__without_Exper
0Num_OD_Claim
0Num_WDS_Claim
0Num_TPL_Claim
0Num_IDSC_Claim
0Num_OTHR_Claim
0Val_Claim_Total_Cost
0Val_Claim_Total_Cost_IBNR
0Val_ClaimCover_Total
0Val_ClaimCover_Total_IBNR
0Val_Closed_Claim_Cost
0Val_Attritional_Total_Cost
0Val_Natural_Event_Total_Cost
0Val_Large_Claim_Total_Cost
0Val_Expert_Cost
0Val_Claim_without_Expert_Cost
0Val_Claim_Total_Capped
0Val_Motor_Total_Without_Credor
0Val_Claim_Total_Capped_IBNR
0Val_Large_Claim_Total_Cost_IBNR
0Val_Claim_Wo_Expert_Cost_IBNR
0Val_Natural_Event_TotalCost_IBNR
0Val_Attritional_Total_Cost_IBNR
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
0Ind_Target
0Ind_Locater
0Id_PolicyAge
0Id_PolicyIssueYear
0Dt_PlStartEffectDate
0Dt_PlStartEmissDate
0Id_EarlyBuyer
0Dt_PlErlyExitEffctDate
0Dt_PlEarlyExitEmDate
0Desc_Situation
0Desc_NewRenewal
0Id_PolicyHolder
0Desc_ClientType_Finance
0Id_NIF_Policyholder
0Dt_BirthPolicyHolder
0Id_PolicyHolderAge
0Id_ZipCodePolicyHolder
0Desc_PolicyHolderDistrict
0Desc_PolicyHolderTown
0Id_CAE_PolicyHolder
0Id_SectorActivityPolicyHolder
0Desc_SectorActivityPolicyHolder
0Desc_Mediator
0Desc_MediatorName
0Ind_UnderterminedDriver
0Ind_UsualDriver
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
0Desc_TransportHazardousMaterials
0Id_CoversCount
0Cod_ThirdLIability
0Desc_ZoneRC
0Desc_ZoneDP
0Desc_OwnDamageClass
0Ind_OnwDamage
0Ind_Collision
0Ind_Theft
0Ind_Windscreen
0Cod_Campaign
0NSUPLEMENTO
0Id_Driver
0Ind_Transfer_Policy
0Number_Transfer_Policy
0Ind_Garage
0Ind_Cotacao
0Cod_CampaignWave
0Cod_CampaignModality
0Ind_Protocol
0E_AIRBAG
0E_DIRECAO_ASSISTIDA
0E_TELEFONE
0E_EQUIPAMENTO_SEGURANCA
0E_ALARME_SEGURANCA
0E_CONTROLO_CONDUCAO
0E_CONTROLO_PASSAGEIRO
0E_CONTROLO_TRAVAGEM
0E_MELHORIA_VISIBILIDADE
0E_APOIO_ESTACIONAMENTO
0Desc_SectorActivityGroup
0Val_New_Vehicle
0Ind_VehicleUse
0Ind_Vehicle_Nationality
0Ind_Vehicle_Traction
0PESO_POTENCIA_INTERVALOS
0TARA_POTENCIA_INTERVALOS
0Ind_Driver_PolicyHolder
0Desc_PolicyHolderMaritalStatus
0C_POSTAL_TOMADOR
0C_URBAN_RURAL
0Desc_DriverTown
0Desc_DriverDistrict
0NOME_LOCADOR
0DNI_LOCADOR
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
0RENEWAL_NEW
0I_NEW_POLICE
0I_RENEWAL_POLICE
0I_CANCELATION_POLICE
0I_Policy_Bag
0Dt_PlStartUW
0Dt_PlEndUW
0Gearbox
0ANOS_COM_SEGURO
0BONUS_MALUS_PER_RC
0cluster
0Cod_BalcaoCarteira
0Id_Anuidade
0Desc_PolicyHolderSex
0OBJETO_PRINCIPAL
0OBJETO_SECUNDARIO
0SITUACAO_OBJETO
0UTILIZACAO
0Id_Color
0Ind_VehicleBoxType
0EXTENSAO_TERRITORIAL
0Ind_TransportesInternacionais
0BANCO_DESCONTO_VALOR
0BANCO_DESCONTO
0MOTOR
0IND_PLUG_IN
0Id_BankRiskRate
0Renewal_date
0FVENCIMIENTO_suplemento
0FEFECTO_SUPLEMENTO
0Cod_CancellationReason
0DAT_EFEITO
0CAE2
0Marca
0RENEWAL_NEW_2
0Id_Object
0Id_UnitRisk_2
0Flg_IsCannibalization
0Flg_IsMidCannibalization
0NumD_CannibWindow
0OLD_Id_Policy
0OLD_Desc_Company
0OLD_Cod_AgentASF
0OLD_Amt_AnnCommercialPremium
0NEW_Amt_AnnCommercialPremium
0Flg_Cannib_Cancel
0Flg_MidCannib_Cancel
0Flg_Agent_Swap
0Flg_Brand_Swap
0Cancellation_Type
0Cancel_Period
0Flg_Cancel_Policy_Oper
0Cancellation_Type_Oper
0Flg_Internal_Transfer
0Flg_Internal_Transfer_Canib
0Flg_IsCannibalization_aux
0Flg_IsCannibalization_TOT_aux
0Flg_Cannib_Cancel_aux
0Flg_Cannib_Cancel_TOT_aux
0Flg_Brand_Swap_Tot
0PRenewals_t
0Renewals_t
0Flg_IsCannibalization_TOT
0Flg_Cannib_Cancel_TOT
0NEW_Amt_AnnCommercialPremium_CNB
0NEW_Amt_AnnCommercialPremium_TOT
0OLD_Amt_AnnCommercialPremium_CNB
0OLD_Amt_AnnCommercialPremium_TOT
0BONUS_MALUS_ADV
0BONUS_MALUS_AV
0BONUS_MALUS_BAG
0BONUS_MALUS_BAT
0BONUS_MALUS_CCC
0Bonus_Malus_CCC_Int
0BONUS_MALUS_EX
0BONUS_MALUS_FDN
0BONUS_MALUS_FRB
0BONUS_MALUS_IRE
0BONUS_MALUS_ODV
0BONUS_MALUS_PER_ADV
0BONUS_MALUS_PER_AV
0BONUS_MALUS_PER_BAG
0BONUS_MALUS_PER_BAT
0BONUS_MALUS_PER_CCC
0BONUS_MALUS_PER_EX
0BONUS_MALUS_PER_FDN
0BONUS_MALUS_PER_FRB
0BONUS_MALUS_PER_IRE
0BONUS_MALUS_PER_ODV
0BONUS_MALUS_PER_PNE
0BONUS_MALUS_PER_PT
0BONUS_MALUS_PER_PTJ
0BONUS_MALUS_PER_QIV
0BONUS_MALUS_PER_RCF
0BONUS_MALUS_PER_SAS
0BONUS_MALUS_PER_SC
0BONUS_MALUS_PER_STS
0BONUS_MALUS_PER_VDS
0BONUS_MALUS_PER_VF
0BONUS_MALUS_PER_VN
0BONUS_MALUS_PNE
0BONUS_MALUS_PT
0BONUS_MALUS_PTJ
0BONUS_MALUS_QIV
0Bonus_Malus_RC_CCC
0Bonus_Malus_RC_CCC_Int
0Bonus_Malus_RC_Int
0BONUS_MALUS_RCF
0BONUS_MALUS_SAS
0BONUS_MALUS_SC
0BONUS_MALUS_STS
0BONUS_MALUS_VDS
0BONUS_MALUS_VF
0BONUS_MALUS_VN
0CAPITAL_ADV
0CAPITAL_AE
0CAPITAL_AEcv
0CAPITAL_ASB
0CAPITAL_AST
0CAPITAL_ASV
0CAPITAL_AV
0CAPITAL_AVP
0CAPITAL_BAG
0CAPITAL_BAT
0CAPITAL_CCC
0CAPITAL_CRO
0CAPITAL_CRT
0CAPITAL_DNC
0CAPITAL_DP10
0CAPITAL_EX
0CAPITAL_FDN
0CAPITAL_FRB
0CAPITAL_IRE
0CAPITAL_ODV
0CAPITAL_PC
0CAPITAL_PDU
0CAPITAL_PF
0CAPITAL_PMU
0CAPITAL_PNE
0CAPITAL_PPE
0CAPITAL_PSR
0CAPITAL_PT
0CAPITAL_PTJ
0CAPITAL_PTL
0CAPITAL_PV
0CAPITAL_QDV
0CAPITAL_QF
0CAPITAL_QIV
0CAPITAL_RC
0CAPITAL_RSP
0CAPITAL_SAS
0CAPITAL_SC
0CAPITAL_STS
0CAPITAL_VAV
0CAPITAL_VDS
0CAPITAL_VF
0CAPITAL_VN
0FRQ_ADV
0FRQ_AV
0FRQ_AVP
0FRQ_BAG
0FRQ_BAT
0FRQ_CCC
0FRQ_DP10
0FRQ_EX
0FRQ_FDN
0FRQ_FRB
0FRQ_IRE
0FRQ_ODV
0FRQ_PC
0FRQ_PNE
0FRQ_PT
0FRQ_PTJ
0FRQ_PV
0FRQ_QF
0FRQ_QIV
0FRQ_RC
0FRQ_SAS
0FRQ_SC
0FRQ_VDS
0FRQ_ASB
0FRQ_AST
0FRQ_ASV
0FRQ_AVE
0FRQ_CRO
0FRQ_CRT
0FRQ_PDU
0FRQ_PMU
0FRQ_PPE
0FRQ_PSR
0FRQ_PTL
0FRQ_QDV
0FRQ_RSP
0FRQ_VAV
0FRQ_ROR_ADV
0FRQ_ROR_CCC
0FRQ_ROR_FDN
0FRQ_ROR_FRB
0FRQ_ROR_IRE
0OPCAO_ADV
0OPCAO_AV
0OPCAO_AVE
0OPCAO_AVP
0OPCAO_BAG
0OPCAO_BAT
0OPCAO_CCC
0OPCAO_DNC
0OPCAO_EX
0OPCAO_FDN
0OPCAO_FRB
0OPCAO_IRE
0OPCAO_ODV
0OPCAO_PC
0OPCAO_PF
0OPCAO_PNE
0OPCAO_PT
0OPCAO_PTJ
0OPCAO_PV
0OPCAO_QF
0OPCAO_QIV
0OPCAO_RC
0OPCAO_SAS
0OPCAO_VDS
0OPCAO_VF
0OPCAO_VN
0PREMIO_ANTES_BM_ADV
0PREMIO_ANTES_BM_AE
0PREMIO_ANTES_BM_AEcv
0PREMIO_ANTES_BM_AV
0PREMIO_ANTES_BM_AVE
0PREMIO_ANTES_BM_AVP
0PREMIO_ANTES_BM_BAG
0PREMIO_ANTES_BM_BAT
0PREMIO_ANTES_BM_CCC
0PREMIO_ANTES_BM_DNC
0PREMIO_ANTES_BM_DP10
0PREMIO_ANTES_BM_EX
0PREMIO_ANTES_BM_FDN
0PREMIO_ANTES_BM_FRB
0PREMIO_ANTES_BM_IRE
0PREMIO_ANTES_BM_ODV
0PREMIO_ANTES_BM_PA
0PREMIO_ANTES_BM_PC
0PREMIO_ANTES_BM_PF
0PREMIO_ANTES_BM_PNE
0PREMIO_ANTES_BM_PT
0PREMIO_ANTES_BM_PTJ
0PREMIO_ANTES_BM_PV
0PREMIO_ANTES_BM_QF
0PREMIO_ANTES_BM_QIV
0PREMIO_ANTES_BM_RC
0PREMIO_ANTES_BM_RCF
0PREMIO_ANTES_BM_SAS
0PREMIO_ANTES_BM_SC
0PREMIO_ANTES_BM_STS
0PREMIO_ANTES_BM_VDS
0PREMIO_ANTES_BM_VF
0PREMIO_ANTES_BM_VN
0Num_Claims_5Annuity
0Num_Claims_3Annuity
0Num_Claims_1Annuity
0Num_Claims_0Annuity
0Ultimate_Number_Occ
0Ultimate_Cost
0IBNR_Number_Occ
0IBNR_Cost
0Num_OD_ClaimCover
0Num_WDS_ClaimCover
0Num_TPL_ClaimCover
0Num_IDSC_ClaimCover
0Num_OTHR_ClaimCover
0Num_Closed_ClaimCover
0Num_Attritional_ClaimCover
1Num_Cost_0__ClaimCover
1Num_Cost_0__without_Exper_Cover
0Num_Natural_Event_ClaimCover
0Num_Large_ClaimCover
0Num_ClaimCover_Wo_Expert_Cost
0Num_BodyInjury_ClaimCover
0Num_IDS_Devedor_ClaimCover
0Num_ClaimCover_0_IDSC
0Num_ClaimCover_IDSC_non_0
0Num_ClaimCover_0_non_IDSC
0Num_Traditional_ClaimCover
0IBNR_Number_Sin
0Ultimate_Number_Sin
1Num_ClaimCover_Without_Credor_0_
0Amt_AfterDiscountPremium
0Amt_BeforeDiscountPremium
0Val_Campaingns
0Val_Comercial
0Val_Commercial
0Val_desconto
0Val_Others
0Val_Others-Commercial
0Val_Repricing
0Val_Retention
0Val_X-Sell
0VALOR_BONUS_MALUS_RC
0Mediador
0Cod_AgentASF1
0Canal_Intermedio
0Canal_Intermedio_II
0Coordenation
0MediatorNetwork
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
