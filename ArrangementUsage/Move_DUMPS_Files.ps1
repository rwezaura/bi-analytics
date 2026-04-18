$source = 'D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\202108'

$streams = @{
  ocs_acct_balance_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ACCT_BALANCE_BO"
ocs_acct_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ACCT_BO"
ocs_ar_adjustment = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\AR_ADJUSTMENT"
ocs_ar_transfer = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\AR_TRANSFER"
ocs_bc_acct = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_ACCT"
ocs_bc_customer = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_CUSTOMER"
ocs_bc_g_member = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_G_MEMBER"
ocs_bc_prod_prop = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_PROD_PROP"
ocs_bc_sub_brand = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_BRAND"
ocs_bc_sub_extinfo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_EXTINFO"
ocs_bc_sub_group = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_GROUP"
ocs_bc_sub_iden_def = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_IDEN_DEF"
ocs_bc_sub_iden_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_IDEN"
ocs_bc_sub_prop = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_PROP"
ocs_bc_subscriber = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUBSCRIBER"
ocs_cm_acct_balance = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CM_ACCT_BALANCE"
ocs_cm_balance_type = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CM_BALANCE_TYPE"
ocs_customer_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CUSTOMER_BO"
ocs_free_unit_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\FREE_UNIT_BO"
ocs_g_member_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\G_MEMBER_BO"
ocs_offering_inst_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\OFFERING_INST_BO"
ocs_pe_free_unit_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PE_FREE_UNIT"
ocs_pe_free_unit_type = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PE_FREE_UNIT_TYPE"
ocs_pm_offering_baseinfo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PM_OFFERING_BASEINFO"
ocs_pm_offering_brand = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PM_OFFERING_BRAND"
ocs_subscriber_bo = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\SUBSCRIBER_BO"
uvc_manlog = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\UVC_MANLOG"
uvc_supply = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\UVC_SUPPLY"

<#agentdetailsreport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSAGENT_DETAILS"
agentbalancereport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSAGENTBALANCE"
commissionbalancereport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSAGENTCOMMISSION"
customersupplierreport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSCUSTOMERSUPPLIERREPORT"
registrationreport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSREG_SUBSCRIBER"
subscriberbalancereport = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSSUBSCRIBER_BAL"
transactiondetails = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSTRANSACTIONDETAILS"
transactions = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSTRANSACTIONS"
closingbalance = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\MFSUVDAILYBALANCE"#>
            }

$streams.keys | %{
                   $Destination = $streams[$_]
                   $filter = "*" + $_.ToString().ToLower() + "*.gz"
                   
                   Get-ChildItem $source -Recurse -Filter $filter  |
                   %{Move-Item -Path $_.FullName -Destination $Destination -Force}
                 }

