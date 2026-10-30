# GitOps operating model

- Keep application source and deployment configuration logically separated.
- Promote the same immutable image digest from dev to test to production.
- Require pull requests, reviewers and protected environment approval for production changes.
- Argo CD continuously reconciles declared desired state; it does not replace access control or image verification.

Suggested layout:
```text
gitops/
├── apps/
│   ├── payments-dev.yaml
│   └── payments-prod.yaml
└── projects/
    └── platform-project.yaml
```

Bootstrap Argo CD only after cluster identity, network access, secret management and administrative ownership are agreed. Do not store repository credentials in plaintext.
