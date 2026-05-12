# Dev Services

Docker Compose stack with common development services, web UIs, monitoring, and a portal page — all pre-configured and ready to go.

![Portal](docs/portal.png)

## Quick Start

```bash
cp .env.example .env    # adjust passwords if needed
docker compose up -d
```

Open **http://localhost** — portal with links to all services.

## Services

### Data Stores

| Service | Port | Description |
|---------|------|-------------|
| **PostgreSQL** | `5432` | Latest version, credentials in `.env` |
| **Redis** | `6379` | With persistence |
| **Memcached** | `11211` | |
| **RabbitMQ** | `5672` | Message broker with management plugin |
| **NATS** | `4222` | With JetStream enabled |

### Web Interfaces

| UI | URL | Credentials |
|----|-----|-------------|
| **Portal** | http://localhost | — |
| **Happy Coder** | http://localhost:3130 | — |
| **Grafana** | http://localhost:3132 | `admin` / `admin` |
| **Logs Explorer** | http://localhost:3132/d/logs-explorer | `admin` / `admin` |
| **pgAdmin** | http://localhost:5050 | see `.env` |
| **RedisInsight** | http://localhost:5540 | — |
| **Memcached Admin** | http://localhost:8081 | — |
| **RabbitMQ Management** | http://localhost:15672 | `dev` / `dev` |
| **Jaeger** | http://localhost:16686 | — |
| **Prometheus** | http://localhost:9090 | — |
| **NATS Monitoring** | http://localhost:8222 | — |
| **MinIO Console** | http://localhost:9001 | `minioadmin` / `minioadmin` |

### Observability

| Component | Description |
|-----------|-------------|
| **Prometheus** | Scrapes metrics from all services via exporters |
| **Grafana** | Pre-provisioned with Prometheus, Loki, and Jaeger datasources + 6 dashboards |
| **Loki** | Log aggregation, available at `localhost:3100` |
| **Jaeger** | Distributed tracing via OTLP (gRPC `:4317`, HTTP `:4318`) |

## Pre-configured Grafana Dashboards

- PostgreSQL Database
- Redis Dashboard
- Memcached
- RabbitMQ Overview
- NATS Server
- Logs Explorer (Loki)

## Connecting from your apps

### .NET — Logs to Loki (Serilog)

```csharp
// Install-Package Serilog.Sinks.Grafana.Loki
Log.Logger = new LoggerConfiguration()
    .WriteTo.GrafanaLoki("http://localhost:3100")
    .CreateLogger();
```

### .NET — Tracing to Jaeger (OpenTelemetry)

```csharp
// Install-Package OpenTelemetry.Exporter.OpenTelemetryProtocol
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation()
        .AddOtlpExporter(o => o.Endpoint = new Uri("http://localhost:4317")));
```

### Connection strings

```
PostgreSQL:  Host=localhost;Port=5432;Database=postgres;Username=postgres;Password=changeme
Redis:       localhost:6379
Memcached:   localhost:11211
RabbitMQ:    amqp://dev:dev@localhost:5672
NATS:        nats://localhost:4222
```

## Project Structure

```
├── docker-compose.yml
├── .env.example
└── config/
    ├── grafana/
    │   ├── dashboards/          # 6 pre-built dashboards
    │   └── provisioning/        # datasources + dashboard provider
    ├── loki/                    # Loki configuration
    ├── memcached-admin/         # Dockerfile + config
    ├── pgadmin/                 # auto-registers PostgreSQL server
    ├── portal/                  # static HTML portal + assets
    ├── prometheus/              # scrape config for all exporters
    ├── rabbitmq/                # enabled plugins
    └── redisinsight/            # auto-registers Redis server
```

## Management

```bash
docker compose up -d       # start all
docker compose down        # stop all
docker compose down -v     # stop all and delete data
docker compose ps          # status
docker compose logs -f     # follow logs
```
