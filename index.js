#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const { execSync } = require('child_process');

const customPath = process.argv[2] || '';

const hour = new Date().getHours();
let greeting;
if (hour >= 4 && hour < 12) {
  greeting = 'Good morning';
} else if (hour >= 12 && hour < 18) {
  greeting = 'Good afternoon';
} else {
  greeting = 'Good evening';
}

console.log(`🎩 ${greeting}. Pray allow me to assist you with this endeavour.`);
console.log('📦 I shall now procure the curl installer and execute it on your behalf...');

function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, (response) => {
      response.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => {});
      reject(err);
    });
  });
}

async function main() {
  try {
    const scriptPath = '/tmp/litellm-router-curl-setup.sh';
    
    console.log('� Acquiring the curl installer...');
    await downloadFile(
      'https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/curl-setup.sh',
      scriptPath
    );
    
    fs.chmodSync(scriptPath, '755');
    
    console.log('� I shall now proceed to execute the installer...');
    if (customPath) {
      execSync(`sh ${scriptPath} ${customPath}`, { stdio: 'inherit' });
    } else {
      execSync(`sh ${scriptPath}`, { stdio: 'inherit' });
    }
    
    fs.unlinkSync(scriptPath);
    
  } catch (error) {
    console.error('❌ An unfortunate error has occurred:', error.message);
    process.exit(1);
  }
}

main();
