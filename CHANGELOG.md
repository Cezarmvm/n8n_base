# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Estrutura inicial do repositório
- Docker Compose com n8n e PostgreSQL
- Scripts de backup e restore
- Makefile para gerenciamento
- Documentação completa

## [1.0.0] - 2024-10-14

### Added
- **Infraestrutura Docker**
  - n8n service com imagem oficial
  - PostgreSQL 16 Alpine com health checks
  - Volumes persistentes para dados
  - Dependências entre serviços

- **Configuração de Ambiente**
  - `.env.example` com todas as variáveis necessárias
  - Suporte a diferentes ambientes (dev/prod)
  - Configurações de segurança e LGPD

- **Scripts de Gerenciamento**
  - `backup.sh` - Backup automatizado com timestamp
  - `restore.sh` - Restore de backups
  - Makefile com comandos essenciais

- **Documentação**
  - README completo com guia de uso
  - Instruções de hardening e segurança
  - Exemplos de configuração

- **Estrutura para Contribuição**
  - LICENSE (MIT)
  - CONTRIBUTING.md
  - CHANGELOG.md
  - Templates GitHub (issues/PRs)
  - CI/CD básico

### Security
- Health checks no PostgreSQL
- Configurações de criptografia para n8n
- Pruning automático de dados de execução
- Documentação de boas práticas de segurança

---

## Tipos de Mudanças

- **Added** para novas funcionalidades
- **Changed** para mudanças em funcionalidades existentes
- **Deprecated** para funcionalidades que serão removidas
- **Removed** para funcionalidades removidas
- **Fixed** para correções de bugs
- **Security** para vulnerabilidades corrigidas
