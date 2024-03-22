from flask import Flask, request, jsonify 
from flask_pymongo import PyMongo
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configuration de la connexion à la base de données MongoDB
app.config['MONGO_URI'] = 'mongodb://localhost:27017/Employés'
mongo = PyMongo(app)

# Modèle utilisateur
class Empl:
    def __init__(self, mail, password,username):
        self.mail = mail
        self.password = password
        self.username = username 

# Endpoint pour l'authentification d'un utilisateur
@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    mail = data.get('mail')
    password = data.get('password')

    # Vérifier les informations d'identification de l'utilisateur
    user = mongo.db.Empl.find_one({'mail': mail, 'password': password})

    if user:
        return jsonify({'message': 'Connexion réussie'}), 200
    else:
        return jsonify({'message': 'Échec de la connexion'}), 401

if __name__ == '__main__':
    app.run(debug=True, port=5000)

