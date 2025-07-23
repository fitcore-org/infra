# Configuração Centralizada de Variáveis de Ambiente - FitCore

## Resumo das Alterações

Este documento descreve as alterações realizadas para centralizar todas as configurações dos microserviços do FitCore em variáveis de ambiente controladas pelo Docker Compose.

## ✅ Modificações Realizadas

### 1. **Auth Service** (`auth-service/app/src/main/resources/`)

**application.yml** - Configuração base com fallbacks para desenvolvimento local:
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS` para PostgreSQL
- `RABBITMQ_HOST`, `RABBITMQ_USER`, `RABBITMQ_PASS` para RabbitMQ
- Mantida configuração de email como está
- Habilitado endpoint `/actuator/health` para health checks

**application-docker.yml** - Profile específico para Docker:
- Configurações otimizadas para produção (logs reduzidos)
- Sem fallbacks, usa apenas variáveis de ambiente

### 2. **User Service** (`user-service/src/main/resources/`)

**application.yml** - Configuração base:
- Mesmas variáveis de DB e RabbitMQ do auth-service
- `MINIO_ENDPOINT`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY` para MinIO
- `SPRING_PROFILES_ACTIVE` para controlar profile ativo

**application-docker.yml** - Profile Docker:
- Configurações de produção para container

### 3. **Training Service** (`training-service/src/main/resources/`)

**application.yml** - Configuração base:
- Mesmas variáveis de DB
- Variáveis MinIO para bucket de exercícios
- `DEEPL_API_KEY` para tradução

**application-docker.yml** - Profile Docker:
- Configurações otimizadas para produção

### 4. **Analytics Consumer** (`analytics-consumer/analytics_consumer.py`)

✅ **Já estava correto** - Usando variáveis de ambiente:
- `RABBITMQ_HOST`, `RABBITMQ_USER`, `RABBITMQ_PASS`
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`
- `QUEUES`

### 5. **Docker Compose** (`infra/docker-compose.yml`)

**Adicionadas variáveis MinIO no training-service**:
```yaml
environment:
  MINIO_ENDPOINT: http://minio:9000
  MINIO_ACCESS_KEY: ${MINIO_USER}
  MINIO_SECRET_KEY: ${MINIO_PASS}
```

## 📋 Variáveis de Ambiente Necessárias

Todas as variáveis estão documentadas no arquivo `infra/.env.example`:

```bash
# PostgreSQL Database Principal
POSTGRES_USER=fitcore
POSTGRES_PASSWORD=fitcore123
POSTGRES_DB=fitcore_db

# PostgreSQL Database Analytics
ANALYTICS_DB_USER=analytics_user
ANALYTICS_DB_PASS=analytics123
ANALYTICS_DB_NAME=analytics_db

# RabbitMQ
RABBITMQ_USER=fitcore
RABBITMQ_PASS=fitcore123
QUEUES=user.events,training.events

# MinIO Object Storage
MINIO_USER=fitcore
MINIO_PASS=fitcore123

# PgAdmin (Opcional)
PGADMIN_EMAIL=admin@fitcore.com
PGADMIN_PASSWORD=admin123

# API Keys (Training Service)
DEEPL_API_KEY=your-deepl-api-key-here

# Translation Settings
# TRANSLATION_ENABLED=true  -> Traduz exercícios para português (requer API key válida)
# TRANSLATION_ENABLED=false -> Mantém exercícios em inglês (padrão, economiza API calls)
TRANSLATION_ENABLED=false
```

## 🚀 Como Usar

### 1. **Configurar Ambiente**
```bash
cd infra
cp .env.example .env
# Editar .env com suas configurações
```

### 2. **Desenvolvimento Local**
Os microserviços podem rodar individualmente com as configurações padrão do `application.yml`

### 3. **Ambiente Docker**
```bash
docker-compose up -d
```
O Docker Compose automaticamente:
- Define `SPRING_PROFILES_ACTIVE=docker` nos microserviços Spring
- Injeta todas as variáveis necessárias
- Os microserviços usam o profile `application-docker.yml`

## 🔧 Benefícios

1. **Centralização**: Todas as configurações em um só lugar (`.env`)
2. **Flexibilidade**: Funciona tanto local quanto em Docker
3. **Segurança**: Senhas e chaves não ficam hardcoded
4. **Consistência**: Mesmos valores em todos os serviços
5. **Facilidade**: Mudança de ambiente apenas alterando `.env`

## 🏥 Health Checks

Todos os microserviços Spring Boot agora têm:
- Endpoint `/actuator/health` habilitado
- Health checks configurados no Docker Compose
- Monitoramento via Prometheus habilitado

## 📝 Observações

- **Email**: Configuração mantida no auth-service (específica)
- **Flyway**: Mantido apenas no training-service (onde é usado)
- **Profiles**: Spring Boot usa `docker` profile quando em container
- **Logs**: Reduzidos em ambiente Docker para performance
- **Fallbacks**: Mantidos no `application.yml` para desenvolvimento local
