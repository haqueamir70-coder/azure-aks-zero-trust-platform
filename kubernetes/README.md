# Kubernetes workload security examples

Starter examples include a restricted namespace, non-root workload, internal ClusterIP service and default-deny ingress policy.

Apply in a disposable cluster:
```bash
kubectl apply -f namespace.yaml
kubectl apply -f secure-demo-deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f network-policy-default-deny.yaml
kubectl -n payments rollout status deployment/secure-demo
kubectl -n payments get pods,svc,networkpolicy
```

Default deny intentionally blocks ingress until explicit allow policies exist. Add required flows for ingress, monitoring, DNS and application dependencies after mapping them. NetworkPolicy enforcement depends on the CNI; acceptance of the object does not prove enforcement.

The image tag is illustrative, not supply-chain verified. Review current image, scan it and pin a digest before production.
