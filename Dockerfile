FROM gcr.io/distroless/static-debian11:nonroot
ENTRYPOINT ["/baton-bitbucket-datacenter"]
COPY baton-bitbucket-datacenter /