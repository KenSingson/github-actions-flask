import socket, os
import base64

from ipaddress import ip_address
from flask import Flask, jsonify, render_template, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
CORS(app)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db_hostname = os.environ.get("DB_HOSTNAME")
db_username = os.environ.get("DB_USERNAME")
db_password_enc = os.environ.get("DB_PASSWORD")
# db_password = base64.b64decode(db_password_enc).decode('ISO-8859-1')
db_name = os.environ.get("DB_NAME")
db_port = os.environ.get("DB_PORT")

DSN = "postgresql://"+ db_username +":"+ db_password_enc +"@"+ db_hostname +":"+ db_port +"/"+ db_name

app.config["SQLALCHEMY_DATABASE_URI"] = DSN

# app.config["SQLALCHEMY_DATABASE_URI"] = os.environ.get('DSN')

db = SQLAlchemy(app)

class ProductsModel(db.Model):
    __tablename__ = 'products'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(250), nullable=False)
    price = db.Column(db.Integer(), nullable=False, default=0)

    def __init__(self, name, price):
        self.name = name
        self.price = price

db.create_all()

def fetchMetadata():
    hostname = socket.gethostname()
    host_ip = socket.gethostbyname(hostname)
    return hostname, host_ip

@app.route("/")
def home():
    return "<h1><center>This is the default home page.</center></h1>"

@app.route("/health")
def health():
    return jsonify(
        status="Active"
    )

@app.route("/details")
def details(): 
    hostname, host_ip = fetchMetadata()
    return render_template("index.htm", hostname=hostname, host_ip=host_ip)

@app.route("/api/v1/products", methods=['GET'])
def getProducts():
    allProducts = ProductsModel.query.all()
    results = [{
        "name": product.name,
        "price": product.price
    } for product in allProducts]
    
    return {"products": results}

@app.route("/api/v1/products", methods=['POST'])
def addProduct():
    print(request.get_json())
    productData = request.get_json()
    product = ProductsModel(name=productData['name'], price=productData['price'])
    db.session.add(product)
    db.session.commit()

    return jsonify(productData)

@app.route("/api/v1/product/<int:id>", methods=['GET', 'PUT', 'DELETE'])
def getProductByID(id: int):
    product = ProductsModel.query.get_or_404(id)

    if request.method == 'GET':
        response = {
            "name": product.name,
            "price": product.price
        }
        return {"product": response}

    elif request.method == 'PUT':
        data = request.get_json()
        product.name = data['name']
        product.price = data['price']
        db.session.add(product)
        db.session.commit()
        return {"message": f"The price of { product.name } was updated successfully."}

    elif request.method == 'DELETE':
        db.session.delete(product)
        db.session.commit()
        return {"message": f"Product {product.name} was removed successfully."}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)