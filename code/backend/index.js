const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

// Cria o servidor
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Olá, Node.js! O servidor está rodando.');
});

// Coloca o servidor para escutar requisições
server.listen(port, hostname, () => {
  console.log(`Servidor rodando em http://${hostname}:${port}/`);
});