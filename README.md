# cicd_poc (counter_app)

Para execução do passo a passo da PoC, verificar o arquivo howto.txt

Demais arquivos do repo:

- counter-app.py - exemplo de código de um server HTTP simples em python para teste
- requirements.txt - versões de extensões/libs do python para funcionamento do código
- Dockerfile - instruções para criação da imagem
- .github/workflows/development-ci.yml - workflow de build da imagem e push para o registry na AWS
- docker-compose.yml - instruções para a criação e execução do container Docker
- .github/workflows/production-cd.yml - workflow de deploy do container no Docker da EC2
