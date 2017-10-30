##############################################################################################
### Variables
### @see https://www.terraform.io/docs/configuration/variables.html
##############################################################################################

variable "git-repository-url" {
  default = "https://github.com/magento/magento2.git"
  type = "string"
  description = "In case, you already added Modules and other stuff to your existing Magento installation, feel free to use your own repository."
}

variable "magento_admin_frontname" {
  type = "string"
  default = "admin"
  description = "Admin Access URL"
}

variable "magento_admin_user" {
  type = "string"
  default = "admin"
  description = "Admin Username"
}

variable "magento_admin_password" {
  type = "string"
  default = "admin123"
  description = "Admin Username"
}

variable "magento_admin_email" {
  type = "string"
  default = "admin@admin.com"
  description = "Admin E-Mail Address"
}

variable "magento_admin_firstname" {
  type = "string"
  default = "Admin"
  description = "Admin Firstname"
}

variable "magento_admin_lastname" {
  type = "string"
  default = "Admin"
  description = "Admin Lastname"
}

variable "magento_admin_timezone" {
  type = "string"
  default = "UTC"
  description = "Default Timezone"
}

variable "magento_locale" {
  type = "string"
  default = "en_US"
  description = "Default Localisation"
}


##############################################################################################
### Data Sources
##############################################################################################

data "aws_availability_zones" "all" {}