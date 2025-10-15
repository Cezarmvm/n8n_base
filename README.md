# n8n-bootstrap (self-hosted)
Infra "coringa" para rodar n8n com Postgres via Docker. Sem workflows.

## 🚀 Quick Start

### Pré-requisitos

#### Windows
- **Docker Desktop** instalado e **rodando** (obrigatório!)
  - [Download Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Inicie o Docker Desktop e aguarde inicializar
  - Verifique se está rodando: ícone na bandeja do sistema

#### Linux/macOS
- **Docker** e **Docker Compose** instalados
- **Git** (opcional, para clonar)

### Passos

1) **Instale e inicie o Docker Desktop** (Windows):
   - Baixe e instale [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Inicie o Docker Desktop
   - Aguarde aparecer "Docker Desktop is running" na bandeja do sistema
   - Teste: `docker --version` deve funcionar
   - Teste: `docker compose version` deve funcionar

2) **Configure o ambiente**:
   ```bash
   # Copie o template
   cp .env.example .env
   
   # Edite com suas configurações (OBRIGATÓRIO!)
   # - N8N_ENCRYPTION_KEY: Gere uma chave forte (≥32 chars)
   # - POSTGRES_PASSWORD: Use uma senha forte
   # - N8N_HOST: Seu domínio (localhost para desenvolvimento)
   ```

3) **Verifique se está tudo funcionando**:
   ```bash
   # Teste se Docker está funcionando
   docker --version
   docker compose version
   
   # Verifique se não há containers rodando
   docker ps
   ```

4) **Inicie os serviços**:
   ```bash
   docker compose up -d
   ```

5) **Acesse**: http://localhost:5678

6) **Primeiro login** cria o Owner; ative 2FA e faça backups.

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

## 🔧 Troubleshooting

### Docker Desktop não inicia (Windows)
```powershell
# Verificar se Docker Desktop está rodando
docker --version

# Se não funcionar:
# 1. Reinicie o Docker Desktop
# 2. Verifique se não há outros containers rodando
# 3. Reinicie o Windows se necessário
```

### Erro "docker compose up -d" falha
```bash
# Verificar se Docker está rodando
docker ps

# Verificar logs de erro
docker compose logs

# Limpar containers antigos
docker compose down
docker system prune -f
```

### ⚠️ Conflito de Portas (Problema Comum)

**Quando usar múltiplas automações, você pode ter conflitos de porta:**

#### Diagnóstico do Conflito:
```bash
# Verificar o que está usando a porta 5678
netstat -ano | findstr :5678

# Verificar containers Docker rodando
docker ps

# Verificar containers com porta 5678
docker ps | findstr 5678
```

#### Soluções:

**Opção 1: Parar outro n8n**
```bash
# Parar container conflitante (ex: n8n_homologacao)
docker stop n8n_homologacao

# Ou parar todos os containers n8n
docker ps | grep n8n | awk '{print $1}' | xargs docker stop
```

**Opção 2: Usar porta diferente**
```env
# Editar .env - usar porta diferente
N8N_PORT=5679
# ou
N8N_PORT=5680
```

**Opção 3: Múltiplas instâncias organizadas**
```bash
# Para cada projeto, use portas diferentes:
# projeto1: porta 5678 (padrão)
# projeto2: porta 5679
# projeto3: porta 5680
# etc.
```

### Erro de codificação UTF-16 no .env
```powershell
# Recriar arquivo .env em UTF-8
Remove-Item .env -Force
Copy-Item .env.example .env
# Editar com VS Code (salva em UTF-8)
```

## 🔧 Múltiplas Automações

### Organização de Projetos

**Estrutura recomendada para múltiplos projetos n8n:**

```
meus-projetos/
├─ projeto-producao/     # Porta 5678 (padrão)
├─ projeto-homologacao/  # Porta 5679
├─ projeto-desenvolvimento/ # Porta 5680
└─ projeto-teste/        # Porta 5681
```

### Configuração por Projeto

**Cada projeto deve ter sua própria configuração:**

```env
# projeto-producao/.env
N8N_PORT=5678
POSTGRES_DB=n8n_prod
POSTGRES_USER=n8n_prod

# projeto-homologacao/.env  
N8N_PORT=5679
POSTGRES_DB=n8n_homolog
POSTGRES_USER=n8n_homolog

# projeto-desenvolvimento/.env
N8N_PORT=5680
POSTGRES_DB=n8n_dev
POSTGRES_USER=n8n_dev
```

### Comandos para Gerenciar Múltiplos Projetos

**Script PowerShell (Windows):**
```powershell
# Status de todos os projetos
.\scripts\manage-multiple.ps1 -Action status

# Parar todos os n8n
.\scripts\manage-multiple.ps1 -Action stop-all

# Iniciar projeto específico
.\scripts\manage-multiple.ps1 -Action start -Project "C:\projetos\meu-n8n"
```

**Comandos manuais:**
```bash
# Parar todos os n8n
docker ps | grep n8n | awk '{print $1}' | xargs docker stop

# Ver todos os n8n rodando
docker ps | grep n8n

# Iniciar projeto específico
cd projeto-producao && docker compose up -d

# Ver logs de projeto específico
cd projeto-producao && docker compose logs -f n8n
```

### Portas Recomendadas

```bash
# Reservar range de portas para n8n:
# 5678-5689 (12 portas disponíveis)

# Exemplos:
5678 - Produção
5679 - Homologação  
5680 - Desenvolvimento
5681 - Teste
5682 - Staging
# etc.
```

## 🔒 Boas Práticas

- **HTTPS obrigatório** em produção (use reverse proxy)
- **2FA obrigatório** no n8n
- **Backups regulares** dos dados
- **Firewall** para restringir acesso
- **LGPD compliance** com EXECUTIONS_DATA_MAX_AGE
- **Organize projetos** com portas diferentes
- **Use nomes descritivos** para containers e volumes

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