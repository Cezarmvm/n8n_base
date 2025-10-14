# n8n-bootstrap (self-hosted)
Infra "coringa" para rodar n8n com Postgres via Docker. Sem workflows.

## Passos
1) Copie .env.example para .env e configure os valores:
   - **N8N_HOST**: Seu domínio/IP (localhost para desenvolvimento)
   - **N8N_PROTOCOL**: http (desenvolvimento) ou https (produção)
   - **N8N_PORT**: Porta do n8n (padrão: 5678)
   - **WEBHOOK_URL**: URL base dos webhooks (ex: https://meudominio.com/)
   - **GENERIC_TIMEZONE**: Fuso horário (ex: America/Sao_Paulo)
   - **N8N_ENCRYPTION_KEY**: Gere uma chave forte (≥32 chars) - use: `openssl rand -hex 32`
   - **POSTGRES_PASSWORD**: Senha forte para o banco
   - **EXECUTIONS_DATA_MAX_AGE**: Tempo de retenção em horas (336 = 14 dias)

2) `make up` → acesse http://localhost:5678
3) Primeiro login cria o Owner; ative 2FA no n8n e faça backups.

## Comandos
- `make up` - Inicia os serviços
- `make down` - Para os serviços  
- `make logs` - Acompanha logs do n8n
- `make backup` - Cria backup em backups/*.sql.gz
- `make restore FILE=backups/xxx.sql.gz` - Restaura backup

## Configurações Específicas

### Para Desenvolvimento Local
```bash
N8N_HOST=localhost
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/
```

### Para Produção com Domínio
```bash
N8N_HOST=meudominio.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://meudominio.com/
```

### Geração de Chaves Seguras
```bash
# Chave de criptografia (32+ caracteres)
openssl rand -hex 32

# Senha forte para PostgreSQL
openssl rand -base64 32
```

### Fusos Horários Comuns
- `America/Sao_Paulo` (Brasil)
- `America/New_York` (EUA Leste)
- `Europe/London` (Reino Unido)
- `Asia/Tokyo` (Japão)

## Boas práticas/hardening

### Segurança Essencial
- **HTTPS obrigatório em produção**: Use reverse proxy (Traefik/Caddy/Nginx)
- **2FA obrigatório**: Ative no primeiro login do n8n
- **Senhas fortes**: Use geradores como `openssl rand -base64 32`
- **Rotação de chaves**: Troque N8N_ENCRYPTION_KEY em incidentes de segurança

### Acesso e Rede
- **Firewall**: Restrinja porta 5678 por IP/VPN
- **SSO**: Configure autenticação externa (OAuth/SAML) se disponível
- **Logs**: Monitore logs regularmente com `make logs`

### Dados e Backup
- **LGPD compliance**: Configure EXECUTIONS_DATA_MAX_AGE conforme política
- **Backups automáticos**: Agende `make backup` via cron
- **Teste restores**: Valide backups com `make restore` periodicamente
- **Volumes**: Monitore espaço dos volumes Docker

## 🍴 Fork e Contribuição

Este é um repositório base para facilitar o setup de n8n. Sinta-se à vontade para fazer fork e customizar para suas necessidades!

### Como Fazer Fork

1. **Fork este repositório** clicando no botão "Fork"
2. **Clone seu fork**:
   ```bash
   git clone https://github.com/SEU-USUARIO/n8n-bootstrap.git
   cd n8n-bootstrap
   ```
3. **Configure seu ambiente**:
   ```bash
   cp .env.example .env
   # Edite .env com suas configurações
   make up
   ```

### Contribuindo de Volta

Tem melhorias? Contribua de volta para ajudar outros!

1. **Crie uma branch**:
   ```bash
   git checkout -b feature/minha-melhoria
   ```
2. **Faça suas mudanças** e teste
3. **Abra um Pull Request** com descrição clara

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para detalhes completos.

### Documentação Adicional

- 📚 [Documentação Completa](docs/)
- 🔧 [Exemplos de Workflows](docs/workflows.md)
- 🐛 [Troubleshooting](docs/troubleshooting.md)
- 📝 [Guia de Contribuição](CONTRIBUTING.md)
- 📋 [Changelog](CHANGELOG.md)

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

## ⭐ Suporte

- 🐛 [Reportar Bugs](../../issues)
- 💡 [Sugerir Funcionalidades](../../issues)
- 💬 [Discussões](../../discussions)
- 📖 [Documentação Oficial n8n](https://docs.n8n.io/)
