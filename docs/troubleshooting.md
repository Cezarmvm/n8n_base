# Troubleshooting

Este guia ajuda a resolver problemas comuns ao usar o n8n-bootstrap.

## Problemas de Inicialização

### PostgreSQL não inicia

**Sintomas:**
- Container PostgreSQL fica em restart loop
- Logs mostram "database is not ready"

**Soluções:**
```bash
# Verificar logs
make logs

# Verificar volumes
docker volume ls
docker volume inspect n8n-base_pgdata

# Limpar volumes (CUIDADO: perde dados)
make down
docker volume rm n8n-base_pgdata
make up
```

### n8n não conecta no PostgreSQL

**Sintomas:**
- n8n inicia mas não consegue conectar no banco
- Erro "ECONNREFUSED" nos logs

**Soluções:**
1. Verificar se PostgreSQL está saudável:
```bash
docker-compose exec postgres pg_isready -U n8n -d n8n
```

2. Verificar variáveis de ambiente:
```bash
# Verificar se .env está correto
cat .env | grep POSTGRES
```

3. Verificar conectividade:
```bash
docker-compose exec n8n ping postgres
```

### Porta já em uso

**Sintomas:**
- Erro "port is already allocated"
- n8n não consegue bind na porta 5678

**Soluções:**
```bash
# Verificar o que está usando a porta
netstat -tulpn | grep 5678

# Parar outros containers
docker ps
docker stop <container_id>

# Ou mudar porta no .env
echo "N8N_PORT=5679" >> .env
```

## Problemas de Performance

### n8n lento

**Sintomas:**
- Interface web lenta
- Workflows demoram para executar

**Soluções:**
1. Verificar recursos do sistema:
```bash
docker stats
```

2. Ajustar configurações no .env:
```bash
# Reduzir logs
N8N_LOG_LEVEL=warn

# Ajustar retenção de dados
EXECUTIONS_DATA_MAX_AGE=168  # 7 dias
```

3. Limpar execuções antigas:
```bash
# Backup primeiro
make backup

# Parar serviços
make down

# Limpar volumes de execução (CUIDADO)
docker volume rm n8n-base_n8n_data
make up
```

### PostgreSQL lento

**Sintomas:**
- Queries demoram para executar
- Backup/restore muito lento

**Soluções:**
1. Verificar uso de disco:
```bash
docker exec postgres df -h
```

2. Otimizar PostgreSQL:
```bash
# Conectar no PostgreSQL
docker-compose exec postgres psql -U n8n -d n8n

# Verificar configurações
SHOW shared_buffers;
SHOW effective_cache_size;
```

## Problemas de Backup/Restore

### Backup falha

**Sintomas:**
- Erro "permission denied"
- Arquivo de backup vazio

**Soluções:**
1. Verificar permissões:
```bash
ls -la scripts/
chmod +x scripts/backup.sh
```

2. Verificar se PostgreSQL está rodando:
```bash
docker-compose ps postgres
```

3. Testar manualmente:
```bash
docker-compose exec postgres pg_dump -U n8n -d n8n | gzip > test.sql.gz
```

### Restore falha

**Sintomas:**
- Erro "relation does not exist"
- Dados não aparecem após restore

**Soluções:**
1. Verificar arquivo de backup:
```bash
file backups/n8n-*.sql.gz
gunzip -t backups/n8n-*.sql.gz
```

2. Verificar formato do dump:
```bash
gunzip -c backups/n8n-*.sql.gz | head -20
```

3. Restore manual:
```bash
gunzip -c backups/n8n-*.sql.gz | docker-compose exec -T postgres psql -U n8n -d n8n
```

## Problemas de Segurança

### Chave de criptografia inválida

**Sintomas:**
- Erro "invalid encryption key"
- n8n não inicia

**Soluções:**
1. Gerar nova chave:
```bash
openssl rand -hex 32
```

2. Atualizar .env:
```bash
N8N_ENCRYPTION_KEY=nova-chave-aqui
```

3. **CUIDADO**: Isso pode tornar dados existentes inacessíveis!

### Acesso não autorizado

**Sintomas:**
- Erro 401/403 na interface web
- Workflows não executam

**Soluções:**
1. Verificar configuração de host:
```bash
cat .env | grep N8N_HOST
```

2. Verificar firewall:
```bash
# Linux
sudo ufw status
sudo iptables -L

# Windows
netsh advfirewall show allprofiles
```

3. Verificar reverse proxy (se usando):
```bash
# Verificar configuração do Nginx/Apache
nginx -t
apache2ctl configtest
```

## Logs e Debug

### Habilitar logs detalhados

```bash
# Editar .env
N8N_LOG_LEVEL=debug

# Reiniciar
make down && make up

# Ver logs
make logs
```

### Coletar informações para suporte

```bash
# Informações do sistema
docker --version
docker-compose --version
uname -a

# Status dos containers
docker-compose ps

# Logs recentes
docker-compose logs --tail=100 n8n
docker-compose logs --tail=100 postgres

# Configuração (sem senhas)
cat .env | grep -v PASSWORD | grep -v KEY
```

## Contato

Se os problemas persistirem:
1. Abra uma [issue no GitHub](../../issues)
2. Inclua logs relevantes
3. Descreva passos para reproduzir
4. Inclua informações do ambiente
