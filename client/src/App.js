import React, { Component } from 'react';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      users: []
    }
  }
  _fetchUsers = () => {
      try {
        fetch("users", {
          method: 'GET',
          headers: {
            Accept: 'application/vnd.api+json'
          }
        })
        .then(res => res.json())
        .then(resJson => {
          this.setState({users: resJson})
        })
      } catch(error) {console.log(error)}
  }
  
  render() {
    return (
      <div>
        <button onClick={this._fetchUsers}/>
      </div>
    );
  }
}

export default App;
