from flask import Flask, request, render_template
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient


app = Flask(__name__)

# Set your Azure Key Vault details
vault_name = "key-vault-uyi"
key_vault_url = f"https://key-vault-uyi.vault.azure.net/"


# Create a SecretClient using DefaultAzureCredential
credential = DefaultAzureCredential()
secret_client = SecretClient(vault_url=key_vault_url, credential=credential)

@app.route('/')
def index():
    return render_template('login_page.html')
    

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']

    # Save password as a secret in Azure Key Vault
    secret_name = f"{username}-password"
    secret_client.set_secret(secret_name, password)

    return f'Password for {username} saved in Azure Key Vault.'

if __name__ == '__main__':
    app.run(debug=True)
