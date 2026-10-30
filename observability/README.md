# Observability and SRE blueprint

## Signals
- Metrics: node/pod CPU and memory, restarts, pending pods, API server health, ingress latency, request rate and error ratio.
- Logs: control-plane audit where enabled, container logs, ingress, firewall, Key Vault and identity activity.
- Traces: OpenTelemetry instrumentation and correlation IDs.
- Events: deployments, policy denials, scaling, upgrades and Azure changes.

## Example SLO
Illustrative objective: 99.9% of valid application requests succeed over a rolling 30-day window. This is a planning target only; no availability measurement is claimed.

## Example PromQL
```promql
sum(rate(http_requests_total{status=~"5.."}[5m]))
/
clamp_min(sum(rate(http_requests_total[5m])), 1e-9)
```

Pod restarts:
```promql
sum by (namespace, pod) (increase(kube_pod_container_status_restarts_total[15m]))
```

Every production alert needs an owner, severity, runbook and tested notification route.
