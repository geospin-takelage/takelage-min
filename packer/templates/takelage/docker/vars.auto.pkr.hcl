variable "ansible_connection" {
  type = string
  default = "docker"
}

variable "ansible_environment" {
  type = string
  default = "{{ ansible_environment }}"
}

variable "ansible_playbook" {
  type = string
}

variable "base_repo" {
  type = string
}

variable "base_tag" {
  type = string
  default = "latest"
}

variable "base_user" {
  type = string
}

variable "command" {
  type = string
  default = "/usr/bin/tail -f /dev/null"
}

variable "entrypoint" {
  type = string
  default = ""
}

variable "env" {
  default = {
    "DEBIAN_FRONTEND" = "noninteractive",
    "LANG" = "en_US.UTF-8",
    "SUPATH" = "",
    "PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }
}

variable "image_name" {
  type = string
}

variable "local_user" {
  type = string
}

variable "packer_command" {
  type = string
  default = "/usr/bin/tail -f /dev/null"
}

variable "privileged" {
  type = string
  default = ""
}

variable "target_repo" {
  type = string
}

variable "target_tag" {
  type = string
  default = "latest"
}

variable "workdir" {
  type = string
  default = "/root"
}

locals {
  ansible_host = "${var.target_repo}"
  changes_list = [
    "CMD ${local.command_substr}",
    "ENTRYPOINT ${var.entrypoint}",
    "WORKDIR ${var.workdir}"
  ]
  changes = concat(local.changes_list, local.env)
  command_substr = join("\", \"", split(" ", "${var.command}"))
  command_string = "[\"${local.command_substr}\"]"
  env = [for key, value in var.env: "ENV $key=$value"]
  privileged_list = "${var.privileged}" == "" ? [] : [
    "${var.privileged}"]
  run_command_arguments = [
    "--detach",
    "--interactive",
    "--tty",
    "--name",
    "${var.target_repo}",
    "{{ .Image }}"
  ]
  run_command_split = split(" ", "${var.packer_command}")
  run_command = concat(concat(
  "${local.privileged_list}", "${local.run_command_arguments}"),
  "${local.run_command_split}"
  )
}
