source "docker" "takelage" {
  image = "${var.base_user}/${var.base_repo}:${var.base_tag}"
  commit = true
  pull = false
  run_command = "${local.run_command}"
  changes = "${local.changes}"
}

build {
  sources = [
    "source.docker.takelage"
  ]

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-v -o ControlMaster=auto -o ControlPersist=15m'"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_host=${var.target_repo} ansible_connection=${var.ansible_connection}"
    ]
    groups = [
      "all",
      "private",
      "users",
      "image",
      "${var.ansible_environment}",
      "${var.image_name}"
    ]
    playbook_file = "../ansible/${var.ansible_playbook}"
    user = "root"
  }

  post-processor "docker-tag" {
    repository = "${var.local_user}/${var.target_repo}"
    tags = [
      "${var.target_tag}"]
  }
}
