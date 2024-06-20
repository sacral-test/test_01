Here is an example of Python Flask API code that implements the secure authentication mechanism for the Supplier Portal login functionality:

```python
from flask import Flask, request, jsonify, session
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import timedelta

app = Flask(__name__)
app.secret_key = 'your_secret_key'
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Strict'
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30)

# Dummy database to store supplier credentials
suppliers = [
    {'username': 'supplier1', 'password': generate_password_hash('password1')},
    {'username': 'supplier2', 'password': generate_password_hash('password2')}
]

@app.route('/login', methods=['POST'])
def login():
    username = request.json['username']
    password = request.json['password']

    supplier = next((s for s in suppliers if s['username'] == username), None)
    if supplier and check_password_hash(supplier['password'], password):
        session['username'] = username
        return jsonify({'message': 'Login successful'})
    else:
        return jsonify({'message': 'Invalid username or password'}), 401

@app.route('/logout', methods=['POST'])
def logout():
    session.pop('username', None)
    return jsonify({'message': 'Logout successful'})

@app.route('/protected', methods=['GET'])
def protected():
    if 'username' in session:
        return jsonify({'message': 'Access granted to protected resource'})
    else:
        return jsonify({'message': 'Access denied'}), 401

if __name__ == '__main__':
    app.run()
```

This code uses Flask to create a simple API with three endpoints: `/login`, `/logout`, and `/protected`. 

The `/login` endpoint accepts a POST request with JSON data containing the username and password. It checks if the supplied credentials match any of the stored supplier credentials. If a match is found, the user is considered authenticated and a session is created with the username stored in it. Otherwise, an error message is returned.

The `/logout` endpoint accepts a POST request and removes the username from the session, effectively logging out the user.

The `/protected` endpoint is an example of a protected resource that requires authentication. It checks if the username is present in the session and returns the appropriate response.

The code also includes session management configuration to set secure session cookies, define the session lifetime, and enforce strict same-site policy.

Please note that this is a simplified example and should be adapted and enhanced to meet your specific requirements and security needs.