# Exemplos de Workflows n8n

Esta página contém exemplos práticos de workflows que você pode implementar no n8n.

## Workflows Básicos

### 1. Webhook → Database → Email

```json
{
  "name": "Webhook to Database Email",
  "nodes": [
    {
      "parameters": {},
      "id": "webhook",
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [240, 300]
    },
    {
      "parameters": {
        "operation": "insert",
        "table": "contacts",
        "columns": "name,email,message"
      },
      "id": "postgres",
      "name": "PostgreSQL",
      "type": "n8n-nodes-base.postgres",
      "position": [460, 300]
    },
    {
      "parameters": {
        "fromEmail": "noreply@example.com",
        "toEmail": "admin@example.com",
        "subject": "Novo contato recebido",
        "message": "Novo contato: {{ $json.name }} - {{ $json.email }}"
      },
      "id": "email",
      "name": "Send Email",
      "type": "n8n-nodes-base.emailSend",
      "position": [680, 300]
    }
  ]
}
```

### 2. Scheduled Data Sync

```json
{
  "name": "Daily Data Sync",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "cronExpression",
              "value": "0 9 * * *"
            }
          ]
        }
      },
      "id": "schedule",
      "name": "Schedule Trigger",
      "type": "n8n-nodes-base.scheduleTrigger",
      "position": [240, 300]
    },
    {
      "parameters": {
        "url": "https://api.example.com/data",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "httpHeaderAuth"
      },
      "id": "api",
      "name": "Fetch Data",
      "type": "n8n-nodes-base.httpRequest",
      "position": [460, 300]
    },
    {
      "parameters": {
        "operation": "upsert",
        "table": "external_data"
      },
      "id": "postgres",
      "name": "Save to DB",
      "type": "n8n-nodes-base.postgres",
      "position": [680, 300]
    }
  ]
}
```

## Workflows Avançados

### 3. Multi-Step Data Processing

```json
{
  "name": "Data Processing Pipeline",
  "nodes": [
    {
      "parameters": {},
      "id": "webhook",
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [240, 300]
    },
    {
      "parameters": {
        "jsCode": "// Validar e transformar dados\nconst data = $input.all();\n\nreturn data.map(item => ({\n  json: {\n    ...item.json,\n    processed_at: new Date().toISOString(),\n    status: 'validated'\n  }\n}));"
      },
      "id": "code",
      "name": "Process Data",
      "type": "n8n-nodes-base.code",
      "position": [460, 300]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "typeValidation": "strict"
          },
          "conditions": [
            {
              "id": "condition1",
              "leftValue": "{{ $json.status }}",
              "rightValue": "validated",
              "operator": {
                "type": "string",
                "operation": "equals"
              }
            }
          ],
          "combinator": "and"
        }
      },
      "id": "if",
      "name": "If Valid",
      "type": "n8n-nodes-base.if",
      "position": [680, 300]
    },
    {
      "parameters": {
        "operation": "insert",
        "table": "processed_data"
      },
      "id": "postgres",
      "name": "Save Valid Data",
      "type": "n8n-nodes-base.postgres",
      "position": [900, 200]
    },
    {
      "parameters": {
        "fromEmail": "alerts@example.com",
        "toEmail": "admin@example.com",
        "subject": "Dados inválidos detectados",
        "message": "Dados inválidos: {{ $json }}"
      },
      "id": "email",
      "name": "Alert Invalid",
      "type": "n8n-nodes-base.emailSend",
      "position": [900, 400]
    }
  ]
}
```

## Dicas de Implementação

### 1. Configuração de Credenciais
- Use variáveis de ambiente para credenciais sensíveis
- Configure autenticação adequada para APIs externas
- Teste credenciais antes de usar em produção

### 2. Tratamento de Erros
- Sempre inclua nós de tratamento de erro
- Configure retry policies para operações críticas
- Implemente alertas para falhas

### 3. Performance
- Use batch processing para grandes volumes de dados
- Configure timeouts apropriados
- Monitore uso de recursos

### 4. Monitoramento
- Ative logs detalhados
- Configure alertas para workflows críticos
- Monitore métricas de performance
