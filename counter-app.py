from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Arquivo de dados salvos do contador no volume Docker
COUNTER_FILE = "./data/counter-file.txt"

def read_counter():
    """
    Le o arquivo de contador e retorna o valor atual. Retorna 0 se o arquivo não existe.
    """
    if os.path.exists(COUNTER_FILE):
        with open(COUNTER_FILE, "r") as f:
            return int(f.read().strip())
    else:
        return 0

def update_counter(counter):
    """
    Atualiza o arquivo de contador com um valor novo.
    """
    with open(COUNTER_FILE, "w") as f:
        f.write(str(counter))

@app.route('/', methods=['GET', 'POST'])
def handle_request():
    """
    GET: retorna o valor atual do contador do endpoint
    POST: incrementa o valor do contador e retorna atualizado
    """
    counter = read_counter()
    if request.method == 'POST':
        counter += 1
        update_counter(counter)
        return f"POST - Contador atualizado de requests. Valor atual: {counter}"
    else:
        return f"GET - Valor atual do contador de requests: {counter}"

if __name__ == '__main__':
    # Deixar o flask em running nas interfaces na porta 8080/tcp.
    # OBS: removido o modo debug para modo em produção.
    app.run(host='0.0.0.0', port=8080, debug=False)
