import React, { Component } from 'react';
import './App.css';

class App extends Component {
  _login = () => {
    return fetch("http://localhost:3001/user/login", {
      method: 'POST',
      headers: {
        Accept: 'application/vnd.api+json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        user: {
          email: "wendy@schroeder.com",
          password: "12345678"
        }
      })
    })
    .then(response => {
      console.log(response)
    })
  }
  render() {
    return (
      <div className="App">
        <button onClick={this._login}>
          Login
        </button>
      </div>
    );
  }
}

export default App;
