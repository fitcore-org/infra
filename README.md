# FitCore Infrastructure

Este diretório contém a configuração do Docker Compose para os microserviços do FitCore.

## Pré-requisitos

- Docker
- Docker Compose V2
- Arquivo `.env` com as variáveis de ambiente

## Configuração

1. Copie o arquivo `.env.example` para `.env`:
```bash
cp .env.example .env
```

## Executando os Serviços

### Subir todos os serviços
```bash
docker-compose up -d
```

### Subir apenas os serviços de infraestrutura
```bash
docker-compose up -d postgres postgres-analytics rabbitmq minio prometheus grafana pgadmin
```

### Subir apenas os microserviços
```bash
docker-compose up -d user-service auth-service training-service analytics-consumer
```

### Verificar status dos serviços
```bash
docker-compose ps
```

### Ver logs de um serviço específico
```bash
docker-compose logs -f user-service
```

## Serviços e Portas

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| auth-service | 8080 | Serviço de Autenticação |
| user-service | 8081 | Serviço de Usuários |
| training-service | 8082 | Serviço de Treinos |
| analytics-consumer | - | Consumer de Analytics |
| PostgreSQL (Principal) | 5432 | Banco de dados principal |
| PostgreSQL (Analytics) | 5433 | Banco de dados de analytics |
| RabbitMQ | 5672, 15672 | Message Broker (15672 = Management UI) |
| MinIO | 9000, 9001 | Object Storage (9001 = Console) |
| PgAdmin | 5050 | Interface web para PostgreSQL |
| Prometheus | 9090 | Sistema de monitoramento |
| Grafana | 3000 | Dashboards e visualizações |

## Health Checks

Todos os serviços possuem health checks configurados:

- **Bancos de dados**: Verificação de conectividade com `pg_isready`
- **RabbitMQ**: Verificação de status com `rabbitmqctl`
- **MinIO**: Verificação de endpoint de saúde
- **Microserviços**: Verificação do endpoint `/actuator/health` (Spring Boot)

## Volumes Persistentes

Os dados são persistidos nos seguintes volumes:

- `postgres_data`: Dados do PostgreSQL principal
- `postgres_analytics_data`: Dados do PostgreSQL de analytics
- `rabbitmq_data`: Dados do RabbitMQ
- `minio_data`: Dados do MinIO
- `pgadmin_data`: Configurações do PgAdmin
- `prometheus_data`: Dados do Prometheus
- `grafana_data`: Configurações e dashboards do Grafana

## Troubleshooting

### Limpar volumes e reiniciar
```bash
docker-compose down -v
docker-compose up -d
```

### Reconstruir imagens
```bash
docker-compose build --no-cache
docker-compose up -d
```

### Verificar logs de erro
```bash
docker-compose logs --tail=50
```

## Ordem de Inicialização

Os serviços são iniciados na seguinte ordem devido às dependências:

1. PostgreSQL (principal e analytics)
2. RabbitMQ
3. MinIO
4. Prometheus
5. Grafana
6. PgAdmin
7. Microserviços (auth-service, user-service, training-service)
8. Analytics Consumer

## Segurança

**IMPORTANTE**: Este docker-compose é para desenvolvimento. Para produção:

1. Use senhas mais seguras
2. Configure SSL/TLS
3. Remova portas desnecessárias
4. Use secrets do Docker
5. Configure firewalls apropriados

# Stop services
docker-compose down
