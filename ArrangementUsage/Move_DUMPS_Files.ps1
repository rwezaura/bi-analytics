$source = 'A:\'

$streams = @{
ocs_acct_balance_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ACCT_BALANCE_BO"
ocs_acct_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ACCT_BO"
ocs_ar_adjustment_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\AR_ADJUSTMENT"
ocs_ar_transfer_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\AR_TRANSFER"
ocs_bc_acct_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_ACCT"
ocs_bc_customer_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_CUSTOMER"
ocs_bc_g_member_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_G_MEMBER"
ocs_bc_prod_prop_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_PROD_PROP"
ocs_bc_sub_brand_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_BRAND"
ocs_bc_sub_extinfo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_EXTINFO"
ocs_bc_sub_group_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_GROUP"
ocs_bc_sub_iden_def_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_IDEN_DEF"
ocs_bc_sub_iden_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_IDEN"
ocs_bc_sub_prop_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUB_PROP"
ocs_bc_subscriber_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\BC_SUBSCRIBER"
ocs_cm_acct_balance_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CM_ACCT_BALANCE"
ocs_cm_balance_type_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CM_BALANCE_TYPE"
ocs_customer_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\CUSTOMER_BO"
ocs_free_unit_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\FREE_UNIT_BO"
ocs_g_member_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\G_MEMBER_BO"
ocs_offering_inst_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\OFFERING_INST_BO"
ocs_pe_free_unit_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PE_FREE_UNIT"
ocs_pe_free_unit_type_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PE_FREE_UNIT_TYPE"
ocs_pm_offering_baseinfo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PM_OFFERING_BASEINFO"
ocs_pm_offering_brand_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\PM_OFFERING_BRAND"#>
ocs_subscriber_bo_all = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\SUBSCRIBER_BO"
uvc_manlog = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\UVC_MANLOG"
uvc_supply = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\UVC_SUPPLY"
            }

$streams.keys | %{
                   $Destination = $streams[$_]
                   $filter = "*" + $_.ToString().ToLower() + "*.verf"
                   
                   Get-ChildItem $source -Recurse -Filter $filter  |
                   %{Move-Item -Path $_.FullName -Destination $Destination -Force}
                 }

