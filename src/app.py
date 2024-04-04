from flask import Flask
from flask import render_template

app = Flask(__name__)


@app.route('/')
def hello():
    mess = 'Nothing to see here move on'
    return render_template('Home.html', message=mess)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
