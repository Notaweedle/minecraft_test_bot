const axios = require('axios');

async function testSignup() {
  try {
    const response = await axios.post('http://localhost:3050/signup', {
      username: 'Crabs',
      password: 'SecretFormula',
      serverIp: 'test',
      serverPort: 'test',
      serverPassword: 'test'
    });
    
    console.log('Signup successful!');
    console.log('Response:', response.data);
  } catch (error) {
    console.error('Signup failed:');
    console.error('Status:', error.response?.status);
    console.error('Error:', error.response?.data || error.message);
  }
}

testSignup();