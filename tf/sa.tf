resource "yandex_iam_service_account" "sa-admin" {
  folder_id  = var.folder_id
  name      = "sa-admin"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-admin-role-admin" {
  folder_id  = var.folder_id
  role       = "admin"
  member     = "serviceAccount:${yandex_iam_service_account.sa-admin.id}"
  depends_on = [
    yandex_iam_service_account.sa-admin
  ]
}

