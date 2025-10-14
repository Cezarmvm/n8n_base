# Contribuindo para n8n-bootstrap

Obrigado por considerar contribuir para o n8n-bootstrap! Este é um repositório base para facilitar a configuração de instâncias n8n self-hosted.

## Como Contribuir

### 1. Fazendo Fork

1. Clique no botão "Fork" no topo desta página
2. Clone seu fork localmente:
   ```bash
   git clone https://github.com/SEU-USUARIO/n8n-bootstrap.git
   cd n8n-bootstrap
   ```

### 2. Criando uma Branch

```bash
git checkout -b feature/nova-funcionalidade
# ou
git checkout -b fix/correcao-bug
```

### 3. Fazendo Mudanças

- Mantenha o código simples e documentado
- Teste suas mudanças localmente
- Atualize a documentação se necessário
- Siga as convenções existentes

### 4. Testando Localmente

```bash
# Configure o ambiente
cp .env.example .env
# Edite .env com suas configurações

# Teste o setup
make up
make logs  # Verifique se está funcionando
make down
```

### 5. Commit e Push

```bash
git add .
git commit -m "feat: adiciona nova funcionalidade"
git push origin feature/nova-funcionalidade
```

### 6. Pull Request

1. Vá para o seu fork no GitHub
2. Clique em "New Pull Request"
3. Descreva claramente suas mudanças
4. Referencie issues relacionadas se houver

## Padrões de Commit

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` nova funcionalidade
- `fix:` correção de bug
- `docs:` mudanças na documentação
- `style:` formatação, sem mudanças de código
- `refactor:` refatoração de código
- `test:` adição de testes
- `chore:` mudanças em ferramentas/scripts

## Tipos de Contribuição

### 🐛 Reportar Bugs
- Use o template de issue
- Inclua passos para reproduzir
- Especifique ambiente (OS, Docker version, etc.)

### ✨ Sugerir Funcionalidades
- Descreva o problema que resolve
- Explique a solução proposta
- Considere alternativas

### 📝 Melhorar Documentação
- Corrija erros de digitação
- Adicione exemplos
- Melhore explicações

### 🔧 Melhorar Código
- Otimize scripts
- Adicione validações
- Melhore tratamento de erros

## Diretrizes

- Mantenha compatibilidade com versões anteriores quando possível
- Teste em diferentes ambientes (Linux, macOS, Windows)
- Considere segurança em todas as mudanças
- Mantenha o README atualizado

## Perguntas?

- Abra uma [issue](../../issues) para discussões
- Use [discussions](../../discussions) para perguntas gerais

## Agradecimentos

Obrigado por contribuir! Sua participação torna este projeto melhor para todos.
