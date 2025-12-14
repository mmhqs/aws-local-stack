import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';

// --- CONFIGURAÇÃO ---
const S3_ENDPOINT_URL = 'http://localhost:4566';
const BUCKET_NAME = 'shopping-images';
const REGION = 'us-east-1';

// Configuração do AWS SDK v3
const s3Client = new S3Client({
    region: REGION,
    endpoint: S3_ENDPOINT_URL,
    credentials: {
        accessKeyId: 'test',
        secretAccessKey: 'test',
    },
    // Crucial para o LocalStack
    forcePathStyle: true 
});

/**
 * Faz o upload de um arquivo (buffer) para o bucket S3 do LocalStack.
 * @param {object} file - Objeto de arquivo do multer (contém buffer, mimetype, originalname).
 * @returns {object} - Retorna o Key e a URL pública do objeto.
 */
export async function uploadFileToS3(file) {
    // 1. Preparar metadados
    const fileExtension = file.originalname.split('.').pop();
    const key = `${uuidv4()}.${fileExtension}`; 

    // 2. Comando PutObject
    const command = new PutObjectCommand({
        Bucket: BUCKET_NAME,
        Key: key, 
        Body: file.buffer, 
        ContentType: file.mimetype, 
        ACL: 'public-read',
    });

    // 3. Executar o Upload
    await s3Client.send(command);

    // 4. Retornar dados do objeto
    const imageUrl = `${S3_ENDPOINT_URL}/${BUCKET_NAME}/${key}`;
    
    return {
        s3Key: key,
        url: imageUrl,
    };
}