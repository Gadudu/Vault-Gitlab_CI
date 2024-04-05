from flask import Flask
from flask import render_template

app = Flask(__name__)


@app.route('/')
def hello():
    try:
        secret = os.environ['MY_SECRET']
        mess = "Shhhh don't tell no one but my assignment ----> " + secret
    except KeyError:
        mess = 'Nothing to see here move on'
    except:
        mess = 'unknown error has happened'
    return render_template('Home.html', message=mess)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
