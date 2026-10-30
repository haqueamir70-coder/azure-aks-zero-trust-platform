# Delivery pipeline design

## Stages
1. Pull request validation: formatting, Terraform validation, manifest lint/schema checks.
2. Security: Checkov for Terraform, Trivy for filesystem/image, secret scanning, policy tests.
3. Build: create image and generate SBOM.
4. Publish: push immutable image to ACR using federated identity.
5. Promote: update GitOps environment with the same image digest.
6. Deploy: Argo CD reconciles approved Git state.
7. Verify: smoke tests, rollout health and security telemetry.

## Guardrails
- Use GitHub Actions `permissions: contents: read` by default; grant `id-token: write` only to Azure OIDC jobs.
- Pin actions to reviewed full commit SHAs in production.
- Use protected environments for higher stages.
- Avoid Azure client secrets or long-lived kubeconfig where OIDC and private runner connectivity can be used.
- Never deploy unreviewed pull-request code.
