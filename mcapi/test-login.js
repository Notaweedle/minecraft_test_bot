const axios = require('axios');

async function testSignup() {
  try {
    const response = await axios.post('http://localhost:3000/login', {
      username: 'Crabs',
      password: 'SecretFormula'
    });
    
    console.log('Login successful!');
    console.log('Response:', response.data);
  } catch (error) {
    console.error('Login failed:');
    console.error('Status:', error.response?.status);
    console.error('Error:', error.response?.data || error.message);
  }
}

testSignup();