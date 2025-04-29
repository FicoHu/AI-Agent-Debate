from flask import Flask
from debateck import debateck
from ttv import ttv

app = Flask(__name__)
app.register_blueprint(debateck)
app.register_blueprint(ttv)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000, debug=True)
