from flask import Flask
from flask_cors import CORS
# from debateck import debateck
from debates import debateck
from ttv import ttv
from debatefromnews import debatefromnews
from photo import photo

app = Flask(__name__)
# 添加CORS支持，允许所有来源的跨域请求
CORS(app, resources={r"/*": {"origins": "*"}})
app.register_blueprint(debateck)
app.register_blueprint(ttv)
app.register_blueprint(debatefromnews)
app.register_blueprint(photo)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000, debug=True)
