import express from 'express';
import multer from 'multer';
import { uploadFileToS3 } from './s3Service.js'; 

const app = express();
const port = 3000;
const S3_ENDPOINT_URL = 'http://localhost:4566';

// Configuração do Multer (mantida aqui por ser um middleware Express)
const upload = multer({ 
    storage: multer.memoryStorage(),
    limits: { fileSize: 5 * 1024 * 1024 } 
});


/**
 * Rota POST para upload de imagem, usando o serviço modularizado.
 */
app.post('/upload-image', upload.single('image'), async (req, res) => {
    if (!req.file) {
        return res.status(400).send({ message: 'Nenhum arquivo de imagem foi fornecido.' });
    }
    try {
        const uploadResult = await uploadFileToS3(req.file);
        console.log(`Upload bem-sucedido para: ${uploadResult.url}`);
        res.status(200).send({
            message: 'Imagem enviada com sucesso para o S3 LocalStack!',
            s3Key: uploadResult.s3Key,
            url: uploadResult.url,
        });
    } catch (error) {
        console.error('Falha ao processar o upload da imagem:', error);
        res.status(500).send({ 
            message: 'Falha ao processar o upload da imagem.', 
            error: error.message 
        });
    }
});

// Rota de Teste
app.get('/', (req, res) => {
    res.send('Backend rodando e pronto para uploads.');
});

app.listen(port, () => {
    console.log(`Servidor Backend rodando em http://localhost:${port}`);
    console.log(`LocalStack S3 endpoint: ${S3_ENDPOINT_URL}`);
});