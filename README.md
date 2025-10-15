# n8n-bootstrap (self-hosted)
Infra "coringa" para rodar n8n com Postgres via Docker. Sem workflows.

## 🚀 Quick Start

### Pré-requisitos
- **Docker** e **Docker Compose** instalados
- **Git** (opcional, para clonar)

### Passos
1) **Configure o ambiente**:
   ```bash
   # Copie o template
   cp .env.example .env
   
   # Edite com suas configurações (OBRIGATÓRIO!)
   # - N8N_ENCRYPTION_KEY: Gere uma chave forte (≥32 chars)
   # - POSTGRES_PASSWORD: Use uma senha forte
   # - N8N_HOST: Seu domínio (localhost para desenvolvimento)
   ```

2) **Inicie os serviços**:
   ```bash
   docker compose up -d
   ```

3) **Acesse**: http://localhost:5678

4) **Primeiro login** cria o Owner; ative 2FA e faça backups.

## 💻 Comandos Essenciais

### Docker Compose (funciona em Windows, Linux, macOS)
```bash
docker compose up -d              # Inicia serviços
docker compose down              # Para serviços
docker compose logs -f n8n       # Ver logs do n8n
docker compose logs -f postgres  # Ver logs do PostgreSQL
docker compose ps                # Status dos serviços
```

### Make (Linux/macOS - opcional)
```bash
make up    # Inicia serviços
make down  # Para serviços
make logs  # Ver logs
make backup # Backup
make restore FILE=backups/xxx.sql.gz # Restore
```

## 🔧 Configurações Importantes

### Geração de Chaves Seguras
```bash
# Linux/macOS
openssl rand -hex 32

# Windows (PowerShell)
-join ((1..32) | ForEach {'{0:X}' -f (Get-Random -Max 16)})
```

### Variáveis Essenciais (.env)
```env
# OBRIGATÓRIAS - Configure antes de usar!
N8N_ENCRYPTION_KEY=sua-chave-32-chars-minima
POSTGRES_PASSWORD=sua-senha-forte

# Desenvolvimento
N8N_HOST=localhost
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

# Produção
N8N_HOST=meudominio.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://meudominio.com/
```

## 🔒 Boas Práticas

- **HTTPS obrigatório** em produção (use reverse proxy)
- **2FA obrigatório** no n8n
- **Backups regulares** dos dados
- **Firewall** para restringir acesso
- **LGPD compliance** com EXECUTIONS_DATA_MAX_AGE

## 🍴 Fork e Contribuição

Este é um repositório base. Faça fork e customize para suas necessidades!

1. **Fork** este repositório
2. **Clone** seu fork
3. **Configure** `.env` e teste
4. **Contribua** melhorias via Pull Request

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para detalhes.

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

## ⭐ Suporte

- 🐛 [Reportar Bugs](../../issues)
- 💡 [Sugerir Funcionalidades](../../issues)
- 📖 [Documentação Oficial n8n](https://docs.n8n.io/)