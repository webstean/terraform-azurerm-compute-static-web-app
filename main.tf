## ${each.value.name}
## ${local.git-repo-from-template[each.key].description}
## ${local.git-repo-from-template[each.key].details}

module "this" {
  source  = "Azure/avm-res-web-staticsite/azurerm"
  version = "~>0.0, < 1.0"

  enable_telemetry = var.enable_telementry

  name                = var.application_name
  resource_group_name = var.resource_group_name
  location            = local.regions[each.key].swa_location

  preview_environments_enabled = false

  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [var.user_managed_id]
  }

  app_settings = {
    ##    WEBSITE_NODE_DEFAULT_VERSION           = "22.16.0"
    WEBSITE_TIME_ZONE = local.regions["sydney"].timezone
    ##    WEB_CONCURRENCY                        = "1"
    ##    WEBSITE_ENABLE_SYNC_UPDATE_SITE        = "true"
    ##    WEBSITE_ENABLE_SYNC_UPDATE_SITE_LOCKED = "false"
    ##    WEBSITE_NODE_DEFAULT_VERSION_LOCKED    = "false"
    WEBSITE_TIME_ZONE_LOCKED = "false"
    ##    WEB_CONCURRENCY_LOCKED                 = "false"
    ##    WEBSITE_RUN_FROM_PACKAGE_LOCKED        = "false"
  }

  #basic_auth_enabled = true

  sku_tier = var.sku_size == lower("free") ? "Free" : "Standard" ## Free or Standard
  sku_size = var.sku_size == lower("free") ? "Free" : "Standard" ## Free or Standard

  tags = each.value.tags
}

output "staticsite_id" {
  value = module.staticsite.id
}
output "staticsite_name" {
  value = module.staticsite.name
}
