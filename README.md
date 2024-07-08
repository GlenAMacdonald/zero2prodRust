# zero2prodRust

### Run locally in Docker with local DB:
```SKIP_DOCKER=true ./scripts/init_db.sh```

### Migrate production Database - via local commandline
`DATABASE_URL=YOUR-DIGITAL-OCEAN-DB-CONNECTION-STRING sqlx migrate run`

### Run in Digital Ocean:
`doctl apps create --spec spec.yaml`

### Get deployed Digital Ocean apps:
`doclt apps list`

### Push spec updates to Digital Ocean
`doctl apps update YOUR-APP-ID --spec=spec.yaml` 


