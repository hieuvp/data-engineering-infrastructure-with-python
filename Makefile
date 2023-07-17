.PHONY: fmt
fmt:
	scripts/fmt.sh

.PHONY: access
access:
	scripts/access.sh

.PHONY: terminate
terminate:
	cd kubernetes/gke && terraform destroy
	scripts/reset-terraform.sh

.PHONY: terraform-minikube
terraform-minikube:
	scripts/update-kubeconfig-minikube.sh
	scripts/apply-terraform.sh minikube

.PHONY: terraform-gke
terraform-gke:
	cd kubernetes/gke && terraform apply
	scripts/update-kubeconfig-gke.sh
	scripts/apply-terraform.sh gke

.PHONY: pull-helm-charts
pull-helm-charts:
	scripts/pull-chart-airflow.sh
	scripts/pull-chart-elastic.sh
	scripts/pull-chart-kafka.sh
	scripts/pull-chart-nifi.sh
	scripts/pull-chart-pgadmin4.sh
	scripts/pull-chart-postgresql.sh
	scripts/pull-chart-spark.sh

.PHONY: pull-terraform-modules
pull-terraform-modules:
	scripts/pull-module-gke.sh
