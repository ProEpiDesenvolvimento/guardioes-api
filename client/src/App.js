import React, { Component } from 'react';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      users: []
    }
  }
  _logUser = () => {
      try {
        fetch("http://localhost:3001/users", {
          method: 'POST',
          headers: {
            Accept: 'application/vnd.api+json',
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            user: {
              email: "oralia@runolfsdottir.io",
              password: "12345678"
            }
          })
        })
        .then(res => {
            res.headers.forEach((key, value) => {
              if (value === 'authorization') {
                console.log(key)
              }
            })
        })
      } catch(error) {console.log(error)}
  }

  _getUsers = () => {
    try {
      fetch('http://localhost:3001/users', {
        method: 'GET',
        headers: {
          Accept: 'application/vnd.api+json',
          'Content-Type': 'application/json',
          Authorization: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MCIsInNjcCI6InVzZXIiLCJhdWQiOm51bGwsImlhdCI6MTU1MDI0OTczOCwiZXhwIjoxNTUwMzM2MTM4LCJqdGkiOiJlYWFiNjkzNC0xYThmLTRjYzMtYjgzMS1jZDY3YjY4OTY2Y2MifQ.kaFpCy15F3SnWDJWO8MmUmUca_Gv5lyTYhZZsHdzbXs'
        }
      }).then(res => {
        this.setState({users: res})
      })
    }
    catch(error) {console.log(error)}
  }
  
  render() {
    return (
      <div>
        <header className="App-header">
          <button onClick={this._logUser}>
            Login
          </button>
          <button onClick={this._getUsers}>
            Users
          </button>
        </header>
      </div>
    );
  }
}

export default App;
